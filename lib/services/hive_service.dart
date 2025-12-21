import 'dart:math';
import 'package:clean_temp/data/levels_import/all_level_list.dart';
import 'package:clean_temp/data/levels_import/levels_import_model.dart';
import 'package:clean_temp/models/case/case_model.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/services/level_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class HiveService {
  (bool, String) initLevels() {
    List<LevelsImport> allLevels = AllLevel.getDefaultList();

    // vérifier que la liste de niveau est de la bonne taille

    if (allLevels.isEmpty || allLevels.length > allLevels.toSet().length) {
      return (
        false,
        "Chargement des niveaux a échoué. Merci de mettre à jour l'application",
      );
    }

    final levelsBox = Hive.box<LevelModel>('levelsBox');

    return _synchroLevels(allLevels, levelsBox);
  }

  (bool, String) _synchroLevels(
    List<LevelsImport> allConfigs,
    Box<LevelModel> levelsBox,
  ) {
    int debutIndex = levelsBox.length;

    int finIndex = min(levelsBox.length + 5, allConfigs.length);
    for (int i = debutIndex; i < finIndex; i++) {
      final result = LevelGenerator.generateLevelComplet(allConfigs[i]);

      // Et accéder aux valeurs du Record comme ceci :
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
}
