// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_update_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckUpdateModel _$CheckUpdateModelFromJson(Map<String, dynamic> json) =>
    CheckUpdateModel(
      json['appVerDscr'] as String?,
      json['hckMngYn'] as String?,
      json['updateKind'] as String?,
      json['cmpsYn'] as String?,
      json['appUpdUrlAddr'] as String?,
      json['scrnshtPrevntYn'] as String?,
      json['message'] as String?,
      json['currentVersion'] as String?,
      json['targetVersion'] as String?,
      json['result'] as String?,
      json['appInstallAddr'] as String?,
      json['wtmkUseYn'] as String?,
      json['appInstlltnFileSiz'] as String?,
      json['targetVersionId'] as int?,
    );

Map<String, dynamic> _$CheckUpdateModelToJson(CheckUpdateModel instance) =>
    <String, dynamic>{
      'appVerDscr': instance.appVerDscr,
      'hckMngYn': instance.hckMngYn,
      'updateKind': instance.updateKind,
      'cmpsYn': instance.cmpsYn,
      'appUpdUrlAddr': instance.appUpdUrlAddr,
      'scrnshtPrevntYn': instance.scrnshtPrevntYn,
      'message': instance.message,
      'currentVersion': instance.currentVersion,
      'targetVersion': instance.targetVersion,
      'result': instance.result,
      'appInstallAddr': instance.appInstallAddr,
      'wtmkUseYn': instance.wtmkUseYn,
      'appInstlltnFileSiz': instance.appInstlltnFileSiz,
      'targetVersionId': instance.targetVersionId,
    };
