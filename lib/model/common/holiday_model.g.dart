// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HolidayModel _$HolidayModelFromJson(Map<String, dynamic> json) => HolidayModel(
      json['creatDttm'] == null
          ? null
          : DateTime.parse(json['creatDttm'] as String),
      json['creatrId'] as int?,
      json['dateKind'] as String?,
      json['dateName'] as String?,
      json['id'] as int?,
      json['isHoliday'] as String?,
      json['locdate'] as String?,
      json['modDttm'] == null
          ? null
          : DateTime.parse(json['modDttm'] as String),
      json['modrId'] as int?,
      json['seq'] as String?,
      json['year'] as String?,
    );

Map<String, dynamic> _$HolidayModelToJson(HolidayModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateKind': instance.dateKind,
      'dateName': instance.dateName,
      'isHoliday': instance.isHoliday,
      'locdate': instance.locdate,
      'seq': instance.seq,
      'year': instance.year,
      'modrId': instance.modrId,
      'modDttm': instance.modDttm?.toIso8601String(),
      'creatrId': instance.creatrId,
      'creatDttm': instance.creatDttm?.toIso8601String(),
    };
