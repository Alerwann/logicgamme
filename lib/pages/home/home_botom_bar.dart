//botom bar et pages seroint crées ici exemple après
import 'package:clean_temp/models/case/case_model.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/pages/game_page.dart';
import 'package:flutter/material.dart';

class HomeBottomBar extends StatefulWidget {
  const HomeBottomBar({super.key});

  @override
  State<HomeBottomBar> createState() => _HomeBottomBarState();
}

class _HomeBottomBarState extends State<HomeBottomBar> {
  LevelModel levelTest = LevelModel(
    levelId: 1,
    cases: [
      CaseModel(xValue: 0, yValue: 0, wallV: true, numberTag: 1),
      CaseModel(xValue: 1, yValue: 0),
      CaseModel(xValue: 2, yValue: 0),
      CaseModel(xValue: 3, yValue: 0, numberTag: 4),
      CaseModel(xValue: 4, yValue: 0),
      CaseModel(xValue: 5, yValue: 0),

      CaseModel(xValue: 0, yValue: 1),
      CaseModel(xValue: 1, yValue: 1, numberTag: 3),
      CaseModel(xValue: 2, yValue: 1),
      CaseModel(xValue: 3, yValue: 1, wallH: true),
      CaseModel(xValue: 4, yValue: 1),
      CaseModel(xValue: 5, yValue: 1),

      CaseModel(xValue: 0, yValue: 2, numberTag: 2),
      CaseModel(xValue: 1, yValue: 2),
      CaseModel(xValue: 2, yValue: 2),
      CaseModel(xValue: 3, yValue: 2),
      CaseModel(xValue: 4, yValue: 2),
      CaseModel(xValue: 5, yValue: 2),

      CaseModel(xValue: 0, yValue: 3),
      CaseModel(xValue: 1, yValue: 3),
      CaseModel(xValue: 2, yValue: 3),
      CaseModel(xValue: 3, yValue: 3),
      CaseModel(xValue: 4, yValue: 3),
      CaseModel(xValue: 5, yValue: 3),

      CaseModel(xValue: 0, yValue: 4),
      CaseModel(xValue: 1, yValue: 4),
      CaseModel(xValue: 2, yValue: 4),
      CaseModel(xValue: 3, yValue: 4, ),
      CaseModel(xValue: 4, yValue: 4),
      CaseModel(xValue: 5, yValue: 4),

      CaseModel(xValue: 0, yValue: 5),
      CaseModel(xValue: 1, yValue: 5),
      CaseModel(xValue: 2, yValue: 5),
      CaseModel(xValue: 3, yValue: 5),
      CaseModel(xValue: 4, yValue: 5),
      CaseModel(xValue: 5, yValue: 5),
    ],
    firstCase: CaseModel(xValue: 0, yValue: 0, wallV: true, numberTag: 1),
    maxTag: 4,
    size: 6,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Everyone")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GamePage(level: levelTest),
              ),
            );
          },
          child: Text("Niveau test"),
        ),
      ),
    );
  }
}
