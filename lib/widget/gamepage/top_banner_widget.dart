import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logic_game/providers/money_provider.dart';

class TopBannerWidget extends ConsumerWidget {
  final int levelId;
  const TopBannerWidget({super.key, required this.levelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moneyP = ref.watch(moneyProvider);
    return Container(
      height: 200,
      padding: EdgeInsets.only(top: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: Color.fromARGB(255, 39, 160, 110),
            width: constraints.biggest.width,

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    "Niveau : $levelId",
                    style: TextTheme.of(context).displayMedium,
                  ),
                  Expanded(
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 5,

                      children: [
                        Text(
                          "Bonus :",
                          style: TextTheme.of(context).titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Monnaie :",
                          style: TextTheme.of(context).titleLarge,
                          textAlign: TextAlign.center,
                        ),

                        GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 3,

                          children: [
                            Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  moneyP.timeBonus.quantity.toString(),
                                  style: TextTheme.of(context).titleLarge,
                                ),
                                Image.asset(
                                  'assets/images/logo_time.png',
                                  width: 30,
                                ),
                              ],
                            ),

                            Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                 moneyP.difficultyBonus.quantity
                                      .toString(),
                                  style: TextTheme.of(context).titleLarge,
                                ),
                                Image.asset(
                                  'assets/images/logo_hard.png',
                                  width: 30,
                                ),
                              ],
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Text(
                             moneyP.gemeStock.toString(),
                              style: TextTheme.of(context).titleLarge,
                            ),
                            Image.asset(
                              'assets/images/logo_money.png',
                              width: 25,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
