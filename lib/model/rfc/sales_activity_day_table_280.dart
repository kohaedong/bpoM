/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_day_table_280.dart
 * Created Date: 2022-08-03 10:18:51
 * Last Modified: 2022-08-03 13:11:48
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';

part 'sales_activity_day_table_280.g.dart';

@JsonSerializable()
class SalesActivityDayTable280 {
  @JsonKey(name: 'BZACTNO')
  String? bzactno;
  @JsonKey(name: 'SEQNO')
  int? seqno;
  @JsonKey(name: 'SUBCAT')
  String? subcat;
  @JsonKey(name: 'XGIFT')
  String? xgift;
  @JsonKey(name: 'KEYMAN_R')
  String? keymanR;
  @JsonKey(name: 'ZMATKL1')
  String? zmatkl1;
  @JsonKey(name: 'XSAMPL1')
  String? xsampl1;
  @JsonKey(name: 'ZMATKL2')
  String? zmatkl2;
  @JsonKey(name: 'XSAMPL2')
  String? xsampl2;
  @JsonKey(name: 'ZMATKL3')
  String? zmatkl3;
  @JsonKey(name: 'XSAMPL3')
  String? xsampl3;
  @JsonKey(name: 'DESC_DTL')
  String? descDtl;
  @JsonKey(name: 'MATNR1')
  String? matnr1;
  @JsonKey(name: 'MATNR2')
  String? matnr2;
  @JsonKey(name: 'MATNR3')
  String? matnr3;
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
  @JsonKey(name: 'MATKL1_NM')
  String? matkl1Nm;
  @JsonKey(name: 'MATKL2_NM')
  String? matkl2Nm;
  @JsonKey(name: 'MATKL3_NM')
  String? matkl3Nm;
  @JsonKey(name: 'MAKTX1')
  String? maktx1;
  @JsonKey(name: 'MAKTX2')
  String? maktx2;
  @JsonKey(name: 'MAKTX3')
  String? maktx3;
  @JsonKey(name: 'UMODE')
  String? umode;

  SalesActivityDayTable280(
      this.bzactno,
      this.aedat,
      this.aenam,
      this.aezet,
      this.descDtl,
      this.erdat,
      this.ernam,
      this.erwid,
      this.erzet,
      this.keymanR,
      this.maktx1,
      this.maktx2,
      this.maktx3,
      this.matkl1Nm,
      this.matkl2Nm,
      this.matkl3Nm,
      this.matnr1,
      this.matnr2,
      this.matnr3,
      this.seqno,
      this.subcat,
      this.umode,
      this.xgift,
      this.xsampl1,
      this.xsampl2,
      this.xsampl3,
      this.zmatkl1,
      this.zmatkl2,
      this.zmatkl3);

  factory SalesActivityDayTable280.fromJson(Object? json) =>
      _$SalesActivityDayTable280FromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalesActivityDayTable280ToJson(this);
}
