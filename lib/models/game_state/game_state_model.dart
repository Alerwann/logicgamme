import 'package:hive_flutter/hive_flutter.dart';

part 'game_state_model.g.dart';

@HiveType(typeId: 2)
class GameStateModel extends HiveObject {
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
  bool freeHardBonus;
  @HiveField(4)
  // Date dernier reset des bonus quotidiens
  DateTime resetDate;

  GameStateModel({
    required this.bestLevel,
    required this.bonusDaily,
    required this.gemeStock,
    required this.freeHardBonus,
    required this.resetDate,
  });

  factory GameStateModel.initial() {
    return GameStateModel(
      bestLevel: 0,
      bonusDaily: 3, 
      gemeStock: 0,
      freeHardBonus: true,
      resetDate: DateTime.now().subtract(
        Duration(days: 1),
      ), 
    );
  }
}
