/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/salse_activity_coordinate_response_model.g.dart
 * Created Date: 2022-08-11 14:55:22
 * Last Modified: 2022-08-11 15:27:55
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salse_activity_coordinate_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalseActivityCoordinateResponseModel
    _$SalseActivityCoordinateResponseModelFromJson(Map<String, dynamic> json) =>
        SalseActivityCoordinateResponseModel(
          json['result'] == null
              ? null
              : SalseActivityCoordinateModel.fromJson(json['result'] as Object),
        );

Map<String, dynamic> _$SalseActivityCoordinateResponseModelToJson(
        SalseActivityCoordinateResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result?.toJson(),
    };
