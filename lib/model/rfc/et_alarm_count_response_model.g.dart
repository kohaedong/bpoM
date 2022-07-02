// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'et_alarm_count_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtAlarmCountResponseModel _$EtAlarmCountResponseModelFromJson(
        Map<String, dynamic> json) =>
    EtAlarmCountResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['ET_BASESUMMARY'] as List<dynamic>)
          .map(
              (e) => e == null ? null : EtAlarmCountModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$EtAlarmCountResponseModelToJson(
        EtAlarmCountResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'ET_BASESUMMARY': instance.model.map((e) => e?.toJson()).toList(),
    };
