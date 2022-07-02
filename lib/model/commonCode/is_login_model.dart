/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/model/commonCode/is_login_model.dart
 * Created Date: 2022-01-05 14:38:48
 * Last Modified: 2022-02-23 12:26:55
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'is_login_model.g.dart';

@JsonSerializable()
class IsLoginModel {
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
  @JsonKey(name: 'KUNAG')
  String? kunag;
  @JsonKey(name: 'SPART')
  String? spart;
  @JsonKey(name: 'VTWEG')
  String? vtweg;
  @JsonKey(name: 'XBATCH')
  String? xbatch;
  @JsonKey(name: 'XCUSTINFO')
  String? xcustinfo;
  @JsonKey(name: 'XEXPORT')
  String? xexport;
  @JsonKey(name: 'XKKBER')
  String? xkkber;
  @JsonKey(name: 'XPLANT')
  String? xplant;
  @JsonKey(name: 'IKENID')
  String? ikenid;
  IsLoginModel(
      this.bukrs,
      this.dptcd,
      this.dptnm,
      this.ename,
      this.logid,
      this.orghk,
      this.salem,
      this.spras,
      this.sysip,
      this.vkgrp,
      this.vkorg,
      this.xtm,
      this.ikenid,
      this.kunag,
      this.spart,
      this.vtweg,
      this.xbatch,
      this.xcustinfo,
      this.xexport,
      this.xkkber,
      this.xplant);
  factory IsLoginModel.fromJson(Object? json) =>
      _$IsLoginModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$IsLoginModelToJson(this);
}
