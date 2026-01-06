/// Classe qui permet de stocker les coordonnées des cases de début et fin de dessin
/// 
/// ces coordonnées seront convertie en Offsets pour le painter
class CoordForPainting {
  /// Coordonée d'origine du dessin
  final (int, int) startCoord;

  /// Coordonnée de calcule de fin de dessin
  final (int, int) endCoord;

  CoordForPainting({required this.startCoord, required this.endCoord});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoordForPainting &&
          runtimeType == other.runtimeType &&
          startCoord == other.startCoord &&
          endCoord ==other. endCoord;

  @override
  int get hashCode => Object.hash(startCoord, endCoord);
}



/// Classe de coordonnée en double qui seront transmise au painter
class OffsetsForPainting {
  final (double, double) startOffset;
  final (double, double) endOffset;

  OffsetsForPainting({required this.startOffset, required this.endOffset});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OffsetsForPainting &&
          runtimeType == other.runtimeType &&
          startOffset == other.startOffset &&
          endOffset == other.endOffset;

  @override
  int get hashCode => Object.hash(startOffset, endOffset);

}
