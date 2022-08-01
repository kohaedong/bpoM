/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/detail_book_response_model.g.dart
 * Created Date: 2022-07-28 12:40:34
 * Last Modified: 2022-08-01 15:08:36
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

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
