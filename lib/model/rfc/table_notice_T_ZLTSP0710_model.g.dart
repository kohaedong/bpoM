// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_notice_T_ZLTSP0710_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableNoticeZLTSP0710Model _$TableNoticeZLTSP0710ModelFromJson(
        Map<String, dynamic> json) =>
    TableNoticeZLTSP0710Model(
      json['AEDAT'] as String?,
      json['AENAM'] as String?,
      json['AEWID'] as String?,
      json['AEZET'] as String?,
      json['ERNAM'] as String?,
      json['ERDAT'] as String?,
      json['ERWID'] as String?,
      json['ERZET'] as String?,
      json['FRMDT'] as String?,
      json['LVORM'] as String?,
      json['MANDT'] as String?,
      json['NTITLE'] as String?,
      json['NTYPE'] as String?,
      json['NOTICENO'] as String?,
      json['SANUM_NM'] as String?,
      json['TODT'] as String?,
    );

Map<String, dynamic> _$TableNoticeZLTSP0710ModelToJson(
        TableNoticeZLTSP0710Model instance) =>
    <String, dynamic>{
      'MANDT': instance.mandt,
      'NOTICENO': instance.noticeNo,
      'NTYPE': instance.nType,
      'FRMDT': instance.frmDt,
      'TODT': instance.toDt,
      'NTITLE': instance.nTitle,
      'LVORM': instance.lvorm,
      'ERDAT': instance.erdat,
      'ERZET': instance.erzet,
      'ERNAM': instance.erNam,
      'ERWID': instance.erwId,
      'AEDAT': instance.aedat,
      'AEZET': instance.aezet,
      'AENAM': instance.aenam,
      'AEWID': instance.aewId,
      'SANUM_NM': instance.sanumNm,
    };
