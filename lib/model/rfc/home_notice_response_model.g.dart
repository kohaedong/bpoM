// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_notice_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeNoticeResponseModel _$HomeNoticeResponseModelFromJson(
        Map<String, dynamic> json) =>
    HomeNoticeResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_ZLTSP0710'] as List<dynamic>?)
          ?.map((e) => TableNoticeZLTSP0710Model.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$HomeNoticeResponseModelToJson(
        HomeNoticeResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_ZLTSP0710': instance.tZltsp0710?.map((e) => e.toJson()).toList(),
    };
