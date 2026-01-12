// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelModelAdapter extends TypeAdapter<LevelModel> {
  @override
  final int typeId = 1;

  @override
  LevelModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LevelModel(
      levelId: fields[0] as int,
      cases: (fields[1] as List).cast<CaseModel>(),
      firstCase: fields[2] as CaseModel,
      maxTag: fields[3] as int,
      size: fields[4] as int,
      storyData: fields[5] as StoryData,
    );
  }

  @override
  void write(BinaryWriter writer, LevelModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.levelId)
      ..writeByte(1)
      ..write(obj.cases)
      ..writeByte(2)
      ..write(obj.firstCase)
      ..writeByte(3)
      ..write(obj.maxTag)
      ..writeByte(4)
      ..write(obj.size)
      ..writeByte(5)
      ..write(obj.storyData);
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
