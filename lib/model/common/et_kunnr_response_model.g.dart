// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'et_kunnr_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtKunnrResponseModel _$EtKunnrResponseModelFromJson(
        Map<String, dynamic> json) =>
    EtKunnrResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['ET_KUNNR'] as List<dynamic>?)
          ?.map((e) => EtKunnrModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$EtKunnrResponseModelToJson(
        EtKunnrResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'ET_KUNNR': instance.etKunnr?.map((e) => e.toJson()).toList(),
    };
