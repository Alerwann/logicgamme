import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logic_game/models/hive/level/level_model.dart';
import 'package:flutter/material.dart';
import 'package:logic_game/pages/home/home_game.dart';
import 'package:logic_game/pages/list_level.dart';
import 'package:logic_game/providers/game_manager_provider.dart';

class LooseResult extends ConsumerWidget {
  final LevelModel level;
  const LooseResult({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sorry"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            Text("Le temps est écoulé..."),
            Text(
              "Essaie de nouveau le niveau, ou entraine toi sur les anciens",
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(gameManagerProvider(level).notifier).resetForReplay();
              },
              child: Text("Rejouer"),
            ),
            ElevatedButton(
                onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ListLevel()),
                );
              },
              child: Text("Liste des niveau/"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeGame()),
                );
              },
              child: Text("Accueil"),
            ),
          ],
        ),
      ),
    );
  }
}
