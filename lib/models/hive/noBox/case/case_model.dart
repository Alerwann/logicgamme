import 'package:hive/hive.dart';

part 'case_model.g.dart';

/// Représente une cellule individuelle de la grille de jeu.
///
/// Chaque case est définie par ses coordonnées [xValue] et [yValue].
/// L'origine (0,0) se situe dans le coin supérieur gauche.

@HiveType(typeId: 10)
class CaseModel {
  @HiveField(0)
  final int xValue;
  @HiveField(1)
  final int yValue;

  /// Indique si un mur horizontal est présent en bas de la case.
  @HiveField(2)
  final bool? wallH;

  /// Indique si un mur Vertical est présent à droite de la case.
  @HiveField(3)
  final bool? wallV;

  /// Le numéro d'ordre à atteindre (balise), ou null si la case est vide.
  @HiveField(4)
  final int? numberTag;

  CaseModel({
    required this.xValue,
    required this.yValue,
    this.wallH,
    this.wallV,
    this.numberTag,
  });

  /// Compare deux instances de [CaseModel] par leurs valeurs.
  ///
  /// Retourne true si les coordonnées, les murs et le tag sont strictement identiques.

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaseModel &&
          runtimeType == other.runtimeType &&
          xValue == other.xValue &&
          yValue == other.yValue &&
          wallH == other.wallH &&
          wallV == other.wallV &&
          numberTag == other.numberTag;

  /// Génère une clé de hachage basée sur l'ensemble des propriétés de la case.
  @override
  int get hashCode => Object.hash(xValue, yValue, wallH, wallV, numberTag);
}
