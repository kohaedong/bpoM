/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/model/rfc/add_activity_suggetion_item_model.dart
 * Created Date: 2022-08-17 20:17:54
 * Last Modified: 2022-08-17 20:27:22
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'add_activity_suggetion_item_model.g.dart';

@JsonSerializable()
class AddActivitySuggetionItemModel {
  @JsonKey(name: 'MATNR')
  String? matnr;
  @JsonKey(name: 'MAKTX')
  String? maktx;
  @JsonKey(name: 'MATKL')
  String? matkl;
  @JsonKey(name: 'WGBEZ')
  String? wgbez;
  @JsonKey(name: 'KBETR1')
  String? kbetr1;
  @JsonKey(name: 'KBETR2')
  String? kbetr2;
  @JsonKey(name: 'UMODE')
  String? umode;
  bool? isChecked;
  AddActivitySuggetionItemModel(
      {this.kbetr1,
      this.kbetr2,
      this.maktx,
      this.matkl,
      this.matnr,
      this.umode,
      this.wgbez,
      this.isChecked});
  factory AddActivitySuggetionItemModel.fromJson(Object? json) =>
      _$AddActivitySuggetionItemModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AddActivitySuggetionItemModelToJson(this);
}
