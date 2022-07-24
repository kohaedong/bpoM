// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_order_detail_amount_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkOrderDetailAmountResponseModel _$BulkOrderDetailAmountResponseModelFromJson(
        Map<String, dynamic> json) =>
    BulkOrderDetailAmountResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_CREDIT_LIMIT'] as List<dynamic>?)
          ?.map(
              (e) => BulkOrderDetailAmountAvaliableModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$BulkOrderDetailAmountResponseModelToJson(
        BulkOrderDetailAmountResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_CREDIT_LIMIT': instance.tCreditLimit?.map((e) => e.toJson()).toList(),
    };
