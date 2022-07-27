/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/bulk_order_detail_t_item_model.dart
 * Created Date: 2022-07-21 15:02:24
 * Last Modified: 2022-07-27 10:15:24
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';

part 'bulk_order_detail_t_item_model.g.dart';

@JsonSerializable()
class BulkOrderDetailTItemModel {
  @JsonKey(name: 'MANDT')
  String? mandt;
  @JsonKey(name: 'ZREQNO')
  String? zreqno;
  @JsonKey(name: 'ZREQPO')
  String? zreqpo;
  @JsonKey(name: 'MATNR')
  String? matnr;
  @JsonKey(name: 'WERKS')
  String? werks;
  @JsonKey(name: 'KWMENG')
  double? kwmeng;
  @JsonKey(name: 'ZNETPR')
  double? znetpr;
  @JsonKey(name: 'NETPR')
  double? netpr;
  @JsonKey(name: 'ZDIS_RATE')
  double? zdisRate;
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
  @JsonKey(name: 'VBELN')
  String? vbeln;
  @JsonKey(name: 'POSNR')
  String? posnr;
  @JsonKey(name: 'ZMIN_QTY')
  double? zminQty;
  @JsonKey(name: 'ZMESSAGE')
  String? zmessage;
  @JsonKey(name: 'ZMSG')
  String? zmsg;
  @JsonKey(name: 'ZSTSTX')
  String? zststx;
  @JsonKey(name: 'LOEVM')
  String? loevm;
  @JsonKey(name: 'LOEVM_OR')
  String? loevmOr;
  @JsonKey(name: 'ZFREE')
  String? zfree;
  @JsonKey(name: 'VDATU')
  String? vkatu;
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
  @JsonKey(name: 'MAKTX')
  String? maktx;
  @JsonKey(name: 'WERKS_NM')
  String? werksNm;
  @JsonKey(name: 'ZERR')
  String? zerr;
  @JsonKey(name: 'ZSTATUS')
  String? zstatus;
  @JsonKey(name: 'UMODE')
  String? umode;
  @JsonKey(name: 'ZFREE_CHK')
  String? zfreeChk;
  @JsonKey(name: 'EAN11')
  String? ean11;
  @JsonKey(name: 'ZKWMENG')
  double? zkwmeng;
  @JsonKey(name: 'SET_UMREZ')
  int? setUmrez;
  @JsonKey(name: 'BOX_UMREZ')
  int? boxUmrez;
  bool? isShowLoading;

  BulkOrderDetailTItemModel(
      this.aedat,
      this.aenam,
      this.aewid,
      this.aezet,
      this.boxUmrez,
      this.ean11,
      this.erdat,
      this.ernam,
      this.erwid,
      this.erzet,
      this.kwmeng,
      this.loevm,
      this.loevmOr,
      this.maktx,
      this.mandt,
      this.matnr,
      this.mwsbp,
      this.netpr,
      this.netwr,
      this.posnr,
      this.setUmrez,
      this.umode,
      this.vbeln,
      this.vkatu,
      this.vrkme,
      this.waerk,
      this.werks,
      this.werksNm,
      this.zdisPrice,
      this.zdisRate,
      this.zerr,
      this.zfree,
      this.zfreeChk,
      this.zfreeQty,
      this.zfreeQtyIn,
      this.zkwmeng,
      this.zmessage,
      this.zminQty,
      this.zmsg,
      this.znetpr,
      this.zreqno,
      this.zreqpo,
      this.zstatus,
      this.zststx,
      this.isShowLoading);
  factory BulkOrderDetailTItemModel.fromJson(Object? json) =>
      _$BulkOrderDetailTItemModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$BulkOrderDetailTItemModelToJson(this);
}
