import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/case/case_model.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/models/money/money_model.dart';
import 'package:flutter/foundation.dart';

class SessionState {
  final LevelModel levelConfig;
  final List<CaseModel> roadList;
  final Set<CaseModel> roadSet;
  final int lastTagSave;

  final EtatGame statutPartie;
  final TypeDifficulty difficultyMode;

  final MoneyModel moneyData;

  SessionState({
    required this.levelConfig,
    required this.roadList,
    required this.roadSet,
    required this.lastTagSave,
    required this.statutPartie,
    required this.difficultyMode,
    required this.moneyData,
  });

  SessionState copyWith({
    LevelModel? levelConfig,
    List<CaseModel>? roadList,
    Set<CaseModel>? roadSet,
    int? lastTagSave,
    EtatGame? statutPartie,
    TypeDifficulty? difficultyMode,
    MoneyModel? moneyData,
  }) {
    return SessionState(
      levelConfig: levelConfig ?? this.levelConfig,
      roadList: roadList ?? this.roadList,
      roadSet: roadSet ?? this.roadSet,
      lastTagSave: lastTagSave ?? this.lastTagSave,
      statutPartie: statutPartie ?? this.statutPartie,
      difficultyMode: difficultyMode ?? this.difficultyMode,
      moneyData: moneyData ?? this.moneyData,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionState &&
          runtimeType == other.runtimeType &&
          levelConfig == other.levelConfig &&
          listEquals(roadList, other.roadList) &&
          setEquals(roadSet, other.roadSet) &&
          lastTagSave == other.lastTagSave &&
          statutPartie == other.statutPartie &&
          difficultyMode == other.difficultyMode &&
          moneyData == other.moneyData;

  @override
  int get hashCode =>
     
      levelConfig.hashCode ^
      Object.hashAll(roadList) ^
      Object.hashAll(roadSet) ^
      statutPartie.hashCode ^
      difficultyMode.hashCode ^
      moneyData.hashCode;
}
