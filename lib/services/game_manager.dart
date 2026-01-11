import 'dart:async';
import 'package:hive/hive.dart';
import 'package:logic_game/data/constants.dart';
import 'package:logic_game/data/enum/enum.dart';
import 'package:logic_game/models/hive/noBox/typebonus/type_bonus.dart';
import 'package:logic_game/models/hive/noBox/case/case_model.dart';
import 'package:logic_game/models/hive/box/level/level_model.dart';
import 'package:logic_game/models/tempory/session_state.dart';
import 'package:logic_game/providers/level_profil_provider.dart';
import 'package:logic_game/providers/message_provider.dart';
import 'package:logic_game/providers/money_provider.dart';
import 'package:logic_game/services/money_service.dart';
import 'package:logic_game/services/move_manager_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service central de la gestion globale de la partie
///
/// Ce service est appelé depuis l'ui quand le joueur lance la partie
/// Il répartie les tâches et fait les retours par changement d'état ou via le provider messenger
///
class GameManager extends StateNotifier<SessionState> {
  final Ref _ref;
  Timer? _waitDiff;
  Timer? _waitDraw;

  late SessionState _result;

  int _maxCurrentValue = Constants.DURATION_NORMAL_MODE;
  int get maxCurrentValue => _maxCurrentValue;

  Set<CaseModel> _errorSetCase = {};
  Set<CaseModel> get errorSetCase => _errorSetCase;

  final MoveManagerService _moveManageService;

  bool _newRecord = false;
  bool get newRecord => _newRecord;

  ///initialisation de la classe
  GameManager(int levelPlaying, this._ref, this._moveManageService)
    : super(_calculerEtatInitial(levelPlaying)) {
    _startGame();
  }

  void _startGame() {
    final initialMoney = _ref.read(moneyProvider);

    if (initialMoney.canUseBonusDifficulty) {
      state = state.copyWith(statutPartie: EtatGame.waitDifficulty);

      _waitDiff = Timer(
        Duration(seconds: Constants.DURATION_PREVIEW_LEVEL),
        () => state = state.copyWith(statutPartie: EtatGame.chooseDifficulty),
      );
    } else {
      state = state.copyWith(statutPartie: EtatGame.isPlaying);
    }
  }

  /// Initialisation de l'état
  static SessionState _calculerEtatInitial(int niveau) {
    final level = Hive.box<LevelModel>(Constants.levelBox).get(niveau)!;
    final firstCase = level.firstCase;
    final size = level.size;
    return SessionState(
      levelId: niveau,
      levelSize: size,
      firstCase: firstCase,
      roadList: [firstCase],
      roadSet: {firstCase},
      lastTagSave: 1,
      statutPartie: EtatGame.loading,
      difficultyMode: TypeDifficulty.normal,
      timerState: TimerAction.init,
      error: ErrorPlayer.none,
      stateGamePage: StateGamePage.playing,
    );
  }

  // Gestion de la partie et ses mouvements

  /// A chaque mouvement envoie les informations à movemanager et affiche le message correspondant
  ///
  /// Pour que le joueur puisse jouer l'état doit être [isPlaying]
  /// Ordone le lancement timer si c'est le premier mouvement

  void handleMove(CaseModel newCase) {
    MoveResult result;
    _errorSetCase = {};

    //Vérifications :
    // état de jeu -> si le droit de jouer
    // si le joueur appuie sur une case différente de la dernière
    // PAs de mouvement autorisé si les conditions non respectées
    if (state.statutPartie != EtatGame.isPlaying ||
        state.roadList.last == newCase) {
      return;
    }

    //nettoyage et initialisation
    // Suprime la liste de case erronées pour qu'elles ne soient plus affichées
    state = state.copyWith(
      statutPartie: EtatGame.waitVerifRoad,
      error: ErrorPlayer.none,
    );

    // Demande annulation du chemin
    // peut etre fait avant l'iniatlisation car la road n'est que la case initiale donc évacué avant
    if (state.roadSet.contains(newCase)) {
      final newState = _moveManageService.cancelMove(state, newCase);
      state = newState.copyWith(
        statutPartie: EtatGame.isPlaying,
        timerState: TimerAction.play,
      );
      return;
    }

    //Envoie des donné au gestionnaire des routes -> vérif chemin ok
    result = _moveManageService.handleMove(state, newCase);

    final codeFeedback = result.statusCode;
    final CaseModel? errorCase = result.errorCase;
    final newState = result.sessionState;
    final bool? wallError = result.wallError;

    if (codeFeedback == MoveStatusCode.success) {
      if (state.timerState == TimerAction.init) {
        state = state.copyWith(timerState: TimerAction.play);
      }
      _startAnimationTimer(false, newState);
    } else if (codeFeedback == MoveStatusCode.successlastTagCheck) {
      print("gamemanager test lastGame");
      _checkEndGame(newState);
    } else
    // Erreur du joueur dans sa technique
    // séparation du wall car par la même animation du résultat
    if (codeFeedback == MoveStatusCode.error) {
      _errorSetCase = errorCase != null ? {errorCase} : {};

      final error = wallError != null && wallError
          ? ErrorPlayer.wall
          : ErrorPlayer.other;

      state = state.copyWith(statutPartie: EtatGame.isPlaying, error: error);
    } else
    // Gestion des 2 derniers cas qui eux devront déclancher une snackbarre
    {
      final String message = codeFeedback == MoveStatusCode.notOrthoError
          ? "Le mouvement est soit horizontal soit vertical uniquement"
          : "Erreur de l'application. Merci de contacter le créateur";

      _ref.read(messageProvider.notifier).state = message;

      state = state.copyWith(
        statutPartie: EtatGame.isPlaying,
        error: ErrorPlayer.snackbar,
      );
    }
  }

