import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:logic_game/data/constants.dart';
import 'package:logic_game/data/enum/enum.dart';
import 'package:logic_game/models/hive/noBox/bonus/bonus_model.dart';
import 'package:logic_game/models/hive/box/money/money_model.dart';
import 'package:logic_game/providers/money_service_provider.dart';

final moneyProvider = NotifierProvider<MoneyNotifier, MoneyModel>(() {
  return MoneyNotifier();
});

class MoneyNotifier extends Notifier<MoneyModel> {
  @override
  MoneyModel build() {
    final box = Hive.box<MoneyModel>(Constants.moneyBox);
    // On s'appuie sur l'objet en box ou l'initial
    return box.isEmpty ? MoneyModel.initial() : box.getAt(0)!;
  }

  Future<bool> saveData(MoneyModel newState) async {
    final result = await ref
        .read(moneyServiceProvider)
        .saveMoneyModel(newState);

    if (result != null) {
      state = result;
      return true;
    }

    return false;
  }

  /// Fonction d'ajout de monnaie et bonus ainsi que la maj quotidienne

  /// Ajout de gemme
  /// parametre [quantity] -> nombre à ajouter
  /// Retourne un bool pour confirmer la sauvegarde
  Future<bool> addGemme(int quantity) async {
    MoneyModel newState = state.copyWith(gemeStock: state.gemeStock + quantity);

    return await saveData(newState);
  }

  /// achat de temps
  Future<bool> addTimeBonus(int quantity) async {
    final newTimeBonus = state.timeBonus.copyWith(
      quantity: state.timeBonus.quantity + quantity,
    );
    final newState = state.copyWith(timeBonus: newTimeBonus);

    return await saveData(newState);
  }

  //achat de difficulté
  Future<bool> addDifficultyBonus(int quantity) async {
    final newDifBonus = state.difficultyBonus.copyWith(
      quantity: quantity + state.difficultyBonus.quantity,
    );
    final newState = state.copyWith(difficultyBonus: newDifBonus);

    return await saveData(newState);
  }

  ///Utilisation monnaie et bonus

  Future<bool> useGemme(int quantity) async {
    MoneyModel newState = state.copyWith(gemeStock: state.gemeStock - quantity);

    return await saveData(newState);
  }

  Future<bool> useTimeBonus(int quantity) async {
    BonusModel newTimeBonus = state.timeBonus.copyWith(
      quantity: state.timeBonus.quantity - quantity,
    );

    MoneyModel newState = state.copyWith(timeBonus: newTimeBonus);
    return await saveData(newState);
  }

  Future<bool> usedifficulty(int quantity) async {
    final oldDifficulty = state.difficultyBonus;
    final BonusModel newDifBonus = oldDifficulty.copyWith(
      quantity: state.difficultyBonus.quantity - quantity,
    );

    final MoneyModel newState = state.copyWith(difficultyBonus: newDifBonus);

    return await saveData(newState);
  }

  //les achats des bonus
  Future<bool> buyTime() async {
    BonusModel timeBonus = state.timeBonus;
    bool result = false;

    if (timeBonus.quantity > 0) {
      result = await useTimeBonus(1);
    } else if (state.gemeStock >= Constants.COUT_ADD_TIME) {
      result = await useGemme(Constants.COUT_ADD_TIME);
    }
    return result;
  }

  Future<bool> buyDifficulty() async {
    BonusModel diff = state.difficultyBonus;
    bool result = false;

    if (diff.quantity > 0) {
      result = await usedifficulty(1);
    } else if (state.gemeStock >= Constants.COUT_HARD_ACHAT) {
      result = await useGemme(Constants.COUT_HARD_ACHAT);
    }
    return result;
  }

  ///All maj
  // mise à jour après rénitialisation quotidienne

  Future<bool> reinitDaily() async {
    final newTimeBonus = state.timeBonus.copyWith(
      quantity: Constants.DAILY_ADDTIME_BONUS_COUN,
    );
    final newdiffBonus = state.difficultyBonus.copyWith(
      quantity: Constants.DAILY_DIFFICULTY_COUNT,
    );

    final newState = state.copyWith(
      timeBonus: newTimeBonus,
      difficultyBonus: newdiffBonus,
    );

    return await saveData(newState);
  }

  Future<bool> majMoneyEndGame(
    TypeDifficulty difficultMode,
    int levelId,
  ) async {
    final winAddGemme = difficultMode == TypeDifficulty.hard
        ? state.difficultyBonus.gain
        : 0;
    final gain = Constants.GAIN_GEMME + winAddGemme;

    MoneyModel newState = state.copyWith(
      gemeStock: state.gemeStock + gain,
      bestLevel: levelId > state.bestLevel ? levelId : state.bestLevel,
    );

    return await saveData(newState);
  }
}
