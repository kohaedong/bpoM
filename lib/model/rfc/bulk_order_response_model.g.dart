// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_order_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkOrderResponseModel _$BulkOrderResponseModelFromJson(
        Map<String, dynamic> json) =>
    BulkOrderResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_LIST'] as List<dynamic>?)
          ?.map((e) => BulkOrderEtTListModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$BulkOrderResponseModelToJson(
        BulkOrderResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_LIST': instance.tList?.map((e) => e.toJson()).toList(),
    };
