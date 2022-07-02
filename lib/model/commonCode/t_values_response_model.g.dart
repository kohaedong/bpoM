// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_values_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TValuesResponseModel _$TValuesResponseModelFromJson(
        Map<String, dynamic> json) =>
    TValuesResponseModel(
      (json['T_VALUES'] as List<dynamic>?)
          ?.map((e) => TValuesModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$TValuesResponseModelToJson(
        TValuesResponseModel instance) =>
    <String, dynamic>{
      'T_VALUES': instance.modelList?.map((e) => e.toJson()).toList(),
    };
