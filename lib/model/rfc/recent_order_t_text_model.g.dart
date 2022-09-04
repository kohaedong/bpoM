// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_order_t_text_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecentOrderTTextModel _$RecentOrderTTextModelFromJson(
        Map<String, dynamic> json) =>
    RecentOrderTTextModel(
      aedat: json['AEDAT'] as String?,
      aenam: json['AENAM'] as String?,
      aewid: json['AEWID'] as String?,
      aezet: json['AEZET'] as String?,
      cdgrp: json['CDGRP'] as String?,
      cditm: json['CDITM'] as String?,
      erdat: json['ERDAT'] as String?,
      ernam: json['ERNAM'] as String?,
      erwid: json['ERWID'] as String?,
      erzet: json['ERZET'] as String?,
      mandt: json['MANDT'] as String?,
      objnr: json['OBJNR'] as String?,
      rChk: json['rChk'] as String?,
      rSeq: json['rSeq'] as String?,
      rStatus: json['rStatus'] as String?,
      seqno: json['SEQNO'] as String?,
      umode: json['UMODE'] as String?,
      ztext: json['ZTEXT'] as String?,
    );

Map<String, dynamic> _$RecentOrderTTextModelToJson(
        RecentOrderTTextModel instance) =>
    <String, dynamic>{
      'MANDT': instance.mandt,
      'OBJNR': instance.objnr,
      'CDGRP': instance.cdgrp,
      'CDITM': instance.cditm,
      'SEQNO': instance.seqno,
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
      'rStatus': instance.rStatus,
      'rChk': instance.rChk,
      'rSeq': instance.rSeq,
    };
