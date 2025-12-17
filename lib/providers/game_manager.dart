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

class GameManager extends StateNotifier<SessionState> {
  final Ref _ref;

  Timer? _timer;
  Timer? _waitDiff;
  Duration _tempsEcoule = Duration.zero;

  Duration get tempsEcoule => _tempsEcoule;

  int _resultTimer = 0;

  final HiveService _hiveService;
  final MoneyService _moneyService;

  final MoveManagerService _moveManageService;

  //initialisation
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

  static SessionState _calculerEtatInitial(
    LevelModel niveau,
    MoneyModel money,
  ) {
    return SessionState(
      levelConfig: niveau,
      roadList: [niveau.firstCase],
      roadSet: {niveau.firstCase},
      lastTagSave: 1,
      statutPartie: EtatGame.loading,
      difficultyMode: TypeDifficulty.normal,
      moneyData: money,
    );
  }

  // gestion des timers

  void _stratWaitingDifficulty() {
    _waitDiff = Timer(
      Duration(seconds: Constants.durationWaitingDif),
      () => state = state.copyWith(statutPartie: EtatGame.chooseDifficulty),
    );
  }

  void _startTimer(int sDurationLevel) {
    _resultTimer = sDurationLevel;
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

  void pauseTime() {
    _timer?.cancel();
    state = state.copyWith(statutPartie: EtatGame.pause);
  }

  void resumeTime() {
    if (state.statutPartie == EtatGame.pause) {
      _startTimer(_resultTimer);
      state = state.copyWith(statutPartie: EtatGame.isPlaying);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _waitDiff?.cancel();
    super.dispose();
  }

  //gestion des scores de fin de partie
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

  Future<void> _saveWinGame() async {
    try {
      (bool, MoneyModel) returnState = await _moneyService.handleWinGame(
        levelId: state.levelConfig.levelId,
        difficultyMode: state.difficultyMode,
        moneyState: state.moneyData,
      );
      if (returnState.$1) {
        state = state.copyWith(moneyData: returnState.$2);
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

  void _checkEndGame() {
    bool isGridCompleted =
        state.roadSet.length == state.levelConfig.cases.length;

    if (isGridCompleted) {
      _timer?.cancel();

      _saveRecord(state.levelConfig);
      _saveWinGame();

      state = state.copyWith(statutPartie: EtatGame.win);
    } else {
      _ref.read(messageProvider.notifier).state =
          "Attention : le plateau n'est pas entièrement couvert !";
    }
  }

  // Gestion de la partie et ses mouvements
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
        state = result.sessionState;
        break;
      case MoveStatusCode.successlastTagCheck:
        {
          state = result.sessionState;
          _checkEndGame();
        }
        break;
      case MoveStatusCode.wallError:
        final CaseModel? errorCase = result.errorCase;
        String coords = (errorCase != null)
            ? "aux coordonées (${result.errorCase?.xValue},${result.errorCase?.yValue})"
            : "";
        _ref.read(messageProvider.notifier).state = "Il y a un mur $coords";
        break;
      case MoveStatusCode.tagError:
        _ref.read(messageProvider.notifier).state =
            "L'ordre des cibles n'est pas respecté dans la case $coords";
        break;
      case MoveStatusCode.alreadyVisitedError:
        _ref.read(messageProvider.notifier).state =
            "Il est interdit de passer deux fois au même endroit";
        break;
      case MoveStatusCode.notOrthoError:
        _ref.read(messageProvider.notifier).state =
            "Le mouvement est soit horizontal soit vertical uniquement";
        break;
      case MoveStatusCode.internalError:
        _ref.read(messageProvider.notifier).state =
            "Erreur de l'application. Merci de contacter le créateur";
    }
  }

  //Fonctions appelé par la validation des popup

  Future<void> difficultyChoose(bool chooseHard) async {
    if (!chooseHard) {
      state = state.copyWith(statutPartie: EtatGame.isPlaying);
    }else{
        try {
        final resultBuy = await _moneyService.buyBonus(
          state.moneyData,
          TypeBonus.bonusDifficulty,
        );

        if (resultBuy.$1) {
          state = state.copyWith(
            moneyData: resultBuy.$2,
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

  Future<void> addTimechoose(bool chooseTime) async {
    if(!chooseTime){
    
      state = state.copyWith(statutPartie: EtatGame.isPlaying);
    }
    else{
      try {
        final resultBuy = await _moneyService.buyBonus(
          state.moneyData,
          TypeBonus.bonusTime,
        );

        if (resultBuy.$1) {
          state = state.copyWith(
            moneyData: resultBuy.$2,
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
