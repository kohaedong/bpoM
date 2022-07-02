// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_values_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TValuesModelAdapter extends TypeAdapter<TValuesModel> {
  @override
  final int typeId = 2;

  @override
  TValuesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TValuesModel(
      tname: fields[1] as String?,
      helpValues: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TValuesModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.tname)
      ..writeByte(2)
      ..write(obj.helpValues);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TValuesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TValuesModel _$TValuesModelFromJson(Map<String, dynamic> json) => TValuesModel(
      tname: json['T_NAME'] as String?,
      helpValues: json['HELPVALUES'] as String?,
    );

Map<String, dynamic> _$TValuesModelToJson(TValuesModel instance) =>
    <String, dynamic>{
      'T_NAME': instance.tname,
      'HELPVALUES': instance.helpValues,
    };
