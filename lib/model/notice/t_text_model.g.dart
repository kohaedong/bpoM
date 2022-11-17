// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_text_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TTextModel _$TTextModelFromJson(Map<String, dynamic> json) => TTextModel(
      json['AEDAT'] as String?,
      json['AENAM'] as String?,
      json['AEWID'] as String?,
      json['AEZET'] as String?,
      json['CDGRP'] as String?,
      json['CDITM'] as String?,
      json['ERDAT'] as String?,
      json['ERNAM'] as String?,
      json['ERWID'] as String?,
      json['ERZET'] as String?,
      json['MANDT'] as String?,
      json['OBJNR'] as String?,
      json['SEQNO'] as String?,
      json['UMODE'] as String?,
      json['ZTEXT'] as String?,
    );

Map<String, dynamic> _$TTextModelToJson(TTextModel instance) =>
    <String, dynamic>{
      'MANDT': instance.mandt,
      'OBJNR': instance.objnr,
      'CDGRP': instance.cdgrp,
      'CDITM': instance.cditm,
      'SEQNO': instance.seqNo,
      'ZTEXT': instance.ztext,
      'ERDAT': instance.erdat,
      'ERZET': instance.erzet,
      'ERNAM': instance.ernam,
      'ERWID': instance.erwid,
      'AEDAT': instance.aedat,
      'AEZET': instance.aezet,
      'AENAM': instance.aenam,
      'AEWID': instance.aewid,
      'UMODE': instance.umode,
    };
