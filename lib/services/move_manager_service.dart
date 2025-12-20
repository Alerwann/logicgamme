import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/case/case_model.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/models/session_state.dart';

class MoveManagerService {
  MoveResult handleMove(SessionState state, CaseModel newCase) {
    final CaseModel lastCase = state.roadList.last;

    bool lastBaliseCheck = false;
    int currentTagIndex = state.lastTagSave;

    // annulation du chemin
    if (state.roadSet.contains(newCase)) {
      final index = state.roadList.indexOf(newCase);
      final newRoad = state.roadList.sublist(0, index + 1);

      int newMaxTag = 0;
      for (var c in newRoad) {
        if (c.numberTag != null) {
          if (c.numberTag! > newMaxTag) {
            newMaxTag = c.numberTag!;
          }
        }
      }
      final newState = state.copyWith(
        roadList: newRoad,
        roadSet: newRoad.toSet(),
        lastTagSave: newMaxTag,
      );
      return MoveResult(
        sessionState: newState,
        statusCode: MoveStatusCode.successCancel,
      );
    }

    // parametrage des informations de directions
    final directionData = testDirection(lastCase, newCase);

    if (!directionData.ortho) {
      return MoveResult(
        sessionState: state,
        statusCode: MoveStatusCode.notOrthoError,
      );
    }

    final expectedLength = directionData.lengthRoad!;
    final direction = directionData.direction!;
    final typeMove = directionData.typeMove!;

    // création de la liste de test
    final casesList = createListCasesTest(
      newCase,
      state.levelConfig,
      state.roadList,
      typeMove,
      direction,
    );
    // si liste crée inférieur à la liste espérée -> problème de chargement
    if (casesList.length < expectedLength) {
      return MoveResult(
        sessionState: state,
        statusCode: MoveStatusCode.internalError,
      );
    }
    // si liste plus grande à l'espérance -> problème de déjà passer ou chargement
    if (casesList.length > expectedLength) {
      final resultAllreadyPass = testAlreadyPass(state.roadSet, casesList);
      if (resultAllreadyPass.$1) {
        return MoveResult(
          sessionState: state,
          statusCode: MoveStatusCode.alreadyVisitedError,
          errorCase: resultAllreadyPass.$2,
        );
      } else {
        return MoveResult(
          sessionState: state,
          statusCode: MoveStatusCode.internalError,
        );
      }
    }

    //test des tags et leur ordre
    final resultTagTest = testOderTag(state.lastTagSave, casesList);

    if (!resultTagTest.goodOrder) {
      return MoveResult(
        sessionState: state,
        statusCode: MoveStatusCode.tagError,
        errorCase: resultTagTest.errorCase,
      );
    } else {
      final int indexTosave = resultTagTest.lastTag;
      if (indexTosave == state.levelConfig.maxTag) {
        lastBaliseCheck = true;
      }
    }

    //test des murs
    final List<CaseModel> allPathCases = [lastCase, ...casesList];

    final resultTestWall = testWall(allPathCases, direction, typeMove);

    if (resultTestWall.$1) {
      return MoveResult(
        sessionState: state,
        statusCode: MoveStatusCode.wallError,
        errorCase: resultTestWall.$2,
      );
    }

    SessionState newState = state.copyWith(
      roadList: [...state.roadList, ...casesList],
      roadSet: {...state.roadSet, ...casesList},
      lastTagSave: currentTagIndex,
    );

    if (lastBaliseCheck) {
      return MoveResult(
        sessionState: newState,
        statusCode: MoveStatusCode.successlastTagCheck,
      );
    }

    return MoveResult(
      sessionState: newState,
      statusCode: MoveStatusCode.success,
    );
  }

  CaseModel? getCaseByCoordinates(LevelModel level, int targetX, int targetY) {
    try {
      return level.cases.firstWhere(
        (caseModel) =>
            caseModel.xValue == targetX && caseModel.yValue == targetY,
      );
    } catch (e) {
      return null;
    }
  }

