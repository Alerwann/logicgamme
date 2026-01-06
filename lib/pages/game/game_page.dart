import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/hive/level/level_model.dart';
import 'package:clean_temp/pages/game/game_main_layout.dart';
import 'package:clean_temp/services/game_manager.dart';
import 'package:clean_temp/widget/gamepage/end%20game/loose_result.dart';
import 'package:clean_temp/widget/gamepage/end%20game/win_result.dart';
import 'package:clean_temp/widget/gamepage/game%20events%20listener/game_events_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GamePage extends ConsumerWidget {
  final LevelModel level;
  const GamePage({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      gameManagerProvider(level).select((s) => s.stateGamePage),
    );

    return Scaffold(
      body: Stack(
        children: [
          GameEventsListener(level: level),
          _buildBody(status, level),
        ],
      ),
    );
  }

  Widget _buildBody(StateGamePage status, LevelModel level) {
    switch (status) {
      case StateGamePage.playing:
        return GameMainLayout(level: level);
      case StateGamePage.win:
        return WinResult(level: level);
      case StateGamePage.loose:
        return LooseResult(level: level);
    }
  }
}
