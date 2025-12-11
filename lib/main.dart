import 'package:clean_temp/Theme/material_theme.dart';
import 'package:clean_temp/Theme/text_theme.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/pages/home/home_botom_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/case/case_model.dart';
import 'models/game_state/game_state_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CaseModelAdapter());
  Hive.registerAdapter(GameStateModelAdapter());
  Hive.registerAdapter(LevelModelAdapter());

  await Hive.openBox<LevelModel>('levelsBox');

  runApp(
    // les providers avec Multiprovider(providers:[])
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'logicgame',

      theme: MaterialTheme(AppTypography.createTextTheme()).light(),
      darkTheme: MaterialTheme(AppTypography.createTextTheme()).dark(),
      themeMode: ThemeMode.system,

      home: const HomeBottomBar(),
    );
  }
}
