import 'package:clean_temp/data/enum.dart';
import 'package:clean_temp/models/case/case_model.dart';
import 'package:clean_temp/models/data_for_painting.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/models/session_state.dart';

/// Service de gestion et vérification des mouvements pendant le jeu

class MoveManagerService {


  /// fonciton d'entrée de mouvement
  ///
  /// A chaque tentative de mouvement cette fonction est appelée
  /// C'est cette fonction qui ordonne dans l'ordre les testes à effectuer pour valider le mouvement
  ///
  /// Paramètre:
  ///   - [state] L'état actuel de la partie pour accéder aux chemins
  ///   - [newCase] la case sélectionner par le jouer
  ///
  /// Retourne un MoveResult :
  /// le statut d'aboutissement du mouvement , l'état modifié si réussite sinon l'état initial , la case qui a posé erreur si nécessaire
  MoveResult handleMove(SessionState state, CaseModel newCase) {
    final CaseModel lastCase = state.roadList.last;

    bool lastBaliseCheck = false;
    int currentTagIndex = state.lastTagSave;

    /// Si le joueur appuie sur une case déjà compté cela fait l'annulation du chemin
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
        statusCode: MoveStatusCode.success,
      );
    }

    /// Définition si le mouvement est horizontal ou vertical ou les deux et le sens du mouvement
    final directionData = testDirection(lastCase, newCase);

    /// retourne une erreur si le mouvement est en diagonal
    if (!directionData.ortho) {
      return MoveResult(
        sessionState: state,
        statusCode: MoveStatusCode.notOrthoError,
      );
    }

    final expectedLength = directionData.lengthRoad!;
    final direction = directionData.direction!;
    final typeMove = directionData.typeMove!;

    /// création de la liste des cases qui sont parcourus pendant le chemin
    final casesList = createListCasesTest(
      newCase,
      state.levelConfig,
      state.roadList,
      typeMove,
      direction,
    );

    /// si liste crée inférieur à la liste espérée -> problème de chargement
    if (casesList.length != expectedLength) {
      return MoveResult(
        sessionState: state,
        statusCode: MoveStatusCode.internalError,
      );
    }

    /// vérification que le nouveau chemin ne coupe pas l'ancien

    final resultAllreadyPass = testAlreadyPass(state.roadSet, casesList);

    if (resultAllreadyPass.$1) {
      return MoveResult(
        sessionState: state,
        statusCode: MoveStatusCode.otherError,
        errorCase: resultAllreadyPass.$2,
      );
    }

    /// Test si l'ordre des balises sont respectés
    final resultTagTest = testOderTag(state.lastTagSave, casesList);

    if (!resultTagTest.goodOrder) {
      return MoveResult(
        sessionState: state,
        statusCode: MoveStatusCode.otherError,
        errorCase: resultTagTest.errorCase,
      );
    }

    currentTagIndex = resultTagTest.lastTag;

    if (currentTagIndex == state.levelConfig.maxTag) {
      lastBaliseCheck = true;
    }

    //Test la présence de mur bloquant
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
      dataPainting: CoordForPainting(
        startCoord: (lastCase.xValue, lastCase.yValue),
        endCoord: (newCase.xValue, newCase.yValue),
      ),
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

  /// Fonction permettant d'obtenir le [CaseModel] d'une case à partir des coordonées
  ///
  /// Paramètre :
  /// [level] L'ensemble des informations du niveau joué
  /// [targetX] L'abscisse de la case
  /// [targetY] l'ordonnée de la case
  ///
  /// Retourne la case si elle a été trouvée
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

  /// Création de la liste du nouveau chemin
  ///
  /// Paramètres :
  /// [newCase] les données de la nouvelle case
  /// [level] les données du niveau
  /// [road] La liste du chemin pour savoir ou s'est arrêté le joueur avant
  /// [typeMove] savoir si le mouvement est vertical ou horizontal
  /// [direction] si gauche droite ou haut bas vaut 1 sinon vaut -1
  ///
  /// retourne une liste de case
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
        start = road.last.yValue + step;
        end = newCase.yValue;
        fixCoordonne = road.last.xValue;
        break;
      case TypeMove.horizontal:
        start = road.last.xValue + step;
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

  /// Fonction qui vérifie la présence de mur bloquant
  ///
  /// Un mur est considérer bloquant s'il est traversé par le chemin
  ///
  /// Paramètre:
  /// [allPathCases] ensemble des cases du chemin y compris la dernière case de roadList car peut avoir un mur bloquant
  /// [directionMove] sens du mouvement
  /// [typeMove] définit si mouvement vertical ou horizontal
  ///
  /// La première case est ignorée dans le cas ou direction est -1 car ne bloque jamais
  /// La Dernière case est ignorée dans le cas ou la direction est 1
  ///
  /// Retourne False et la dernière case de la liste si aucun mur
  /// Retourne True et la première case comprenant le mur si le mur est bloquant
  ///
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
        if (caseSearch.wallV != null && caseSearch != caseTonotVerif) {
          return (true, caseSearch);
        }
      }
    } else if (typeMove == TypeMove.vertical) {
      for (final caseSearch in allPathCases) {
        if (caseSearch.wallH != null && caseSearch != caseTonotVerif) {
          return (true, caseSearch);
        }
      }
    }

    return (false, allPathCases.last);
  }

  /// Fonction qui teste si le nouveau chemin coupe l'ancien
  ///
  /// Paramètre :
  /// [allCases] Le chemin déjà parcouru
  /// [newCasesList] Le chemin qui va être parcouru
  ///
  /// Retourne True et la case de la première intersection si les chemins se coupent
  /// Retourne False et la dernière case si aucune intersection
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

  /// Fonction qui teste la présence de balise et valide si elles suivent l'ordre
  ///
  /// Paramètre :
  /// [lastTagSave] le numéro de la dernière balise validée
  /// [newRoad] List des case qui vont etre parcourues par le nouveau chemin
  ///
  /// Retourne true, et le dernier tag à enregistrer si valide
  /// Retourne false, [lastTagSave] pour qu'il n'y ai pas de changement et la case qui à posé problème

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

  /// fonction qui vérifie l'orthogonalité et retourne le sens et la direction du mouvement
  ///
  /// [lastCase] Dernière case valide du chemin déjà parcouru
  /// [newCase] Case choisi par le joueur
  ///
  /// Retourne un bool qui est false si le chemin est en diagonale et true sinon
  /// Si l'orthogonalité est vérifiée retourne
  ///  - la longueur du chemin
  ///  - s'il est horizontal ou vertical
  ///  - la direction (1 si gauche-> Droite ou haut-> bas sinon -1 )

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

