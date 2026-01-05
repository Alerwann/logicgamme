// Ensemble des enums

enum EtatGame {
  /// Chargement initial
  loading,

  /// Le joeur peut jouer
  isPlaying,

  /// Le joueur a gagné
  win,

  /// Le joueur a perdu
  loose,

  /// Le joueur a mis la partie en pause
  pause,

  /// En attente de savoir si le joueur peut modifier la difficulté
  waitDifficulty,

  /// En attente de savoir si le joueur peut ajouter du temps
  waitAddTime,

  /// En attente de savoir si le joueur veut modifier la difficulté
  chooseDifficulty,

  /// En attente de savoir si le joueur veut ajouter du temps
  chooseAddTime,

  /// En attente de la fin du dessin de la fin du tracé
  isDrawing,

  /// Attente de véification du tracé
  waitVerifRoad,
}

enum StateGamePage { playing, win, loose}

enum MoveStatusCode {
  /// Si le mouvement n'a pas eu d'obstacle
  success,

  /// Mouvement sans obstacle et la dernoère balise est atteinte(demi victoire)
  successlastTagCheck,

  /// le chemin traverse un mur
  wallError,

  /// le chemin est en diagonale
  notOrthoError,

  /// erreur lors de la création des chemins  interne au chargement de niveau
  internalError,

  /// autres erreur possibles
  otherError,
}

enum ErrorPlayer { wall, other, none, snackbar}

enum TypeMove { vertical, horizontal }

enum TypeBonus { bonusTime, bonusDifficulty }

enum TypeDifficulty { normal, hard }

enum BuyStatusCode {
  /// la mise à jour et la sauvegarde de l'achat a réussi
  success,

  /// Impossible de sauvegarder l'achat
  saveKO,

  /// Achat a échoué par manque de money
  actionKo,
}

enum CodeLevelGenerator {
  /// le niveau a été généré avec succès
  success,

  /// le niveau demandé est supérieur au niveau max du jeu
  countLevelKo,

  /// les tags ont une erreur lors de la saisie du niveau
  countTagKo,

  /// Le niveau n'existe pas
  levelNotExist,
}

enum TimerAction { play, pause, stop, addTime, win, init }
