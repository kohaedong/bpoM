// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sap_login_info_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SapLoginInfoDataModel _$SapLoginInfoDataModelFromJson(
        Map<String, dynamic> json) =>
    SapLoginInfoDataModel(
      json['ES_LOGIN'] == null
          ? null
          : EsLoginModel.fromJson(json['ES_LOGIN'] as Object),
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['ET_ORGHK'] as List<dynamic>?)
          ?.map((e) => EtOrghkModel.fromJson(e as Object))
          .toList(),
      (json['T_CODE'] as List<dynamic>?)
          ?.map((e) => TCodeModel.fromJson(e as Object))
          .toList(),
    )..isLogin = json['IS_LOGIN'] as String?;

Map<String, dynamic> _$SapLoginInfoDataModelToJson(
        SapLoginInfoDataModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'ES_LOGIN': instance.esLogin?.toJson(),
      'ET_ORGHK': instance.etOrghk?.map((e) => e.toJson()).toList(),
      'T_CODE': instance.tCode?.map((e) => e.toJson()).toList(),
      'IS_LOGIN': instance.isLogin,
    };
