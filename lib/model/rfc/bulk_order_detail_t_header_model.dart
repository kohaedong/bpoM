/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/bulk_order_detail_t_header_model.dart
 * Created Date: 2022-07-21 14:49:46
 * Last Modified: 2022-07-21 15:29:12
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'bulk_order_detail_t_header_model.g.dart';

@JsonSerializable()
class BulkOrderDetailTHeaderModel {
  @JsonKey(name: 'MANDT')
  String? mandt;
  @JsonKey(name: 'ZREQNO')
  String? zreqno;
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
  @JsonKey(name: 'VDATU')
  String? vdatu;
  @JsonKey(name: 'REQNO')
  String? reqno;
  @JsonKey(name: 'ZDMSTATUS')
  String? zdmstatus;
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
  String? rezet;
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
  @JsonKey(name: 'SANUMNM')
  String? sanumnm;
  @JsonKey(name: 'KUNNR_NM')
  String? kunnrNm;
  @JsonKey(name: 'ZZKUNNR_END_NM')
  String? zzkunnrEndNm;
  @JsonKey(name: 'EMPNO')
  String? empno;
  @JsonKey(name: 'UMODE')
  String? umode;
  @JsonKey(name: 'ZSTATUS')
  String? zstatus;
  @JsonKey(name: 'ZSTATUS_NM')
  String? zstatusNm;
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
  @JsonKey(name: 'AUART')
  String? auart;
  @JsonKey(name: 'DDATE')
  String? ddate;
  @JsonKey(name: 'ZDMSTATUS_NM')
  String? zdmstatusNm;

  BulkOrderDetailTHeaderModel(
      this.aedat,
      this.aenam,
      this.aewid,
      this.aezet,
      this.auart,
      this.bstkd,
      this.bukrs,
      this.ddate,
      this.dptcd,
      this.empno,
      this.erdat,
      this.ernam,
      this.erwid,
      this.kunnr,
      this.kunnrNm,
      this.kunwe,
      this.loevm,
      this.loevmOr,
      this.mandt,
      this.mwsbpSum,
      this.netwrSum,
      this.orerr,
      this.orghk,
      this.pernr,
      this.pernrNm,
      this.reqno,
      this.rezet,
      this.sanum,
      this.sanumnm,
      this.slnum,
      this.spart,
      this.umode,
      this.vbeln,
      this.vdatu,
      this.vkgrp,
      this.vkgrpNm,
      this.vkorg,
      this.vtweg,
      this.waerk,
      this.xconf,
      this.xconfNm,
      this.zdmstatus,
      this.zdmstatusNm,
      this.zreqDate,
      this.zreqno,
      this.zstatus,
      this.zstatusNm,
      this.zzkunnrEnd,
      this.zzkunnrEndNm);
  factory BulkOrderDetailTHeaderModel.fromJson(Object? json) =>
      _$BulkOrderDetailTHeaderModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$BulkOrderDetailTHeaderModelToJson(this);
}
