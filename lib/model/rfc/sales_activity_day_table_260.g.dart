/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_day_table_260.g.dart
 * Created Date: 2022-08-03 13:11:14
 * Last Modified: 2022-08-03 13:11:24
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_activity_day_table_260.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesActivityDayTable260 _$SalesActivityDayTable260FromJson(
        Map<String, dynamic> json) =>
    SalesActivityDayTable260(
      json['ACTCAT'] as String?,
      json['ACTCAT1'] as String?,
      json['ACTCAT2'] as String?,
      json['ACTCAT3'] as String?,
      json['ACTCAT4'] as String?,
      json['ADATE'] as String?,
      json['AEDAT'] as String?,
      json['AENAM'] as String?,
      json['AEWID'] as String?,
      json['AEZET'] as String?,
      json['ATIME'] as String?,
      json['BZACTNO'] as String?,
      json['CALL_TYPE'] as String?,
      json['COMNT'] as String?,
      json['DIST'] as String?,
      json['ERDAT'] as String?,
      json['ERNAM'] as String?,
      json['ERWID'] as String?,
      json['ERZET'] as String?,
      json['MEET_RMK'] as String?,
      json['RSLT'] as String?,
      json['SEQNO'] as int?,
      json['STPNO'] as String?,
      json['UMODE'] as String?,
      json['VISIT_RMK'] as String?,
      json['XMEET'] as String?,
      json['XVISIT'] as String?,
      json['ZADD_NAME1'] as String?,
      json['ZADD_NAME2'] as String?,
      json['ZADD_NAME3'] as String?,
      json['ZADD_NAME4'] as String?,
      json['ZADDR'] as String?,
      json['ZKMNO'] as String?,
      json['ZKMNO_NM'] as String?,
      json['ZSKUNNR'] as String?,
      json['ZSKUNNR_NM'] as String?,
      json['ZSTATUS'] as String?,
      json['ACCOMPANY'] as String?,
      json['ACCP_NM'] as String?,
      json['COMNT_M'] as String?,
      json['ETIME'] as String?,
      json['IS_GPS'] as String?,
      (json['X_LATITUDE'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      (json['Y_LONGITUDE'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      json['SMINUTE'] as int?,
    );

Map<String, dynamic> _$SalesActivityDayTable260ToJson(
        SalesActivityDayTable260 instance) =>
    <String, dynamic>{
      'ADATE': instance.adate,
      'BZACTNO': instance.bzactno,
      'SEQNO': instance.seqno,
      'ATIME': instance.atime,
      'ETIME': instance.etime,
      'ZSKUNNR': instance.zskunnr,
      'ZKMNO': instance.zkmno,
      'STPNO': instance.stpno,
      'XVISIT': instance.xvisit,
      'SMINUTE': instance.sminute,
      'VISIT_RMK': instance.visitRmk,
      'XMEET': instance.xmeet,
      'MEET_RMK': instance.meetRmk,
      'ACTCAT1': instance.actcat1,
      'ACTCAT2': instance.actcat2,
      'ACTCAT3': instance.actcat3,
      'ACTCAT4': instance.actcat4,
      'ZADDR': instance.zaddr,
      'DIST': instance.dist,
      'RSLT': instance.rslt,
      'ERDAT': instance.erdat,
      'ERZET': instance.erzet,
      'ERNAM': instance.ernam,
      'ERWID': instance.erwid,
      'AEDAT': instance.aedat,
      'AEZET': instance.aezet,
      'AENAM': instance.aenam,
      'AEWID': instance.aewid,
      'X_LATITUDE': instance.xLatitude,
      'Y_LONGITUDE': instance.yLongitude,
      'ZSKUNNR_NM': instance.zskunnrNm,
      'ACCOMPANY': instance.accompany,
      'ZKMNO_NM': instance.zkmnoNm,
      'ZADD_NAME1': instance.zaddName1,
      'ZADD_NAME2': instance.zaddName2,
      'ZADD_NAME3': instance.zaddName3,
      'ZADD_NAME4': instance.zaddName4,
      'ACTCAT': instance.actcat,
      'COMNT': instance.comnt,
      'COMNT_M': instance.comntM,
      'IS_GPS': instance.isGps,
      'ACCP_NM': instance.accpNm,
      'ZSTATUS': instance.zstatus,
      'CALL_TYPE': instance.callType,
      'UMODE': instance.umode,
    };
