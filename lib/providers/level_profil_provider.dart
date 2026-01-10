import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:logic_game/data/constants.dart';
import 'package:logic_game/data/enum/enum.dart';
import 'package:logic_game/models/hive/box/level%20profil/level_profil_model.dart';
import 'package:logic_game/models/models%20utils/result_save_record.dart';
import 'package:logic_game/providers/level_profil_service_provider.dart';

final levelProfilProvider =
    NotifierProvider.family<LevelProfilNotifier, LevelProfilModel, int>(() {
      return LevelProfilNotifier();
    });

class LevelProfilNotifier extends FamilyNotifier<LevelProfilModel, int> {
  @override
  LevelProfilModel build(int id) {
    final box = Hive.box<LevelProfilModel>(Constants.levelProfilBox);

    return box.get(id) ??
        LevelProfilModel(levelId: id, bestTime: 9999, winWithHard: false);
  }

  Future<ResultSaveRecord> saveEndGame(
    int newTime,
    TypeDifficulty difficulty,
  ) async {
    int? newRecord;
    bool? winHard;
    LevelProfilModel newState;
    bool isNewRecord = false;

    if (newTime < state.bestTime) {
      isNewRecord = true;
      newRecord = newTime;
    }
    if (difficulty == TypeDifficulty.hard) {
      winHard = true;
    }
    newState = state.copyWith(bestTime: newRecord, winWithHard: winHard);

    final saveResult = await ref
        .read(levelProfilServiceProvider)
        .saveData(newState);

    if (saveResult) {
      state = newState;
      return ResultSaveRecord(record: isNewRecord, save: true);
    }
    return ResultSaveRecord(record: isNewRecord, save: false);
  }
}
