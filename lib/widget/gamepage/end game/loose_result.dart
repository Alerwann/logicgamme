import 'package:logic_game/models/hive/level/level_model.dart';
import 'package:flutter/material.dart';

class LooseResult extends StatelessWidget {
  final LevelModel level;
  const LooseResult({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sorry"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(child: Text('Tu as perdu')),
    );
  }
}
