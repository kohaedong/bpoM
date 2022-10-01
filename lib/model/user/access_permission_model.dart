/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/user/access_permission_model.dart
 * Created Date: 2022-10-01 13:27:11
 * Last Modified: 2022-10-01 13:31:09
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:json_annotation/json_annotation.dart';
part 'access_permission_model.g.dart';

@JsonSerializable()
class AccessPermissionModel {
  String? accessMsg;
  bool? accessApp;
  bool? scrnshtPrevnt;
  bool? wtmkUse;
  bool? hckMng;

  AccessPermissionModel(this.accessMsg, this.accessApp, this.scrnshtPrevnt,
      this.wtmkUse, this.hckMng);
  factory AccessPermissionModel.fromJson(Object? json) =>
      _$AccessPermissionModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$AccessPermissionModelToJson(this);
}
