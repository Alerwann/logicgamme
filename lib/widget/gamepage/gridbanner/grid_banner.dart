import 'package:hive/hive.dart';
import 'package:logic_game/data/constants.dart';
import 'package:logic_game/models/hive/box/level/level_model.dart';
import 'package:logic_game/widget/gamepage/gridbanner/case_widget.dart';
import 'package:logic_game/widget/gamepage/path%20draw/animated_path_layer.dart';
import 'package:logic_game/widget/gamepage/gridbanner/error_gesture_gestion.dart';
import 'package:logic_game/widget/gamepage/gridbanner/static_background_grid.dart';
import 'package:flutter/material.dart';

class GridBanner extends StatelessWidget {
  final int levelId;
  const GridBanner({super.key, required this.levelId});

  @override
  Widget build(BuildContext context) {
    final level = Hive.box<LevelModel>(Constants.levelBox).get(levelId)!;
    final sizeLevel =level.size;

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
                StaticBackgroundGrid(sizeLevel: sizeLevel),
                //  Dessin du shéma
                AnimatedPathLayer(
                  sizeLevel: sizeLevel,
                  sizeGrid: sizeGrid,
                  levelId: levelId,
                ),

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
