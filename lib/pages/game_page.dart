import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/pages/game_main_layout.dart';
import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  final LevelModel level;
  const GamePage({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return GameMainLayout(level: level);
  }
}
