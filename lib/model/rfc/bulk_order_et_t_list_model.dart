/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/et_t_list_bulk_order_model.dart
 * Created Date: 2022-07-17 21:31:23
 * Last Modified: 2022-07-17 21:41:11
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'bulk_order_et_t_list_model.g.dart';

@JsonSerializable()
class BulkOrderEtTListModel {
  @JsonKey(name: 'ZREQNO')
  String? zreqno;
  @JsonKey(name: 'ZREQ_DATE')
  String? zreqDate;
  @JsonKey(name: 'VBELN')
  String? vbeln;
  @JsonKey(name: 'VKGRP')
  String? vkgrp;
  @JsonKey(name: 'PERNR')
  String? pernr;
  @JsonKey(name: 'EMPNO')
  String? empno;
  @JsonKey(name: 'SPART')
  String? spart;
  @JsonKey(name: 'KUNNR')
  String? kunnr;
  @JsonKey(name: 'ZZKUNNR_END')
  String? zzkunnrEnd;
  @JsonKey(name: 'KUNNR_NM')
  String? kunnrNm;
  @JsonKey(name: 'ZZKUNNR_END_NM')
  String? zzkunnrEndNm;
  @JsonKey(name: 'PERNR_NM')
  String? pernrNm;
  @JsonKey(name: 'VKGRP_NM')
  String? vkgrpNm;
  @JsonKey(name: 'ZDMSTATUS')
  String? zdmstatus;
  @JsonKey(name: 'WADAT_IST')
  String? wadatIst;
  @JsonKey(name: 'CDATE')
  String? cdate;
  BulkOrderEtTListModel(
      this.cdate,
      this.empno,
      this.kunnr,
      this.kunnrNm,
      this.pernr,
      this.pernrNm,
      this.spart,
      this.vbeln,
      this.vkgrp,
      this.vkgrpNm,
      this.wadatIst,
      this.zdmstatus,
      this.zreqDate,
      this.zreqno,
      this.zzkunnrEnd,
      this.zzkunnrEndNm);
  factory BulkOrderEtTListModel.fromJson(Object? json) =>
      _$BulkOrderEtTListModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$BulkOrderEtTListModelToJson(this);
}
