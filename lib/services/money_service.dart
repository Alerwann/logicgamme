import 'package:clean_temp/data/constants.dart';
import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/money/money_model.dart';
import 'package:flutter/foundation.dart';

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

  Future<ResultActionBonus> buyBonus(
    MoneyModel moneyState,
    TypeBonus type,
  ) async {
    MoneyModel newState;

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
    return await saveMoneyModel(newState, moneyState);
  }

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

  // Gestion de la victoire
  Future<ResultActionBonus> handleWinGame({
    required int levelId,
    required TypeDifficulty difficultyMode,
    required MoneyModel moneyState,
  }) async {
    final stateToUpdate = niveauCalculate(levelId, moneyState, difficultyMode);

    return saveMoneyModel(stateToUpdate, moneyState);
  }

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

class ResultActionBonus {
  final bool isDo;
  final BuyStatusCode statusCode;
  final MoneyModel state;

  ResultActionBonus({
    required this.isDo,
    required this.statusCode,
    required this.state,
  });
}
