// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_activity_distance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddActivityDistanceModel _$AddActivityDistanceModelFromJson(
        Map<String, dynamic> json) =>
    AddActivityDistanceModel(
      distance: json['distance'] as String?,
      resultCd: json['resultCd'] as String?,
      resultMsg: json['resultMsg'] as String?,
    );

Map<String, dynamic> _$AddActivityDistanceModelToJson(
        AddActivityDistanceModel instance) =>
    <String, dynamic>{
      'resultCd': instance.resultCd,
      'resultMsg': instance.resultMsg,
      'distance': instance.distance,
    };