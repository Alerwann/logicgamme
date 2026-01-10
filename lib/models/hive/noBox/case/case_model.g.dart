// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'case_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CaseModelAdapter extends TypeAdapter<CaseModel> {
  @override
  final int typeId = 10;

  @override
  CaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CaseModel(
      xValue: fields[0] as int,
      yValue: fields[1] as int,
      wallH: fields[2] as bool?,
      wallV: fields[3] as bool?,
      numberTag: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, CaseModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.xValue)
      ..writeByte(1)
      ..write(obj.yValue)
      ..writeByte(2)
      ..write(obj.wallH)
      ..writeByte(3)
      ..write(obj.wallV)
      ..writeByte(4)
      ..write(obj.numberTag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
