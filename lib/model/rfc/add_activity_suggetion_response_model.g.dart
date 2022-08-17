// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_activity_suggetion_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddActivitySuggetionResponseModel _$AddActivitySuggetionResponseModelFromJson(
        Map<String, dynamic> json) =>
    AddActivitySuggetionResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['ET_OUTPUT'] as List<dynamic>?)
          ?.map((e) => AddActivitySuggetionItemModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$AddActivitySuggetionResponseModelToJson(
        AddActivitySuggetionResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'ET_OUTPUT': instance.etOutput?.map((e) => e.toJson()).toList(),
    };
