import 'package:hive/hive.dart';

part 'level_profil_model.g.dart';
@HiveType(typeId: 2)
class LevelProfilModel extends HiveObject {
  @HiveField(0)
  final int levelId;
  @HiveField(1)
  final int bestTime;
  @HiveField(2)
  final bool winWithHard;

  LevelProfilModel({
    required this.levelId,
    required this.bestTime,
    required this.winWithHard,
  });

  LevelProfilModel copyWith({int? levelId, int? bestTime, bool? winWithHard}) {
    return LevelProfilModel(
      levelId: levelId ?? this.levelId,
      bestTime: bestTime ?? this.bestTime,
      winWithHard: winWithHard ?? this.winWithHard,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelProfilModel &&
          levelId == other.levelId &&
          bestTime == other.bestTime &&
          winWithHard == other.winWithHard;

  @override
  int get hashCode => Object.hash(levelId, bestTime, winWithHard);
}
