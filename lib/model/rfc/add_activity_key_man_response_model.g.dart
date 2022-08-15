/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/add_activity_key_man_response_model.g.dart
 * Created Date: 2022-08-15 10:58:03
 * Last Modified: 2022-08-15 11:01:54
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_activity_key_man_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddActivityKeyManResponseModel _$AddActivityKeyManResponseModelFromJson(
        Map<String, dynamic> json) =>
    AddActivityKeyManResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['ET_LIST'] as List<dynamic>?)
          ?.map((e) => AddActivityKeyManModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$AddActivityKeyManResponseModelToJson(
        AddActivityKeyManResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'ET_LIST': instance.etList?.map((e) => e.toJson()).toList(),
    };
