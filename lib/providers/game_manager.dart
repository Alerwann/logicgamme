import 'dart:async';
import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/case/case_model.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/models/session_state.dart';
import 'package:clean_temp/providers/hive_service_provider.dart';
import 'package:clean_temp/providers/message_provider.dart';
import 'package:clean_temp/services/hive_service.dart';
import 'package:clean_temp/services/move_manager_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameManager extends StateNotifier<SessionState> {
  final Ref _ref;

  Timer? _timer;
  Duration _tempsEcoule = Duration.zero;

  Duration get tempsEcoule => _tempsEcoule;
  final HiveService _hiveService;

  final MoveManagerService _moveManageService;

  GameManager(
    LevelModel levelPlaying,
    this._hiveService,
    this._ref,
    this._moveManageService,
  ) : super(_calculerEtatInitial(levelPlaying));

  void _startTimer(LevelModel level) {
    int sDurationLevel = level.hardDifficulty ? 60 : 90;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _tempsEcoule = _tempsEcoule + const Duration(seconds: 1);

      if (_tempsEcoule.inSeconds >= sDurationLevel) {
        timer.cancel();

        state = state.copyWith(statutPartie: EtatGame.loose);
      }
    });
  }

  static SessionState _calculerEtatInitial(LevelModel niveau) {
    return SessionState(
      levelConfig: niveau,
      roadList: [niveau.firstCase],
      roadSet: {niveau.firstCase},
      lastTagSave: 1,
      statutPartie: EtatGame.isPlaying,
    );
  }

  void pauseTime() {
    _timer?.cancel();
    state = state.copyWith(statutPartie: EtatGame.pause);
  }

  void resumeTime() {
    if (state.statutPartie == EtatGame.pause) {
      _startTimer(state.levelConfig);
      state = state.copyWith(statutPartie: EtatGame.isPlaying);
    }
  }

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

  void _checkEndGame() {
    bool isGridCompleted =
        state.roadSet.length == state.levelConfig.cases.length;

    if (isGridCompleted) {
      _timer?.cancel();

      _saveRecord(state.levelConfig);

      state = state.copyWith(statutPartie: EtatGame.win);
    } else {
      _ref.read(messageProvider.notifier).state =
          "Attention : le plateau n'est pas entièrement couvert !";
    }
  }

  void handleMove(CaseModel newCase) {
    if (state.statutPartie != EtatGame.isPlaying ||
        state.roadList.last == newCase) {
      return;
    }

    if (_tempsEcoule.inSeconds == 0 && state.roadSet.length == 1) {
      _startTimer(state.levelConfig);
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final gameManagerProvider =
    StateNotifierProvider.family<GameManager, SessionState, LevelModel>((
      ref,
      level,
    ) {
      // La fonction de création utilise l'argument 'level' pour initialiser le GameManager.
      final hiveService = ref.read(hiveServiceProvider);
      final moveManagerService = MoveManagerService();
      return GameManager(level, hiveService, ref, moveManagerService);
    });
