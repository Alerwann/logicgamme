// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameStateModelAdapter extends TypeAdapter<GameStateModel> {
  @override
  final int typeId = 2;

  @override
  GameStateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameStateModel(
      bestLevel: fields[0] as int,
      bonusDaily: fields[1] as int,
      gemeStock: fields[2] as int,
      freeHardBonus: fields[3] as bool,
      resetDate: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GameStateModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.bestLevel)
      ..writeByte(1)
      ..write(obj.bonusDaily)
      ..writeByte(2)
      ..write(obj.gemeStock)
      ..writeByte(3)
      ..write(obj.freeHardBonus)
      ..writeByte(4)
      ..write(obj.resetDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
