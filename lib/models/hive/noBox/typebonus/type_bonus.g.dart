// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type_bonus.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TypeBonusAdapter extends TypeAdapter<TypeBonus> {
  @override
  final int typeId = 12;

  @override
  TypeBonus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TypeBonus.bonusTime;
      case 1:
        return TypeBonus.bonusDifficulty;
      default:
        return TypeBonus.bonusTime;
    }
  }

  @override
  void write(BinaryWriter writer, TypeBonus obj) {
    switch (obj) {
      case TypeBonus.bonusTime:
        writer.writeByte(0);
        break;
      case TypeBonus.bonusDifficulty:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeBonusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
