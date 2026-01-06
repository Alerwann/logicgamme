import 'dart:math';
import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/data/levels_import/all_level_list.dart';
import 'package:clean_temp/data/levels_import/levels_import_model.dart';
import 'package:clean_temp/models/hive/case/case_model.dart';
import 'package:clean_temp/models/hive/level/level_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

/// Service qui gère la création et la sauvegarde des niveaux
///
class HiveService {
  /// Vérifie la liste des niveaux et génère les nouveaux si nécessaire
  ///
  /// Retourne (bool, String)
  /// le bool:
  ///   - true si la création des nouveaux niveau et l'initialisation est finalisé correctement
  ///   - false si soit aucun niveau n'est trouvé dans le fichier soit si la création de niveau à échoué
  /// le string permet de retourner le commentaire à afficher
  ///
  (bool, String) initLevels() {
    List<LevelsImport> allLevels = AllLevel.getDefaultList();

    if (allLevels.isEmpty || allLevels.length > allLevels.toSet().length) {
      return (
        false,
        "Chargement des niveaux a échoué. Merci de mettre à jour l'application",
      );
    }

    final levelsBox = Hive.box<LevelModel>('levelsBox');

    int debutIndex = levelsBox.length;

    /// Géné ration de 5 niveau pour éviter la saturation de la mémoire pour rien
    int finIndex = min(levelsBox.length + 5, allLevels.length);

    for (int i = debutIndex; i < finIndex; i++) {
      final result = _generateLevelComplet(allLevels[i]);

      if (result.success) {
        final List<CaseModel> casesFinales = result.cases!;
        final CaseModel firstCase = result.firstTagCase!;
        final int maxTag = result.maxTag!;

        LevelModel value = LevelModel(
          levelId: i,
          cases: casesFinales,
          firstCase: firstCase,
          maxTag: maxTag,
          size: result.size!,
        );
        levelsBox.put(i, value);
      } else if (!result.success) {
        return (
          false,
          "La création du niveau $i a échoué. Veuillez contacter le support en mentionnant le niveau et code erreur : TAG",
        );
      }
    }
    return (true, "Les niveaux ont été initialisé, Bonne chance");
  }

  /// Fonction qui permet de mettre à jour le record du joueur dans le [LevelModel] du niveau
  ///
  /// Paramètre:
  ///   [levelId] est l'id du niveau pour le retrouver dans la box
  ///   [newTimeInSeconds] est le temps à enregistrer
  ///
  /// Fonction asynchrone pour être sur que la sauvegarde soit à jour avant de continuer
  ///
  /// Retourne un bool qui est vrai si le record a été sauvegardé sinon false

  Future<bool> saveRecord(int levelId, int newTimeInSeconds) async {
    try {
      final levelsBox = Hive.box<LevelModel>('levelsBox');

      LevelModel? level = levelsBox.get(levelId);

      if (level != null) {
        level.bestRecordNormalSeconds = newTimeInSeconds;
        await level.save();
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
      }
    }
    return false;
  }

  /// Générateur de niveau
  ///
  /// Permet à partir de l'objet levelimport de configurer l'entièreté du niveau
  ///
  /// retourne un [ResultLevelGenerator] suivant si l'action est réussie ou non
  /// Si la génération à échouer le retour sera false avec le codeerror
  /// Si elle a réussi sera true, avec comme code succès et la liste des cases générées, le maximum tag et la première case
  ResultLevelGenerator _generateLevelComplet(LevelsImport levelImport) {
    final int size = levelImport.size;

    final List<CaseModel> listFinal = [];

    /// vérifie que sur le niveau la liste des tag est complete sans doublons
    if (levelImport.tagsList.isEmpty ||
        levelImport.tagsList.length > levelImport.tagsList.toSet().length) {
      return ResultLevelGenerator(
        success: false,
        codeResult: CodeLevelGenerator.countTagKo,
      );
    }

    /// converti en map pour augmenter la rapidité de recherche
    final Map<(int, int), int> mapTags = {
      for (int i = 0; i < levelImport.tagsList.length; i++)
        levelImport.tagsList[i]: i + 1,
    };

    final lastTag = levelImport.tagsList.length;

    /// Double boucle pour la création creations de toutes les cases

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        bool? wallH;
        bool? wallV;

        final cle = (x, y);

        wallH = levelImport.wallH.isNotEmpty && levelImport.wallH.contains(cle)
            ? true
            : null;

        wallV = levelImport.wallV.isNotEmpty && levelImport.wallV.contains(cle)
            ? true
            : null;

        listFinal.add(
          CaseModel(
            xValue: x,
            yValue: y,
            wallH: wallH,
            wallV: wallV,
            numberTag: mapTags[cle],
          ),
        );
      }
    }

    /// Recherche de la case avec le tag =1
    final firstCase = listFinal.firstWhereOrNull((c) => c.numberTag == 1);

    /// Si pas de case avec le premier tag retour une erreur car le niveau est corrompu
    if (firstCase == null) {
      return ResultLevelGenerator(
        success: false,
        codeResult: CodeLevelGenerator.countTagKo,
      );
    }

    /// Succès complet donc retourne toutes les données
    return ResultLevelGenerator(
      success: true,
      codeResult: CodeLevelGenerator.success,
      cases: listFinal,
      firstTagCase: firstCase,
      maxTag: lastTag,
      size: size,
    );
  }
}

/// Classe pour rendre homogène les retours du générateur
///
class ResultLevelGenerator {
  /// si tout est généré sans erreur true sinon false
  final bool success;

  /// donne plus d'information sur le succès ou l'echec (cf enum pour p)lus d'info)
  final CodeLevelGenerator codeResult;

  /// Si généré retourne la liste des cases
  final List<CaseModel>? cases;

  /// si généré retourne le [CaseModel] de la première case
  final CaseModel? firstTagCase;

  /// Si génété retourne le tag maximal
  final int? maxTag;

  /// Si généré retourne la taille

  final int? size;

  ResultLevelGenerator({
    required this.success,
    required this.codeResult,
    this.cases,
    this.firstTagCase,
    this.maxTag,
    this.size,
  });
}