  /// Si le joueur arrive à la dernière balise vérification du gain de la partie
  ///
  /// Si tout le tableau est rempli les sauvegardes sont appelées et passage en Win
  /// Sinon retour comme quoi le tableau n'est pas remplis

  void _checkEndGame(SessionState result) async {
    final cases = Hive.box<LevelModel>(
      Constants.levelBox,
    ).get(state.levelId)!.cases;
    if (result.roadList.length == cases.length) {
      state = state.copyWith(timerState: TimerAction.win);

      _result = result;
    } else {
      final setCases = cases.toSet();
      _errorSetCase = setCases.difference(state.roadSet);
      state = state.copyWith(
        statutPartie: EtatGame.isPlaying,
        error: ErrorPlayer.other,
      );
    }
  }

  /// Gestion du timer de l'animation du dessin
  ///
  /// Il gère le passage de l'état isDrawing à isPlaying au bout du temps imparti
  /// Paramètre :
  /// [endState] est l'état de la partie après l'animation soit en jeu soit en victoire
  /// [result] est l'état de la session après la vérification pour mettre à jour la route finale après l'animation

  void _startAnimationTimer(bool win, SessionState result) {
    print("start animation pour victoire? $win");
    const int tickMs = 20;
    double progress = 0;

    final double step = tickMs / Constants.DURATION_DRAWING_MS;

    state = state.copyWith(statutPartie: EtatGame.isDrawing);

    _waitDraw = Timer.periodic(const Duration(milliseconds: tickMs), (timer) {
      progress += step;

      if (progress < 1.0) {
        state = state.copyWith(
          animationProgress: progress,
          dataPainting: result.dataPainting!,
        );
      } else {
        timer.cancel();
        state = win
            ? result.copyWith(
                animationProgress: null,
                dataPainting: null,
                stateGamePage: StateGamePage.win,
                statutPartie: EtatGame.win,
                timerState: TimerAction.stop,
              )
            : state = result.copyWith(
                animationProgress: null,
                dataPainting: null,
                statutPartie: EtatGame.isPlaying,
              );
      }
    });
  }

  Future<void> finishGame(int timeGame) async {
    await _saveRecord(timeGame, state);
    _startAnimationTimer(true, _result);
  }

  /// Après vérification si le record est battut, envoie de la demande de sauvegarde
  ///
  Future<void> _saveRecord(int timeGame, SessionState state) async {
    final levelId = state.levelId;
    final difficulty = state.difficultyMode;

    final levelData = await _ref
        .read(levelProfilProvider(levelId).notifier)
        .saveEndGame(timeGame, difficulty);

    _newRecord = levelData.record;
    final isalreadyHard = _ref
        .read(levelProfilProvider(state.levelId))
        .winWithHard;

    if (!isalreadyHard || levelData.record) {
      await _saveWinGame();
    }

    if (!levelData.save) {
      _ref.read(messageProvider.notifier).state =
          "Erreur lors de la sauvegarde du record. Contacter le support.";
    }
  }

  /// Si la partie est gagnée envoie la maj des information de [MoneyService]
  ///
  Future<void> _saveWinGame() async {
    final moneyP = _ref.read(moneyProvider.notifier);

    final majEndGame = await moneyP.majMoneyEndGame(
      state.difficultyMode,
      state.levelId,
    );
    if (!majEndGame) {
      _ref.read(messageProvider.notifier).state =
          "Le gain n'a pas pu être sauvegardé pour défaut de mémoire.";
    }
  }

