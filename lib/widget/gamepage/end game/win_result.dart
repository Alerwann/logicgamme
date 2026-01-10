import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logic_game/pages/home/home_game.dart';
import 'package:logic_game/pages/list_level.dart';
import 'package:logic_game/providers/game_manager_provider.dart';

class WinResult extends ConsumerWidget {
  final int level;
  const WinResult({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool newRecord = ref
        .read(gameManagerProvider(level).notifier)
        .newRecord;
    // final time = ref.read(
    //   gameManagerProvider(
    //     level,
    //   ).select((s) => s.levelConfig.bestRecordNormalSeconds),
    // );
    final time = 12;
    
    final minutes = (time ~/ 60).toString().padLeft(2, '0');
    final seconds = (time % 60).toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(
        title: Text("Good job !"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            Text("Bravo ! "),
            newRecord
                ? Text("Nouveau record enregistré : $minutes : $seconds ")
                : Text(
                    "Le record $minutes : $seconds n'est pas battut cette fois",
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
              child: Text("Liste des niveau"),
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
