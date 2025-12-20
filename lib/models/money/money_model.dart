import 'package:hive/hive.dart';

part 'money_model.g.dart';

@HiveType(typeId: 2)
class MoneyModel extends HiveObject {
  @HiveField(0)
  //L'id du dernier niveau atteint par le joueur
  int bestLevel;
  @HiveField(1)
  // Bonus quotidien qui permet un ajout de temps au chronomètre
  // 3 bonus parjours sont offerts -> si non utilisés ils ne sont pas reportés
  int bonusDaily;
  @HiveField(2)
  // Les gemes sont la monaie permanente du jeu et s'acquière à chaque niveau
  int gemeStock;
  @HiveField(3)
  // 1 fois par jour le joueur peut échouer gratuitement à un mode HARD
  int freeHardBonus;

  MoneyModel({
    required this.bestLevel,
    required this.bonusDaily,
    required this.gemeStock,
    required this.freeHardBonus,
  });

  factory MoneyModel.initial() {
    return MoneyModel(
      bestLevel: 0,
      bonusDaily: 3,
      gemeStock: 0,
      freeHardBonus: 1,
    );
  }

  MoneyModel copyWith({
    int? bestLevel,
    int? bonusDaily,
    int? gemeStock,
    int? freeHardBonus,
  }) {
    return MoneyModel(
      bestLevel: bestLevel ?? this.bestLevel,
      bonusDaily: bonusDaily ?? this.bonusDaily,
      gemeStock: gemeStock ?? this.gemeStock,
      freeHardBonus: freeHardBonus ?? this.freeHardBonus,
    );
  }

  // ignore: strict_top_level_inference
  static empty() {}

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoneyModel &&
      runtimeType == other.runtimeType &&
          bestLevel == other.bestLevel &&
          bonusDaily == other.bonusDaily &&
          gemeStock == other.gemeStock &&
          freeHardBonus ==other.freeHardBonus;

  @override
  int get hashCode =>
      bestLevel.hashCode ^
      bonusDaily.hashCode ^
      gemeStock.hashCode ^
      freeHardBonus.hashCode;
}
