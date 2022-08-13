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
