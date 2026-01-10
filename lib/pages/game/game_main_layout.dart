import 'package:logic_game/widget/gamepage/gridbanner/grid_banner.dart';
import 'package:logic_game/widget/gamepage/timer/timer_banner.dart';
import 'package:logic_game/widget/gamepage/top_banner_widget.dart';
import 'package:flutter/material.dart';


class GameMainLayout extends StatelessWidget {
  final int level;
  const GameMainLayout({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBannerWidget(levelId: level),

            Expanded(
              flex: 6,
              child: Column(
                children: [
                  TimerBanner(level: level),
                  Expanded(child: GridBanner(levelId: level)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
