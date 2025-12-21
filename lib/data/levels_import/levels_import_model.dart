import 'package:flutter/foundation.dart';

class LevelsImport {
  final int levelId;
  final int size;
  final List<(int, int)> tagsList;
  final Set<(int, int)> wallH;
  final Set<(int, int)> wallV;

  LevelsImport({
    required this.levelId,
    required this.size,
    required this.tagsList,
    required this.wallH,
    required this.wallV,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelsImport &&
          runtimeType == other.runtimeType &&

          size == other.size &&
          listEquals(tagsList, other.tagsList) &&
          setEquals(wallH, other.wallH) &&
          setEquals(wallV, other.wallV);

@override
  int get hashCode => Object.hash(
    size,
    Object.hashAll(tagsList),
    Object.hashAll(wallH),
    Object.hashAll(wallV),
  );
}
