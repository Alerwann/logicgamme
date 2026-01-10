import 'package:hive/hive.dart';
part 'type_bonus.g.dart';

@HiveType(typeId: 12)
enum TypeBonus {
  @HiveField(0)
  bonusTime,
  @HiveField(1)
  bonusDifficulty,
}
