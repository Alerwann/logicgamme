import 'package:logic_game/models/hive/level/level_model.dart';
import 'package:flutter/material.dart';

class WinResult extends StatelessWidget {
  final LevelModel level;
  const WinResult({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Felicitation"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(child: Text('Tu as gagné')),
    );
  }
}
