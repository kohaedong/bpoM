/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/recent_order_response_model.g.dart
 * Created Date: 2022-09-05 10:39:10
 * Last Modified: 2022-09-05 11:02:21
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_order_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecentOrderResponseModel _$RecentOrderResponseModelFromJson(
        Map<String, dynamic> json) =>
    RecentOrderResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_HEAD'] as List<dynamic>?)
          ?.map((e) => RecentOrderHeadModel.fromJson(e as Object))
          .toList(),
      (json['T_ITEM'] as List<dynamic>?)
          ?.map((e) => RecentOrderTItemModel.fromJson(e as Object))
          .toList(),
      (json['T_TEXT'] as List<dynamic>?)
          ?.map((e) => RecentOrderTTextModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$RecentOrderResponseModelToJson(
        RecentOrderResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_HEAD': instance.tHead?.map((e) => e.toJson()).toList(),
      'T_ITEM': instance.tItem?.map((e) => e.toJson()).toList(),
      'T_TEXT': instance.tText?.map((e) => e.toJson()).toList(),
    };
