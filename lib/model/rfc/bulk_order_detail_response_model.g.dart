// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_order_detail_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkOrderDetailResponseModel _$BulkOrderDetailResponseModelFromJson(
        Map<String, dynamic> json) =>
    BulkOrderDetailResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_HEAD'] as List<dynamic>?)
          ?.map((e) => BulkOrderDetailTHeaderModel.fromJson(e as Object))
          .toList(),
      (json['T_ITEM'] as List<dynamic>?)
          ?.map((e) => BulkOrderDetailTItemModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$BulkOrderDetailResponseModelToJson(
        BulkOrderDetailResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_HEAD': instance.tHead?.map((e) => e.toJson()).toList(),
      'T_ITEM': instance.tItem?.map((e) => e.toJson()).toList(),
    };
