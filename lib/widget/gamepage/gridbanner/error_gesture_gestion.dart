import 'package:logic_game/data/enum/enum.dart';
import 'package:logic_game/models/hive/noBox/case/case_model.dart';
import 'package:logic_game/models/hive/box/level/level_model.dart';
import 'package:logic_game/providers/game_manager_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorGestureGestion extends ConsumerWidget {
  final LevelModel level;
  const ErrorGestureGestion({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BoxDecoration deco = BoxDecoration();

    Set<CaseModel> errorCases = {};

    Border borderFinal = Border.all(
      color: const Color.fromARGB(255, 255, 0, 0),
      width: 5,
    );
    Border borderWallError(CaseModel errorCase) {
      return Border(
        bottom: errorCase.wallH != null
            ? BorderSide(color: const Color.fromARGB(255, 255, 0, 0), width: 5)
            : BorderSide.none,
        right: errorCase.wallV != null
            ? BorderSide(color: const Color.fromARGB(255, 255, 0, 0), width: 5)
            : BorderSide.none,
      );
    }

    final error = ref.watch(gameManagerProvider(level.levelId).select((s) => s.error));

    if (error == ErrorPlayer.wall || error == ErrorPlayer.other) {
      errorCases = ref.read(gameManagerProvider(level.levelId).notifier).errorSetCase;

      borderFinal = error == ErrorPlayer.wall
          ? borderWallError(errorCases.first)
          : Border.all(color: const Color.fromARGB(255, 255, 0, 0), width: 5);
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: level.size,
      ),
      itemCount: level.cases.length,
      itemBuilder: (context, index) {
        final levelCaseData = level.cases[index];

        bool testCaseError = errorCases.contains(levelCaseData);

        deco = BoxDecoration(
          color: testCaseError ? const Color.fromARGB(98, 244, 67, 54) : null,
          border: testCaseError ? borderFinal : null,
        );

        return GestureDetector(
          onTap: () => ref
              .read(gameManagerProvider(level.levelId).notifier)
              .handleMove(levelCaseData),
          child: Container(decoration: deco, child: SizedBox()),
        );
      },
    );
  }
}
