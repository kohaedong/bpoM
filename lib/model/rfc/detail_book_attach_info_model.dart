/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/detail_book_attach_info_model.dart
 * Created Date: 2022-08-03 15:13:18
 * Last Modified: 2022-08-03 15:17:03
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:json_annotation/json_annotation.dart';
part 'detail_book_attach_info_model.g.dart';

@JsonSerializable()
class DetailBookAttachInfoModel {
  String? id;
  DetailBookAttachInfoModel(this.id);
  factory DetailBookAttachInfoModel.fromJson(Object? json) =>
      _$DetailBookAttachInfoModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$DetailBookAttachInfoModelToJson(this);
}
