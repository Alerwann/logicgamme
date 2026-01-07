import 'package:logic_game/data/enum.dart';
import 'package:hive/hive.dart';

part 'bonus_model.g.dart';

/// définition de la classe de bonus et de leur propriété
@HiveType(typeId: 3)
class BonusModel {
  /// le typeBonus est une énumération des bonus disponibles
  @HiveField(0)
  final TypeBonus nameBonus;

  /// cout de l'achat du bonus en gemme
  @HiveField(1)
  final int costForBuy;

  /// nombre de bonus gratuit disponible
  @HiveField(2)
  final int quantity;

  /// gain en s pour le temps ou en gemme pour la difficulté
  @HiveField(3)
  final int gain;

  BonusModel({
    required this.nameBonus,
    required this.costForBuy,
    required this.quantity,
    required this.gain,
  });

  BonusModel copyWith({
    TypeBonus? nameBonus,
    int? costForBuy,
    int? quantity,
    bool? canBuy,
    int? gain,
  }) {
    return BonusModel(
      nameBonus: nameBonus ?? this.nameBonus,
      costForBuy: costForBuy ?? this.costForBuy,
      quantity: quantity ?? this.quantity,
      gain: gain ?? this.gain,
    );
  }

  /// Compare 2 [BonusModel] par leur valeurs
  /// retourne vrai si toutes les propriétées sont identiques
  ///
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BonusModel &&
          runtimeType == other.runtimeType &&
          nameBonus == other.nameBonus &&
          costForBuy == other.costForBuy &&
          quantity == other.quantity &&
          gain == other.gain;

  /// Génère une clé de hachage basée sur l'ensemble des propriétés de la case.
  @override
  int get hashCode => Object.hash(nameBonus, costForBuy, quantity, gain);
}
