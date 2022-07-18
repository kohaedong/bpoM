/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/commonCode/is_login_simple_model.dart
 * Created Date: 2022-07-18 10:24:55
 * Last Modified: 2022-07-18 13:14:10
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'is_login_simple_model.g.dart';

@JsonSerializable()
class IsLoginSimpleModel {
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
  IsLoginSimpleModel(this.bukrs, this.dptcd, this.ename, this.logid, this.orghk,
      this.salem, this.spras, this.sysip, this.vkgrp, this.vkorg, this.xtm);
  factory IsLoginSimpleModel.fromJson(Object? json) =>
      _$IsLoginSimpleModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$IsLoginSimpleModelToJson(this);
}
