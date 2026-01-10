import 'package:logic_game/models/hive/noBox/case/case_model.dart';
import 'package:logic_game/models/models%20utils/data_for_painting.dart';
import 'package:logic_game/utils/calcul_coordonnee.dart';
import 'package:logic_game/widget/gamepage/path%20draw/animated_path_layer.dart';
import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {
  final DataForAnimation provid;
  final int sizeLevel;

  PathPainter({required this.sizeLevel, required this.provid});

  @override
  void paint(Canvas canvas, Size size) {
    final double cellSize = size.width / sizeLevel;
    final List<CaseModel> roadlist = provid.roadList;

    final CoordForPainting dataPainting = provid.coordForPainting;

    final animationProgress = provid.animationProgress;

    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = cellSize / 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // BLOC 1 : Le chemin permanent (Le Passé)

    if (roadlist.isNotEmpty) {
      final roadPath = Path();
      final firstCenter = CalculCoordonnee.centerCaseWithCoord((
        roadlist.first.xValue,
        roadlist.first.yValue,
      ), cellSize);

      if (roadlist.length == 1) {
        canvas.drawCircle(
          Offset(firstCenter.$1, firstCenter.$2),
          cellSize * 0.35,
          paint..style = PaintingStyle.fill,
        );

        paint.style = PaintingStyle.stroke;
      } else {
        roadPath.moveTo(firstCenter.$1, firstCenter.$2);
        for (int i = 1; i < roadlist.length; i++) {
          final c = roadlist[i];
          final center = CalculCoordonnee.centerCaseWithCoord((
            c.xValue,
            c.yValue,
          ), cellSize);
          roadPath.lineTo(center.$1, center.$2);
        }
        canvas.drawPath(roadPath, paint);
      }
    }

    // BLOC 2 : Le trait animé (Le Présent)

    final offsets = CalculCoordonnee.dataForPainting(dataPainting, cellSize);

    final start = Offset(offsets.startOffset.$1, offsets.startOffset.$2);
    final end = Offset(offsets.endOffset.$1, offsets.endOffset.$2);

    // Interpolation entre le début et la fin selon le progrès
    final currentEnd = Offset.lerp(start, end, animationProgress);

    if (currentEnd != null) {
      canvas.drawLine(start, currentEnd, paint);
    }
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) {
    return oldDelegate.provid.roadList != provid.roadList ||
        oldDelegate.provid.animationProgress != provid.animationProgress;
  }
}
