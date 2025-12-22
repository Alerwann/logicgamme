import 'package:clean_temp/data/constants.dart';
import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/money/money_model.dart';
import 'package:flutter/foundation.dart';

/// Service permettant de modifier le nombre de bonus et monnaie virtuelle
///
class MoneyService {
  /// gestion de la vérification
  ///
  /// Paramètre:
  ///   [moneystate] l'état actuel de la monaie
  ///   [type] définit si le bonus est pour la difficulté ou le temps
  ///
  /// Retourne True si le joueur a de quoi acheter le bonus et false sinon
  bool canUseBonus(MoneyModel moneystate, TypeBonus type) {
    int countBonus;
    int costBonus;
    switch (type) {
      case TypeBonus.bonusTime:
        countBonus = moneystate.bonusDaily;
        costBonus = Constants.COUT_ADD_TIME;
        break;
      case TypeBonus.bonusDifficulty:
        countBonus = moneystate.freeHardBonus;
        costBonus = Constants.COUT_HARD_ACHAT;
        break;
    }

    if (countBonus > 0 || moneystate.gemeStock >= costBonus) {
      return true;
    }
    return false;
  }

  /// Fait l'achat et si réalisé sauvegarde le nouvel état
  ///
  /// Paramètre:
  ///   [moneyState] l'état actuel de la monaie
  ///   [type] définit si le bonus est pour la difficulté ou le temps
  ///
  /// Fonction async pour que la sauvegarde soit complète avant le retour
  ///
  /// Retourne [ResultActionBonus]
  /// si l'achat est réalisé et sauvegardé retourne le nouvel état et succès
  /// si il y a un echect retourne false, le code erreur et le [moneyState] initiale

  Future<ResultActionBonus> buyBonus(
    MoneyModel moneyState,
    TypeBonus type,
  ) async {
    MoneyModel newState;

    /// tentative d'achat
    final testBuy = testTypeBuyBonus(type, moneyState);

    if (!testBuy.$1) {
      return ResultActionBonus(
        isDo: false,
        statusCode: BuyStatusCode.actionKo,
        state: moneyState,
      );
    } else {
      newState = testBuy.$2;
    }

    /// tentative de sauvegarde
    return await saveMoneyModel(newState, moneyState);
  }

  /// après vérification du solde,procède à la déduction de l'achat
  ///
  /// L'achat se fait en premier à l'aide des bonus puis sur les Gemmes
  ///
  /// Paramètre:
  /// [type] indique quel bonus est acheté
  /// [moneyState] donne l'état des monnaies
  ///
  /// Retourne true et le nouveau modèle si achat réussi
  /// Sinon retourne false et le modèle initial
  ///
  (bool, MoneyModel) testTypeBuyBonus(TypeBonus type, MoneyModel moneyState) {
    MoneyModel newState;
    int countBonus;
    int costBonus;

    switch (type) {
      case TypeBonus.bonusTime:
        countBonus = moneyState.bonusDaily;
        costBonus = Constants.COUT_ADD_TIME;
        break;
      case TypeBonus.bonusDifficulty:
        countBonus = moneyState.freeHardBonus;
        costBonus = Constants.COUT_HARD_ACHAT;
        break;
    }

    if (countBonus > 0) {
      final newCountBonus = countBonus - 1;

      if (type == TypeBonus.bonusTime) {
        newState = moneyState.copyWith(bonusDaily: newCountBonus);
      } else {
        newState = moneyState.copyWith(freeHardBonus: newCountBonus);
      }
      return (true, newState);
    } else if (moneyState.gemeStock >= costBonus) {
      final newCountGemme = moneyState.gemeStock - costBonus;
      newState = moneyState.copyWith(gemeStock: newCountGemme);
      return (true, newState);
    } else {
      return (false, moneyState);
    }
  }

  /// Mets à jour [moneyState] suite à une victoire
  ///
  /// Envoie les informations à niveauCalculate pour le calcul du nouveau nombre de gemme et du levelmax
  /// Au retour tente la sauvegarde de ce nouvel état
  ///
  /// paramètre:
  ///   [levelId] permet de vérifier si besoin de mise à jour du level max
  ///   [difficultyMode] pour attribuer le bon nombre de gemme
  ///   [moneyState] pour voir son état et le modifier à l'aide d'une copie
  ///
  /// Retourne [ResultActionBonus]
  /// si la mise à jour est réalisé et sauvegardé retourne le nouvel état et succès
  /// si il y a un echect retourne false, le code erreur et le [moneyState] initiale
  ///
  Future<ResultActionBonus> handleWinGame({
    required int levelId,
    required TypeDifficulty difficultyMode,
    required MoneyModel moneyState,
  }) async {
    final stateToUpdate = niveauCalculate(levelId, moneyState, difficultyMode);

    return saveMoneyModel(stateToUpdate, moneyState);
  }

  /// Fait une copie de l'état avec les nouvelles informations
  ///
  /// paramètre:
  ///   [levelId] permet de vérifier si besoin de mise à jour du level max
  ///   [difficultyMode] pour attribuer le bon nombre de gemme
  ///   [moneyState] pour voir son état et le modifier à l'aide d'une copie
  ///
  /// Retourne le nouvel état pour qu'il puisse être sauvegarder
  MoneyModel niveauCalculate(
    int levelId,
    MoneyModel moneyState,
    TypeDifficulty difficultyMode,
  ) {
    int winGemme;
    MoneyModel stateToUpdate;

    switch (difficultyMode) {
      case TypeDifficulty.normal:
        winGemme = Constants.GAIN_NORMAL + moneyState.gemeStock;
        break;
      case TypeDifficulty.hard:
        winGemme = Constants.GAIN_HARD_BONUS + moneyState.gemeStock;
        break;
    }

    if (levelId == moneyState.bestLevel) {
      stateToUpdate = moneyState.copyWith(
        bestLevel: levelId + 1,
        gemeStock: winGemme,
      );
    } else {
      stateToUpdate = moneyState.copyWith(gemeStock: winGemme);
    }

    return stateToUpdate;
  }

  /// Fonction générale de sauvegarde de [MoneyModel]
  ///
  /// Paramètre :
  ///   - [newState] l'état qui est modifier
  ///   - [oldState] l'état initial
  ///
  /// Ces deux états sont obligatoires pour qu'en cas d'échec l'ancien état soit retourné et ainsi conserver la synchronisation dans toute l'application
  ///
  /// Retourne [ResultActionBonus]
  /// si la sauvegarde est réalisé et sauvegardé retourne le nouvel état et succès
  /// si il y a un echect retourne false, le code erreur et le [oldState] initiale
  Future<ResultActionBonus> saveMoneyModel(
    MoneyModel newState,
    MoneyModel oldState,
  ) async {
    try {
      await newState.save();
    } catch (e) {
      if (kDebugMode) {
        print("erreur de la sauvegarde de money : $e");
        return ResultActionBonus(
          isDo: false,
          statusCode: BuyStatusCode.saveKO,
          state: oldState,
        );
      }
    }
    return ResultActionBonus(
      isDo: true,
      statusCode: BuyStatusCode.success,
      state: newState,
    );
  }
}

/// Modèle homogène de réponse aux actions sur [MoneyModel]
class ResultActionBonus {
  /// vrai si l'action est faite et finalisée sinon faux
  final bool isDo;

  /// status descriptif pour expliquer les retours (cf enum pour plus de détail)
  final BuyStatusCode statusCode;

  /// etat suite à l'exécution de l'action
  final MoneyModel state;

  ResultActionBonus({
    required this.isDo,
    required this.statusCode,
    required this.state,
  });
}
