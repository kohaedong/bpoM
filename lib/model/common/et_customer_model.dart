/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/model/rfc/es_customer_model.dart
 * Created Date: 2021-09-13 18:20:27
 * Last Modified: 2022-01-08 01:24:08
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'et_customer_model.g.dart';

@JsonSerializable()
class EtCustomerModel {
  @JsonKey(name: 'KUNNR')
  String? kunnr;
  @JsonKey(name: 'KUNNR_NM')
  String? kunnrNm;
  @JsonKey(name: 'KTOKD')
  String? ktokd;
  @JsonKey(name: 'KTOKD_NM')
  String? ktokdNm;
  @JsonKey(name: 'STCD2')
  String? stcd2;
  @JsonKey(name: 'ERDAT')
  String? erdat;
  @JsonKey(name: 'J_1KFTBUS')
  String? j1kftbus;
  @JsonKey(name: 'J_1KFTIND')
  String? j1kftind;
  @JsonKey(name: 'ORT01')
  String? ort01;
  @JsonKey(name: 'STRAS')
  String? stras;
  @JsonKey(name: 'PSTLZ')
  String? pstlz;
  @JsonKey(name: 'LAND1')
  String? land1;
  @JsonKey(name: 'LAND1_NM')
  String? land1Nm;
  @JsonKey(name: 'J_1KFREPRE')
  String? j1kfrepre;
  @JsonKey(name: 'TELF1')
  String? telf1;
  @JsonKey(name: 'TELFX')
  String? telfx;
  @JsonKey(name: 'rStatus')
  String? rStatus;
  @JsonKey(name: 'rChk')
  String? rChk;
  @JsonKey(name: 'rSeq')
  String? rSeq;

  EtCustomerModel(
      this.erdat,
      this.j1kfrepre,
      this.j1kftbus,
      this.j1kftind,
      this.ktokd,
      this.ktokdNm,
      this.kunnr,
      this.kunnrNm,
      this.land1,
      this.land1Nm,
      this.ort01,
      this.pstlz,
      this.rChk,
      this.rSeq,
      this.rStatus,
      this.stcd2,
      this.stras,
      this.telf1,
      this.telfx);
  factory EtCustomerModel.fromJson(Object? json) =>
      _$EtCustomerModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EtCustomerModelToJson(this);
}
