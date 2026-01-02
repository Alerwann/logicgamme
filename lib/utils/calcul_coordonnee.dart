import 'package:clean_temp/models/data_for_painting.dart';

class CalculCoordonnee {
  static (double, double) centerCaseWithCoord(
    (int, int) coord,
    double sizeOneCase,
  ) {
    double centerXCoord = (coord.$1 + 0.5) * sizeOneCase;
    double centerYCoord = (coord.$2 + 0.5) * sizeOneCase;

    return (centerXCoord, centerYCoord);
  }

  static OffsetsForPainting dataForPainting(
    CoordForPainting coordAll,
    double cellSize,
  ) {
    final startOffset = centerCaseWithCoord(coordAll.startCoord, cellSize);
    final endOffset = centerCaseWithCoord(coordAll.endCoord, cellSize);

    return OffsetsForPainting(startOffset: startOffset, endOffset: endOffset);
  }



}