/// Retour normalisé pour les tag
class ResultOrderTag {
  /// l'ordre est repecté -> true sinon false
  final bool goodOrder;

  /// la valeur du dernier tag valide
  final int lastTag;

  /// le model de la case qui a causé l'erreur
  final CaseModel? errorCase;

  ResultOrderTag({
    required this.goodOrder,
    required this.lastTag,
    this.errorCase,
  });
}

/// Retour normalisé pour la direction
class ResultDirection {
  /// vrai si orthogonal sinon faux
  final bool ortho;

  /// Si ortho la longueur de la route
  final int? lengthRoad;

  /// si ortho la direction représenté par 1 ou -1
  final int? direction;

  /// Si le mouvement est vertical ou horizontal
  final TypeMove? typeMove;

  ResultDirection({
    required this.ortho,
    this.lengthRoad,
    this.direction,
    this.typeMove,
  });
}

/// Retour normalisé pour le mouvement

class MoveResult {
  /// Détail l'erreur ou le succès (cf enum pour plus d'info)
  final MoveStatusCode statusCode;

  /// Retourne l'état modifier si pas d'erreur sinon l'état original
  final SessionState sessionState;

  /// Retourne si nécessaire la casse qui a causé l'erreur
  final CaseModel? errorCase;

  MoveResult({
    required this.sessionState,
    required this.statusCode,
    this.errorCase,
  });
}
