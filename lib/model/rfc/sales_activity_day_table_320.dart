/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_day_table_320.dart
 * Created Date: 2022-08-03 10:45:59
 * Last Modified: 2022-08-03 14:30:53
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';

part 'sales_activity_day_table_320.g.dart';

@JsonSerializable()
class SalesActivityDayTable320 {
  @JsonKey(name: 'BZACTNO')
  String? bzactno;
  @JsonKey(name: 'SEQNO')
  String? seqno;
  @JsonKey(name: 'DESC_DTL')
  String? descDtl;
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

  SalesActivityDayTable320(
      this.aedat,
      this.aenam,
      this.aewid,
      this.aezet,
      this.bzactno,
      this.descDtl,
      this.erdat,
      this.ernam,
      this.erwid,
      this.erzet,
      this.seqno,
      this.umode);

  factory SalesActivityDayTable320.fromJson(Object? json) =>
      _$SalesActivityDayTable320FromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalesActivityDayTable320ToJson(this);
}
