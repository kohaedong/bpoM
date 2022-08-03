/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_day_table_300.dart
 * Created Date: 2022-08-03 10:34:54
 * Last Modified: 2022-08-03 14:30:17
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';

part 'sales_activity_day_table_300.g.dart';

@JsonSerializable()
class SalesActivityDayTable300 {
  @JsonKey(name: 'BZACTNO')
  String? bzactno;
  @JsonKey(name: 'SEQNO')
  String? seqno;
  @JsonKey(name: 'DESC_DTL1')
  String? descDtl1;
  @JsonKey(name: 'DESC_DTL2')
  String? descDtl2;
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

  SalesActivityDayTable300(
      this.aedat,
      this.aenam,
      this.aewid,
      this.aezet,
      this.bzactno,
      this.descDtl1,
      this.descDtl2,
      this.erdat,
      this.ernam,
      this.erwid,
      this.erzet,
      this.seqno,
      this.umode);

  factory SalesActivityDayTable300.fromJson(Object? json) =>
      _$SalesActivityDayTable300FromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalesActivityDayTable300ToJson(this);
}
