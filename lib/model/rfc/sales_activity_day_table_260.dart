/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_day_table_260.dart
 * Created Date: 2022-08-03 10:06:46
 * Last Modified: 2022-08-03 13:37:02
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'sales_activity_day_table_260.g.dart';

@JsonSerializable()
class SalesActivityDayTable260 {
  @JsonKey(name: 'ADATE')
  String? adate;
  @JsonKey(name: 'BZACTNO')
  String? bzactno;
  @JsonKey(name: 'SEQNO')
  String? seqno;
  @JsonKey(name: 'ATIME')
  String? atime;
  @JsonKey(name: 'ETIME')
  String? etime;
  @JsonKey(name: 'ZSKUNNR')
  String? zskunnr;
  @JsonKey(name: 'ZKMNO')
  String? zkmno;
  @JsonKey(name: 'STPNO')
  String? stpno;
  @JsonKey(name: 'XVISIT')
  String? xvisit;
  @JsonKey(name: 'SMINUTE')
  String? sminute;
  @JsonKey(name: 'VISIT_RMK')
  String? visitRmk;
  @JsonKey(name: 'XMEET')
  String? xmeet;
  @JsonKey(name: 'MEET_RMK')
  String? meetRmk;
  @JsonKey(name: 'ACTCAT1')
  String? actcat1;
  @JsonKey(name: 'ACTCAT2')
  String? actcat2;
  @JsonKey(name: 'ACTCAT3')
  String? actcat3;
  @JsonKey(name: 'ACTCAT4')
  String? actcat4;
  @JsonKey(name: 'ZADDR')
  String? zaddr;
  @JsonKey(name: 'DIST')
  double? dist;
  @JsonKey(name: 'RSLT')
  String? rslt;
  @JsonKey(name: 'ERDAT')
  String? erdat;
  @JsonKey(name: 'ERZET')
  String? erzet;
  @JsonKey(name: 'ERNAM')
  String? ernam;
  @JsonKey(name: 'ERWID')
  String? erwid;
  @JsonKey(name: 'AEDAT')
  String? aedat;
  @JsonKey(name: 'AEZET')
  String? aezet;
  @JsonKey(name: 'AENAM')
  String? aenam;
  @JsonKey(name: 'AEWID')
  String? aewid;
  @JsonKey(name: 'X_LATITUDE')
  double? xLatitude;
  @JsonKey(name: 'Y_LONGITUDE')
  double? yLongitude;
  @JsonKey(name: 'ZSKUNNR_NM')
  String? zskunnrNm;
  @JsonKey(name: 'ACCOMPANY')
  String? accompany;
  @JsonKey(name: 'ZKMNO_NM')
  String? zkmnoNm;
  @JsonKey(name: 'ZADD_NAME1')
  String? zaddName1;
  @JsonKey(name: 'ZADD_NAME2')
  String? zaddName2;
  @JsonKey(name: 'ZADD_NAME3')
  String? zaddName3;
  @JsonKey(name: 'ZADD_NAME4')
  String? zaddName4;
  @JsonKey(name: 'ACTCAT')
  String? actcat;
  @JsonKey(name: 'COMNT')
  String? comnt;
  @JsonKey(name: 'COMNT_M')
  String? comntM;
  @JsonKey(name: 'IS_GPS')
  String? isGps;
  @JsonKey(name: 'ACCP_NM')
  String? accpNm;
  @JsonKey(name: 'ZSTATUS')
  String? zstatus;
  @JsonKey(name: 'CALL_TYPE')
  String? callType;
  @JsonKey(name: 'UMODE')
  String? umode;

  SalesActivityDayTable260(
      this.actcat,
      this.actcat1,
      this.actcat2,
      this.actcat3,
      this.actcat4,
      this.adate,
      this.aedat,
      this.aenam,
      this.aewid,
      this.aezet,
      this.atime,
      this.bzactno,
      this.callType,
      this.comnt,
      this.dist,
      this.erdat,
      this.ernam,
      this.erwid,
      this.erzet,
      this.meetRmk,
      this.rslt,
      this.seqno,
      this.stpno,
      this.umode,
      this.visitRmk,
      this.xmeet,
      this.xvisit,
      this.zaddName1,
      this.zaddName2,
      this.zaddName3,
      this.zaddName4,
      this.zaddr,
      this.zkmno,
      this.zkmnoNm,
      this.zskunnr,
      this.zskunnrNm,
      this.zstatus,
      this.accompany,
      this.accpNm,
      this.comntM,
      this.etime,
      this.isGps,
      this.xLatitude,
      this.yLongitude,
      this.sminute);
  factory SalesActivityDayTable260.fromJson(Object? json) =>
      _$SalesActivityDayTable260FromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalesActivityDayTable260ToJson(this);
}