  /// Fonction appellé par le popup de choix d'achat de bonus
  ///
  /// Vérification de la possibiliter de prendre un bonus de temps
  /// appelé par timeBanner en fin de timer

  void canUseBonusTime() {
    ///modif en attendant popup
    final useBonus = _ref.read(moneyProvider).canUseBonusTime;
    if (useBonus) {
      //lancement du popup et traitement de la rep
      state = state.copyWith(statutPartie: EtatGame.chooseAddTime);
    } else {
      state = state.copyWith(stateGamePage: StateGamePage.loose);
    }
  }

  void bonusAll(TypeBonus bonus, bool addIt) {
    switch (bonus) {
      case TypeBonus.bonusTime:
        _addTimechoose(addIt);
      case TypeBonus.bonusDifficulty:
        _difficultyChoose(addIt);
    }
  }

  /// paramètre [chooseHard] est true si le joueur change le niveau false sinon
  /// Si le joueur refuse le changelment le statut de la partie passe en isplayin directement
  /// Modification de l'état de la partie si l'achat et la sauvegarde à réussi  et envoie du message à afficher
  /// Si echec matien du niveau à normal
  ///
  /// Passage à isPlaying en fin quoi qu'il arrive
  Future<void> _difficultyChoose(bool chooseHard) async {
    if (!chooseHard) {
      _maxCurrentValue = Constants.DURATION_NORMAL_MODE;
      state = state.copyWith(statutPartie: EtatGame.isPlaying);
    } else {
      final moneyP = _ref.read(moneyProvider.notifier);

      final resultBuy = await moneyP.buyDifficulty();

      if (resultBuy) {
        _maxCurrentValue = Constants.DURATION_HARD_MODE;
        state = state.copyWith(
          difficultyMode: TypeDifficulty.hard,
          statutPartie: EtatGame.isPlaying,
        );
        _ref.read(messageProvider.notifier).state =
            "Bonne chance pour le mode Hard !";
      } else {
        _maxCurrentValue = Constants.DURATION_NORMAL_MODE;
        state = state.copyWith(statutPartie: EtatGame.isPlaying);
        _ref.read(messageProvider.notifier).state =
            "Echec du changement de niveau de difficultés. Niveau joué en normal";
      }
    }
  }

  /// Fonction appellé par le popup de choix de difficulté
  ///
  /// paramètre [chooseTime] est true si le joueur change le niveau false sinon
  /// Si le joueur refuse l'augmentation de tamps le statut de la partie passe en loose directement
  ///
  /// Modification de l'état de la partie si l'achat et la sauvegarde ont réussi
  ///   - mise à jour de l'état de la partie -> la difficulté en normal, monnaie à jour, statut isPlaying
  ///   - lancement du timer avec 30s supplémentaire
  ///
  /// Si echec passage en état loose et envoie du message d'information
  ///
  ///
  Future<void> _addTimechoose(bool chooseTime) async {
    if (!chooseTime) {
      state = state.copyWith(stateGamePage: StateGamePage.loose);
    } else {
      final moneyP = _ref.read(moneyProvider.notifier);

      final resultBuy = await moneyP.buyTime();
      if (resultBuy) {
        state = state.copyWith(
          difficultyMode: TypeDifficulty.normal,
          statutPartie: EtatGame.isPlaying,
          timerState: TimerAction.addTime,
        );
      } else {
        state = state.copyWith(stateGamePage: StateGamePage.loose);
        _ref.read(messageProvider.notifier).state =
            "Achat du temps non finalisée, la partie est terminée";
      }
    }
  }

  /// fonction de la pause du timer sur demande du joueur
  ///si actuellement en pause passe en jeu et inversement

  void pauseResumeTime(bool isPause) {
    final newStatue = isPause ? EtatGame.isPlaying : EtatGame.pause;

    state = state.copyWith(statutPartie: newStatue);
  }

  /// Permet le nettoyage des contrôleurs
  ///

  void resetForReplay() {
    state = state.copyWith(
      roadList: [state.firstCase],
      roadSet: {state.firstCase},
      lastTagSave: 1,
      statutPartie: EtatGame.loading,
      difficultyMode: TypeDifficulty.normal,
      stateGamePage: StateGamePage.playing,
      timerState: TimerAction.init,
    );
    _startGame();
  }

  @override
  void dispose() {
    _waitDiff?.cancel();
    _waitDraw?.cancel();
    super.dispose();
  }
}
