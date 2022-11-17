// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sap_login_info_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SapLoginInfoResponseModel _$SapLoginInfoResponseModelFromJson(
        Map<String, dynamic> json) =>
    SapLoginInfoResponseModel(
      json['code'] as String?,
      json['message'] as String?,
      json['data'] == null
          ? null
          : SapLoginInfoDataModel.fromJson(json['data'] as Object),
    );

Map<String, dynamic> _$SapLoginInfoResponseModelToJson(
        SapLoginInfoResponseModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };
