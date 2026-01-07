import 'package:logic_game/data/enum/typebonus/type_bonus.dart';
import 'package:logic_game/models/hive/bonus/bonus_model.dart';
import 'package:logic_game/data/constants.dart';
import 'package:hive/hive.dart';

part 'money_model.g.dart';

/// Représente les stocks de bonus et d'argent virtuel(gemmes)

@HiveType(typeId: 0)
class MoneyModel extends HiveObject {
  @HiveField(0)
  ///L'id du dernier niveau atteint par le joueur
  int bestLevel;
  @HiveField(1)
  /// Bonus quotidien qui permet un ajout de temps au chronomètre
  /// 3 bonus parjours sont offerts -> si non utilisés ils ne sont pas reportés
  int gemeStock;

  @HiveField(2)
  /// Les gemes sont la monaie permanente du jeu et s'acquière à chaque niveau
  BonusModel timeBonus;
  @HiveField(3)
  /// 1 fois par jour le joueur peut échouer gratuitement à un mode HARD
  BonusModel difficultyBonus;
  @HiveField(4)
  bool canUseBonusTime;
  @HiveField(5)
  bool canUseBonusDifficulty;

  MoneyModel({
    required this.bestLevel,
    required this.gemeStock,
    required this.timeBonus,
    required this.difficultyBonus,
    required this.canUseBonusTime,
    required this.canUseBonusDifficulty,
  });

  /// Stock par défaut de bonus et argent virtuel
  ///
  factory MoneyModel.initial() {
    print("init de money model");
    return MoneyModel(
      bestLevel: 0,
      gemeStock: 0,
      timeBonus: BonusModel(
        nameBonus: TypeBonus.bonusTime,
        costForBuy: Constants.COUT_ADD_TIME,
        quantity: 3,
        gain: Constants.TIME_ADD_SECONDS,
      ),
      difficultyBonus: BonusModel(
        nameBonus: TypeBonus.bonusDifficulty,
        costForBuy: Constants.COUT_HARD_ACHAT,
        quantity: 1,
        gain: Constants.GAIN_HARD_BONUS,
      ),

      canUseBonusTime: true,
      canUseBonusDifficulty: true,
    );
  }

  ///Utilise la copy pour te pas casser l'immuabilité du modèle
  MoneyModel copyWith({
    int? bestLevel,
    int? gemeStock,

    BonusModel? timeBonus,

    BonusModel? difficultyBonus,
    bool? canUseBonusTime,
    bool? canUseBonusDifficulty,
  }) {
    return MoneyModel(
      bestLevel: bestLevel ?? this.bestLevel,
      gemeStock: gemeStock ?? this.gemeStock,
      difficultyBonus: difficultyBonus ?? this.difficultyBonus,
      timeBonus: timeBonus ?? this.timeBonus,
      canUseBonusTime: canUseBonusTime ?? this.canUseBonusTime,
      canUseBonusDifficulty:
          canUseBonusDifficulty ?? this.canUseBonusDifficulty,
    );
  }

  /// Compare 2 [MoneyModel] par leur valeurs
  /// retourne vrai si le meilleur niveau, la quantité de bonus et de monaie sont identique
  ///
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoneyModel &&
          runtimeType == other.runtimeType &&
          bestLevel == other.bestLevel &&
          timeBonus == other.timeBonus &&
          gemeStock == other.gemeStock &&
          difficultyBonus == other.difficultyBonus &&
          timeBonus == other.timeBonus &&
          canUseBonusTime == other.canUseBonusTime &&
          canUseBonusDifficulty == other.canUseBonusDifficulty;

  /// Génère une clé de hachage basée sur l'ensemble des propriétés de la case.
  @override
  int get hashCode => Object.hash(
    bestLevel,
    timeBonus,
    gemeStock,
    difficultyBonus,
    timeBonus,
    canUseBonusTime,
    canUseBonusDifficulty,
  );
}
