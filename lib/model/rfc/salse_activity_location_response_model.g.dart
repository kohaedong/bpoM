// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salse_activity_location_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalseActivityLocationResponseModel _$SalseActivityLocationResponseModelFromJson(
        Map<String, dynamic> json) =>
    SalseActivityLocationResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_LIST'] as List<dynamic>?)
          ?.map((e) => SalseActivityLocationModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$SalseActivityLocationResponseModelToJson(
        SalseActivityLocationResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_LIST': instance.tList?.map((e) => e.toJson()).toList(),
    };
