// import 'package:logic_game/data/constants.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:logic_game/services/money_service.dart';
// import 'package:logic_game/models/money/money_model.dart';
// import 'package:logic_game/data/enum.dart';

// void main() {
//   final moneyService = MoneyService();
//   group('MoneyService - canUseBonus', () {
//     test('Doit retourner true si le joueur a un bonus gratuit', () {
//       // 1. Initialisation : Création d'un modèle avec 1 bonus
//       final money = MoneyModel(
//         gemeStock: 0,
//         bonusDaily: 1,
//         freeHardBonus: 0,
//         bestLevel: 1,
//       );

//       // 2. Exécution
//       final result = moneyService.canUseBonus(money, TypeBonus.bonusTime);

//       // 3. Vérification
//       expect(result, isTrue);
//     });

//     test('Doit retourner true si le joueur a assez de gemmes', () {
//       final money = MoneyModel(
//         gemeStock: 500,
//         bonusDaily: 0,
//         freeHardBonus: 0,
//         bestLevel: 1,
//       );

//       final result = moneyService.canUseBonus(money, TypeBonus.bonusTime);

//       expect(result, isTrue);
//     });
//   });

//   group("Money-service - testbuybonus", () {
//     test("achat par bonus s'il existe", () {
//       final MoneyModel modelTry = MoneyModel(
//         bestLevel: 1,
//         bonusDaily: 1,
//         gemeStock: 0,
//         freeHardBonus: 1,
//       );

//       final MoneyModel resultModel = MoneyModel(
//         bestLevel: 1,
//         bonusDaily: 0,
//         gemeStock: 0,
//         freeHardBonus: 1,
//       );

//       final result = moneyService.testTypeBuyBonus(
//         TypeBonus.bonusTime,
//         modelTry,
//       );

//       expect(result.$1, isTrue);
//       expect(result.$2, resultModel);
//     });
//     test(
//       'buyBonus - Doit échouer si pas assez de gemmes et pas de bonus',
//       () async {
//         // 1. Arrange : 0 gemmes, 0 bonus


//          final MoneyModel modelTry = MoneyModel(
//           bestLevel: 1,
//           bonusDaily: 0,
//           gemeStock: 0,
//           freeHardBonus: 1,
//         );


//         final result = moneyService.testTypeBuyBonus(
//           TypeBonus.bonusTime,
//           modelTry,
//         );


//         // 3. Assert
//         expect(result.$1, isFalse);
//         expect(result.$2, modelTry );

//       },
//     );

//     test('buyBonus - achat par gemme si pas de bonus', ()  {
//       // 1. Arrange : 0 gemmes, 0 bonus
//       final moneyInitial = MoneyModel(
//         gemeStock: 500,
//         bonusDaily: 0,
//         freeHardBonus: 0,
//         bestLevel: 1,
//       );

//       final endMoney = MoneyModel(
//         gemeStock: 500 - Constants.COUT_ADD_TIME,
//         bonusDaily: 0,
//         freeHardBonus: 0,
//         bestLevel: 1,
//       );

//       final result = moneyService.testTypeBuyBonus(
//         TypeBonus.bonusTime,
//         moneyInitial,
//       );

//       expect(result.$2, endMoney);
//       expect(result.$1, isTrue);
//     });
//   });

//   group("Money - Service - niveauCalculate", () {
//     final moneyBefore = MoneyModel(
//       bestLevel: 3,
//       bonusDaily: 0,
//       gemeStock: 0,
//       freeHardBonus: 0,
//     );

//     test("Dernier niveau doit augmenter si dernier niveau réussi", () {
//       final moneyAfter = MoneyModel(
//         bestLevel: 4,
//         bonusDaily: 0,
//         gemeStock: Constants.GAIN_NORMAL,
//         freeHardBonus: 0,
//       );

//       final result = moneyService.niveauCalculate(
//         3,
//         moneyBefore,
//         TypeDifficulty.normal,
//       );

//       expect(result, moneyAfter);
//     });

//     test(
//       "si le niveau joué est inférieur au meilleur pas de gain de niveau",
//       () {
//         final moneyAfter = MoneyModel(
//           bestLevel: 3,
//           bonusDaily: 0,
//           gemeStock: Constants.GAIN_NORMAL,
//           freeHardBonus: 0,
//         );

//         final result = moneyService.niveauCalculate(
//           1,
//           moneyBefore,
//           TypeDifficulty.normal,
//         );

//         expect(result, moneyAfter);
//       },
//     );

//     test("verification différences entre les gain normal et hard", () {
//       final resultNormal = moneyService.niveauCalculate(
//         1,
//         moneyBefore,
//         TypeDifficulty.normal,
//       );

//       final resultHard = moneyService.niveauCalculate(
//         1,
//         moneyBefore,
//         TypeDifficulty.hard,
//       );

//       expect(resultNormal.gemeStock < resultHard.gemeStock, isTrue);
      
//     });
//   });
// }
