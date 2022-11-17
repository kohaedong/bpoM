// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_activity_key_man_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddActivityKeyManModel _$AddActivityKeyManModelFromJson(
        Map<String, dynamic> json) =>
    AddActivityKeyManModel(
      telf2: json['TELF2'] as String?,
      xrepkm: json['XREPKM'] as String?,
      zTraitment: json['ZTRAITMENT'] as String?,
      zaddName1: json['ZADD_NAME1'] as String?,
      zaddName2: json['ZADD_NAME2'] as String?,
      zeMail: json['ZEMAIL'] as String?,
      zkmTrust: json['ZKMTRUST'] as String?,
      zkmType: json['ZKMTYPE'] as String?,
      zkmno: json['ZKMNO'] as String?,
      zkmnoNm: json['ZKMNO_NM'] as String?,
      zskunnr: json['ZSKUNNR'] as String?,
      zskunnrNm: json['ZSKUNNR_NM'] as String?,
    );

Map<String, dynamic> _$AddActivityKeyManModelToJson(
        AddActivityKeyManModel instance) =>
    <String, dynamic>{
      'ZSKUNNR': instance.zskunnr,
      'ZSKUNNR_NM': instance.zskunnrNm,
      'ZKMNO': instance.zkmno,
      'ZKMNO_NM': instance.zkmnoNm,
      'ZKMTRUST': instance.zkmTrust,
      'XREPKM': instance.xrepkm,
      'ZKMTYPE': instance.zkmType,
      'ZTRAITMENT': instance.zTraitment,
      'TELF2': instance.telf2,
      'ZEMAIL': instance.zeMail,
      'ZADD_NAME1': instance.zaddName1,
      'ZADD_NAME2': instance.zaddName2,
    };
