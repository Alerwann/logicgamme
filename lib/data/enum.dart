// Ensemble des enums

enum DifficultyGame { normal, difficile }

enum EtatGame { loading, isPlaying, win, loose, pause }

enum MoveStatusCode {
  success,
  successlastTagCheck,
  wallError,
  tagError,
  alreadyVisitedError,
  notOrthoError,
  internalError,
}
