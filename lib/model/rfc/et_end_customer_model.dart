/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/et_end_customer_model.dart
 * Created Date: 2022-07-14 16:51:19
 * Last Modified: 2022-07-14 16:55:24
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'et_end_customer_model.g.dart';

@JsonSerializable()
class EtEndCustomerModel {
  @JsonKey(name: 'KUNNR')
  String? kunnr;
  @JsonKey(name: 'KUNNR_NM')
  String? kunnrNm;
  @JsonKey(name: 'REGIO')
  String? regio;
  @JsonKey(name: 'REGIO_NM')
  String? regioNm;
  @JsonKey(name: 'ORT01')
  String? ort01;
  @JsonKey(name: 'STRAS')
  String? stras;
  @JsonKey(name: 'TELF1')
  String? telf1;
  @JsonKey(name: 'DEFPA')
  String? defpa;

  EtEndCustomerModel(this.defpa, this.kunnr, this.kunnrNm, this.ort01,
      this.regio, this.regioNm, this.stras, this.telf1);

  factory EtEndCustomerModel.fromJson(Object? json) =>
      _$EtEndCustomerModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$EtEndCustomerModelToJson(this);
}
