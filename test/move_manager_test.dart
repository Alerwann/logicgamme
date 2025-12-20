import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/case/case_model.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/models/money/money_model.dart';
import 'package:clean_temp/models/session_state.dart';
import 'package:clean_temp/services/move_manager_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final moveManageService = MoveManagerService();

  final LevelModel level = LevelModel(
    levelId: 1,
    cases: [
      CaseModel(xValue: 0, yValue: 0, wallH: false, wallV: true, numberTag: 1),
      CaseModel(xValue: 0, yValue: 1, wallH: true, wallV: false),
      CaseModel(xValue: 0, yValue: 2, wallH: false, wallV: false),
      CaseModel(xValue: 0, yValue: 3, wallH: false, wallV: false),

      CaseModel(xValue: 1, yValue: 0, wallH: false, wallV: false),
      CaseModel(xValue: 1, yValue: 1, wallH: false, wallV: false),
      CaseModel(xValue: 1, yValue: 2, wallH: false, wallV: false),
      CaseModel(xValue: 1, yValue: 3, wallH: false, wallV: false),

      CaseModel(xValue: 2, yValue: 0, wallH: false, wallV: false, numberTag: 2),
      CaseModel(xValue: 2, yValue: 1, wallH: false, wallV: false),
      CaseModel(xValue: 2, yValue: 2, wallH: false, wallV: false),
      CaseModel(xValue: 2, yValue: 3, wallH: false, wallV: false),

      CaseModel(xValue: 3, yValue: 0, wallH: false, wallV: false, numberTag: 4),
      CaseModel(xValue: 3, yValue: 1, wallH: false, wallV: false),
      CaseModel(xValue: 3, yValue: 2, wallH: false, wallV: false),
      CaseModel(xValue: 3, yValue: 3, wallH: false, wallV: false),
    ],
    firstCase: CaseModel(
      xValue: 0,
      yValue: 0,
      wallH: false,
      wallV: false,
      numberTag: 1,
    ),
    maxTag: 4,
  );

  final MoneyModel money = MoneyModel(
    bestLevel: 1,
    bonusDaily: 0,
    gemeStock: 0,
    freeHardBonus: 0,
  );

  final SessionState sessionG = SessionState(
    levelConfig: level,
    roadList: [
          CaseModel(xValue: 0, yValue: 0, wallH: false, wallV: true, numberTag: 1),
    ],
    roadSet: {
      CaseModel(xValue: 0, yValue: 0, wallH: false, wallV: true, numberTag: 1),
    },
    lastTagSave: 1,
    statutPartie: EtatGame.isPlaying,
    difficultyMode: TypeDifficulty.normal,
    moneyData: money,
  );

  group('move-manage - case gestion', () {
    test('retourner cases grâce aux coordonnées', () {
      final caseExpect = CaseModel(
        xValue: 1,
        yValue: 1,
        wallH: true,
        wallV: false,
      );

      final result = moveManageService.getCaseByCoordinates(
        sessionG.levelConfig,
        1,
        1,
      );

      expect(result, caseExpect);
    });

    test("create liste des cases du chemin", () {
      final expectList = [
        CaseModel(xValue: 0, yValue: 1, wallH: true, wallV: false),
        CaseModel(xValue: 0, yValue: 2, wallH: false, wallV: false),
      ];

      final result = moveManageService.createListCasesTest(
        CaseModel(xValue: 0, yValue: 2, wallH: false, wallV: false),
        sessionG.levelConfig,
        sessionG.roadList,
        TypeMove.vertical,
        1,
      );

      expect(result, expectList);
    });
  });

  group("Move_manager_service - handlemove", () {
    test("horizontal wall - handle", () {
      final result = moveManageService.handleMove(
        sessionG,
        CaseModel(xValue: 0, yValue: 2, wallH: false, wallV: false),
      );

      // expect(
      //   result.errorCase,
      //   CaseModel(xValue: 0, yValue: 1, wallH: true, wallV: false),
      // );
      expect(result.statusCode, MoveStatusCode.wallError);

      // expect(result.sessionState, sessionG);
    });

    test("vertical wall ", () {
      final result = moveManageService.handleMove(
        sessionG,
        CaseModel(xValue: 1, yValue: 0, wallH: false, wallV: false),
      );

      // expect(
      //   result.errorCase,
      //   CaseModel(xValue: 1, yValue: 0, wallH: false, wallV: false),
      // );
      expect(result.statusCode, MoveStatusCode.wallError);

      // expect(result.sessionState, sessionG);
    });
    test("Tag suit", () {
      final result = moveManageService.handleMove(
        sessionG,
        CaseModel(
          xValue: 3,
          yValue: 0,
          wallH: false,
          wallV: false,
          numberTag: 4,
        ),
      );
      expect(
        result.errorCase,
        CaseModel(
          xValue: 3,
          yValue: 0,
          wallH: false,
          wallV: false,
          numberTag: 4,
        ),
      );
      expect(result.statusCode, MoveStatusCode.tagError);

      expect(result.sessionState, sessionG);
    });
    test("allready pass", () {
      final SessionState session = SessionState(
        levelConfig: level,
        roadList: [
          CaseModel(
            xValue: 0,
            yValue: 0,
            wallH: false,
            wallV: false,
            numberTag: 1,
          ),
          CaseModel(xValue: 0, yValue: 1, wallH: false, wallV: false),
          CaseModel(xValue: 0, yValue: 2, wallH: true, wallV: false),
          CaseModel(xValue: 1, yValue: 2, wallH: false, wallV: false),
          CaseModel(xValue: 2, yValue: 2, wallH: false, wallV: false),
          CaseModel(xValue: 2, yValue: 3, wallH: false, wallV: false),
          CaseModel(xValue: 1, yValue: 3, wallH: false, wallV: false),
        ],
        roadSet: {
          CaseModel(
            xValue: 0,
            yValue: 0,
            wallH: false,
            wallV: false,
            numberTag: 1,
          ),
          CaseModel(xValue: 0, yValue: 1, wallH: false, wallV: false),
          CaseModel(xValue: 0, yValue: 2, wallH: true, wallV: false),
          CaseModel(xValue: 1, yValue: 2, wallH: false, wallV: false),
          CaseModel(xValue: 2, yValue: 2, wallH: false, wallV: false),
          CaseModel(xValue: 2, yValue: 3, wallH: false, wallV: false),
          CaseModel(xValue: 1, yValue: 3, wallH: false, wallV: false),
        },
        lastTagSave: 1,
        statutPartie: EtatGame.isPlaying,
        difficultyMode: TypeDifficulty.normal,
        moneyData: money,
      );

      final result = moveManageService.handleMove(
        session,
        CaseModel(xValue: 1, yValue: 0, wallH: false, wallV: false),
      );

      // expect(
      //   result.errorCase,
      //   CaseModel(xValue: 1, yValue: 2, wallH: false, wallV: false),
      // );
      expect(result.statusCode, MoveStatusCode.alreadyVisitedError);

      // expect(result.sessionState, session);
    });

    test("othogonalite - ko si non horizontal ou vertical", () {
      final SessionState session = SessionState(
        levelConfig: level,
        roadList: [
          CaseModel(
            xValue: 0,
            yValue: 0,
            wallH: false,
            wallV: false,
            numberTag: 1,
          ),
        ],
        roadSet: {
          CaseModel(
            xValue: 0,
            yValue: 0,
            wallH: false,
            wallV: false,
            numberTag: 1,
          ),
        },
        lastTagSave: 1,
        statutPartie: EtatGame.isPlaying,
        difficultyMode: TypeDifficulty.normal,
        moneyData: money,
      );

      final result = moveManageService.handleMove(
        session,
        CaseModel(xValue: 1, yValue: 1, wallH: false, wallV: false),
      );

      expect(result.statusCode, MoveStatusCode.notOrthoError);

      expect(result.sessionState, session);
    });

    test("si aucune contrainte creation nouveau model", () {
      final result = moveManageService.handleMove(
        sessionG,
        CaseModel(xValue: 0, yValue: 1, wallH: true, wallV: false),
      );

      expect(result.errorCase, null);
      expect(result.statusCode, MoveStatusCode.success);

      expect(result.sessionState, result.sessionState);
    });

    test('annulation de chemin - sans modification tag', () {
      final state = SessionState(
        levelConfig: level,
        roadList: [
          CaseModel(
            xValue: 0,
            yValue: 0,
            wallH: false,
            wallV: false,
            numberTag: 1,
          ),

          CaseModel(xValue: 0, yValue: 1, wallH: false, wallV: false),
        ],
        roadSet: {
          CaseModel(
            xValue: 0,
            yValue: 0,
            wallH: false,
            wallV: false,
            numberTag: 1,
          ),
          CaseModel(xValue: 0, yValue: 1, wallH: false, wallV: false),
        },
        lastTagSave: 1,
        statutPartie: EtatGame.isPlaying,
        difficultyMode: TypeDifficulty.normal,
        moneyData: money,
      );

      final excepStatewithoutTag = SessionState(
        levelConfig: level,
        roadList: [
          CaseModel(
            xValue: 0,
            yValue: 0,
            wallH: false,
            wallV: false,
            numberTag: 1,
          ),
        ],
        roadSet: {
          CaseModel(
            xValue: 0,
            yValue: 0,
            wallH: false,
            wallV: false,
            numberTag: 1,
          ),
        },
        lastTagSave: 1,
        statutPartie: EtatGame.isPlaying,
        difficultyMode: TypeDifficulty.normal,
        moneyData: money,
      );

      final resultWOTag = moveManageService.handleMove(
        state,
        CaseModel(
          xValue: 0,
          yValue: 0,
          wallH: false,
          wallV: false,
          numberTag: 1,
        ),
      );

      expect(resultWOTag.sessionState, excepStatewithoutTag);
      expect(resultWOTag.statusCode, MoveStatusCode.successCancel);
    });
  });

  group('direction verif', () {
    test('orthogonalité - si mouvemnt vertical et horizontal false', () {
      final lastCase = CaseModel(
        xValue: 0,
        yValue: 0,
        wallH: false,
        wallV: false,
      );
      final newCase = CaseModel(
        xValue: 1,
        yValue: 1,
        wallH: false,
        wallV: false,
      );

      final result = moveManageService.testDirection(lastCase, newCase);
      expect(result.ortho, false);
    });

    test('mouvement vertical - ', () {
      final lastCase = CaseModel(
        xValue: 0,
        yValue: 0,
        wallH: false,
        wallV: false,
      );
      final newCase = CaseModel(
        xValue: 0,
        yValue: 2,
        wallH: false,
        wallV: false,
      );

      final result = moveManageService.testDirection(lastCase, newCase);
      expect(result.typeMove, TypeMove.vertical);
    });
    test('mouvement horizontal - ', () {
      final lastCase = CaseModel(
        xValue: 0,
        yValue: 0,
        wallH: false,
        wallV: false,
      );
      final newCase = CaseModel(
        xValue: 1,
        yValue: 0,
        wallH: false,
        wallV: false,
      );

      final result = moveManageService.testDirection(lastCase, newCase);
      expect(result.typeMove, TypeMove.horizontal);
    });

    test("direction - si abs ou ordoné final suppérieur retourne 1", () {
      final lastCase = CaseModel(
        xValue: 0,
        yValue: 0,
        wallH: false,
        wallV: false,
      );
      final newCase = CaseModel(
        xValue: 0,
        yValue: 2,
        wallH: false,
        wallV: false,
      );

      final result = moveManageService.testDirection(lastCase, newCase);
      expect(result.direction, 1);
    });

    test("global datadirection", () {
      final lastCase = CaseModel(
        xValue: 0,
        yValue: 0,
        wallH: false,
        wallV: false,
      );
      final newCase = CaseModel(
        xValue: 0,
        yValue: 2,
        wallH: false,
        wallV: false,
      );

      final result = moveManageService.testDirection(lastCase, newCase);
      expect(result.typeMove, TypeMove.vertical);
      expect(result.direction, 1);
      expect(result.lengthRoad, 2);
      expect(result.ortho, isTrue);
    });
  });

  group('testwall part', () {
    test('horizontal wall', () {
      List<CaseModel> allPathCases = [
        CaseModel(xValue: 0, yValue: 0, wallH: false, wallV: false),
        CaseModel(xValue: 0, yValue: 1, wallH: true, wallV: false),
        CaseModel(xValue: 0, yValue: 2, wallH: false, wallV: false),
      ];

      final int direction = 1;

      final resultTest = moveManageService.testWall(
        allPathCases,
        direction,
        TypeMove.vertical,
      );

      expect(resultTest.$1, true);
      expect(
        resultTest.$2,
        CaseModel(xValue: 0, yValue: 1, wallH: true, wallV: false),
      );
    });

    test('vertical wall', () {
      List<CaseModel> allPathCases = [
        CaseModel(
          xValue: 0,
          yValue: 0,
          wallH: false,
          wallV: true,
          numberTag: 1,
        ),
        CaseModel(xValue: 1, yValue: 0, wallH: false, wallV: false),
      ];

      final int direction = 1;

      final resultTest = moveManageService.testWall(
        allPathCases,
        direction,
        TypeMove.horizontal,
      );
      expect(resultTest.$1, true);
      expect(
        resultTest.$2,
        CaseModel(
          xValue: 0,
          yValue: 0,
          wallH: false,
          wallV: true,
          numberTag: 1,
        ),
      );
    });
  });

  group('tag test', () {
    test('ordre et validation des balises - ordre bon retourne bon', () {
      final int initialMaxTag = 2;

      final List<CaseModel> road = [
        CaseModel(
          xValue: 0,
          yValue: 1,
          wallH: false,
          wallV: false,
          numberTag: 3,
        ),
      ];

      final result = moveManageService.testOderTag(initialMaxTag, road);
      expect(result.goodOrder, true);
      expect(result.lastTag, 3);
    });
    test(
      'ordre et validation des balises - ordre mauvais retourne erreu avec case',
      () {
        final int initialMaxTag = 2;

        final List<CaseModel> road = [
          CaseModel(
            xValue: 0,
            yValue: 1,
            wallH: false,
            wallV: false,
            numberTag: 5,
          ),
        ];
        final result = moveManageService.testOderTag(initialMaxTag, road);
        expect(result.goodOrder, false);
        expect(result.lastTag, 2);
        expect(
          result.errorCase,
          CaseModel(
            xValue: 0,
            yValue: 1,
            wallH: false,
            wallV: false,
            numberTag: 5,
          ),
        );
      },
    );
  });

  group('allreadypass', () {
    test('Erreur si le chemin coupe le tacé', () {
      Set<CaseModel> allCases = {
        CaseModel(
          xValue: 0,
          yValue: 0,
          wallH: false,
          wallV: false,
          numberTag: 1,
        ),

        CaseModel(xValue: 0, yValue: 1, wallH: true, wallV: false),
        CaseModel(xValue: 1, yValue: 1, wallH: false, wallV: false),
        CaseModel(xValue: 2, yValue: 1, wallH: false, wallV: false),
        CaseModel(xValue: 2, yValue: 2, wallH: false, wallV: false),
        CaseModel(xValue: 1, yValue: 2, wallH: false, wallV: false),
      };
      List<CaseModel> newRoadList = [
        CaseModel(xValue: 1, yValue: 1, wallH: false, wallV: false),
        CaseModel(xValue: 1, yValue: 0, wallH: false, wallV: false),
      ];
      final result = moveManageService.testAlreadyPass(allCases, newRoadList);
      expect(result.$1, true);
    });
  });
}
