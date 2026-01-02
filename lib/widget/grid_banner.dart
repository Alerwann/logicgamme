import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/services/game_manager.dart';
import 'package:clean_temp/widget/case_widget.dart';
import 'package:clean_temp/widget/path_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GridBanner extends ConsumerWidget {
  final LevelModel level;
  const GridBanner({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provid = ref.watch(
      gameManagerProvider(
        level,
      ).select((s) => (s.dataPainting, s.roadList, s.animationProgress)),
    );

    return LayoutBuilder(
      builder: (contex, constraints) {
        final sizeGrid = constraints.biggest.shortestSide * 0.95;
        return Center(
          child: SizedBox(
            width: sizeGrid,
            height: sizeGrid,
            child: Stack(
              children: [
                // Grille de fond
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: level.size,
                  ),
                  itemCount: level.size * level.size,
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5),
                    ),
                  ),
                ),
                //  Dessin du shéma
                  RepaintBoundary(
                    child: CustomPaint(
                      size: Size(sizeGrid, sizeGrid),
                      painter: PathPainter(
                        level: level,
                        provid: provid,
                      ),
                    ),
                  ),
                // dessin des cases
                CaseWidget(level: level),
              ],
            ),
          ),
        );
      },
    );
  }
}
