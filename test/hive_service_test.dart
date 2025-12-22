import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:clean_temp/services/hive_service.dart';
import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/models/case/case_model.dart';

void main() {
  late HiveService hiveService;
  late Directory tempDir;

  setUp(() async {
 
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);


    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(LevelModelAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(CaseModelAdapter());

    await Hive.openBox<LevelModel>('levelsBox');

    hiveService = HiveService();
  });

  tearDown(() async {

    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('HiveService - initLevels', () {
    test('Doit charger les 5 premiers niveaux dans une box vide', () async {
      final levelsBox = Hive.box<LevelModel>('levelsBox');

      final result = hiveService.initLevels();

      expect(result.$1, isTrue);
      expect(levelsBox.length, 5);
      expect(levelsBox.get(0)?.levelId, 0);
    });
  });
}
