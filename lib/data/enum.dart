// Ensemble des enums

enum DifficultyGame { normal, difficile }

enum EtatGame { loading, isPlaying, win, loose, pause, waitDifficulty, waitAddTime, chooseDifficulty, chooseAddTime }

enum MoveStatusCode {
  success,
  successlastTagCheck,
  wallError,
  tagError,
  alreadyVisitedError,
  notOrthoError,
  internalError,
}


enum TypeBonus{
bonusTime,
bonusDifficulty
}

enum TypeDifficulty{
normal,
hard
}