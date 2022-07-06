// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'et_customer_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtCustomerResponseModel _$EtCustomerResponseModelFromJson(
        Map<String, dynamic> json) =>
    EtCustomerResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['ET_KUNNR'] as List<dynamic>?)
          ?.map((e) => EtCustomerModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$EtCustomerResponseModelToJson(
        EtCustomerResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'ET_KUNNR': instance.etKunnr?.map((e) => e.toJson()).toList(),
    };
