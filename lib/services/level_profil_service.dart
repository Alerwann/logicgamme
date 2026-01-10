import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logic_game/data/constants.dart';
import 'package:logic_game/models/hive/box/level%20profil/level_profil_model.dart';

class LevelProfilService {

  
   Future<bool> saveData(LevelProfilModel level) async {
    final profilLevelBox = Hive.box<LevelProfilModel>(Constants.levelProfilBox);

    try {
      await profilLevelBox.put(level.levelId, level);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur de sauvegarde du record : $e");
      }
      return false;
    }
  }
}
