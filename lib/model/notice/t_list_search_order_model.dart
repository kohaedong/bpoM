/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/t_list_search_order_model.dart
 * Created Date: 2022-07-11 12:35:31
 * Last Modified: 2022-07-14 12:45:56
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 't_list_search_order_model.g.dart';

@JsonSerializable()
class TlistSearchOrderModel {
  @JsonKey(name: 'ZREQNO')
  String? zreqno;
  @JsonKey(name: 'VBELN')
  String? vbeln;
  @JsonKey(name: 'POSNR')
  String? posnr;
  @JsonKey(name: 'ZREQ_DATE')
  String? zreqDate;
  @JsonKey(name: 'ZSTATUS')
  String? zstatus;
  @JsonKey(name: 'ZSTATUS_NM')
  String? zstatusNm;
  @JsonKey(name: 'KUNNR')
  String? kunnr;
  @JsonKey(name: 'KUNNR_NM')
  String? kunnrNm;
  @JsonKey(name: 'ZZKUNNR_END')
  String? zzkunnrEnd;
  @JsonKey(name: 'ZZKUNNR_END_NM')
  String? zzkunnrEndNm;
  @JsonKey(name: 'MATNR')
  String? matnr;
  @JsonKey(name: 'MAKTX')
  String? maktx;
  @JsonKey(name: 'KWMENG')
  double? kwmeng;
  @JsonKey(name: 'ZNETPR')
  double? znetpr;
  @JsonKey(name: 'ZDIS_RATE')
  double? zdisRate;
  @JsonKey(name: 'NETPR')
  double? netpr;
  @JsonKey(name: 'ZDIS_PRICE')
  double? zdisPrice;
  @JsonKey(name: 'ZFREE_QTY')
  double? zfreeQty;
  @JsonKey(name: 'ZFREE_QTY_IN')
  double? zfreeQtyIn;
  @JsonKey(name: 'VRKME')
  String? vrkme;
  @JsonKey(name: 'NETWR')
  double? netwr;
  @JsonKey(name: 'MWSBP')
  double? mwsbp;
  @JsonKey(name: 'WAERK')
  String? waerk;
  @JsonKey(name: 'SPART')
  String? spart;
  @JsonKey(name: 'MATKL')
  String? matkl;
  @JsonKey(name: 'ORGHK')
  String? orghk;
  @JsonKey(name: 'ORGHK_NM')
  String? orghkNm;
  @JsonKey(name: 'PERNR')
  String? pernr;
  @JsonKey(name: 'SNAME')
  String? sname;
  @JsonKey(name: 'ZMESSAGE')
  String? zmessage;
  @JsonKey(name: 'VKGRP')
  String? vkgrp;
  @JsonKey(name: 'VKGRP_NM')
  String? vkgrpNm;
  @JsonKey(name: 'ZREQMSG')
  String? zreqmsg;
  @JsonKey(name: 'ZFREE')
  String? zfree;

  TlistSearchOrderModel(
      this.kunnr,
      this.kunnrNm,
      this.kwmeng,
      this.maktx,
      this.matkl,
      this.matnr,
      this.mwsbp,
      this.netpr,
      this.netwr,
      this.orghk,
      this.orghkNm,
      this.pernr,
      this.posnr,
      this.sname,
      this.spart,
      this.vbeln,
      this.vkgrp,
      this.vkgrpNm,
      this.vrkme,
      this.waerk,
      this.zdisPrice,
      this.zdisRate,
      this.zfree,
      this.zfreeQty,
      this.zmessage,
      this.znetpr,
      this.zreqDate,
      this.zreqmsg,
      this.zreqno,
      this.zstatus,
      this.zstatusNm,
      this.zzkunnrEnd,
      this.zzkunnrEndNm,
      this.zfreeQtyIn);
  factory TlistSearchOrderModel.fromJson(Object? json) =>
      _$TlistSearchOrderModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$TlistSearchOrderModelToJson(this);
}
