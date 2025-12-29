import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/case/case_model.dart';
import 'package:clean_temp/models/data_for_painting.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/models/money/money_model.dart';
import 'package:flutter/foundation.dart';

/// Réprésente l'état de la partie à un instant t
///
/// L'état est généré quand le joueur lance la partie et s'arrête une fois l'affichage terminé
/// Stockage non persistant d'où la non utilisation de Hive
///

class SessionState {
  /// Model du niveau joué
  final LevelModel levelConfig;

  /// List des cases qui ont été parcouru par le joueur
  /// Est initialisé avec [firstCase] du [levelConfig]
  final List<CaseModel> roadList;

  /// Set des cases qui ont été parcouru par le joueur
  /// le set doit avoir les mêmes cases que la List
  /// Il est nécessaire pour facilité la recherche d'une case dans celle parcouru
  final Set<CaseModel> roadSet;

  /// Initialisé à 1, augmente à chaque fois que le jour valide la balise suivante
  final int lastTagSave;

  /// Définit les état de la partie (définition précise de chaque état dans l'énum)
  final EtatGame statutPartie;

  /// Définit si la partie est en mode Normal ou Hard
  final TypeDifficulty difficultyMode;

  /// Définit l'état des monnaies
  final MoneyModel moneyData;

  /// Les offsets pour la création du dessin
  final CoordForPainting? dataPainting;

  /// Variable indiquant la progression de l'animation
  final double? animationProgress;

  SessionState({
    required this.levelConfig,
    required this.roadList,
    required this.roadSet,
    required this.lastTagSave,
    required this.statutPartie,
    required this.difficultyMode,
    required this.moneyData,
    this.dataPainting,
    this.animationProgress
  });

  ///Utilise la copy pour te pas casser l'immuabilité du modèle
  SessionState copyWith({
    LevelModel? levelConfig,
    List<CaseModel>? roadList,
    Set<CaseModel>? roadSet,
    int? lastTagSave,
    EtatGame? statutPartie,
    TypeDifficulty? difficultyMode,
    MoneyModel? moneyData,
    CoordForPainting? dataPainting,
    double? animationProgress
  }) {
    return SessionState(
      levelConfig: levelConfig ?? this.levelConfig,
      roadList: roadList ?? this.roadList,
      roadSet: roadSet ?? this.roadSet,
      lastTagSave: lastTagSave ?? this.lastTagSave,
      statutPartie: statutPartie ?? this.statutPartie,
      difficultyMode: difficultyMode ?? this.difficultyMode,
      moneyData: moneyData ?? this.moneyData,
      dataPainting: dataPainting,
      animationProgress: animationProgress
    );
  }

  /// Compare 2 [SessionState] par leur valeurs
  /// retourne vrai si le niveau, les list et set du chemin, le dernier tag validé, le statut de la partie, la difficulté et l'état des monaies sont identiques
  ///
  ///
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
          moneyData == other.moneyData &&
          dataPainting == other.dataPainting &&
          animationProgress == other.animationProgress ;

  @override
  int get hashCode => Object.hash(
    levelConfig,
    Object.hashAll(roadList),
    Object.hashAll(roadSet),
    statutPartie,
    difficultyMode,
    moneyData,
    dataPainting,
    animationProgress
  );
}
