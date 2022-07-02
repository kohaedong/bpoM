// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'et_staff_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtStaffListModel _$EtStaffListModelFromJson(Map<String, dynamic> json) =>
    EtStaffListModel(
      json['DPTCD'] as String?,
      json['DPTNM'] as String?,
      json['EMPNO'] as String?,
      json['LEVELCDNM'] as String?,
      json['LOGID'] as String?,
      json['ORGHK'] as String?,
      json['PERNR'] as String?,
      json['rChk'] as String?,
      json['rSeq'] as String?,
      json['rStatus'] as String?,
      json['SNAME'] as String?,
    );

Map<String, dynamic> _$EtStaffListModelToJson(EtStaffListModel instance) =>
    <String, dynamic>{
      'ORGHK': instance.orghk,
      'DPTCD': instance.dptck,
      'DPTNM': instance.dptnm,
      'LOGID': instance.logid,
      'LEVELCDNM': instance.levelcdnm,
      'EMPNO': instance.empno,
      'SNAME': instance.sname,
      'PERNR': instance.pernr,
      'rStatus': instance.rStatus,
      'rChk': instance.rChk,
      'rSeq': instance.rSeq,
    };
