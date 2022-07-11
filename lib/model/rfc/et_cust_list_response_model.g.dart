// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'et_cust_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtCustListResponseModel _$EtCustListResponseModelFromJson(
        Map<String, dynamic> json) =>
    EtCustListResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['ET_CUSTLIST'] as List<dynamic>?)
          ?.map((e) => EtCustListModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$EtCustListResponseModelToJson(
        EtCustListResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'ET_CUSTLIST': instance.etCustList?.map((e) => e.toJson()).toList(),
    };
