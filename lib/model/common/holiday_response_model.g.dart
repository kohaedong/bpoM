/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/common/holiday_response_model.g.dart
 * Created Date: 2022-08-04 16:35:04
 * Last Modified: 2022-08-04 16:35:37
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HolidayResponseModel _$HolidayResponseModelFromJson(
        Map<String, dynamic> json) =>
    HolidayResponseModel(
      json['code'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => HolidayModel.fromJson(e as Object))
          .toList(),
      json['message'] as String?,
    );

Map<String, dynamic> _$HolidayResponseModelToJson(
        HolidayResponseModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };
