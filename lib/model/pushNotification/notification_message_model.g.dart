// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationMessageModel _$NotificationMessageModelFromJson(
        Map<String, dynamic> json) =>
    NotificationMessageModel(
      json['badge'] as int?,
      json['link'] as String?,
      json['title'] as String?,
      json['message'] as String?,
    );

Map<String, dynamic> _$NotificationMessageModelToJson(
        NotificationMessageModel instance) =>
    <String, dynamic>{
      'badge': instance.badge,
      'link': instance.link,
      'title': instance.title,
      'message': instance.message,
    };
