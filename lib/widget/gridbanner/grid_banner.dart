import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/widget/gridbanner/case_widget.dart';
import 'package:clean_temp/widget/gridbanner/path%20draw/animated_path_layer.dart';
import 'package:clean_temp/widget/gridbanner/error_gesture_gestion.dart';
import 'package:clean_temp/widget/gridbanner/static_background_grid.dart';
import 'package:flutter/material.dart';

class GridBanner extends StatelessWidget {
  final LevelModel level;
  const GridBanner({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
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
                StaticBackgroundGrid(levelSize: level.size),
                //  Dessin du shéma
                AnimatedPathLayer(level: level, sizeGrid: sizeGrid),

            
                // dessin des cases
                CaseWidget(level: level),
                    // Erreur et geste
                ErrorGestureGestion(level: level),
              ],
            ),
          ),
        );
      },
    );
  }
}
