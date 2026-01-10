// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoneyModelAdapter extends TypeAdapter<MoneyModel> {
  @override
  final int typeId = 0;

  @override
  MoneyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoneyModel(
      bestLevel: fields[0] as int,
      gemeStock: fields[1] as int,
      timeBonus: fields[2] as BonusModel,
      difficultyBonus: fields[3] as BonusModel,
      canUseBonusTime: fields[4] as bool,
      canUseBonusDifficulty: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MoneyModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.bestLevel)
      ..writeByte(1)
      ..write(obj.gemeStock)
      ..writeByte(2)
      ..write(obj.timeBonus)
      ..writeByte(3)
      ..write(obj.difficultyBonus)
      ..writeByte(4)
      ..write(obj.canUseBonusTime)
      ..writeByte(5)
      ..write(obj.canUseBonusDifficulty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoneyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
