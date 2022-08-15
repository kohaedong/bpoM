// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_activity_key_man_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddActivityKeyManModel _$AddActivityKeyManModelFromJson(
        Map<String, dynamic> json) =>
    AddActivityKeyManModel(
      json['TELF2'] as String?,
      json['XREPKM'] as String?,
      json['ZTRAITMENT'] as String?,
      json['ZADD_NAME1'] as String?,
      json['ZADD_NAME2'] as String?,
      json['ZEMAIL'] as String?,
      json['ZKMTRUST'] as String?,
      json['ZKMTYPE'] as String?,
      json['ZKMNO'] as String?,
      json['ZKMNO_NM'] as String?,
      json['ZSKUNNR'] as String?,
      json['ZSKUNNR_NM'] as String?,
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
