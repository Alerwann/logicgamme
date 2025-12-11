// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelModelAdapter extends TypeAdapter<LevelModel> {
  @override
  final int typeId = 3;

  @override
  LevelModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LevelModel(
      levelId: fields[0] as int,
      cases: (fields[1] as List).cast<CaseModel>(),
      bestRecordNormalSeconds: fields[2] as int,
      hardDifficulty: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LevelModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.levelId)
      ..writeByte(1)
      ..write(obj.cases)
      ..writeByte(2)
      ..write(obj.bestRecordNormalSeconds)
      ..writeByte(3)
      ..write(obj.hardDifficulty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
