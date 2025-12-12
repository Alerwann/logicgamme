import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/case/case_model.dart';
import 'package:clean_temp/models/level/level_model.dart';

class SessionState {
  final LevelModel levelConfig;
  final List<CaseModel> roadList;
  final Set<CaseModel> roadSet;
  final int lastTag;
  final EtatGame statutPartie;

  SessionState({
    required this.levelConfig,
    required this.roadList,
    required this.roadSet,
    required this.lastTag,
    required this.statutPartie,
  });

  SessionState copyWith({
    LevelModel? levelConfig,
    List<CaseModel>? roadList,
    Set<CaseModel>? roadSet,
    int? lastTag,
    EtatGame? statutPartie
  }) {
    return SessionState(
      levelConfig: levelConfig ?? this.levelConfig,
      roadList: roadList ?? this.roadList,
      roadSet: roadSet ?? this.roadSet,
      lastTag: lastTag ?? this.lastTag,
      statutPartie: statutPartie??this.statutPartie
    );
  }
}
