/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/recent_order_head_model.dart
 * Created Date: 2022-09-04 16:18:47
 * Last Modified: 2022-09-05 10:42:30
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'recent_order_head_model.g.dart';

@JsonSerializable()
class RecentOrderHeadModel {
  @JsonKey(name: 'ZREQNO')
  String? zreqNo;
  @JsonKey(name: 'ZREQ_DATE')
  String? zreqDate;
  @JsonKey(name: 'VTWEG')
  String? vtweg;
  @JsonKey(name: 'SPART')
  String? spart;
  @JsonKey(name: 'VKGRP')
  String? vkgrp;
  @JsonKey(name: 'PERNR')
  String? pernr;
  @JsonKey(name: 'KUNNR')
  String? kunnr;
  @JsonKey(name: 'KUNWE')
  String? kunwe;
  @JsonKey(name: 'ZZKUNNR_END')
  String? zzkunnrEnd;
  @JsonKey(name: 'BSTKD')
  String? bstkd;
  @JsonKey(name: 'VBELN')
  String? vbeln;
  @JsonKey(name: 'LOEVM')
  String? loevm;
  @JsonKey(name: 'ORERR')
  String? orerr;
  @JsonKey(name: 'LOEVM_OR')
  String? loevmOr;
  @JsonKey(name: 'XCONF')
  String? xconf;
  @JsonKey(name: 'BUKRS')
  String? bukrs;
  @JsonKey(name: 'VKORG')
  String? vkorg;
  @JsonKey(name: 'DPTCD')
  String? dptcd;
  @JsonKey(name: 'ORGHK')
  String? orghk;
  @JsonKey(name: 'SANUM')
  String? sanum;
  @JsonKey(name: 'SLNUM')
  String? slnum;
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
  @JsonKey(name: 'AENAM')
  String? aenam;
  @JsonKey(name: 'AEWID')
  String? aewid;
  @JsonKey(name: 'SANUMNM')
  String? sanumnm;
  @JsonKey(name: 'KUNNR_NM')
  String? kunnrNm;
  @JsonKey(name: 'KUNWE_NM')
  String? kunweNm;
  @JsonKey(name: 'ZZKUNNR_END_NM')
  String? zzkunnrEndNm;
  @JsonKey(name: 'EMPNO')
  String? empno;
  @JsonKey(name: 'UMODE')
  String? umode;
  @JsonKey(name: 'ZSTATUS')
  String? zstatus;
  @JsonKey(name: 'PERNR_NM')
  String? pernrNm;
  @JsonKey(name: 'VKGRP_NM')
  String? vkgrpNm;
  @JsonKey(name: 'XCONF_NM')
  String? xconfNm;
  @JsonKey(name: 'NETWR_SUM')
  double? netwrSum;
  @JsonKey(name: 'MWSBP_SUM')
  double? mwsbpSum;
  @JsonKey(name: 'WAERK')
  String? waerk;

  RecentOrderHeadModel(
      {this.aedat,
      this.aenam,
      this.aewid,
      this.bstkd,
      this.bukrs,
      this.dptcd,
      this.empno,
      this.erdat,
      this.ernam,
      this.erwid,
      this.erzet,
      this.kunnr,
      this.kunnrNm,
      this.kunwe,
      this.kunweNm,
      this.loevm,
      this.loevmOr,
      this.mwsbpSum,
      this.netwrSum,
      this.orerr,
      this.orghk,
      this.pernr,
      this.pernrNm,
      this.sanum,
      this.sanumnm,
      this.slnum,
      this.spart,
      this.umode,
      this.vbeln,
      this.vkgrp,
      this.vkgrpNm,
      this.vkorg,
      this.vtweg,
      this.waerk,
      this.xconf,
      this.xconfNm,
      this.zreqDate,
      this.zreqNo,
      this.zstatus,
      this.zzkunnrEnd,
      this.zzkunnrEndNm});
  factory RecentOrderHeadModel.fromJson(Object? json) =>
      _$RecentOrderHeadModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$RecentOrderHeadModelToJson(this);
}
