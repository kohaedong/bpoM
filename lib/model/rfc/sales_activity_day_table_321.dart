/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_day_table_321.dart
 * Created Date: 2022-08-03 10:49:02
 * Last Modified: 2022-08-03 12:26:55
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'sales_activity_day_table_321.g.dart';

@JsonSerializable()
class SalesActivityDayTable321 {
  @JsonKey(name: 'BZACTNO')
  String? bzactno;
  @JsonKey(name: 'SEQNO')
  String? seqno;
  @JsonKey(name: 'SUBSEQ')
  String? subseq;
  @JsonKey(name: 'ZMATKL')
  String? zmatkl;
  @JsonKey(name: 'WAERK')
  String? waerk;
  @JsonKey(name: 'AMT')
  String? amt;
  @JsonKey(name: 'RMK')
  String? rmk;
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
  String? aename;
  @JsonKey(name: 'AEWID')
  String? aewid;
  @JsonKey(name: 'MATKL_NM')
  String? matklNm;
  @JsonKey(name: 'MAKTX')
  String? maktx;
  @JsonKey(name: 'UMODE')
  String? umode;

  SalesActivityDayTable321(
      this.aedat,
      this.aename,
      this.aewid,
      this.aezet,
      this.amt,
      this.bzactno,
      this.erdat,
      this.ernam,
      this.erwid,
      this.erzet,
      this.maktx,
      this.matklNm,
      this.matnr,
      this.rmk,
      this.seqno,
      this.subseq,
      this.umode,
      this.waerk,
      this.zmatkl);

  factory SalesActivityDayTable321.fromJson(Object? json) =>
      _$SalesActivityDayTable321FromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalesActivityDayTable321ToJson(this);
}
