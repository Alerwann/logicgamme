import 'dart:convert';
import 'dart:math';
import 'package:clean_temp/data/constants.dart';
import 'package:clean_temp/models/case/case_model.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/services/level_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class HiveService {
  Future<(bool, String)> initLevels() async {
    // Le try/catch principal doit être ici
    try {
      final List<Map<String, dynamic>> allConfigs = await _loadAllJson(
        Constants.jsonLevelPath,
      );

      // Vérification rapide du fichier JSON
      if (allConfigs.isEmpty) {
        return (false, "Merci de mettre à jour l'application");
      }

      final levelsBox = Hive.box<LevelModel>('levelsBox');

      // Déléguer la logique complexe de mise à jour à une fonction dédiée
      return _synchroLevels(allConfigs, levelsBox);
    } catch (e) {
      if (kDebugMode) {
        print("Erreur fatale d'initialisation Hive/JSON : $e");
      }
      return (
        false,
        'Impossible de charger les niveaux, merci de contacter le créateur via "À propos"',
      );
    }
  }

  Future<List<Map<String, dynamic>>> _loadAllJson(String path) async {
    try {
      final String response = await rootBundle.loadString(path);

      final dynamic decodeData = jsonDecode(response);
      if (decodeData is List) {
        return decodeData.cast<Map<String, dynamic>>();
      }

      if (kDebugMode) {
        print("Erreur de format JSON: La racine n'est pas une liste.");
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("erreur de lecture du fichier : $e");
      }
      return [];
    }
  }

  (bool, String) _synchroLevels(
    List<Map<String, dynamic>> allConfigs,
    Box<LevelModel> levelsBox,
  ) {
    int debutIndex = levelsBox.length;

    int finIndex = min(levelsBox.length + 5, allConfigs.length);
    for (int i = debutIndex; i < finIndex; i++) {
      List<CaseModel> listCase = LevelGenerator.generateLevelComplet(
        allConfigs[i],
      );
      LevelModel value = LevelModel(levelId: i, cases: listCase);
      levelsBox.put(i, value);
    }
    return (true, "Les niveaux ont été initialisé, Bonne chance");
  }
}
