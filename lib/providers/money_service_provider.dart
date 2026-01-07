import 'package:logic_game/services/money_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moneyServiceProvider = Provider<MoneyService>((ref) {
  return MoneyService();
});
