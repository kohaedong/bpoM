// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_activity_day_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesActivityDayResponseModel _$SalesActivityDayResponseModelFromJson(
        Map<String, dynamic> json) =>
    SalesActivityDayResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_ZLTSP0250S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable250.fromJson(e as Object))
          .toList(),
      (json['T_ZLTSP0260S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable260.fromJson(e as Object))
          .toList(),
      (json['T_ZLTSP0270S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable270.fromJson(e as Object))
          .toList(),
      (json['T_ZLTSP0280S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable280.fromJson(e as Object))
          .toList(),
      (json['T_ZLTSP0290S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable290.fromJson(e as Object))
          .toList(),
      (json['T_ZLTSP0291S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable291.fromJson(e as Object))
          .toList(),
      (json['T_ZLTSP0300S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable300.fromJson(e as Object))
          .toList(),
      (json['T_ZLTSP0301S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable301.fromJson(e as Object))
          .toList(),
      (json['T_ZLTSP0310S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable310.fromJson(e as Object))
          .toList(),
      (json['T_ZLTSP0320S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable320.fromJson(e as Object))
          .toList(),
      (json['T_ZLTSP0321S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable321.fromJson(e as Object))
          .toList(),
      (json['T_ZLTSP0330S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable330.fromJson(e as Object))
          .toList(),
      (json['T_ZLTSP0340S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable340.fromJson(e as Object))
          .toList(),
      (json['T_ZLTSP0350S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable350.fromJson(e as Object))
          .toList(),
      (json['T_ZLTSP0361S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable361.fromJson(e as Object))
          .toList(),
      (json['T_ZLTSP0430S'] as List<dynamic>?)
          ?.map((e) => SalesActivityDayTable430.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$SalesActivityDayResponseModelToJson(
        SalesActivityDayResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_ZLTSP0250S': instance.table250?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0260S': instance.table260?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0270S': instance.table270?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0280S': instance.table280?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0290S': instance.table290?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0291S': instance.table291?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0300S': instance.table300?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0301S': instance.table301?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0310S': instance.table310?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0320S': instance.table320?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0321S': instance.table321?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0330S': instance.table330?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0340S': instance.table340?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0350S': instance.table350?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0361S': instance.table361?.map((e) => e.toJson()).toList(),
      'T_ZLTSP0430S': instance.table430?.map((e) => e.toJson()).toList(),
    };
