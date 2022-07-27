/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/bulk_order_detail_search_meta_price_model.dart
 * Created Date: 2022-07-25 11:31:18
 * Last Modified: 2022-07-27 10:11:47
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'bulk_order_detail_search_meta_price_model.g.dart';

@JsonSerializable()
class BulkOrderDetailSearchMetaPriceModel {
  @JsonKey(name: 'MATNR')
  String? matnr;
  @JsonKey(name: 'MAKTX')
  String? maktx;
  @JsonKey(name: 'WERKS')
  String? werks;
  @JsonKey(name: 'WERKS_NM')
  String? werksNm;
  @JsonKey(name: 'KWMENG')
  double? kwmeng;
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
  @JsonKey(name: 'ZNETPR')
  double? znetpr;
  @JsonKey(name: 'NETWR')
  double? netwr;
  @JsonKey(name: 'MWSBP')
  double? mwsbp;
  @JsonKey(name: 'WAERK')
  String? waerk;
  @JsonKey(name: 'ZMIN_QTY')
  double? mainQty;
  @JsonKey(name: 'ZMSG')
  String? zmsg;
  @JsonKey(name: 'ZERR')
  String? zerr;
  @JsonKey(name: 'SET_UMREZ')
  int? setUmrez;
  @JsonKey(name: 'BOX_UMREZ')
  int? boxUmrez;
  @JsonKey(name: 'EAN11')
  String? ean11;

  BulkOrderDetailSearchMetaPriceModel(
      {this.boxUmrez,
      this.ean11,
      this.kwmeng,
      this.mainQty,
      this.maktx,
      this.matnr,
      this.mwsbp,
      this.netpr,
      this.netwr,
      this.setUmrez,
      this.vrkme,
      this.waerk,
      this.werks,
      this.werksNm,
      this.zdisPrice,
      this.zdisRate,
      this.zerr,
      this.zfreeQty,
      this.zfreeQtyIn,
      this.zmsg,
      this.znetpr});
  factory BulkOrderDetailSearchMetaPriceModel.fromJson(Object? json) =>
      _$BulkOrderDetailSearchMetaPriceModelFromJson(
          json as Map<String, dynamic>);

  Map<String, dynamic> toJson() =>
      _$BulkOrderDetailSearchMetaPriceModelToJson(this);
}
