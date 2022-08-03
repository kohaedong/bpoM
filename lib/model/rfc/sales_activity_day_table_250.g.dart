/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_day_table_250.g.dart
 * Created Date: 2022-08-03 13:00:53
 * Last Modified: 2022-08-03 13:10:55
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_activity_day_table_250.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesActivityDayTable250 _$SalesActivityDayTable250FromJson(
        Map<String, dynamic> json) =>
    SalesActivityDayTable250(
      json['ADATE'] as String?,
      json['ADDCAT'] as String?,
      json['AEDAT'] as String?,
      json['AENAM'] as String?,
      json['AEWID'] as String?,
      json['AEZET'] as String?,
      json['BUKRS'] as String?,
      json['BZACTNO'] as String?,
      json['DPTCD'] as String?,
      json['ERDAT'] as String?,
      json['ERNAM'] as String?,
      json['ERWID'] as String?,
      json['ERZET'] as String?,
      json['FADDCAT'] as String?,
      json['FZADDR'] as String?,
      json['ORGHK'] as String?,
      json['ORGHK_NM'] as String?,
      (json['RTN_DIST'] as num?)?.toDouble(),
      json['SADDCAT'] as String?,
      json['SANUM'] as String?,
      json['SANUM_NM'] as String?,
      json['SLNUM'] as String?,
      json['STAT'] as String?,
      json['SZADDR'] as String?,
      (json['TOT_DIST'] as num?)?.toDouble(),
      json['UMODE'] as String?,
      json['VKORG'] as String?,
      json['ZADDR'] as String?,
      json['ZADDR1'] as String?,
      json['ACCOMPANY'] as String?,
      json['FTIME'] as String?,
      (json['FX_LATITUDE'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      (json['FY_LONGITUDE'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      json['SCALL_TYPE'] as String?,
      json['STIME'] as String?,
      (json['SX_LATITUDE'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      (json['SY_LONGITUDE'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$SalesActivityDayTable250ToJson(
        SalesActivityDayTable250 instance) =>
    <String, dynamic>{
      'ADATE': instance.adate,
      'BZACTNO': instance.bzactno,
      'STAT': instance.stat,
      'ADDCAT': instance.addcat,
      'ZADDR': instance.zaddr,
      'SADDCAT': instance.saddcat,
      'SZADDR': instance.szaddr,
      'FADDCAT': instance.faddcat,
      'SX_LATITUDE': instance.sxLatitude,
      'SY_LONGITUDE': instance.sxLongitude,
      'STIME': instance.stime,
      'SCALL_TYPE': instance.scallType,
      'FX_LATITUDE': instance.fxLatitude,
      'FY_LONGITUDE': instance.fylongitude,
      'FTIME': instance.ftime,
      'FZADDR': instance.fzaddr,
      'ACCOMPANY': instance.accompany,
      'RTN_DIST': instance.rtnDist,
      'TOT_DIST': instance.totDist,
      'BUKRS': instance.bukrs,
      'VKORG': instance.vkorg,
      'DPTCD': instance.dptcd,
      'ORGHK': instance.orghk,
      'SANUM': instance.sanum,
      'SLNUM': instance.slnum,
      'ERDAT': instance.erdat,
      'ERZET': instance.erzet,
      'ERNAM': instance.ernam,
      'ERWID': instance.erwid,
      'AEDAT': instance.aedat,
      'AEZET': instance.aezet,
      'AENAM': instance.aenam,
      'AEWID': instance.aewid,
      'ORGHK_NM': instance.orghkNm,
      'SANUM_NM': instance.sanumNm,
      'ZADDR1': instance.zaddr1,
      'UMODE': instance.umode,
    };
