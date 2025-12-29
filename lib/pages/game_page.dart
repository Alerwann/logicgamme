import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/services/game_manager.dart';
import 'package:clean_temp/widget/case_widget.dart';
import 'package:clean_temp/widget/path_painter.dart';
// import 'package:clean_temp/widget/game_grid_backgroung.dart';
// import 'package:clean_temp/widget/top_banner_widget.dart';
// import 'package:clean_temp/widget/bottom_tools_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GamePage extends ConsumerWidget {
  final LevelModel level;
  const GamePage({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On écoute le manager pour reconstruire l'UI à chaque mouvement

    final session = ref.watch(gameManagerProvider(level));

    return Scaffold(
      appBar: AppBar(title: Text("Niveau de Test"),),
      body: SafeArea(
        child: Column(
          children: [
            // 1/8 : Bandeau Timer / Monnaie (Haut)
             Expanded(flex: 1, child: Text("Timer")),

            Expanded(
              flex: 6,
              child: LayoutBuilder(
                builder: (context, constraints) {
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
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: level.size,
                                ),
                            itemCount: level.size * level.size,
                            itemBuilder: (context, index) => Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                              ),
                            ),
                          ),
                          //  Dessin du shéma
                          RepaintBoundary(
                            child: CustomPaint(
                              size: Size(sizeGrid, sizeGrid),
                              painter: PathPainter(state: session),
                            ),
                          ),
                          // dessin des cases
                          CaseWidget(level: level),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 1/8 : Barre d'outils / Bonus (Bas)
            Expanded(flex: 1, child: Text("info bonus")),
          ],
        ),
      ),
    );
  }
}
