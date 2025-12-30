import 'package:clean_temp/utils/calcul_coordonnee.dart';
import 'package:flutter/material.dart';
import 'package:clean_temp/models/session_state.dart';

class PathPainter extends CustomPainter {
  final SessionState state;

  PathPainter({required this.state});

  @override
  void paint(Canvas canvas, Size size) {

    final double cellSize = size.width / state.levelConfig.size;

    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = cellSize / 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // BLOC 1 : Le chemin permanent (Le Passé)

    if (state.roadList.isNotEmpty) {
      final roadPath = Path();
      final firstCenter = CalculCoordonnee.centerCaseWithCoord((
        state.roadList.first.xValue,
        state.roadList.first.yValue,
      ), cellSize);

      if (state.roadList.length == 1) {
        canvas.drawCircle(
          Offset(firstCenter.$1, firstCenter.$2),
          cellSize * 0.35,
          paint..style = PaintingStyle.fill,
        );

        paint.style = PaintingStyle.stroke;
      } else {
        roadPath.moveTo(firstCenter.$1, firstCenter.$2);
        for (int i = 1; i < state.roadList.length; i++) {
          final c = state.roadList[i];
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
    if (state.dataPainting != null) {
      final offsets = CalculCoordonnee.dataForPainting(
        state.dataPainting!,
        cellSize,
      );

      final start = Offset(offsets.startOffset.$1, offsets.startOffset.$2);
      final end = Offset(offsets.endOffset.$1, offsets.endOffset.$2);

      // Interpolation entre le début et la fin selon le progrès
      final currentEnd = Offset.lerp(start, end, state.animationProgress ?? 0);

      if (currentEnd != null) {
        canvas.drawLine(start, currentEnd, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) {
    return oldDelegate.state.roadList != state.roadList ||
        oldDelegate.state.animationProgress != state.animationProgress;
  }
}
