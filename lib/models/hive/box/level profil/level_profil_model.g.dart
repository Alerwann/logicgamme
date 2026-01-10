// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_profil_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelProfilModelAdapter extends TypeAdapter<LevelProfilModel> {
  @override
  final int typeId = 2;

  @override
  LevelProfilModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LevelProfilModel(
      levelId: fields[0] as int,
      bestTime: fields[1] as int,
      winWithHard: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LevelProfilModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.levelId)
      ..writeByte(1)
      ..write(obj.bestTime)
      ..writeByte(2)
      ..write(obj.winWithHard);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelProfilModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
