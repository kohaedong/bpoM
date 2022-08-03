// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_activity_day_table_320.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesActivityDayTable320 _$SalesActivityDayTable320FromJson(
        Map<String, dynamic> json) =>
    SalesActivityDayTable320(
      json['AEDAT'] as String?,
      json['AENAM'] as String?,
      json['AEWID'] as String?,
      json['AEZET'] as String?,
      json['BZACTNO'] as String?,
      json['DESC_DTL'] as String?,
      json['ERDAT'] as String?,
      json['ERNAM'] as String?,
      json['ERWID'] as String?,
      json['ERZET'] as String?,
      json['SEQNO'] as String?,
      json['UMODE'] as String?,
    );

Map<String, dynamic> _$SalesActivityDayTable320ToJson(
        SalesActivityDayTable320 instance) =>
    <String, dynamic>{
      'BZACTNO': instance.bzactno,
      'SEQNO': instance.seqno,
      'DESC_DTL': instance.descDtl,
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
