/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/model/rfc/et_staff_list_model.dart
 * Created Date: 2021-09-23 11:36:54
 * Last Modified: 2022-09-15 11:08:35
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'et_staff_list_model.g.dart';

@JsonSerializable()
class EtStaffListModel {
  @JsonKey(name: 'ORGHK')
  String? orghk;
  @JsonKey(name: 'DPTCD')
  String? dptcd;
  @JsonKey(name: 'DPTNM')
  String? dptnm;
  @JsonKey(name: 'LOGID')
  String? logid;
  @JsonKey(name: 'LEVELCDNM')
  String? levelcdnm;
  @JsonKey(name: 'EMPNO')
  String? empno;
  @JsonKey(name: 'SNAME')
  String? sname;
  @JsonKey(name: 'IKENID')
  String? ikenId;
  @JsonKey(name: 'SALEM')
  String? salem;
  @JsonKey(name: 'VKGRP')
  String? vkgrp;
  @JsonKey(name: 'VKORG')
  String? vkorg;
  @JsonKey(name: 'PERNR')
  String? pernr;
  String? rStatus;
  String? rChk;
  String? rSeq;

  EtStaffListModel(
      {this.dptcd,
      this.dptnm,
      this.empno,
      this.levelcdnm,
      this.logid,
      this.orghk,
      this.pernr,
      this.rChk,
      this.rSeq,
      this.rStatus,
      this.sname});

  factory EtStaffListModel.fromJson(Object? json) =>
      _$EtStaffListModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EtStaffListModelToJson(this);
}
