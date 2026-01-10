import 'package:hive/hive.dart';
import 'package:logic_game/data/constants.dart';
import 'package:logic_game/models/hive/bonus/bonus_model.dart';
import 'package:logic_game/models/hive/money/money_model.dart';
import 'package:logic_game/models/models%20utils/result_can_buy.dart';

class MoneyService {
  Future<MoneyModel?> saveMoneyModel(MoneyModel newState) async {
    final moneyBox = Hive.box<MoneyModel>(Constants.moneyBox);

    final resultCanBuy = _canAllUseBonus(newState);

    newState = newState.copyWith(
      canUseBonusTime: resultCanBuy.time,
      canUseBonusDifficulty: resultCanBuy.difficulty,
    );

    try {
      await moneyBox.put(0, newState);
    } catch (e) {
      print("erreur de sauvegarde : $e");
      return null;
    }
    return newState;
  }

  ResultCanBuy _canAllUseBonus(MoneyModel moneystate) {
    print("canAll");
    bool canBuytime;
    bool canBuyDifficulty;
    BonusModel time = moneystate.timeBonus;
    BonusModel diff = moneystate.difficultyBonus;

    canBuyDifficulty =
        moneystate.gemeStock >= diff.costForBuy || diff.quantity > 0;
    canBuytime = moneystate.gemeStock >= time.costForBuy || time.quantity > 0;

    return ResultCanBuy(time: canBuytime, difficulty: canBuyDifficulty);
  }
}
