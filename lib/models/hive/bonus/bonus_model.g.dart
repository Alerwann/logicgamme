// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bonus_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BonusModelAdapter extends TypeAdapter<BonusModel> {
  @override
  final int typeId = 3;

  @override
  BonusModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BonusModel(
      nameBonus: fields[0] as TypeBonus,
      costForBuy: fields[1] as int,
      quantity: fields[2] as int,
      gain: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BonusModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nameBonus)
      ..writeByte(1)
      ..write(obj.costForBuy)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.gain);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BonusModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
