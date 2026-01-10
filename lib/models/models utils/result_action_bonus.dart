import 'package:logic_game/data/enum/enum.dart';
import 'package:logic_game/models/hive/money/money_model.dart';

class ResultActionBonus {
  /// vrai si l'action est faite et finalisée sinon faux
  final bool isDo;

  /// status descriptif pour expliquer les retours (cf enum pour plus de détail)
  final BuyStatusCode statusCode;

  /// etat suite à l'exécution de l'action
  final MoneyModel state;

  ResultActionBonus({
    required this.isDo,
    required this.statusCode,
    required this.state,
  });
}
