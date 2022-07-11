// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_order_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchOrderResponseModel _$SearchOrderResponseModelFromJson(
        Map<String, dynamic> json) =>
    SearchOrderResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_LIST'] as List<dynamic>?)
          ?.map((e) => TlistSearchOrderModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$SearchOrderResponseModelToJson(
        SearchOrderResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_LIST': instance.tList?.map((e) => e.toJson()).toList(),
    };
