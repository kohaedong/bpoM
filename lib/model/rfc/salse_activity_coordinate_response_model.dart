/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/salse_activity_coordinate_response_model.dart
 * Created Date: 2022-08-11 14:53:46
 * Last Modified: 2022-08-11 14:55:42
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/salse_activity_coordinate_model.dart';
part 'salse_activity_coordinate_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SalseActivityCoordinateResponseModel {
  SalseActivityCoordinateModel? result;
  SalseActivityCoordinateResponseModel(this.result);
  factory SalseActivityCoordinateResponseModel.fromJson(Object? json) =>
      _$SalseActivityCoordinateResponseModelFromJson(
          json as Map<String, dynamic>);
  Map<String, dynamic> toJson() =>
      _$SalseActivityCoordinateResponseModelToJson(this);
}
