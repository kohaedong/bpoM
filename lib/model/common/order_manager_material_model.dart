/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/model/rfc/order_manager_material_model.dart
 * Created Date: 2022-09-08 11:01:26
 * Last Modified: 2022-09-14 11:08:31
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'order_manager_material_model.g.dart';

@JsonSerializable()
class OrderManagerMaterialModel {
  @JsonKey(name: 'MATNR')
  String? matnr;
  @JsonKey(name: 'MAKTX')
  String? maktx;
  @JsonKey(name: 'MATKL')
  String? matkl;
  @JsonKey(name: 'WGBEZ')
  String? wgbez;
  @JsonKey(name: 'KBETR1')
  String? kbetr1;
  @JsonKey(name: 'KBETR2')
  String? kbetr2;
  @JsonKey(name: 'UMODE')
  String? umode;
  @JsonKey(name: 'VRKME')
  String? vrkme;
  @JsonKey(name: 'ZRE_MIN_QTY')
  double? zreMinQty;
  @JsonKey(name: 'ZRE_MAX_QTY')
  double? zreMaxQty;
  @JsonKey(name: 'ZRE_CONSOL')
  String? zreConsol;
  @JsonKey(name: 'ZWH_MIN_QTY')
  double? zwhMinWty;
  @JsonKey(name: 'ZWH_MAX_QTY')
  double? zwhMaxQty;
  @JsonKey(name: 'ZWH_CONSOL')
  String? zwhConsol;
  @JsonKey(name: 'VBAMG')
  double? vbamg;
  @JsonKey(name: 'KWMENG')
  double? kwmeng;
  @JsonKey(name: 'MEINS')
  String? meins;
  @JsonKey(name: 'SET_UMREZ')
  int? setUmrez;
  @JsonKey(name: 'BOX_UMREZ')
  int? boxUmrez;
  @JsonKey(name: 'EAN11')
  String? ean11;

  OrderManagerMaterialModel(
      {this.boxUmrez,
      this.ean11,
      this.kbetr1,
      this.kbetr2,
      this.kwmeng,
      this.maktx,
      this.matkl,
      this.matnr,
      this.meins,
      this.setUmrez,
      this.umode,
      this.vbamg,
      this.vrkme,
      this.wgbez,
      this.zreConsol,
      this.zreMaxQty,
      this.zreMinQty,
      this.zwhConsol,
      this.zwhMaxQty,
      this.zwhMinWty});
  factory OrderManagerMaterialModel.fromJson(Object? json) =>
      _$OrderManagerMaterialModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$OrderManagerMaterialModelToJson(this);
}
