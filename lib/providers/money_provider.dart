import 'package:clean_temp/models/money/money_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final moneyProvider = Provider<MoneyModel>((ref) {
  final box = Hive.box<MoneyModel>('gameStateBox');
  return box.getAt(0) ?? MoneyModel.empty();
});
