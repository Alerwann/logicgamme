import 'dart:async';
import 'dart:ffi';

import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/models/session_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class GameManager extends StateNotifier<SessionState> {
  Timer? _timer;
  Duration _tempsEcoule = Duration.zero;

  GameManager(LevelModel levelPlaying)
    : super(_calculerEtatInitial(levelPlaying)) {
    _startTimer(levelPlaying);
  }

  void _startTimer(LevelModel level) {
    int sDurationLevel = level.hardDifficulty ? 60 : 90;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _tempsEcoule = _tempsEcoule + const Duration(seconds: 1);

          if (_tempsEcoule.inSeconds >= sDurationLevel) {
        // 🚨 Arrêter le Timer !
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
      lastTag: 1,
      statutPartie: EtatGame.isPlaying,
    );
  }
}

final gameManagerProvider =
    StateNotifierProvider.family<GameManager, SessionState, LevelModel>((
      ref,
      level,
    ) {
      // La fonction de création utilise l'argument 'level' pour initialiser le GameManager.
      return GameManager(level);
    });
