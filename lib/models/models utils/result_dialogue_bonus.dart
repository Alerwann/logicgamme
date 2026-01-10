import 'package:logic_game/models/hive/noBox/typebonus/type_bonus.dart';

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
