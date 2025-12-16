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
  // boolean qui indique si le jouer choisi le niveau hard ou facile
  bool hardDifficulty;

  @HiveField(4)
  //premiere case de jeux
  CaseModel firstCase;

  @HiveField(5)
  //numéro de la dernière balise
  int maxTag;

  LevelModel({
    required this.levelId,
    required this.cases,
    this.bestRecordNormalSeconds = 99999,
    this.hardDifficulty = false,
    required this.firstCase,
    required this.maxTag
  });
}
