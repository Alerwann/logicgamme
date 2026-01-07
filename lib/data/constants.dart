// ignore_for_file: constant_identifier_names

import 'package:logic_game/data/enum/typebonus/type_bonus.dart';

class Constants {
  static const String levelBox = 'levelsBox';
  static const String moneyBox = 'moneyBox';

  static const int DURATION_PREVIEW_LEVEL = 2;
  static const int DURATION_DRAWING_MS = 500;

  static const List<TypeBonus> bonusList = [
    TypeBonus.bonusTime,
    TypeBonus.bonusDifficulty,
  ];

  //MODE NORMAL

  static const int GAIN_NORMAL = 100;
  static const int DURATION_NORMAL_MODE = 10;

  //BONUS HARD MODE
  static const int DAILY_DIFFICULTY_COUNT = 1;
  static const int GAIN_HARD_BONUS = 250;
  static const int COUT_HARD_ACHAT = 100;
  static const int DURATION_HARD_MODE = 10;

  // BONUS ADD_TIME
  static const int DAILY_ADDTIME_BONUS_COUN = 3;
  static const int COUT_ADD_TIME = 50;
  static const int TIME_ADD_SECONDS = 30;
}
