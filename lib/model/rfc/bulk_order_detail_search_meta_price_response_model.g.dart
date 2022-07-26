// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_order_detail_search_meta_price_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkOrderDetailSearchMetaPriceResponseModel
    _$BulkOrderDetailSearchMetaPriceResponseModelFromJson(
            Map<String, dynamic> json) =>
        BulkOrderDetailSearchMetaPriceResponseModel(
          json['ES_RETURN'] == null
              ? null
              : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
          (json['T_LIST'] as List<dynamic>?)
              ?.map((e) =>
                  BulkOrderDetailSearchMetaPriceModel.fromJson(e as Object))
              .toList(),
        );

Map<String, dynamic> _$BulkOrderDetailSearchMetaPriceResponseModelToJson(
        BulkOrderDetailSearchMetaPriceResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_LIST': instance.tList?.map((e) => e.toJson()).toList(),
    };
