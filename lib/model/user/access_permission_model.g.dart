// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_permission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessPermissionModel _$AccessPermissionModelFromJson(
        Map<String, dynamic> json) =>
    AccessPermissionModel(
      json['accessMsg'] as String?,
      json['accessApp'] as bool?,
      json['scrnshtPrevnt'] as bool?,
      json['wtmkUse'] as bool?,
      json['hckMng'] as bool?,
    );

Map<String, dynamic> _$AccessPermissionModelToJson(
        AccessPermissionModel instance) =>
    <String, dynamic>{
      'accessMsg': instance.accessMsg,
      'accessApp': instance.accessApp,
      'scrnshtPrevnt': instance.scrnshtPrevnt,
      'wtmkUse': instance.wtmkUse,
      'hckMng': instance.hckMng,
    };
