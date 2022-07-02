part of 'et_dd07v_customer_category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TCustomerCustomsModelAdapter extends TypeAdapter<TCustomerCustomsModel> {
  @override
  final int typeId = 3;

  @override
  TCustomerCustomsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TCustomerCustomsModel(
      fields[9] as String?,
      fields[6] as String?,
      fields[3] as String?,
      fields[1] as String?,
      fields[8] as String?,
      fields[7] as String?,
      fields[5] as String?,
      fields[4] as String?,
      fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TCustomerCustomsModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(1)
      ..write(obj.domname)
      ..writeByte(2)
      ..write(obj.valpos)
      ..writeByte(3)
      ..write(obj.dolanguage)
      ..writeByte(4)
      ..write(obj.domvalueL)
      ..writeByte(5)
      ..write(obj.domvalueH)
      ..writeByte(6)
      ..write(obj.ddtext)
      ..writeByte(7)
      ..write(obj.domvalLD)
      ..writeByte(8)
      ..write(obj.domvalHD)
      ..writeByte(9)
      ..write(obj.appval);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TCustomerCustomsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TCustomerCustomsModel _$TCustomerCustomsModelFromJson(
        Map<String, dynamic> json) =>
    TCustomerCustomsModel(
      json['APPVAL'] as String?,
      json['DDTEXT'] as String?,
      json['DDLANGUAGE'] as String?,
      json['DOMNAME'] as String?,
      json['DOMVAL_HD'] as String?,
      json['DOMVAL_LD'] as String?,
      json['DOMVALUE_H'] as String?,
      json['DOMVALUE_L'] as String?,
      json['VALPOS'] as String?,
    );

Map<String, dynamic> _$TCustomerCustomsModelToJson(
        TCustomerCustomsModel instance) =>
    <String, dynamic>{
      'DOMNAME': instance.domname,
      'VALPOS': instance.valpos,
      'DDLANGUAGE': instance.dolanguage,
      'DOMVALUE_L': instance.domvalueL,
      'DOMVALUE_H': instance.domvalueH,
      'DDTEXT': instance.ddtext,
      'DOMVAL_LD': instance.domvalLD,
      'DOMVAL_HD': instance.domvalHD,
      'APPVAL': instance.appval,
    };
