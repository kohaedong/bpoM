// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_activity_month_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesActivityMonthResponseModel _$SalesActivityMonthResponseModelFromJson(
        Map<String, dynamic> json) =>
    SalesActivityMonthResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_LIST'] as List<dynamic>?)
          ?.map((e) => SalesActivityWeeksModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$SalesActivityMonthResponseModelToJson(
        SalesActivityMonthResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_LIST': instance.tList?.map((e) => e.toJson()).toList(),
    };
