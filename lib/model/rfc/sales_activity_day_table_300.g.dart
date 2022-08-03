// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_activity_day_table_300.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesActivityDayTable300 _$SalesActivityDayTable300FromJson(
        Map<String, dynamic> json) =>
    SalesActivityDayTable300(
      json['AEDAT'] as String?,
      json['AENAM'] as String?,
      json['AEWID'] as String?,
      json['AEZET'] as String?,
      json['BZACTNO'] as String?,
      json['DESC_DTL1'] as String?,
      json['DESC_DTL2'] as String?,
      json['ERDAT'] as String?,
      json['ERNAM'] as String?,
      json['ERWID'] as String?,
      json['ERZET'] as String?,
      json['SEQNO'] as int?,
      json['UMODE'] as String?,
    );

Map<String, dynamic> _$SalesActivityDayTable300ToJson(
        SalesActivityDayTable300 instance) =>
    <String, dynamic>{
      'BZACTNO': instance.bzactno,
      'SEQNO': instance.seqno,
      'DESC_DTL1': instance.descDtl1,
      'DESC_DTL2': instance.descDtl2,
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
