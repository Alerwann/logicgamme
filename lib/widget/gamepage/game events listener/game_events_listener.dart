import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/widget/gamepage/gridbanner/grid_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameEventsListener extends ConsumerWidget {
  final LevelModel level ;
  const GameEventsListener({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
 
    return GridBanner(level: level,);
  }
}
