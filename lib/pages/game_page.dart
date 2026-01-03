import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/widget/gridbanner/grid_banner.dart';
import 'package:clean_temp/widget/timer/timer_banner.dart';
import 'package:clean_temp/widget/top_banner_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class GamePage extends ConsumerWidget {
  final LevelModel level;
  const GamePage({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBannerWidget(level: level),

            Expanded(
              flex: 6,
              child: Column(
                children: [
                  TimerBanner(level: level), 
                  Expanded(
                    child: GridBanner(level: level),
                  ),
                ],
              ),
            ),

      
          ],
        ),
      ),
    );
  }
}
