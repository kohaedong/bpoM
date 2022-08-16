/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/add_activity_distance_model.dart
 * Created Date: 2022-08-16 21:29:36
 * Last Modified: 2022-08-16 21:33:11
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:json_annotation/json_annotation.dart';
part 'add_activity_distance_model.g.dart';

@JsonSerializable()
class AddActivityDistanceModel {
  String? resultCd;
  String? resultMsg;
  String? distance;
  AddActivityDistanceModel(this.distance, this.resultCd, this.resultMsg);
  factory AddActivityDistanceModel.fromJson(Object? json) =>
      _$AddActivityDistanceModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AddActivityDistanceModelToJson(this);
}
