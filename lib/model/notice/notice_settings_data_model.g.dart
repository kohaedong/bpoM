// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_settings_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeSettingsDataModel _$NoticeSettingsDataModelFromJson(
        Map<String, dynamic> json) =>
    NoticeSettingsDataModel(
      json['id'] as int?,
      json['appGrpId'] as int?,
      json['creatDttm'] == null
          ? null
          : DateTime.parse(json['creatDttm'] as String),
      json['creatrId'] as String?,
      json['modDttm'] == null
          ? null
          : DateTime.parse(json['modDttm'] as String),
      json['modrId'] as String?,
      json['notiUseYn'] as String?,
      json['stopNotiTimeBeginTime'] as String?,
      json['stopNotiTimeEndTime'] as String?,
      json['stopNotiTimeUseYn'] as String?,
      json['userId'] as String?,
    );

Map<String, dynamic> _$NoticeSettingsDataModelToJson(
        NoticeSettingsDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appGrpId': instance.appGrpId,
      'userId': instance.userId,
      'notiUseYn': instance.notiUseYn,
      'stopNotiTimeUseYn': instance.stopNotiTimeUseYn,
      'stopNotiTimeBeginTime': instance.stopNotiTimeBeginTime,
      'stopNotiTimeEndTime': instance.stopNotiTimeEndTime,
      'creatrId': instance.creatrId,
      'modrId': instance.modrId,
      'creatDttm': instance.creatDttm?.toIso8601String(),
      'modDttm': instance.modDttm?.toIso8601String(),
    };
