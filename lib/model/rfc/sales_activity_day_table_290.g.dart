// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_activity_day_table_290.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesActivityDayTable290 _$SalesActivityDayTable290FromJson(
        Map<String, dynamic> json) =>
    SalesActivityDayTable290(
      aedat: json['AEDAT'] as String?,
      aenam: json['AENAM'] as String?,
      aewid: json['AEWID'] as String?,
      aezet: json['AEZET'] as String?,
      bzactno: json['BZACTNO'] as String?,
      descDtl: json['DESC_DTL'] as String?,
      erdat: json['ERDAT'] as String?,
      ernam: json['ERNAM'] as String?,
      erwid: json['ERWID'] as String?,
      erzet: json['ERZET'] as String?,
      seqno: json['SEQNO'] as String?,
      subcat: json['SUBCAT'] as String?,
      umode: json['UMODE'] as String?,
    );

Map<String, dynamic> _$SalesActivityDayTable290ToJson(
        SalesActivityDayTable290 instance) =>
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
