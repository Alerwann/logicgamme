import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/data/levels_import/levels_import_model.dart';
import 'package:clean_temp/models/case/case_model.dart';
import 'package:collection/collection.dart';

class LevelGenerator {
  static ResultLevelGenerator generateLevelComplet(LevelsImport levelImport) {
    final int size = levelImport.size;

    final List<CaseModel> listFinal = [];

    // vérifie que sur le niveau la liste des tag est complete sans doublons
    if (levelImport.tagsList.isEmpty ||
        levelImport.tagsList.length > levelImport.tagsList.toSet().length) {
      return ResultLevelGenerator(
        success: false,
        codeResult: CodeLevelGenerator.countTagKo,
      );
    }

    final Map<(int, int), int> mapTags = {
      for (int i = 0; i < levelImport.tagsList.length; i++)
        levelImport.tagsList[i]: i + 1,
    };

    final lastTag = levelImport.tagsList.length;
    // boucle de creations des cases

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        bool? wallH;
        bool? wallV;

        final cle = (x, y);

        wallH = levelImport.wallH.isNotEmpty && levelImport.wallH.contains(cle)
            ? true
            : null;

        wallV = levelImport.wallV.isNotEmpty && levelImport.wallV.contains(cle)
            ? true
            : null;

        listFinal.add(
          CaseModel(
            xValue: x,
            yValue: y,
            wallH: wallH,
            wallV: wallV,
            numberTag: mapTags[cle],
          ),
        );
      }
    }

    final firstCase = listFinal.firstWhereOrNull((c) => c.numberTag == 1);

    if (firstCase == null) {
      return ResultLevelGenerator(
        success: false,
        codeResult: CodeLevelGenerator.countTagKo,
      );
    }

    return ResultLevelGenerator(
      success: true,
      codeResult: CodeLevelGenerator.success,
      cases: listFinal,
      firstTagCase: firstCase,
      maxTag: lastTag,
    );
  }
}

class ResultLevelGenerator {
  final bool success;
  final CodeLevelGenerator codeResult;
  final List<CaseModel>? cases;
  final CaseModel? firstTagCase;
  final int? maxTag;

  ResultLevelGenerator({
    required this.success,
    required this.codeResult,
    this.cases,
    this.firstTagCase,
    this.maxTag,
  });
}
