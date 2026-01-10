import 'package:logic_game/data/constants.dart';
import 'package:logic_game/data/enum/enum.dart';
import 'package:logic_game/providers/game_manager_provider.dart';
import 'package:logic_game/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerBanner extends ConsumerStatefulWidget {
  final int level;
  const TimerBanner({super.key, required this.level});

  @override
  ConsumerState<TimerBanner> createState() => _TimerBannerState();
}

class _TimerBannerState extends ConsumerState<TimerBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  int dureeMax = 60;
  // double ratio = 1;

  int initCompteurValue = 0;

  bool pauseAction = false;
  int currentDuration = 0;
  int timeValue = 0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: dureeMax),
      value: 0,
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        initCompteurValue = timeValue + 1;
        controller.reset();
        final notifier = ref.read(gameManagerProvider(widget.level).notifier);
        notifier.canUseBonusTime();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      gameManagerProvider(widget.level).select((s) => (s.timerState)),
      (previous, next) {
        if (previous == TimerAction.init && next == TimerAction.play) {
          dureeMax = ref
              .read(gameManagerProvider(widget.level).notifier)
              .maxCurrentValue;
          controller.duration = Duration(seconds: dureeMax);
          controller.forward();
        } else if (next == TimerAction.addTime) {
          print("on passe en addtime init ");
          controller.duration = Duration(seconds: Constants.TIME_ADD_SECONDS);
          dureeMax = Constants.TIME_ADD_SECONDS;
          controller.forward();
        } else if (next == TimerAction.win) {
          print("win de time baner");
          ref
              .read(gameManagerProvider(widget.level).notifier)
              .finishGame(timeValue);
          controller.stop();
        }
      },
    );

    return SizedBox(
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  colors: const [
                    Colors.green,
                    Colors.yellow,
                    Colors.orange,
                    Colors.red,
                  ],
                ),
              ),

              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  currentDuration = controller.duration?.inSeconds ?? 0;
                  timeValue =
                      (initCompteurValue +
                      ((controller.value) * currentDuration).floor());

                  return Stack(
                    children: [
                      // Le dégradé qui se vide
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: controller.value,
                        child: Container(color: Colors.white),
                      ),
                      // Le texte par-dessus
                      Center(child: formatTime(timeValue)),
                    ],
                  );
                },
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ref
                  .read(gameManagerProvider(widget.level).notifier)
                  .pauseResumeTime(pauseAction);
              pauseAction ? controller.forward() : controller.stop();
              setState(() {
                pauseAction = !pauseAction;
              });
            },
            icon: pauseAction
                ? Icon(Icons.play_circle)
                : Icon(Icons.pause_circle_filled),
          ),
        ],
      ),
    );
  }
}
