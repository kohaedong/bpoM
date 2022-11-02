// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_noti_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificatonModel _$NotificatonModelFromJson(Map<String, dynamic> json) =>
    NotificatonModel(
      json['badge'] as int?,
      json['body'] as String?,
      json['icon'] as String?,
      json['mutable-content'] as int?,
      json['sound'] as String?,
      json['title'] as String?,
    );

Map<String, dynamic> _$NotificatonModelToJson(NotificatonModel instance) =>
    <String, dynamic>{
      'badge': instance.badge,
      'sound': instance.sound,
      'icon': instance.icon,
      'title': instance.title,
      'body': instance.body,
      'mutable-content': instance.mutableContent,
    };
