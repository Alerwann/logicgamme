import 'package:logic_game/data/enum/typebonus/type_bonus.dart';

class ResultDialogueBonus {
  final int quantity;
  final int nombreGemme;
  final String gain;
  final TypeBonus bonusName;

  ResultDialogueBonus({
    required this.quantity,
    required this.nombreGemme,
    required this.gain,
    required this.bonusName,
  });
}
