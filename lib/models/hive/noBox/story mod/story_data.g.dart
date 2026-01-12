// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoryDataAdapter extends TypeAdapter<StoryData> {
  @override
  final int typeId = 13;

  @override
  StoryData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoryData(
      enigme: fields[0] as String,
      solution: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StoryData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.enigme)
      ..writeByte(1)
      ..write(obj.solution);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
