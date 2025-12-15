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

    int step;
    int start;
    int end;

    CaseModel? caseSearch;

    List<CaseModel> caseToTest = [];

    if (oldAbscisse != newAbscisse && oldOrdonnee != newOrdonnee) {
      return MoveResult(
        sessionState: state,
        statusCode: MoveStatusCode.notOrthoError,
      );
    }

    if (oldOrdonnee == newOrdonnee) {
      step = newAbscisse > oldAbscisse ? 1 : -1;
      start = oldAbscisse + step;
      end = newAbscisse;
    } else {
      step = newOrdonnee > oldOrdonnee ? 1 : -1;
      start = oldOrdonnee + step;
      end = newOrdonnee;
    }

    for (var i = start ;step>0? i <= end : i>=end; i += step) {
      if (oldOrdonnee == newOrdonnee) {
        caseSearch = getCaseByCoordinates(state, i, oldOrdonnee);
      } else {
      caseSearch = getCaseByCoordinates(state, oldAbscisse, i);
      }
      
      
      
      if (caseSearch != null) {
        caseToTest.add(caseSearch);
      } else {
        return MoveResult(
          sessionState: state,
          statusCode: MoveStatusCode.internalError,
        );
      }
    }

    return MoveResult(sessionState: state, statusCode: MoveStatusCode.success);
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
}
