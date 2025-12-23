import 'package:clean_temp/models/data_for_painting.dart';

class CalculCoordonnee {
  static (double, double) _centerCaseWithCoord(
    (int, int) coord,
    double sizeOneCase,
  ) {
    double centerXCoord = coord.$1 * 1.5 * sizeOneCase;
    double centerYCoord = coord.$2 * 1.5 * sizeOneCase;

    return (centerXCoord, centerYCoord);
  }

  static (bool, OffsetsForPainting) dataForPainting(
CoordForPainting coordAll,
    double sizeGrid,
    int size,
  ) {
    if (size == 0) {
      return (false, OffsetsForPainting(startOffset: (0, 0), endOffset: (0, 0)));
    }

    final sizeOneCase = sizeGrid / size;

    final startOffset = _centerCaseWithCoord(coordAll.startCoord, sizeOneCase);
    final endOffset = _centerCaseWithCoord(coordAll.endCoord, sizeOneCase);

    return (
      true,
      OffsetsForPainting(startOffset: startOffset, endOffset: endOffset),
    );
  }
}
