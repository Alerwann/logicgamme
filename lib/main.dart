import 'package:logic_game/Theme/material_theme.dart';
import 'package:logic_game/Theme/text_theme.dart';
import 'package:logic_game/data/constants.dart';
import 'package:logic_game/data/enum/typebonus/type_bonus.dart';
import 'package:logic_game/models/hive/bonus/bonus_model.dart';
import 'package:logic_game/models/hive/level/level_model.dart';
import 'package:logic_game/models/hive/money/money_model.dart';
import 'package:logic_game/pages/home/home_botom_bar.dart';
import 'package:logic_game/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logic_game/services/money_service.dart';

import 'models/hive/case/case_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CaseModelAdapter());
  Hive.registerAdapter(MoneyModelAdapter());
  Hive.registerAdapter(LevelModelAdapter());
  Hive.registerAdapter(BonusModelAdapter());
  Hive.registerAdapter(TypeBonusAdapter());

  await Hive.openBox<LevelModel>(Constants.levelBox);
  await Hive.openBox<MoneyModel>(Constants.moneyBox);
  MoneyService.initMoney();

  final (bool, String) initHiveService = HiveService.initLevels();
  print(initHiveService.$2);

  runApp(
    // les providers avec Multiprovider(providers:[])
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'logic_game',

      theme: MaterialTheme(AppTypography.createTextTheme()).light(),
      darkTheme: MaterialTheme(AppTypography.createTextTheme()).dark(),
      themeMode: ThemeMode.system,

      home: const HomeBottomBar(),
    );
  }
}
