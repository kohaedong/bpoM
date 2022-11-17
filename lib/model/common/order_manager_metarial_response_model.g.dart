// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_manager_metarial_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderManagerMetarialResponseModel _$OrderManagerMetarialResponseModelFromJson(
        Map<String, dynamic> json) =>
    OrderManagerMetarialResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['ET_OUTPUT'] as List<dynamic>?)
          ?.map((e) => OrderManagerMaterialModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$OrderManagerMetarialResponseModelToJson(
        OrderManagerMetarialResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'ET_OUTPUT': instance.etOutput?.map((e) => e.toJson()).toList(),
    };
