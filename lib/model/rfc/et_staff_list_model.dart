/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/model/rfc/et_staff_list_model.dart
 * Created Date: 2021-09-23 11:36:54
 * Last Modified: 2022-01-08 01:24:08
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
  String? dptck;
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
  @JsonKey(name: 'PERNR')
  String? pernr;
  String? rStatus;
  String? rChk;
  String? rSeq;

  EtStaffListModel(
      this.dptck,
      this.dptnm,
      this.empno,
      this.levelcdnm,
      this.logid,
      this.orghk,
      this.pernr,
      this.rChk,
      this.rSeq,
      this.rStatus,
      this.sname);

  factory EtStaffListModel.fromJson(Object? json) =>
      _$EtStaffListModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EtStaffListModelToJson(this);
}
