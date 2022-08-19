/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/add_activity_page_history_for_visit_model.dart
 * Created Date: 2022-08-19 23:17:19
 * Last Modified: 2022-08-19 23:38:34
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'visit_result_history_page_model.g.dart';

@JsonSerializable()
class VisitResultHistoryPageModel {
  @JsonKey(name: 'MANDT')
  String? mandt;
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
  @JsonKey(name: 'ZSTATUS')
  String? zstatus;
  @JsonKey(name: 'ZKMNO')
  String? zkmno;
  @JsonKey(name: 'ZKMTRUST')
  String? zkmtrust;
  @JsonKey(name: 'STPNO')
  String? stpno;
  @JsonKey(name: 'XVISIT')
  String? xvisit;
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
  @JsonKey(name: 'ZADDR')
  String? zaddr;
  @JsonKey(name: 'DIST')
  double? dist;
  @JsonKey(name: 'RSLT')
  String? rslt;
  @JsonKey(name: 'COMNT')
  String? comnt;
  @JsonKey(name: 'X_LATITUDE')
  double? xLatitude;
  @JsonKey(name: 'Y_LONGITUDE')
  double? yLongitude;
  @JsonKey(name: 'SMINUTE')
  String? sminute;
  @JsonKey(name: 'ACCOMPANY')
  String? accompany;
  @JsonKey(name: 'CALL_TYPE')
  String? callType;
  @JsonKey(name: 'PVISIT')
  String? pvisit;
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
  @JsonKey(name: 'ZKMNO_NM')
  String? zkmnoNm;

  VisitResultHistoryPageModel(
      this.accompany,
      this.actcat1,
      this.actcat2,
      this.actcat3,
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
      this.etime,
      this.mandt,
      this.meetRmk,
      this.pvisit,
      this.rslt,
      this.seqno,
      this.sminute,
      this.stpno,
      this.visitRmk,
      this.xLatitude,
      this.xmeet,
      this.xvisit,
      this.yLongitude,
      this.zaddr,
      this.zkmno,
      this.zkmnoNm,
      this.zkmtrust,
      this.zskunnr,
      this.zstatus);
  factory VisitResultHistoryPageModel.fromJson(Object? json) =>
      _$VisitResultHistoryPageModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$VisitResultHistoryPageModelToJson(this);
}
