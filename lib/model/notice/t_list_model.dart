/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/salse_activity_result_model.dart
 * Created Date: 2022-07-07 09:29:23
 * Last Modified: 2022-11-09 13:32:37
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 't_list_model.g.dart';

@JsonSerializable()
class TlistModel {
  @JsonKey(name: 'BZACTNO')
  String? bzactno;
  @JsonKey(name: 'NAME')
  String? name;
  @JsonKey(name: 'SEQNO')
  String? seqno;
  @JsonKey(name: 'PVISIT')
  String? pvisit;
  @JsonKey(name: 'STPNO')
  String? stpno;
  @JsonKey(name: 'ADATE')
  String? adate;
  @JsonKey(name: 'ATIME')
  String? atime;
  @JsonKey(name: 'ZSTATUS')
  String? zstatus;
  @JsonKey(name: 'ZSKUNNR')
  String? zskunnr;
  @JsonKey(name: 'ZSKUNNR_NM')
  String? zskunnrNm;
  @JsonKey(name: 'ZKMNO')
  String? zkmno;
  @JsonKey(name: 'ZKMNO_NM')
  String? zkmnoNm;
  @JsonKey(name: 'ZADDR')
  String? zaddr;
  @JsonKey(name: 'DIST')
  double? dist;
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
  @JsonKey(name: 'ACTCAT1_NM')
  String? actcat1Nm;
  @JsonKey(name: 'ACTCAT2')
  String? actcat2;
  @JsonKey(name: 'SANUM')
  String? sanum;
  @JsonKey(name: 'ORGHK')
  String? orghk;
  @JsonKey(name: 'SANUM_NM')
  String? sanumNm;
  @JsonKey(name: 'ORGHK_NM')
  String? orghkNm;
  @JsonKey(name: 'STAT')
  String? stat;
  @JsonKey(name: 'ACT_DTL')
  String? actDtl;
  @JsonKey(name: 'RSLT')
  String? rslt;
  @JsonKey(name: 'XTARGET')
  String? xtarget;
  @JsonKey(name: 'COMNT')
  String? comnt;
  @JsonKey(name: 'SADDCAT')
  String? saddcat;
  @JsonKey(name: 'FADDCAT')
  String? faddcat;
  @JsonKey(name: 'SADDCAT_NM')
  String? saddcatNm;
  @JsonKey(name: 'FADDCAT_NM')
  String? faddcatNm;
  @JsonKey(name: 'ACT_FLAG')
  String? actFlag;
  @JsonKey(name: 'CFM_FLAG')
  String? cfmFlag;
  @JsonKey(name: 'PDESC')
  String? pdesc;
  @JsonKey(name: 'VKGRP')
  String? vkgrp;
  @JsonKey(name: 'ACCOMPANY')
  String? accompany;
  @JsonKey(name: 'ACCP_NM')
  String? accpNm;
  @JsonKey(name: 'MAKTX1')
  String? maktx1;
  @JsonKey(name: 'MAKTX2')
  String? maktx2;
  @JsonKey(name: 'MAKTX3')
  String? maktx3;
  @JsonKey(name: 'MATNR1')
  String? matnr1;
  @JsonKey(name: 'MATNR2')
  String? matnr2;
  @JsonKey(name: 'MATNR3')
  String? matnr3;
  @JsonKey(name: 'ZTREAT3')
  String? ztreat3;
  @JsonKey(name: 'ZTREAT3_NM')
  String? ztreat3Nm;
  @JsonKey(name: 'ZBIZ')
  String? zbiz;
  @JsonKey(name: 'MATKL')
  String? matkl;
  @JsonKey(name: 'MVGR1')
  String? mvgr1;
  @JsonKey(name: 'UMODE')
  String? umode;
  String? activityStatus;

  TlistModel(
      this.accompany,
      this.accpNm,
      this.actDtl,
      this.actFlag,
      this.actcat1,
      this.actcat1Nm,
      this.actcat2,
      this.adate,
      this.atime,
      this.bzactno,
      this.cfmFlag,
      this.comnt,
      this.pvisit,
      this.dist,
      this.faddcat,
      this.faddcatNm,
      this.maktx1,
      this.maktx2,
      this.name,
      this.maktx3,
      this.matkl,
      this.matnr1,
      this.matnr2,
      this.matnr3,
      this.meetRmk,
      this.mvgr1,
      this.orghk,
      this.orghkNm,
      this.pdesc,
      this.rslt,
      this.saddcat,
      this.saddcatNm,
      this.sanum,
      this.sanumNm,
      this.seqno,
      this.stat,
      this.stpno,
      this.umode,
      this.visitRmk,
      this.vkgrp,
      this.xmeet,
      this.xtarget,
      this.xvisit,
      this.zaddr,
      this.zbiz,
      this.zkmno,
      this.zkmnoNm,
      this.zskunnr,
      this.zskunnrNm,
      this.zstatus,
      this.ztreat3,
      this.activityStatus,
      this.ztreat3Nm);
  factory TlistModel.fromJson(Object? json) =>
      _$TlistModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$TlistModelToJson(this);
}
