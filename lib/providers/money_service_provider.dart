import 'package:clean_temp/services/money_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moneyServiceProvider = Provider<MoneyService>((ref) {
  return MoneyService();
});
