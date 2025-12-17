import 'package:clean_temp/models/case/case_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'level_model.g.dart';

@HiveType(typeId: 3)
class LevelModel extends HiveObject {
  @HiveField(0)
  //entier identifiant le niveau joué
  final int levelId;
  @HiveField(1)
  // liste des paramètres des case pour ce niveau
  final List<CaseModel> cases;

  @HiveField(2)
  // meilleur temps enregistré
  late int bestRecordNormalSeconds;
@HiveField(3)
  //premiere case de jeux
  CaseModel firstCase;

  @HiveField(4)
  //numéro de la dernière balise
  int maxTag;

  LevelModel({
    required this.levelId,
    required this.cases,
    this.bestRecordNormalSeconds = 99999,
    required this.firstCase,
    required this.maxTag,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelModel &&
          runtimeType == other.runtimeType &&
          levelId == other.levelId; 

  @override
  int get hashCode => levelId.hashCode;
}
