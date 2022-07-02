// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
      isSetNotDisturb: json['isSetNotDisturb'] as bool,
      isShowNotice: json['isShowNotice'] as bool,
      notDisturbStartHour: json['notDisturbStartHour'] as String?,
      notDisturbStartMine: json['notDisturbStartMine'] as String?,
      notDisturbStopHour: json['notDisturbStopHour'] as String?,
      notDisturbStopMine: json['notDisturbStopMine'] as String?,
      textScale: json['textScale'] as String?,
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'isShowNotice': instance.isShowNotice,
      'isSetNotDisturb': instance.isSetNotDisturb,
      'notDisturbStartHour': instance.notDisturbStartHour,
      'notDisturbStartMine': instance.notDisturbStartMine,
      'notDisturbStopHour': instance.notDisturbStopHour,
      'notDisturbStopMine': instance.notDisturbStopMine,
      'textScale': instance.textScale,
    };
