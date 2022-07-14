// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'et_end_customer_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtEndCustomerResponseModel _$EtEndCustomerResponseModelFromJson(
        Map<String, dynamic> json) =>
    EtEndCustomerResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['ET_CUSTLIST'] as List<dynamic>?)
          ?.map((e) => EtEndCustomerModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$EtEndCustomerResponseModelToJson(
        EtEndCustomerResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'ET_CUSTLIST': instance.etCustList?.map((e) => e.toJson()).toList(),
    };
