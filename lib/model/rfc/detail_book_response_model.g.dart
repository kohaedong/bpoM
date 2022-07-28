// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_book_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailBookResponseModel _$DetailBookResponseModelFromJson(
        Map<String, dynamic> json) =>
    DetailBookResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_LIST'] as List<dynamic>?)
          ?.map((e) => DetailBookTListModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$DetailBookResponseModelToJson(
        DetailBookResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_LIST': instance.tList?.map((e) => e.toJson()).toList(),
    };
