// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoneyModelAdapter extends TypeAdapter<MoneyModel> {
  @override
  final int typeId = 2;

  @override
  MoneyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoneyModel(
      bestLevel: fields[0] as int,
      bonusDaily: fields[1] as int,
      gemeStock: fields[2] as int,
      freeHardBonus: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MoneyModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.bestLevel)
      ..writeByte(1)
      ..write(obj.bonusDaily)
      ..writeByte(2)
      ..write(obj.gemeStock)
      ..writeByte(3)
      ..write(obj.freeHardBonus);
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
