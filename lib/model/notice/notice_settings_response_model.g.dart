// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_settings_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeSettingsResponseModel _$NoticeSettingsResponseModelFromJson(
        Map<String, dynamic> json) =>
    NoticeSettingsResponseModel(
      json['code'] as String?,
      json['message'] as String?,
      json['data'] == null
          ? null
          : NoticeSettingsDataModel.fromJson(json['data'] as Object),
    );

Map<String, dynamic> _$NoticeSettingsResponseModelToJson(
        NoticeSettingsResponseModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };
