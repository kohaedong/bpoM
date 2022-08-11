/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/salse_activity_location_model.dart
 * Created Date: 2022-08-11 14:34:14
 * Last Modified: 2022-08-11 14:40:25
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'salse_activity_location_model.g.dart';

@JsonSerializable()
class SalseActivityLocationModel {
  @JsonKey(name: 'MANDT')
  String? mandt;
  @JsonKey(name: 'VKGRP')
  String? vkgrp;
  @JsonKey(name: 'LOGID')
  String? logid;
  @JsonKey(name: 'ADDCAT')
  String? addcat;
  @JsonKey(name: 'ZADD1')
  String? zadd1;
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
  @JsonKey(name: 'VKGRP_NM')
  String? vkgrpNm;
  @JsonKey(name: 'LOGID_NM')
  String? logidNm;

  SalseActivityLocationModel(
      this.addcat,
      this.aedat,
      this.aenam,
      this.aewid,
      this.aezet,
      this.erdat,
      this.ernam,
      this.erwid,
      this.erzet,
      this.logid,
      this.logidNm,
      this.mandt,
      this.umode,
      this.vkgrp,
      this.vkgrpNm,
      this.zadd1);
  factory SalseActivityLocationModel.fromJson(Object? json) =>
      _$SalseActivityLocationModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalseActivityLocationModelToJson(this);
}
