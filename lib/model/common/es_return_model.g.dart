// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'es_return_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EsReturnModel _$EsReturnModelFromJson(Map<String, dynamic> json) =>
    EsReturnModel(
      json['ARBGB'] as String?,
      json['MSGNR'] as String?,
      json['MTYPE'] as String?,
      json['MESSAGE'] as String?,
    );

Map<String, dynamic> _$EsReturnModelToJson(EsReturnModel instance) =>
    <String, dynamic>{
      'ARBGB': instance.arbgb,
      'MSGNR': instance.msgnr,
      'MTYPE': instance.mtype,
      'MESSAGE': instance.message,
    };
