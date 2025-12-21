import 'package:clean_temp/data/levels_import/levels_import_model.dart';

class AllLevel {
  static final List<LevelsImport> _defaultList = [
    LevelsImport(
      levelId: 0,
      size: 6,
      tagsList: [(0, 0), (4, 4)],
      wallH: {},
      wallV: {},
    ),
    LevelsImport(
      levelId: 1,
      size: 6,
      tagsList: [
        (0, 0),
        (0, 5),
        (5, 5),
        (5, 0),
        (1, 0),
        (1, 4),
        (4, 4),
        (4, 1),
        (2, 2),
        (2, 3),
        (3, 2),
      ],
      wallH: {},
      wallV: {},
    ),
    LevelsImport(
      levelId: 2,
      size: 6,
      tagsList: [(2, 2), (1, 1), (5, 0), (3, 1), (3, 3), (0, 3), (4, 3)],
      wallH: {},
      wallV: {},
    ),

    LevelsImport(
      levelId: 3,
      size: 6,
      tagsList: [(5, 5), (0, 2), (2, 0), (3, 2), (5, 2), (1, 3), (5, 4)],
      wallH: {},
      wallV: {},
    ),

    LevelsImport(
      levelId: 4,
      size: 6,
      tagsList: [(2, 1), (0, 0), (5, 0), (4, 3), (0, 5), (3, 1)],
      wallH: {},
      wallV: {},
    ),

    LevelsImport(
      levelId: 5,
      size: 6,
      tagsList: [(0, 5), (0, 3), (2, 3), (1, 1), (3, 4), (4, 3), (5, 1)],
      wallH: {(0, 4), (1, 4), (5, 3)},
      wallV: {(2, 4), (3, 4), (4, 1)},
    ),
  ];

  static List<LevelsImport> getDefaultList() {
    
    return List.from( _defaultList);
  }
}
