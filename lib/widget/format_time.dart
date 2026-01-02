import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/services/game_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormatTime extends ConsumerWidget {
  final LevelModel level;
  const FormatTime({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = ref.watch(
      gameManagerProvider(level).select((s) => s.actualValue),
    );

    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toString().padLeft(2, '0');

    return Text(
      "$minutes : $seconds",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Color(0xFF1A1A1A), 
      ),
    );
  }
}
