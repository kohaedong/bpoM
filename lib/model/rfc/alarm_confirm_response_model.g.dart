// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_confirm_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlamConfirmResponseModel _$AlamConfirmResponseModelFromJson(
        Map<String, dynamic> json) =>
    AlamConfirmResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_ALARM'] as List<dynamic>?)
          ?.map((e) => TAlarmModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$AlamConfirmResponseModelToJson(
        AlamConfirmResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_ALARM': instance.alarmList?.map((e) => e.toJson()).toList(),
    };
