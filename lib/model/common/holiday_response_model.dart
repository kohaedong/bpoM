/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/model/common/holiday_response_model.dart
 * Created Date: 2022-08-04 16:32:08
 * Last Modified: 2022-08-04 16:35:23
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:bpom/model/common/holiday_model.dart';
part 'holiday_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HolidayResponseModel {
  String? code;
  String? message;
  List<HolidayModel>? data;
  HolidayResponseModel(this.code, this.data, this.message);
  factory HolidayResponseModel.fromJson(Object? json) =>
      _$HolidayResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$HolidayResponseModelToJson(this);
}
