import 'package:logic_game/models/hive/case/case_model.dart';
import 'package:logic_game/models/models%20utils/data_for_painting.dart';
import 'package:logic_game/models/hive/level/level_model.dart';
import 'package:logic_game/providers/game_manager_provider.dart';
import 'package:logic_game/widget/gamepage/path%20draw/path_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimatedPathLayer extends ConsumerWidget {
  final LevelModel level;
  final double sizeGrid;
  const AnimatedPathLayer({
    super.key,
    required this.level,
    required this.sizeGrid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provid = ref.watch(
      gameManagerProvider(
        level,
      ).select((s) => (s.dataPainting, s.roadList, s.animationProgress)),
    );

    final roadlist = provid.$2;

    final firstCaseX = roadlist[0].xValue;
    final firstCaseY = roadlist[0].yValue;

    final DataForAnimation dataProvid = DataForAnimation(
      coordForPainting:
          provid.$1 ??
          CoordForPainting(
            startCoord: (firstCaseX, firstCaseY),
            endCoord: (firstCaseX, firstCaseY),
          ),
      roadList: roadlist,
      animationProgress: provid.$3 ?? 0,
    );
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(sizeGrid, sizeGrid),
        painter: PathPainter(level: level, provid: dataProvid),
      ),
    );
  }
}

class DataForAnimation {
  final CoordForPainting coordForPainting;
  final List<CaseModel> roadList;
  final double animationProgress;

  DataForAnimation({
    required this.coordForPainting,
    required this.roadList,
    required this.animationProgress,
  });
}
