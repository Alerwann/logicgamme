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

  Timer? _timer;
  Timer? _waitDiff;
  Timer? _waitDraw;

  Duration _tempsEcoule = Duration.zero;

  Duration get tempsEcoule => _tempsEcoule;

  int _resultTimer = 0;
  int get resultTimer => _resultTimer;

  int _maxCurrentValue = 0;
  int get maxCurrentValue => _maxCurrentValue;

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

  /// Lancement du timer de la partie
  /// Il demarre au premier toucher
  /// Quand le compteur est à 0 :
  ///   - il est arrété
  ///   - passe en waitAddtime qui vérifie
  ///   - si assez pour acheté passe l'état en chooseAddtime pour déclancé un popup de choix
  ///   - si pas assez passe l'état en loose pour signaler la perte de la partie

  void _startTimer(int sDurationLevel) {
    _resultTimer = sDurationLevel;
    _maxCurrentValue = sDurationLevel;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _tempsEcoule = _tempsEcoule + const Duration(seconds: 1);

      _resultTimer -= 1;

      if (_resultTimer == 0) {
        timer.cancel();
        state = state.copyWith(statutPartie: EtatGame.waitAddTime);
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
    });
  }

  /// fonction de mise en pause du timer sur demande du joueur
  ///
  /// passe l'état de la partie en pause
  void pauseTime() {
    _timer?.cancel();
    state = state.copyWith(statutPartie: EtatGame.pause);
  }

  /// Permet de redémarrer le timer après une pause
  ///
  /// repasse la partie en isPalaying
  void resumeTime() {
    if (state.statutPartie == EtatGame.pause) {
      _startTimer(_resultTimer);
      state = state.copyWith(statutPartie: EtatGame.isPlaying);
    }
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
    _timer?.cancel();
    _waitDiff?.cancel();
    _waitDraw?.cancel();
    super.dispose();
  }

  //gestion des scores de fin de partie

  /// Après vérification si le record est battut, envoie de la demande de sauvegarde
  ///
  Future<void> _saveRecord(LevelModel level) async {
    if (level.bestRecordNormalSeconds > _tempsEcoule.inSeconds) {
      try {
        await _hiveService.saveRecord(level.levelId, _tempsEcoule.inSeconds);

        _ref.read(messageProvider.notifier).state =
            "Nouveau record de ${_tempsEcoule.inSeconds} secondes sauvegardé !";
      } catch (e) {
        _ref.read(messageProvider.notifier).state =
            "Erreur lors de la sauvegarde du record. Contacter le support.";
        if (kDebugMode) {
          print("Erreur de la demande de sauvegarde du record : $e");
        }
      }
    } else {
      _ref.read(messageProvider.notifier).state =
          "Bravo ! Record non battu (actuel: ${level.bestRecordNormalSeconds}s)";
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
        _ref.read(messageProvider.notifier).state =
            "Bravo! Vos récompenses sont à jour";
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
    _timer?.cancel();

    await _saveRecord(state.levelConfig);
    await _saveWinGame();

    _startAnimationTimer(EtatGame.win, result);
  }

  // Gestion de la partie et ses mouvements

  /// A chaque mouvement envoie les informations à movemanager et affiche le message correspondant
  ///
  /// Pour que le joueur puisse jouer l'état doit être [isPlaying]
  /// Ordone le lancement timer si c'est le premier mouvement
  void handleMove(CaseModel newCase) {
    int sDurationLevel;
    switch (state.difficultyMode) {
      case TypeDifficulty.normal:
        sDurationLevel = Constants.DURATION_NORMAL_MODE;
        break;
      case TypeDifficulty.hard:
        sDurationLevel = Constants.DURATION_HARD_MODE;
        break;
    }

    if (state.statutPartie != EtatGame.isPlaying ||
        state.roadList.last == newCase) {
      return;
    }
    state = state.copyWith(statutPartie: EtatGame.waitVerifRoad);
    if (_tempsEcoule.inSeconds == 0 && state.roadSet.length == 1) {
      _startTimer(sDurationLevel);
    }
    final result = _moveManageService.handleMove(state, newCase);

    final codeFeedback = result.statusCode;
    final CaseModel? errorCase = result.errorCase;
    String coords = (errorCase != null)
        ? "aux coordonées (${result.errorCase?.xValue},${result.errorCase?.yValue})"
        : "";

    switch (codeFeedback) {
      case MoveStatusCode.success:
        state = state.copyWith(statutPartie: EtatGame.isDrawing);

        _startAnimationTimer(EtatGame.isPlaying, result.sessionState);
        break;
      case MoveStatusCode.successlastTagCheck:
        {
          /// réflexion en cours pour que le timer se lance et qu'après l'animation se fasse
          state = result.sessionState;
          if (state.roadSet.length == state.levelConfig.cases.length) {
            _checkEndGame(result.sessionState);
          } else {
            _ref.read(messageProvider.notifier).state =
                "Attention : le plateau n'est pas entièrement couvert !";
            state = state.copyWith(statutPartie: EtatGame.isPlaying);
          }
        }
        break;
      case MoveStatusCode.wallError:
        final CaseModel? errorCase = result.errorCase;
        String coords = (errorCase != null)
            ? "aux coordonées (${result.errorCase?.xValue},${result.errorCase?.yValue})"
            : "";
        _ref.read(messageProvider.notifier).state = "Il y a un mur $coords";
        state = state.copyWith(statutPartie: EtatGame.isPlaying);
        break;
      case MoveStatusCode.tagError:
        _ref.read(messageProvider.notifier).state =
            "L'ordre des cibles n'est pas respecté dans la case $coords";
        state = state.copyWith(statutPartie: EtatGame.isPlaying);

        break;
      case MoveStatusCode.alreadyVisitedError:
        _ref.read(messageProvider.notifier).state =
            "Il est interdit de passer deux fois au même endroit";
        state = state.copyWith(statutPartie: EtatGame.isPlaying);

        break;
      case MoveStatusCode.notOrthoError:
        _ref.read(messageProvider.notifier).state =
            "Le mouvement est soit horizontal soit vertical uniquement";
        state = state.copyWith(statutPartie: EtatGame.isPlaying);

        break;
      case MoveStatusCode.internalError:
        _ref.read(messageProvider.notifier).state =
            "Erreur de l'application. Merci de contacter le créateur";
        state = state.copyWith(statutPartie: EtatGame.isPlaying);

        break;
      case MoveStatusCode.successCancel:
        _ref.read(messageProvider.notifier).state =
            "Annulation du chemin effectuée";
        state = result.sessionState.copyWith(statutPartie: EtatGame.isPlaying);
        break;
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
      state = state.copyWith(statutPartie: EtatGame.isPlaying);
    } else {
      try {
        final resultBuy = await _moneyService.buyBonus(
          state.moneyData,
          TypeBonus.bonusDifficulty,
        );

        if (resultBuy.isDo) {
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
          );
          _startTimer(Constants.TIME_ADD_SECONDS);
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
