// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_code_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonCodeResponseModel _$CommonCodeResponseModelFromJson(
        Map<String, dynamic> json) =>
    CommonCodeResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_CODE'] as List<dynamic>?)
          ?.map((e) => TCodeModel.fromJson(e as Object))
          .toList(),
      (json['T_VALUES'] as List<dynamic>?)
          ?.map((e) => TValuesModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$CommonCodeResponseModelToJson(
        CommonCodeResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_CODE': instance.tCodeModel?.map((e) => e.toJson()).toList(),
      'T_VALUES': instance.tValuesModel?.map((e) => e.toJson()).toList(),
    };
