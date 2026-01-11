import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logic_game/pages/game/game_page.dart';
import 'package:flutter/material.dart';
import 'package:logic_game/providers/level_profil_provider.dart';
import 'package:logic_game/providers/money_provider.dart';

class HomeGame extends ConsumerWidget {
  const HomeGame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(moneyProvider);

    final levelId = 1;



    final money = ref.watch(moneyProvider);
    final levelprofil = ref.watch(levelProfilProvider(levelId));

    return Scaffold(
      appBar: AppBar(title: Text("Everyone"),automaticallyImplyLeading: false,),
      body: Center(
        child: Column(
          children: [
            Text("le niveau max : ${money.bestLevel}"),
            Text("Money gemme :${money.gemeStock}"),
            Text("Bonus temps: ${money.timeBonus.quantity}"),
            Text("Bonus difficulté: ${money.difficultyBonus.quantity}"),
            levelprofil.bestTime > 1000
                ? Text("Pas de records pour le moment")
                : Text("Record du level $levelId : ${levelprofil.bestTime}"),
            Text("harde mode? : ${levelprofil.winWithHard}"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePage(level: levelId),
                  ),
                );
              },
              child: Text("Niveau test"),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await ref
                    .read(moneyProvider.notifier)
                    .resetMoneyData();
                print(result);
              },
              child: Text("nettoyage de money"),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await ref
                    .read(levelProfilProvider(levelId).notifier)
                    .resetLevelData();
                print(result);
              },
              child: Text("reset du niveau"),
            ),
          ],
        ),
      ),
    );
  }
}
