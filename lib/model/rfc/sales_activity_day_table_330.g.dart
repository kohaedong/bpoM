// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_activity_day_table_330.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesActivityDayTable330 _$SalesActivityDayTable330FromJson(
        Map<String, dynamic> json) =>
    SalesActivityDayTable330(
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
      json['SEQNO'] as int?,
      json['SUBCAT'] as String?,
      json['UMODE'] as String?,
    );

Map<String, dynamic> _$SalesActivityDayTable330ToJson(
        SalesActivityDayTable330 instance) =>
    <String, dynamic>{
      'BZACTNO': instance.bzactno,
      'SEQNO': instance.seqno,
      'SUBCAT': instance.subcat,
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
