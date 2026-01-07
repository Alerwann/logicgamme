import 'package:logic_game/models/hive/level/level_model.dart';
import 'package:flutter/material.dart';

class CaseWidget extends StatelessWidget {
  final LevelModel level;
  const CaseWidget({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final BorderSide borderDeco = BorderSide(color: Colors.black, width: 5);

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: level.size,
      ),
      itemCount: level.cases.length,
      itemBuilder: (context, index) {
        final levelCaseData = level.cases[index];

        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: levelCaseData.wallH != null
                  ? borderDeco
                  : BorderSide.none,
              right: levelCaseData.wallV != null ? borderDeco : BorderSide.none,
            ),
          ),

          child: levelCaseData.numberTag != null
              ? Center(
                  child: Container(
                    width: 50,
                    height: 50,

                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        levelCaseData.numberTag.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        );
      },
    );
  }
}
