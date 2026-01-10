import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:logic_game/models/hive/box/level/level_model.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);

    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(LevelModelAdapter());

    await Hive.openBox<LevelModel>('levelsBox');
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  // group('HiveService - initLevels', () {
  //   test('Doit charger les 5 premiers niveaux dans une box vide', () async {
  //     final levelsBox = Hive.box<LevelModel>('levelsBox');

  //     final result = hiveService.initLevels();

  //     expect(result.$1, isTrue);
  //     expect(levelsBox.length, 5);
  //     expect(levelsBox.get(0)?.levelId, 0);
  //   });
  // });
}
