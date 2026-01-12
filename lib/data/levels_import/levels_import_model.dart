import 'package:flutter/foundation.dart';
import 'package:logic_game/models/hive/noBox/story%20mod/story_data.dart';

/// Model de chaque niveau lors de l'import
///
///
class LevelsImport {
  // id du niveau
  final int levelId;

  /// taille : la grille étant carrée [size] est la longueur et la largeur
  final int size;

  /// liste ordonnée des coordonées ayant un tag
  final List<(int, int)> tagsList;

  /// Set de l'ensemble des case ayant un mur horizontal en bas
  final Set<(int, int)> wallH;

  /// Set de l'ensemble des case ayant un mur vertical à droite
  final Set<(int, int)> wallV;

  final StoryData storyData;

  LevelsImport({
    required this.levelId,
    required this.size,
    required this.tagsList,
    required this.wallH,
    required this.wallV,
    required this.storyData,
  });

  /// vérification d'égalité de 2 niveaux par leur valeurs
  ///
  /// L'id n'est pas pris en compte pour etre sur que 2 niveaux ont exactement 2 configurations différentes
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelsImport &&
          runtimeType == other.runtimeType &&
          size == other.size &&
          listEquals(tagsList, other.tagsList) &&
          setEquals(wallH, other.wallH) &&
          setEquals(wallV, other.wallV) &&
          storyData==other.storyData;

  /// Génère une clé de hachage basée sur l'ensemble des propriétés de la case.
  @override
  int get hashCode => Object.hash(
    size,
    Object.hashAll(tagsList),
    Object.hashAll(wallH),
    Object.hashAll(wallV),
    storyData
  );
}
