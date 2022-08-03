/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_day_table_340.dart
 * Created Date: 2022-08-03 11:18:00
 * Last Modified: 2022-08-03 12:27:16
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';

part 'sales_activity_day_table_340.g.dart';

@JsonSerializable()
class SalesActivityDayTable340 {
  @JsonKey(name: 'ADATE')
  String? adate;
  @JsonKey(name: 'LNDKEY')
  String? lndkey;
  @JsonKey(name: 'VALIDTO')
  String? validt0;
  @JsonKey(name: 'STAGE')
  String? stage;
  @JsonKey(name: 'LNDCAT')
  String? lndcat;
  @JsonKey(name: 'STAT')
  String? stat;
  @JsonKey(name: 'RMK')
  String? rmk;
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
  @JsonKey(name: 'ZSKUNNR')
  String? zskunnr;
  @JsonKey(name: 'MATNR')
  String? matnr;
  @JsonKey(name: 'MAKTX')
  String? maktx;
  @JsonKey(name: 'PMONTH')
  String? pmonth;
  @JsonKey(name: 'UMODE')
  String? umode;

  SalesActivityDayTable340(
      this.adate,
      this.aedat,
      this.aenam,
      this.aezet,
      this.erdat,
      this.ernam,
      this.erwid,
      this.erzet,
      this.lndcat,
      this.lndkey,
      this.maktx,
      this.matnr,
      this.pmonth,
      this.rmk,
      this.stage,
      this.stat,
      this.umode,
      this.validt0,
      this.zskunnr);

  factory SalesActivityDayTable340.fromJson(Object? json) =>
      _$SalesActivityDayTable340FromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalesActivityDayTable340ToJson(this);
}
