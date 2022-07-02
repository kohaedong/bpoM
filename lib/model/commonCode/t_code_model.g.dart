// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_code_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TCodeModelAdapter extends TypeAdapter<TCodeModel> {
  @override
  final int typeId = 1;

  @override
  TCodeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TCodeModel(
      mandt: fields[1] as String?,
      spras: fields[2] as String?,
      cdcls: fields[3] as String?,
      cdgrp: fields[4] as String?,
      cditm: fields[5] as String?,
      sortf: fields[6] as String?,
      cdnam: fields[7] as String?,
      desc3: fields[8] as String?,
      lvorm: fields[9] as String?,
      erdat: fields[10] as String?,
      erzet: fields[11] as String?,
      ernam: fields[12] as String?,
      erwid: fields[13] as String?,
      aedat: fields[14] as String?,
      aezet: fields[15] as String?,
      aewid: fields[16] as String?,
      rstatus: fields[17] as String?,
      rchk: fields[18] as String?,
      rseq: fields[19] as String?,
      timestamp: fields[20] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TCodeModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(1)
      ..write(obj.mandt)
      ..writeByte(2)
      ..write(obj.spras)
      ..writeByte(3)
      ..write(obj.cdcls)
      ..writeByte(4)
      ..write(obj.cdgrp)
      ..writeByte(5)
      ..write(obj.cditm)
      ..writeByte(6)
      ..write(obj.sortf)
      ..writeByte(7)
      ..write(obj.cdnam)
      ..writeByte(8)
      ..write(obj.desc3)
      ..writeByte(9)
      ..write(obj.lvorm)
      ..writeByte(10)
      ..write(obj.erdat)
      ..writeByte(11)
      ..write(obj.erzet)
      ..writeByte(12)
      ..write(obj.ernam)
      ..writeByte(13)
      ..write(obj.erwid)
      ..writeByte(14)
      ..write(obj.aedat)
      ..writeByte(15)
      ..write(obj.aezet)
      ..writeByte(16)
      ..write(obj.aewid)
      ..writeByte(17)
      ..write(obj.rstatus)
      ..writeByte(18)
      ..write(obj.rchk)
      ..writeByte(19)
      ..write(obj.rseq)
      ..writeByte(20)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TCodeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TCodeModel _$TCodeModelFromJson(Map<String, dynamic> json) => TCodeModel(
      mandt: json['MANDT'] as String?,
      spras: json['SPRAS'] as String?,
      cdcls: json['CDCLS'] as String?,
      cdgrp: json['CDGRP'] as String?,
      cditm: json['CDITM'] as String?,
      sortf: json['SORTF'] as String?,
      cdnam: json['CDNAM'] as String?,
      desc3: json['DESC3'] as String?,
      lvorm: json['LVORM'] as String?,
      erdat: json['ERDAT'] as String?,
      erzet: json['ERZET'] as String?,
      ernam: json['ERNAM'] as String?,
      erwid: json['ERWID'] as String?,
      aedat: json['AEDAT'] as String?,
      aezet: json['AEZET'] as String?,
      aewid: json['AEWID'] as String?,
      rstatus: json['rStatus'] as String?,
      rchk: json['rChk'] as String?,
      rseq: json['rSeq'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$TCodeModelToJson(TCodeModel instance) =>
    <String, dynamic>{
      'MANDT': instance.mandt,
      'SPRAS': instance.spras,
      'CDCLS': instance.cdcls,
      'CDGRP': instance.cdgrp,
      'CDITM': instance.cditm,
      'SORTF': instance.sortf,
      'CDNAM': instance.cdnam,
      'DESC3': instance.desc3,
      'LVORM': instance.lvorm,
      'ERDAT': instance.erdat,
      'ERZET': instance.erzet,
      'ERNAM': instance.ernam,
      'ERWID': instance.erwid,
      'AEDAT': instance.aedat,
      'AEZET': instance.aezet,
      'AEWID': instance.aewid,
      'rStatus': instance.rstatus,
      'rChk': instance.rchk,
      'rSeq': instance.rseq,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
