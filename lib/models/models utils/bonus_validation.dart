import 'package:clean_temp/data/enum.dart';

class AllBonus {
  final BonusDef timeBonus;
  final BonusDef difficultyBonus;

  AllBonus({required this.timeBonus, required this.difficultyBonus});
}



class BonusDef {
  final TypeBonus nameBonus;
  final int costForBuy;
  final int quantity;

  final int gain;

  BonusDef({
    required this.nameBonus,
    required this.costForBuy,
    required this.quantity,
    required this.gain,
  });

  BonusDef copyWith({
    TypeBonus? nameBonus,
    int? costForBuy,
    int? quantity,
    bool? canBuy,
    int? gain,
  }) {
    return BonusDef(
      nameBonus: nameBonus ?? this.nameBonus,
      costForBuy: costForBuy ?? this.costForBuy,
      quantity: quantity ?? this.quantity,
      gain: gain ?? this.gain,
    );
  }

  /// Compare 2 [BonusDef] par leur valeurs
  /// retourne vrai si le meilleur niveau, la quantité de bonus et de monaie sont identique
  ///
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BonusDef &&
          runtimeType == other.runtimeType &&
          nameBonus == other.nameBonus &&
          costForBuy == other.costForBuy &&
          quantity == other.quantity &&
          gain == other.gain;

  /// Génère une clé de hachage basée sur l'ensemble des propriétés de la case.
  @override
  int get hashCode => Object.hash(nameBonus, costForBuy, quantity, gain);
}
