import 'package:clean_temp/models/hive/level/level_model.dart';
import 'package:clean_temp/widget/gamepage/gridbanner/grid_banner.dart';
import 'package:clean_temp/widget/gamepage/timer/timer_banner.dart';
import 'package:clean_temp/widget/gamepage/top_banner_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameMainLayout extends ConsumerWidget {
  final LevelModel level;
  const GameMainLayout({super.key, required this.level});

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
