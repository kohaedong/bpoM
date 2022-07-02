// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeModel _$NoticeModelFromJson(Map<String, dynamic> json) => NoticeModel(
      json['id'] as int?,
      json['appGrpIdParticipant'] as String?,
      json['targetParticipant'] as String?,
      json['appNtcGbCd'] as String?,
      json['appNtcSbjctNm'] as String?,
      json['appCbgtYn'] as String?,
      json['ntcBltnDttm'] == null
          ? null
          : DateTime.parse(json['ntcBltnDttm'] as String),
      json['ntcEndDttm'] == null
          ? null
          : DateTime.parse(json['ntcEndDttm'] as String),
      json['ntcTmpltCd'] as String?,
      json['ntcDscr'] as String?,
      json['ntcLnkAddr'] as String?,
      json['relyAppId'] as String?,
      json['recnfrmYn'] as String?,
      json['relyAppPackageNm'] as String?,
      json['relyAppSchm'] as String?,
      json['modrId'] as String?,
      json['modDttm'] == null
          ? null
          : DateTime.parse(json['modDttm'] as String),
      json['creatrId'] as String?,
      json['creatrNm'] as String?,
      json['creatDttm'] == null
          ? null
          : DateTime.parse(json['creatDttm'] as String),
      json['ext'] as bool?,
    );

Map<String, dynamic> _$NoticeModelToJson(NoticeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appGrpIdParticipant': instance.appGrpIdParticipant,
      'targetParticipant': instance.targetParticipant,
      'appNtcGbCd': instance.appNtcGbCd,
      'appNtcSbjctNm': instance.appNtcSbjctNm,
      'appCbgtYn': instance.appCbgtYn,
      'ntcBltnDttm': instance.ntcBltnDttm?.toIso8601String(),
      'ntcEndDttm': instance.ntcEndDttm?.toIso8601String(),
      'ntcTmpltCd': instance.ntcTmpltCd,
      'ntcDscr': instance.ntcDscr,
      'ntcLnkAddr': instance.ntcLnkAddr,
      'relyAppId': instance.relyAppId,
      'recnfrmYn': instance.recnfrmYn,
      'relyAppPackageNm': instance.relyAppPackageNm,
      'relyAppSchm': instance.relyAppSchm,
      'modrId': instance.modrId,
      'modDttm': instance.modDttm?.toIso8601String(),
      'creatrId': instance.creatrId,
      'creatrNm': instance.creatrNm,
      'creatDttm': instance.creatDttm?.toIso8601String(),
      'ext': instance.ext,
    };
