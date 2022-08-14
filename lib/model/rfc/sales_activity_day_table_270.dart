/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_day_table_270.dart
 * Created Date: 2022-08-03 10:14:31
 * Last Modified: 2022-08-14 12:51:10
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';

part 'sales_activity_day_table_270.g.dart';

@JsonSerializable()
class SalesActivityDayTable270 {
  @JsonKey(name: 'BZACTNO')
  String? bzactno;
  @JsonKey(name: 'SEQNO')
  String? seqno;
  @JsonKey(name: 'SUBCAT')
  String? subcat;
  @JsonKey(name: 'ACTTYP')
  String? acttyp;
  @JsonKey(name: 'KEYMAN_R')
  String? keymanR;
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

  SalesActivityDayTable270(
      {this.acttyp,
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
      this.keymanR,
      this.seqno,
      this.subcat,
      this.umode});
  factory SalesActivityDayTable270.fromJson(Object? json) =>
      _$SalesActivityDayTable270FromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalesActivityDayTable270ToJson(this);
}
