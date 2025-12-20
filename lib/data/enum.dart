// Ensemble des enums

enum EtatGame {
  loading,
  isPlaying,
  win,
  loose,
  pause,
  waitDifficulty,
  waitAddTime,
  chooseDifficulty,
  chooseAddTime,
}

enum MoveStatusCode {
  success,
  successlastTagCheck,
  wallError,
  tagError,
  alreadyVisitedError,
  notOrthoError,
  internalError,
  successCancel,
}

enum TypeMove { vertical, horizontal }

enum TypeBonus { bonusTime, bonusDifficulty }

enum TypeDifficulty { normal, hard }

enum BuyStatusCode { success, saveKO, actionKo }
