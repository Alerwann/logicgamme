import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/case/case_model.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/models/money/money_model.dart';

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
    required this.moneyData
  });

  SessionState copyWith({
    LevelModel? levelConfig,
    List<CaseModel>? roadList,
    Set<CaseModel>? roadSet,
    int? lastTagSave,
    EtatGame? statutPartie,
    TypeDifficulty? difficultyMode,
    MoneyModel? moneyData
  }) {
    return SessionState(
      levelConfig: levelConfig ?? this.levelConfig,
      roadList: roadList ?? this.roadList,
      roadSet: roadSet ?? this.roadSet,
      lastTagSave: lastTagSave ?? this.lastTagSave,
      statutPartie: statutPartie ?? this.statutPartie,
      difficultyMode: difficultyMode ?? this.difficultyMode,
      moneyData: moneyData?? this.moneyData,
    );
  }
}
