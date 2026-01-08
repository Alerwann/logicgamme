import 'dart:async';

import 'package:logic_game/data/constants.dart';
import 'package:logic_game/data/enum/enum.dart';
import 'package:logic_game/models/hive/level/level_model.dart';
import 'package:logic_game/models/hive/money/money_model.dart';
import 'package:logic_game/models/tempory/session_state.dart';

/// création de l'état initial de Session State
SessionState calculerEtatInitial(LevelModel niveau, MoneyModel money) {
  return SessionState(
    levelConfig: niveau,
    roadList: [niveau.firstCase],
    roadSet: {niveau.firstCase},
    lastTagSave: 1,
    statutPartie: EtatGame.loading,
    difficultyMode: TypeDifficulty.normal,
    moneyData: money,
    timerState: TimerAction.init,
    error: ErrorPlayer.none,
    stateGamePage: StateGamePage.playing,
  );
}

/// Mise en place du timer de prévisualisation de la grille
/// Il est lancé uniquement si le joueur à les moyen d'acheter le changement de difficulté
/// Une fois terminé passe en etat chooseDifficulty pour afficher le popup de choix
Timer stratWaitingDifficulty(SessionState state) {
  Timer waitDif = Timer(
    Duration(seconds: Constants.DURATION_PREVIEW_LEVEL),
    () => state = state.copyWith(statutPartie: EtatGame.chooseDifficulty),
  );
  return waitDif;
}
