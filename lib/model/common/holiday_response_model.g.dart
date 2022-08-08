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
