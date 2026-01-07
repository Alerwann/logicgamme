import 'package:logic_game/data/constants.dart';
import 'package:logic_game/models/hive/money/money_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final moneyProvider = Provider<MoneyModel>((ref) {
  final box = Hive.box<MoneyModel>(Constants.moneyBox);

  return box.isEmpty ? MoneyModel.initial() : box.getAt(0)!;
});
