import 'dart:math';
import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/data/levels_import/all_level_list.dart';
import 'package:clean_temp/data/levels_import/levels_import_model.dart';
import 'package:clean_temp/models/case/case_model.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class HiveService {

  (bool, String) initLevels() {
    List<LevelsImport> allLevels = AllLevel.getDefaultList();

    if (allLevels.isEmpty || allLevels.length > allLevels.toSet().length) {
      return (
        false,
        "Chargement des niveaux a échoué. Merci de mettre à jour l'application",
      );
    }

    final levelsBox = Hive.box<LevelModel>('levelsBox');
    
    int debutIndex = levelsBox.length;

    int finIndex = min(levelsBox.length + 5, allLevels.length);

    for (int i = debutIndex; i < finIndex; i++) {

      final result = _generateLevelComplet(allLevels[i]);

   
      if (result.success) {
        final List<CaseModel> casesFinales = result.cases!;
        final CaseModel firstCase = result.firstTagCase!;
        final int maxTag = result.maxTag!;

        LevelModel value = LevelModel(
          levelId: i,
          cases: casesFinales,
          firstCase: firstCase,
          maxTag: maxTag,
        );
        levelsBox.put(i, value);
      } else if (!result.success) {
        return (
          false,
          "La création du niveau $i a échoué. Veuillez contacter le support en mentionnant le niveau et code erreur : TAG",
        );
      }
    }
    return (true, "Les niveaux ont été initialisé, Bonne chance");
  }

  Future<void> saveRecord(int levelId, int newTimeInSeconds) async {
    try {
      final levelsBox = Hive.box<LevelModel>('levelsBox');

      LevelModel? level = levelsBox.get(levelId);

      if (level != null) {
        level.bestRecordNormalSeconds = newTimeInSeconds;
        await level.save();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur de sauvegarde de record Hive : $e");
      }
    }
  }

  ResultLevelGenerator _generateLevelComplet(LevelsImport levelImport) {
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
