/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_day_table_291.dart
 * Created Date: 2022-08-03 10:30:26
 * Last Modified: 2022-08-03 13:12:09
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'sales_activity_day_table_291.g.dart';

@JsonSerializable()
class SalesActivityDayTable291 {
  @JsonKey(name: 'BZACTNO')
  String? bzactno;
  @JsonKey(name: 'SEQNO')
  int? seqno;
  @JsonKey(name: 'SUBSEQ')
  String? subseq;
  @JsonKey(name: 'SUBCAT')
  String? subcat;
  @JsonKey(name: 'MEINS')
  String? meins;
  @JsonKey(name: 'QTY')
  String? qty;
  @JsonKey(name: 'WAERK')
  String? waerk;
  @JsonKey(name: 'AMOUNT')
  String? amount;
  @JsonKey(name: 'DESC_DTL')
  String? descDtl;
  @JsonKey(name: 'MATNR')
  String? matnr;
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
  @JsonKey(name: 'MATKL_NM')
  String? matklNm;
  @JsonKey(name: 'MAKTX')
  String? maktx;
  @JsonKey(name: 'UMODE')
  String? umode;

  SalesActivityDayTable291(
      this.aedat,
      this.aenam,
      this.aewid,
      this.aezet,
      this.amount,
      this.bzactno,
      this.descDtl,
      this.erdat,
      this.ernam,
      this.erwid,
      this.erzet,
      this.maktx,
      this.matklNm,
      this.matnr,
      this.meins,
      this.qty,
      this.seqno,
      this.subcat,
      this.subseq,
      this.umode,
      this.waerk);

  factory SalesActivityDayTable291.fromJson(Object? json) =>
      _$SalesActivityDayTable291FromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalesActivityDayTable291ToJson(this);
}
