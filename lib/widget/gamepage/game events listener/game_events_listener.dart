import 'package:logic_game/data/constants.dart';
import 'package:logic_game/data/enum/enum.dart';
import 'package:logic_game/data/enum/typebonus/type_bonus.dart';
import 'package:logic_game/models/hive/level/level_model.dart';
import 'package:logic_game/models/models%20utils/result_dialogue_bonus.dart';
import 'package:logic_game/providers/message_provider.dart';
import 'package:logic_game/services/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameEventsListener extends ConsumerWidget {
  final LevelModel level;
  const GameEventsListener({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(messageProvider, (previous, next) {
      if (next != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next)));
      }
    });

    // 2. Écoute des popups de choix (Début : difficulté / Fin : temps)
    ref.listen(gameManagerProvider(level).select((s) => s.statutPartie), (
      previous,
      next,
    ) {
      if (next == EtatGame.chooseDifficulty) {
        print('je suis appelé');
        _initDifficulty(context, ref, level);
      } else if (next == EtatGame.chooseAddTime) {
        _initTimeMessage(context, ref, level);
      }
    });

    return const SizedBox.shrink(); // Ce widget est invisible
  }

  void _showDifficultyPopup(
    BuildContext context,
    WidgetRef ref,
    LevelModel level,
    ResultDialogueBonus dataBonus,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Achat du Bonus ${dataBonus.bonusName.name}"),
          content: Column(
            children: [
              Text(
                "Il te reste ${dataBonus.quantity} bonus offert et ${dataBonus.nombreGemme} gemmes",
              ),
              Text(dataBonus.gain),
              Text("Que choisis tu?"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref
                    .read(gameManagerProvider(level).notifier)
                    .bonusAll(dataBonus.bonusName, false);
                Navigator.of(context).pop();
              },
              child: Text("Ne pas acheter"),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(gameManagerProvider(level).notifier)
                    .bonusAll(dataBonus.bonusName, true);
                Navigator.of(context).pop();
              },

              child: Text("Acheter"),
            ),
          ],
        );
      },
    );
  }

  void _initTimeMessage(BuildContext context, WidgetRef ref, LevelModel level) {
    final money = ref.read(gameManagerProvider(level)).moneyData;
    final bonusTime = money.timeBonus;
    final quantity = bonusTime.quantity;
    final nombreGemme = money.gemeStock;
    final typeAchat = money.canUseBonusDifficulty
        ? "ton bonus quotidien"
        : "${bonusTime.costForBuy} gemmes";
    final modeDiff = ref.read(gameManagerProvider(level)).difficultyMode;
    final annulDifMod = modeDiff == TypeDifficulty.hard
        ? "Le gain supplémentaire est annulé"
        : "";

    final gain =
        "Si tu utilises $typeAchat, tu auras un temps additionnel de ${Constants.TIME_ADD_SECONDS} seconds. $annulDifMod";

    ResultDialogueBonus timeBonus = ResultDialogueBonus(
      quantity: quantity,
      nombreGemme: nombreGemme,
      gain: gain,
      bonusName: TypeBonus.bonusTime,
    );

    _showDifficultyPopup(context, ref, level, timeBonus);
  }

  void _initDifficulty(BuildContext context, WidgetRef ref, LevelModel level) {
    final money = ref.read(gameManagerProvider(level)).moneyData;

    final bonusDifficulty = money.difficultyBonus;
    final quantity = bonusDifficulty.quantity;
    final nombreGemme = money.gemeStock;
    final typeAchat = money.canUseBonusDifficulty
        ? "ton bonus quotidien"
        : "${bonusDifficulty.costForBuy} gemmes";
    final gain =
        "Si tu utilises $typeAchat et finis le jeu en moins de ${Constants.DURATION_HARD_MODE}, tu gagneras ${bonusDifficulty.gain} gemmes supplémentaires.";

    ResultDialogueBonus difficultyBonus = ResultDialogueBonus(
      quantity: quantity,
      nombreGemme: nombreGemme,
      gain: gain,
      bonusName: TypeBonus.bonusDifficulty,
    );
    _showDifficultyPopup(context, ref, level, difficultyBonus);
  }
}