  List<CaseModel> createListCasesTest(
    CaseModel newCase,
    LevelModel level,
    List<CaseModel> road,
    TypeMove typeMove,
    int direction,
  ) {
    int step = direction;
    int start;
    int end;
    int fixCoordonne;

    switch (typeMove) {
      case TypeMove.vertical:
        start = road.last.yValue + 1;
        end = newCase.yValue;
        fixCoordonne = road.last.xValue;
        break;
      case TypeMove.horizontal:
        start = road.last.xValue + 1;
        end = newCase.xValue;
        fixCoordonne = road.last.yValue;
        break;
    }

    CaseModel? caseSearch;

    List<CaseModel> caseToTest = [];

    for (var i = start; step > 0 ? i <= end : i >= end; i += step) {
      if (typeMove == TypeMove.horizontal) {
        caseSearch = getCaseByCoordinates(level, i, fixCoordonne);
      } else if (typeMove == TypeMove.vertical) {
        caseSearch = getCaseByCoordinates(level, fixCoordonne, i);
      }
      if (caseSearch != null) {
        caseToTest.add(caseSearch);
      }
    }
    return caseToTest;
  }

  (bool, CaseModel) testWall(
    List<CaseModel> allPathCases,
    int directionMove,
    TypeMove typeMove,
  ) {
    final CaseModel caseTonotVerif;

    directionMove == 1
        ? caseTonotVerif = allPathCases.last
        : caseTonotVerif = allPathCases[0];

    if (typeMove == TypeMove.horizontal) {
      for (final caseSearch in allPathCases) {
        if (caseSearch.wallV && caseSearch != caseTonotVerif) {
          return (true, caseSearch);
        }
      }
    } else if (typeMove == TypeMove.vertical) {
      for (final caseSearch in allPathCases) {
        if (caseSearch.wallH && caseSearch != caseTonotVerif) {
          return (true, caseSearch);
        }
      }
    }

    return (false, allPathCases.last);
  }

  (bool, CaseModel) testAlreadyPass(
    Set<CaseModel> allCases,
    List<CaseModel> newCasesList,
  ) {
    for (var cases in newCasesList) {
      if (allCases.contains(cases)) {
        return (true, cases);
      }
    }

    return (false, newCasesList.last);
  }

  ResultOrderTag testOderTag(int lastTagSave, List<CaseModel> newRoad) {
    int temporyTag = lastTagSave;

    for (var cases in newRoad) {
      if (cases.numberTag != null) {
        if (cases.numberTag == temporyTag + 1) {
          temporyTag = cases.numberTag!;
        } else {
          return ResultOrderTag(
            goodOrder: false,
            lastTag: lastTagSave,
            errorCase: cases,
          );
        }
      }
    }
    return ResultOrderTag(goodOrder: true, lastTag: temporyTag);
  }

  ResultDirection testDirection(CaseModel lastCase, CaseModel newCase) {
    int delta;
    TypeMove typeMove;

    //fin orthogonalité
    if (lastCase.xValue != newCase.xValue &&
        lastCase.yValue != newCase.yValue) {
      return ResultDirection(ortho: false);
    }
    //verif horizontal vertical

    if (lastCase.xValue == newCase.xValue) {
      // mouvement vertical
      delta = newCase.yValue - lastCase.yValue;
      typeMove = TypeMove.vertical;
    } else {
      delta = newCase.xValue - lastCase.xValue;
      typeMove = TypeMove.horizontal;
    }

    final lengthRoad = delta.abs();
    final direction = delta > 0 ? 1 : -1;

    return ResultDirection(
      ortho: true,
      lengthRoad: lengthRoad,
      direction: direction,
      typeMove: typeMove,
    );
  }
}

class ResultOrderTag {
  final bool goodOrder;
  final int lastTag;
  final CaseModel? errorCase;

  ResultOrderTag({
    required this.goodOrder,
    required this.lastTag,
    this.errorCase,
  });
}

class ResultDirection {
  final bool ortho;
  final int? lengthRoad;
  final int? direction;
  final TypeMove? typeMove;

  ResultDirection({
    required this.ortho,
    this.lengthRoad,
    this.direction,
    this.typeMove,
  });
}

class MoveResult {
  final MoveStatusCode statusCode;
  final SessionState sessionState;
  final CaseModel? errorCase;

  MoveResult({
    required this.sessionState,
    required this.statusCode,
    this.errorCase,
  });
}
