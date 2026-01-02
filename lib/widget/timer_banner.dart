import 'package:clean_temp/data/constants.dart';
import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/services/game_manager.dart';
import 'package:clean_temp/widget/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerBanner extends ConsumerStatefulWidget {
  final LevelModel level;
  const TimerBanner({super.key, required this.level});

  @override
  ConsumerState<TimerBanner> createState() => _TimerBannerState();
}

// SingleTickerProviderStateMixin permet de gérer le "battement" de l'animation (60fps)
class _TimerBannerState extends ConsumerState<TimerBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  int dureeMax = 60;
  double ratio = 1;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: dureeMax),
      value: 1,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  //a modifier

  @override
  Widget build(BuildContext context) {
    ref.listen(
      gameManagerProvider(widget.level).select((s) => (s.timerState)),
      (previous, next) {
    

        if (previous == TimerAction.stop && next == TimerAction.addTime) {
          controller.duration = Duration(seconds: Constants.TIME_ADD_SECONDS);
          controller.reverse();
        } else if (previous == TimerAction.init && next == TimerAction.play) {
          dureeMax = ref
              .read(gameManagerProvider(widget.level).notifier)
              .maxCurrentValue;

          controller.duration = Duration(seconds: dureeMax);
          controller.reverse();

        } else 
        // gestion de mise en pause -> arret du controller
        if (next == TimerAction.pause) {
          controller.stop();
        } else 
        if (previous == TimerAction.pause && next == TimerAction.play) {
          ratio = ref
              .read(gameManagerProvider(widget.level).notifier)
              .ratioTime;
          controller.reverse(from: ratio);
        }
      },
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            children: [
              // Le dégradé qui se vide
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: controller.value,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green,
                        Colors.yellow,
                        Colors.orange,
                        Colors.red,
                      ],
                    ),
                  ),
                ),
              ),
              // Le texte par-dessus
              Center(child: FormatTime(level: widget.level)),
            ],
          ),
        );
      },
    );
  }
}
