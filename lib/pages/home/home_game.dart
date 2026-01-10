import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logic_game/data/constants.dart';
import 'package:logic_game/models/hive/box/money/money_model.dart';
import 'package:logic_game/pages/game/game_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logic_game/providers/money_provider.dart';

class HomeGame extends ConsumerWidget {
  const HomeGame({super.key});

  // @override
  // State<HomeGame> createState() => _HomeGameState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(moneyProvider);

    // final levelsBox = Hive.box<LevelModel>('levelsBox');

    // @override
    // Widget build(BuildContext context) {
    // final LevelModel level = levelsBox.getAt(1)!;

    final levelId = 1;
    //   print("levelid choisi = ${level.levelId}");

    final money = ref.watch(moneyProvider);
    final moneyBox = Hive.box<MoneyModel>(Constants.moneyBox);
    // moneyBox.put(0, money);

    return Scaffold(
      appBar: AppBar(title: Text("Everyone")),
      body: Center(
        child: Column(
          children: [
            Text("le niveau max : ${money.bestLevel}"),
            Text("Money gemme :${money.gemeStock}"),
            Text("Bonus temps: ${money.timeBonus.quantity}"),
            Text("Bonus difficulté: ${money.difficultyBonus.quantity}"),
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
                await moneyBox.delete(0);
              },
              child: Text("nettoyage de money"),
            ),
          ],
        ),
      ),
    );
  }
}
