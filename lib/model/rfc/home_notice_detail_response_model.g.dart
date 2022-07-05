// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_notice_detail_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeNoticeDetailResponseModel _$HomeNoticeDetailResponseModelFromJson(
        Map<String, dynamic> json) =>
    HomeNoticeDetailResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_VKGRP'] as List<dynamic>?)
          ?.map((e) => TVkgrpModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['T_ZLTSP0700'] as List<dynamic>?)
          ?.map((e) => TableNoticeZLTSP0710Model.fromJson(e as Object))
          .toList(),
      (json['T_TEXT'] as List<dynamic>?)
          ?.map((e) => TTextModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeNoticeDetailResponseModelToJson(
        HomeNoticeDetailResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_TEXT': instance.tText?.map((e) => e.toJson()).toList(),
      'T_VKGRP': instance.tVkgrp?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0700': instance.tZLTSP0700?.map((e) => e.toJson()).toList(),
    };
