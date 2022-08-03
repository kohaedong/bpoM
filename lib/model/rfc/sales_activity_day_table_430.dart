/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_day_table_430.dart
 * Created Date: 2022-08-03 11:26:46
 * Last Modified: 2022-08-03 13:19:46
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'sales_activity_day_table_430.g.dart';

@JsonSerializable()
class SalesActivityDayTable430 {
  @JsonKey(name: 'SNRNO')
  String? snrno;
  @JsonKey(name: 'PYEAR')
  int? pyear;
  @JsonKey(name: 'PMONTH')
  int? pmonth;
  @JsonKey(name: 'MWNUM')
  int? mwnum;
  @JsonKey(name: 'ZSKUNNR')
  String? zskunnr;
  @JsonKey(name: 'ZKMNO')
  String? zkmno;
  @JsonKey(name: 'FRDAT')
  String? frdat;
  @JsonKey(name: 'TODAT')
  String? todat;
  @JsonKey(name: 'SNRCAT')
  String? snrcat;
  @JsonKey(name: 'PDESC')
  String? pdesc;
  @JsonKey(name: 'RSLT')
  String? rslt;
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
  @JsonKey(name: 'UMODE')
  String? umode;
  SalesActivityDayTable430(
      this.aedat,
      this.aenam,
      this.aewid,
      this.aezet,
      this.erdat,
      this.ernam,
      this.erwid,
      this.erzet,
      this.frdat,
      this.mwnum,
      this.pdesc,
      this.pmonth,
      this.pyear,
      this.rslt,
      this.snrcat,
      this.snrno,
      this.todat,
      this.umode,
      this.zkmno,
      this.zskunnr);

  factory SalesActivityDayTable430.fromJson(Object? json) =>
      _$SalesActivityDayTable430FromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalesActivityDayTable430ToJson(this);
}
