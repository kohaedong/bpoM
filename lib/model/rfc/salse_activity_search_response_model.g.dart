// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salse_activity_search_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalseActivitySearchResponseModel _$SalseActivitySearchResponseModelFromJson(
        Map<String, dynamic> json) =>
    SalseActivitySearchResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_LIST'] as List<dynamic>?)
          ?.map((e) => TlistModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$SalseActivitySearchResponseModelToJson(
        SalseActivitySearchResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_LIST': instance.tList?.map((e) => e.toJson()).toList(),
    };
