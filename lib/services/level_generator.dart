import 'package:clean_temp/models/case/case_model.dart';

class LevelGenerator {
  static ({List<CaseModel> cases, CaseModel firstTagCase, int maxTag}) generateLevelComplet(
    dynamic leveljson,
  ) {
    final List<dynamic> balisesPoints =
        leveljson['balisesPoints'] as List<dynamic>;

    final int maxTag = balisesPoints.length;

    final Map<String, int> balisesMap = {
      for (final entry in balisesPoints.asMap().entries)
        '${entry.value[0]},${entry.value[1]}': entry.key + 1,
    };

    final List<dynamic> wallH = leveljson['wallH'] as List<dynamic>;
    final Set<String> mursHSet = (wallH as List<List<int>>).map((coords) {
      return '${coords[0]},${coords[1]}';
    }).toSet();

    final List<dynamic> wallV = leveljson['wallV'] as List<dynamic>;

    final Set<String> mursVSet = (wallV as List<List<int>>).map((coords) {
      return '${coords[0]},${coords[1]}';
    }).toSet();

    List<CaseModel> casesFinales = [];
    int tailleGrille = 6;

    // --- Démarrage de la Double Boucle ---
    for (int y = 0; y < tailleGrille; y++) {
      for (int x = 0; x < tailleGrille; x++) {
        String cle = '$x,$y';

        var wallH = false;
        var wallV = false;
        int? balise;

        if (mursHSet.contains(cle)) {
          wallH = true;
        }

        if (mursVSet.contains(cle)) {
          wallV = true;
        }

        if (balisesMap.containsKey(cle)) {
          // Récupérer le numéro de la balise
          balise = balisesMap[cle];
        }

        casesFinales.add(
          CaseModel(
            xValue: x,
            yValue: y,
            wallH: wallH,
            wallV: wallV,
            numberTag: balise,
          ),
        );
      }
    }
    final CaseModel firstCase = casesFinales.firstWhere(
      (c) => c.numberTag == 1,
      orElse: () => throw Exception("Balise de départ (Tag 1) non trouvée."),
    );

    return (cases: casesFinales, firstTagCase: firstCase, maxTag: maxTag);
  }
}
