// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_alarm_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalarmResponseModel _$TalarmResponseModelFromJson(Map<String, dynamic> json) =>
    TalarmResponseModel(
      (json['T_ALARM'] as List<dynamic>?)
          ?.map((e) => TAlarmModel.fromJson(e as Object))
          .toList(),
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
    );

Map<String, dynamic> _$TalarmResponseModelToJson(
        TalarmResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_ALARM': instance.list?.map((e) => e.toJson()).toList(),
    };
