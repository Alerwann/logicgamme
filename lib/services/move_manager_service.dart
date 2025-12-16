import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/case/case_model.dart';
import 'package:clean_temp/models/session_state.dart';

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

class MoveManagerService {
  MoveResult handleMove(SessionState state, CaseModel newCase) {
    final newAbscisse = newCase.xValue;
    final newOrdonnee = newCase.yValue;

    final oldAbscisse = state.roadList.last.xValue;
    final oldOrdonnee = state.roadList.last.yValue;

    final deltaX = (newAbscisse - oldAbscisse);
    final deltaY = (newOrdonnee - oldOrdonnee);
    final expectedLength = deltaX > 0 ? deltaX.abs() : deltaY.abs();
    final direction = deltaX != 0
        ? (deltaX > 0 ? 1 : -1)
        : (deltaY > 0 ? 1 : -1);

    final CaseModel lastCase = state.roadList.last;

    bool lastBaliseCheck = false;
    int currentTagIndex = state.lastTagSave;

    if (oldAbscisse != newAbscisse && oldOrdonnee != newOrdonnee) {
      return MoveResult(
        sessionState: state,
        statusCode: MoveStatusCode.notOrthoError,
      );
    }
    final casesList = createListCasesTest(state, newCase);

    if (casesList.length != expectedLength) {
      return MoveResult(
        sessionState: state,
        statusCode: MoveStatusCode.internalError,
      );
    }
    final List<CaseModel> allPathCases = [lastCase, ...casesList];

    for (final caseSearch in casesList) {
      if (state.roadSet.contains(caseSearch)) {
        return MoveResult(
          sessionState: state,
          statusCode: MoveStatusCode.alreadyVisitedError,
          errorCase: caseSearch,
        );
      }
      if (caseSearch.numberTag != null) {
        if (caseSearch.numberTag != currentTagIndex + 1) {
          return MoveResult(
            sessionState: state,
            statusCode: MoveStatusCode.tagError,
          );
        }

        currentTagIndex = caseSearch.numberTag!;
        if (currentTagIndex == state.levelConfig.maxTag) {
          lastBaliseCheck = true;
        }
      }
    }

    final testWall = _testWall(allPathCases, direction);
    if (testWall.$1) {
      return MoveResult(
        sessionState: state,
        statusCode: MoveStatusCode.wallError,
        errorCase: testWall.$2,
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

    return MoveResult(sessionState: newState, statusCode: MoveStatusCode.success);
  }

  CaseModel? getCaseByCoordinates(
    SessionState state,
    int targetX,
    int targetY,
  ) {
    try {
      return state.levelConfig.cases.firstWhere(
        (caseModel) =>
            caseModel.xValue == targetX && caseModel.yValue == targetY,
      );
    } catch (e) {
      return null;
    }
  }

  List<CaseModel> createListCasesTest(SessionState state, CaseModel newCase) {
    final newAbscisse = newCase.xValue;
    final newOrdonnee = newCase.yValue;

    final oldAbscisse = state.roadList.last.xValue;
    final oldOrdonnee = state.roadList.last.yValue;

    int step;
    int start;
    int end;

    CaseModel? caseSearch;

    List<CaseModel> caseToTest = [];

    if (oldOrdonnee == newOrdonnee) {
      step = newAbscisse > oldAbscisse ? 1 : -1;
      start = oldAbscisse + step;
      end = newAbscisse;
    } else {
      step = newOrdonnee > oldOrdonnee ? 1 : -1;
      start = oldOrdonnee + step;
      end = newOrdonnee;
    }

    for (var i = start; step > 0 ? i <= end : i >= end; i += step) {
      if (oldOrdonnee == newOrdonnee) {
        caseSearch = getCaseByCoordinates(state, i, oldOrdonnee);
      } else {
        caseSearch = getCaseByCoordinates(state, oldAbscisse, i);
      }

      if (caseSearch != null) {
        caseToTest.add(caseSearch);
      }
    }
    return caseToTest;
  }

  (bool, CaseModel) _testWall(List<CaseModel> allPathCases, int directionMove) {
    final CaseModel firstCase = allPathCases[0];
    final CaseModel lastCase = allPathCases.last;

    for (final caseSearchWall in allPathCases) {
      if (caseSearchWall.yValue == firstCase.yValue) {
        if (caseSearchWall.wallV) {
          if (directionMove == 1 && caseSearchWall != lastCase) {
            return (true, caseSearchWall);
          }

          if (directionMove == -1 && caseSearchWall != firstCase) {
            return (true, caseSearchWall);
          }
        }
      } else {
        if (caseSearchWall.wallH) {
          if (directionMove == 1 && caseSearchWall != lastCase) {
            return (true, caseSearchWall);
          }

          if (directionMove == -1 && caseSearchWall != firstCase) {
            return (true, caseSearchWall);
          }
        }
      }
    }
    return (false, lastCase);
  }
}
