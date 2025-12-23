import 'package:clean_temp/models/case/case_model.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/services/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CaseWidget extends ConsumerStatefulWidget {
  final LevelModel level;
  const CaseWidget({super.key, required this.level});

  @override
  ConsumerState<CaseWidget> createState() => _CaseWidgetState();
}

class _CaseWidgetState extends ConsumerState<CaseWidget> {
  late BoxDecoration caseDecoration;
  final BorderSide borderDeco = BorderSide(color: Colors.black, width: 2);

  BoxDecoration decorationBox(CaseModel caseData) {
    if (caseData.wallH != null && caseData.wallV != null) {
      caseDecoration = BoxDecoration(
        border: Border(bottom: borderDeco, right: borderDeco),
      );
    } else if (caseData.wallH != null) {
      caseDecoration = BoxDecoration(border: Border(bottom: borderDeco));
    } else if (caseData.wallV != null) {
      caseDecoration = BoxDecoration(border: Border(right: borderDeco));
    }

    return caseDecoration;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.level.size,
      ),
      itemCount: widget.level.cases.length,
      itemBuilder: (context, index) {
        final levelCaseData = widget.level.cases[index];
  

        return GestureDetector(
          onTap: () => ref
              .read(gameManagerProvider(widget.level).notifier)
              .handleMove(levelCaseData),
          child: Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: levelCaseData.wallH !=null ? borderDeco : BorderSide.none,
                right: levelCaseData.wallV !=null ? borderDeco : BorderSide.none,
              ),
            ),

            child: levelCaseData.numberTag != null
                ? Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        levelCaseData.numberTag.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : SizedBox(),
          ),
        );
      },
    );
  }
}
