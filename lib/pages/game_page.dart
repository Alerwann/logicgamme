import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/services/game_manager.dart';
import 'package:clean_temp/widget/case_widget.dart';
import 'package:clean_temp/widget/game_grid_backgroung.dart';
import 'package:clean_temp/widget/top_banner_widget.dart';
import 'package:clean_temp/widget/bottom_tools_widget.dart';
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
      body: Column(
        children: [
          // 1/8 : Bandeau Timer / Monnaie (Haut)
          Expanded(flex: 1, child: TopBannerWidget()),

          Expanded(
            flex: 6,
            child: LayoutBuilder(
              builder: (context, constraints) {
               
                final sizeGrid = constraints.maxWidth * 0.95;
                return // Dans ta GamePage, au moment de construire la zone de jeu :
                Center(
                  child: SizedBox(
                    width: sizeGrid,
                    height: sizeGrid,
                    child: Stack(
                      children: [
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

                        CaseWidget(level: level),

               
            
                   
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 1/8 : Barre d'outils / Bonus (Bas)
          Expanded(flex: 1, child: BottomToolsWidget()),
        ],
      ),
    );
  }
}
