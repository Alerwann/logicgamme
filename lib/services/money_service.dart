import 'package:clean_temp/data/constants.dart';
import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/money/money_model.dart';


class MoneyService {
  // gestion de la vérification
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

  //Gestion des Achats

  Future<(bool, MoneyModel)> buyBonus(
    MoneyModel moneyState,
    TypeBonus type,
  ) async {
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
    } else if (moneyState.gemeStock >= costBonus) {
      final newCountGemme = moneyState.gemeStock - costBonus;
      newState = moneyState.copyWith(gemeStock: newCountGemme);
    } else {
      return (false, moneyState);
    }

    try {
      await newState.save();
      return (true, newState);
    } catch (e) {
      return (false, moneyState);
    }
  }


// Gestion de la victoire
  Future<(bool, MoneyModel)> handleWinGame({
    required int levelId,

    required TypeDifficulty difficultyMode,
    required MoneyModel moneyState,
  }) async {
    MoneyModel stateToUpdate;
    int winGemme;

    //gestion des gains de gemmes
    switch (difficultyMode) {
      case TypeDifficulty.normal:
        winGemme = Constants.GAIN_NORMAL + moneyState.gemeStock;
        break;
      case TypeDifficulty.hard:
        winGemme = Constants.GAIN_HARD_BONUS + moneyState.gemeStock;
        break;
    }

    //evolution du niveau
    if (levelId == moneyState.bestLevel) {
      stateToUpdate = moneyState.copyWith(
        bestLevel: levelId + 1,
        gemeStock: winGemme,
      );
    } else {
      stateToUpdate = moneyState.copyWith(gemeStock: winGemme);
    }
    //tentative de sauvegarde de l'état
    try {
      await stateToUpdate.save();

      return (true, stateToUpdate);
    } catch (e) {
      return (false, moneyState);
    }
  }
}
