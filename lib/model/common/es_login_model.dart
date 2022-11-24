/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/model/rfc/es_login_model.dart
 * Created Date: 2022-07-04 14:36:26
 * Last Modified: 2022-07-04 14:36:32
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'es_login_model.g.dart';

@JsonSerializable()
class EsLoginModel {
  @JsonKey(name: 'LOGID')
  String? logid;
  @JsonKey(name: 'ENAME')
  String? ename;
  @JsonKey(name: 'BUKRS')
  String? bukrs;
  @JsonKey(name: 'VKORG')
  String? vkorg;
  @JsonKey(name: 'DPTCD')
  String? dptcd;
  @JsonKey(name: 'DPTNM')
  String? dptnm;
  @JsonKey(name: 'ORGHK')
  String? orghk;
  @JsonKey(name: 'SALEM')
  String? salem;
  @JsonKey(name: 'SYSIP')
  String? sysip;
  @JsonKey(name: 'SPRAS')
  String? spras;
  @JsonKey(name: 'XTM')
  String? xtm;
  @JsonKey(name: 'VKGRP')
  String? vkgrp;

  EsLoginModel(
      this.logid,
      this.ename,
      this.bukrs,
      this.vkorg,
      this.dptcd,
      this.dptnm,
      this.orghk,
      this.salem,
      this.sysip,
      this.spras,
      this.xtm,
      this.vkgrp);

  factory EsLoginModel.fromJson(Object? json) =>
      _$EsLoginModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EsLoginModelToJson(this);
}
