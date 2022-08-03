// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_key_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchKeyResponseModel _$SearchKeyResponseModelFromJson(
        Map<String, dynamic> json) =>
    SearchKeyResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_LIST'] as List<dynamic>?)
          ?.map((e) => SearchKeyForPartmentModel.fromJson(e as Object))
          .toList(),
      (json['T_LIST2'] as List<dynamic>?)
          ?.map((e) => SearchKeyForBusinessGroupModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$SearchKeyResponseModelToJson(
        SearchKeyResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_LIST': instance.tList?.map((e) => e.toJson()).toList(),
      'T_LIST2': instance.tList2?.map((e) => e.toJson()).toList(),
    };
