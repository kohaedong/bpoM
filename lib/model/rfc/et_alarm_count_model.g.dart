// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'et_alarm_count_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtAlarmCountModel _$EtAlarmCountModelFromJson(Map<String, dynamic> json) =>
    EtAlarmCountModel(
      json['ACCNTPLAN_CNT'] as String?,
      json['ALARM_CNT'] as String?,
      json['CUSTCONSULT_CNT'] as String?,
      json['KUNNR_CNT'] as String?,
      json['rChk'] as String?,
      json['rSeq'] as String?,
      json['rStatus'] as String?,
      json['SALESOPP_CNT'] as String?,
    );

Map<String, dynamic> _$EtAlarmCountModelToJson(EtAlarmCountModel instance) =>
    <String, dynamic>{
      'ALARM_CNT': instance.alarmCnt,
      'KUNNR_CNT': instance.kunnrCnt,
      'ACCNTPLAN_CNT': instance.accntplanCnt,
      'SALESOPP_CNT': instance.salesoppCnt,
      'CUSTCONSULT_CNT': instance.custconsultCnt,
      'rStatus': instance.rStatus,
      'rChk': instance.rChk,
      'rSeq': instance.rSeq,
    };
