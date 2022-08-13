/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_day_table_361.dart
 * Created Date: 2022-08-03 11:39:53
 * Last Modified: 2022-08-13 10:51:51
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';

part 'sales_activity_day_table_361.g.dart';

@JsonSerializable()
class SalesActivityDayTable361 {
  @JsonKey(name: 'BZACTNO')
  String? bzactno;
  @JsonKey(name: 'SEQNO')
  String? seqno;
  @JsonKey(name: 'SUBSEQ')
  int? subseq;
  @JsonKey(name: 'LOGID')
  String? logid;
  @JsonKey(name: 'SNAME')
  String? sname;
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
  @JsonKey(name: 'ORGHK')
  String? orghk;
  @JsonKey(name: 'ORGHK_NM')
  String? orghkNm;
  @JsonKey(name: 'ZSKUNNR')
  String? zskunnr;
  @JsonKey(name: 'ZKMNO')
  String? zkmno;
  @JsonKey(name: 'UMODE')
  String? umode;

  SalesActivityDayTable361(
      {this.aedat,
      this.aenam,
      this.aewid,
      this.aezet,
      this.bzactno,
      this.erdat,
      this.ernam,
      this.erwid,
      this.erzet,
      this.logid,
      this.orghk,
      this.orghkNm,
      this.seqno,
      this.sname,
      this.subseq,
      this.umode,
      this.zkmno,
      this.zskunnr});

  factory SalesActivityDayTable361.fromJson(Object? json) =>
      _$SalesActivityDayTable361FromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalesActivityDayTable361ToJson(this);
}
