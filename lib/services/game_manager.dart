import 'dart:async';
import 'package:clean_temp/data/constants.dart';
import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/case/case_model.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/models/money/money_model.dart';
import 'package:clean_temp/models/session_state.dart';
import 'package:clean_temp/providers/hive_service_provider.dart';
import 'package:clean_temp/providers/message_provider.dart';
import 'package:clean_temp/providers/money_provider.dart';
import 'package:clean_temp/providers/money_service_provider.dart';
import 'package:clean_temp/services/hive_service.dart';
import 'package:clean_temp/services/money_service.dart';
import 'package:clean_temp/services/move_manager_service.dart';
import 'package:flutter/foundation.dart';
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

  final HiveService _hiveService;
  final MoneyService _moneyService;
  final MoveManagerService _moveManageService;

  ///initialisation de la classe
  GameManager(
    LevelModel levelPlaying,
    this._moneyService,
    this._hiveService,
    this._ref,
    this._moveManageService, {
    required MoneyModel initialMoney,
  }) : super(_calculerEtatInitial(levelPlaying, initialMoney)) {
    final bonusBuyValidation = _moneyService.canUseBonus(
      initialMoney,
      TypeBonus.bonusDifficulty,
    );

    if (bonusBuyValidation) {
      state = state.copyWith(statutPartie: EtatGame.waitDifficulty);
      _stratWaitingDifficulty();
    } else {
      state = state.copyWith(statutPartie: EtatGame.isPlaying);
    }
  }

  /// création de l'état initial de Session State
  static SessionState _calculerEtatInitial(
    LevelModel niveau,
    MoneyModel money,
  ) {
    return SessionState(
      levelConfig: niveau,
      // roadList: [niveau.firstCase],
      roadList: [CaseModel(xValue: 0, yValue: 0, wallV: true, numberTag: 1)],
      // roadSet: {niveau.firstCase},
      roadSet: {CaseModel(xValue: 0, yValue: 0, wallV: true, numberTag: 1)},
      lastTagSave: 1,
      statutPartie: EtatGame.loading,
      difficultyMode: TypeDifficulty.normal,
      moneyData: money,
      actualValue: 0,
      timerState: TimerAction.init,
      error: ErrorPlayer.none,
    );
  }

  /// Mise en place du timer de prévisualisation de la grille
  /// Il est lancé uniquement si le joueur à les moyen d'acheter le changement de difficulté
  /// Une fois terminé passe en etat chooseDifficulty pour afficher le popup de choix
  void _stratWaitingDifficulty() {
    _waitDiff = Timer(
      Duration(seconds: Constants.DURATION_PREVIEW_LEVEL),
      () => state = state.copyWith(statutPartie: EtatGame.chooseDifficulty),
    );
  }

  /// Vérification de la possibiliter de prendre un bonus de temps
  /// appelé par timeBanner en fin de timer

  void canUseBonus() {
    final chekBonus = _moneyService.canUseBonus(
      state.moneyData,
      TypeBonus.bonusTime,
    );
    if (chekBonus) {
      //lancement du popup et traitement de la rep
      state = state.copyWith(statutPartie: EtatGame.chooseAddTime);
    } else {
      state = state.copyWith(statutPartie: EtatGame.loose);
    }
  }

  /// fonction de mise en pause du timer sur demande du joueur
  ///
  /// passe l'état de la partie en pause
  void pauseTime() {
    state = state.copyWith(statutPartie: EtatGame.pause);
  }

  /// Permet de redémarrer le timer après une pause
  ///
  /// repasse la partie en isPalaying
  void resumeTime() {
    state = state.copyWith(statutPartie: EtatGame.isPlaying);
  }

  /// Gestion du timer de l'animation du dessin
  ///
  /// Il gère le passage de l'état isDrawing à isPlaying au bout du temps imparti
  /// Paramètre :
  /// [endState] est l'état de la partie après l'animation soit en jeu soit en victoire
  /// [result] est l'état de la session après la vérification pour mettre à jour la route finale après l'animation
  void _startAnimationTimer(EtatGame endState, SessionState result) {
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

        state = result.copyWith(
          animationProgress: null,
          dataPainting: null,
          statutPartie: endState,
        );
      }
    });
  }

  /// Permet le nettoyage des contrôleurs
  @override
  void dispose() {
    _waitDiff?.cancel();
    _waitDraw?.cancel();
    super.dispose();
  }

  //gestion des scores de fin de partie

  void finishGame(int timeGame) async {
    print("Sauvegarde de win");
    await _saveRecord(timeGame);
    await _saveWinGame();
    _startAnimationTimer(EtatGame.win, _result);
  }

  /// Après vérification si le record est battut, envoie de la demande de sauvegarde
  ///
  Future<void> _saveRecord(int timeGame) async {
    if (state.levelConfig.bestRecordNormalSeconds > timeGame) {
      try {
        await _hiveService.saveRecord(state.levelConfig.levelId, timeGame);
      } catch (e) {
        _ref.read(messageProvider.notifier).state =
            "Erreur lors de la sauvegarde du record. Contacter le support.";
        if (kDebugMode) {
          print("Erreur de la demande de sauvegarde du record : $e");
        }
      }
    } else {
      _ref.read(messageProvider.notifier).state =
          "Bravo ! Record non battu (actuel: ${state.levelConfig.bestRecordNormalSeconds}s)";
    }
  }

  /// Si la partie est gagnée envoie la maj des information de [MoneyService]
  ///
  Future<void> _saveWinGame() async {
    try {
      ResultActionBonus returnState = await _moneyService.handleWinGame(
        levelId: state.levelConfig.levelId,
        difficultyMode: state.difficultyMode,
        moneyState: state.moneyData,
      );
      if (returnState.isDo) {
        state = state.copyWith(moneyData: returnState.state);
      } else {
        _ref.read(messageProvider.notifier).state =
            "Le gain n'a pas pu être sauvegardé pour défaut de mémoire.";
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur de sauvegarde suite à victoire : $e");
      }
      _ref.read(messageProvider.notifier).state =
          "Impossible de sauvegarder le score. ";
    }
  }

  /// Si le joueur arrive à la dernière balise vérification du gain de la partie
  ///
  /// Si tout le tableau est rempli les sauvegardes sont appelées et passage en Win
  /// Sinon retour comme quoi le tableau n'est pas remplis

  void _checkEndGame(SessionState result) async {
    print(
      "checkAndgame. : ${result.roadList.length} =? ${state.levelConfig.cases.length}",
    );
    if (result.roadList.length == state.levelConfig.cases.length) {
      print("gagné");
      state = state.copyWith(timerState: TimerAction.win);
      print(state.timerState);
      _result = result;
    } else {
      _errorSetCase = state.levelConfig.cases.toSet().difference(
        state.roadSet.toSet(),
      );
      state = state.copyWith(
        statutPartie: EtatGame.isPlaying,
        error: ErrorPlayer.other,
      );
    }
  }

  // Gestion de la partie et ses mouvements

  /// A chaque mouvement envoie les informations à movemanager et affiche le message correspondant
  ///
  /// Pour que le joueur puisse jouer l'état doit être [isPlaying]
  /// Ordone le lancement timer si c'est le premier mouvement

  void handleMove(CaseModel newCase) {
    MoveResult result;
    _errorSetCase = {};

    // vérificcation en mode jeu et qu'on
    if (state.statutPartie != EtatGame.isPlaying ||
        state.roadList.last == newCase) {
      return;
    }

    //nettoyage et initialisation
    state = state.copyWith(
      statutPartie: EtatGame.waitVerifRoad,
      error: ErrorPlayer.none,
    );

    // Demande annulation du chemin
    // peut etre fait avant l'iniatlisation car la road n'est que la case initiale donc évacué avant
    if (state.roadSet.contains(newCase)) {
      final newState = _moveManageService.cancelMove(state, newCase);
      state = newState.copyWith(statutPartie: EtatGame.isPlaying);
      return;
    }

    //Envoue des donné au gestionnaire des routes
    result = _moveManageService.handleMove(state, newCase);

    final codeFeedback = result.statusCode;
    final CaseModel? errorCase = result.errorCase;
    final newState = result.sessionState;

    if (codeFeedback == MoveStatusCode.success) {
      if (state.timerState == TimerAction.init) {
        state = state.copyWith(timerState: TimerAction.play);
      }
      _startAnimationTimer(EtatGame.isPlaying, newState);
    } else if (codeFeedback == MoveStatusCode.successlastTagCheck) {
      _checkEndGame(newState);
    } else
    // Erreur du joueur dans sa technique
    // séparation du wall car par la même animation du résultat
    if (codeFeedback == MoveStatusCode.otherError ||
        codeFeedback == MoveStatusCode.wallError) {
      _errorSetCase = errorCase != null ? {errorCase} : {};

      final error = codeFeedback == MoveStatusCode.wallError
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

  //Fonctions appelé par la validation des popup

  /// Fonction appellé par le popup de choix de difficulté
  ///
  /// paramètre [chooseHard] est true si le joueur change le niveau false sinon
  /// Si le joueur refuse le changelment le statut de la partie passe en isplayin directement
  /// Modification de l'état de la partie si l'achat et la sauvegarde à réussi  et envoie du message à afficher
  /// Si echec matien du niveau à normal
  ///
  /// Passage à isPlaying en fin quoi qu'il arrive
  Future<void> difficultyChoose(bool chooseHard) async {
    if (!chooseHard) {
      _maxCurrentValue = Constants.DURATION_NORMAL_MODE;
      state = state.copyWith(statutPartie: EtatGame.isPlaying);
    } else {
      try {
        final resultBuy = await _moneyService.buyBonus(
          state.moneyData,
          TypeBonus.bonusDifficulty,
        );

        if (resultBuy.isDo) {
          _maxCurrentValue = Constants.DURATION_HARD_MODE;
          state = state.copyWith(
            moneyData: resultBuy.state,
            difficultyMode: TypeDifficulty.hard,
            statutPartie: EtatGame.isPlaying,
          );

          _ref.read(messageProvider.notifier).state =
              "Bonne chance pour le mode Hard !";
        }
      } catch (e) {
        if (kDebugMode) {
          print("Erreur lors du changement de difficultées : $e");
        }
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
  Future<void> addTimechoose(bool chooseTime) async {
    if (!chooseTime) {
      state = state.copyWith(statutPartie: EtatGame.loose);
    } else {
      try {
        final resultBuy = await _moneyService.buyBonus(
          state.moneyData,
          TypeBonus.bonusTime,
        );

        if (resultBuy.isDo) {
          state = state.copyWith(
            moneyData: resultBuy.state,
            difficultyMode: TypeDifficulty.normal,
            statutPartie: EtatGame.isPlaying,
            timerState: TimerAction.addTime,
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print("Erreur lors du changement de difficultées : $e");
        }
        state = state.copyWith(statutPartie: EtatGame.loose);
        _ref.read(messageProvider.notifier).state =
            "Achat du temps non finalisée, la partie est terminée";
      }
    }
  }
}

/// Définission du provider de gameManager
///
final gameManagerProvider =
    StateNotifierProvider.family<GameManager, SessionState, LevelModel>((
      ref,
      level,
    ) {
      final hiveService = ref.read(hiveServiceProvider);

      final moveManagerService = MoveManagerService();

      final moneyService = ref.read(moneyServiceProvider);

      final initialMoney = ref.read(moneyProvider);

      return GameManager(
        level,
        moneyService,
        hiveService,
        ref,
        moveManagerService,
        initialMoney: initialMoney,
      );
    });
