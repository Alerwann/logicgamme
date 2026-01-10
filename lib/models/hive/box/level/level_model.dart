import 'package:logic_game/models/hive/noBox/case/case_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'level_model.g.dart';

/// Représente les caractéristiques d'un niveau de jeu
///
/// Chaque niveau est définit par :
/// [levelId] qui est son id
/// [cases] qui est l'ensembles des cases de la grille
/// [firstCase] qui représente le point de départ sur la grille qui est la case à la balise 1
/// [maxTag] qui représente le numéro de la dernière balise

@HiveType(typeId: 1)
class LevelModel extends HiveObject {
  @HiveField(0)
  final int levelId;
  @HiveField(1)
  final List<CaseModel> cases;
  @HiveField(2)
  CaseModel firstCase;
  @HiveField(3)
  int maxTag;
  @HiveField(4)
  int size;

  LevelModel({
    required this.levelId,
    required this.cases,
    required this.firstCase,
    required this.maxTag,
    required this.size,
  });

  LevelModel copyWith({
    int? levelId,
    List<CaseModel>? cases,
    CaseModel? firstCase,
    int? maxTag,
    int? size,
  }) {
    return LevelModel(
      levelId: levelId ?? this.levelId,
      cases: cases ?? this.cases,
      firstCase: firstCase ?? this.firstCase,
      maxTag: maxTag ?? this.maxTag,
      size: size ?? this.size,
    );
  }

  /// Compare deux instances de [LevelModel] par leurs valeurs.
  ///
  /// Retourne true si l'id , la liste des cases, le record, la première et la dernière case sont strictement identiques.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelModel &&
          runtimeType == other.runtimeType &&
          levelId == other.levelId &&
          listEquals(cases, other.cases) &&
          firstCase == other.firstCase &&
          maxTag == other.maxTag &&
          size == other.size;

  /// Génère une clé de hachage basée sur l'ensemble des propriétés de la case.
  @override
  int get hashCode => Object.hash(
    levelId,
    Object.hashAll(cases),
    firstCase,
    maxTag,
    size,
  );
}
