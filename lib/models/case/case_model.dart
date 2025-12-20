import 'package:hive/hive.dart';

part 'case_model.g.dart';

@HiveType(typeId: 1)
class CaseModel extends HiveObject {
  @HiveField(0)
  final int xValue;
  @HiveField(1)
  final int yValue;
  @HiveField(2)
  //mur en dessous
  final bool wallH;
  @HiveField(3)
  //mur à droite
  final bool wallV;
  @HiveField(4)
  final int? numberTag;

  CaseModel({
    required this.xValue,
    required this.yValue,
    required this.wallH,
    required this.wallV,
    this.numberTag,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaseModel &&
          runtimeType == other.runtimeType &&
          xValue == other.xValue &&
          yValue == other.yValue &&
          wallH == other.wallH &&
          wallV == other.wallV &&
          numberTag == other.numberTag;

  @override
  int get hashCode =>
      xValue.hashCode ^
      yValue.hashCode ^
      wallH.hashCode ^
      wallV.hashCode ^
      numberTag.hashCode;
}
