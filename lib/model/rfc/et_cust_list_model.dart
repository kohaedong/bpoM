/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/model/rfc/et_customer_model_by_search_compay_type.dart
 * Created Date: 2021-11-11 02:55:30
 * Last Modified: 2022-07-11 12:33:31
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'et_cust_list_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EtCustListModel {
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
  EtCustListModel(this.kunnr, this.kunnrNm, this.regio, this.regioNm,
      this.ort01, this.stras, this.telf1, this.defpa);
  factory EtCustListModel.fromJson(Object? json) =>
      _$EtCustListModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EtCustListModelToJson(this);
}
