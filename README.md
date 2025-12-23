# 🧩 LogicGamme

LogicGamme est un jeu de puzzle logique développé avec Flutter et Riverpod. Le joueur doit tracer un chemin sur une grille en respectant des contraintes de murs, l'ordre de balises numériques et une couverture totale du plateau.

## 🎄 État du projet (Pause de Noël 2025)

Le projet a franchi une étape majeure dans la séparation des couches de rendu et la gestion robuste des états de jeu.

### ✅ Fondations Solides
* **Gestion d'État (Riverpod)** : Utilisation de `SessionState` immuable avec `copyWith` et comparaisons de valeurs pour une réactivité optimale de l'UI.
* **Moteur de Jeu (`GameManager`)** : Centralise la logique des timers, le suivi du score, la gestion de la monnaie virtuelle et les transitions d'états (`isPlaying`, `loading`, etc.).
* **Validation des Mouvements** : Le `MoveManagerService` garantit l'intégrité des déplacements (murs, balises, non-chevauchement).
* **UI Multi-couches** :
    * **Couche 1** : Fond de grille statique optimisé.
    * **Couche 3** : Grille interactive gérant les murs (bordures) et les balises visuelles.

### 🛠️ Travaux en cours : Système d'Animation
L'architecture pour le tracé fluide du chemin est prête :
* **Modèles de données** : Création de `DataForPainting` et `PendingMovement` pour transporter les coordonnées (`Offset`) et le progrès de l'animation.
* **Calcul des coordonnées** : Utilitaire `CalculCoordonnee` opérationnel pour convertir les cases de la grille en pixels.

## 🚀 Prochaines étapes (Reprise Janvier)

1.  **Implémentation de l'état `isAnimating`** :
    * Ajouter l'état à l'énumération `EtatGame` pour verrouiller les interactions pendant les déplacements.
    * Gérer le timer de 500ms dans le `GameManager` avant la validation finale du mouvement.
2.  **Couche 2 : Le PathPainter** :
    * Développer le `CustomPainter` pour dessiner le tracé permanent (`roadList`) et le segment animé (`pendingMovement`).
    * Utiliser `Offset.lerp` pour une fluidité parfaite du trait vert fluo.
3.  **Finalisation du "Swap"** :
    * Fusionner visuellement le segment animé dans le tracé permanent à la fin de l'animation pour éviter tout clignotement.

## 🛠 Tech Stack
* **Framework** : Flutter
* **State Management** : Riverpod
* **Data Models** : Freezed / Immuabilité manuelle
* **Stockage** : Hive (pour les records et la monnaie)
