import 'package:logic_game/Theme/material_theme.dart';
import 'package:logic_game/Theme/text_theme.dart';

import 'package:logic_game/data/constants.dart';
import 'package:logic_game/models/hive/noBox/story%20mod/story_data.dart';
import 'package:logic_game/models/hive/noBox/typebonus/type_bonus.dart';

import 'package:logic_game/models/hive/noBox/bonus/bonus_model.dart';
import 'package:logic_game/models/hive/box/level%20profil/level_profil_model.dart';
import 'package:logic_game/models/hive/box/level/level_model.dart';
import 'package:logic_game/models/hive/box/money/money_model.dart';
import 'package:logic_game/pages/home/home_game.dart';
import 'package:logic_game/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/hive/noBox/case/case_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  //Avec une box
  //typeId 0
  Hive.registerAdapter(MoneyModelAdapter());
  // typeID 1
  Hive.registerAdapter(LevelModelAdapter());
  // typeID 2
  Hive.registerAdapter(LevelProfilModelAdapter());

  // sans box
  // typeID 10
  Hive.registerAdapter(CaseModelAdapter());
  //typeID 11
  Hive.registerAdapter(BonusModelAdapter());
  //typeId 12
  Hive.registerAdapter(TypeBonusAdapter());
  //typeId 13
  Hive.registerAdapter(StoryDataAdapter());

  await Hive.openBox<LevelModel>(Constants.levelBox);
  await Hive.openBox<MoneyModel>(Constants.moneyBox);
  await Hive.openBox<LevelProfilModel>(Constants.levelProfilBox);

  HiveService.initLevels();

  runApp(const ProviderScope(child: MyApp()));
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

      home: const HomeGame(),
    );
  }
}
