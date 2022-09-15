// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'et_staff_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtStaffListModel _$EtStaffListModelFromJson(Map<String, dynamic> json) =>
    EtStaffListModel(
      dptcd: json['DPTCD'] as String?,
      dptnm: json['DPTNM'] as String?,
      empno: json['EMPNO'] as String?,
      levelcdnm: json['LEVELCDNM'] as String?,
      logid: json['LOGID'] as String?,
      orghk: json['ORGHK'] as String?,
      pernr: json['PERNR'] as String?,
      rChk: json['rChk'] as String?,
      rSeq: json['rSeq'] as String?,
      rStatus: json['rStatus'] as String?,
      sname: json['SNAME'] as String?,
    )
      ..ikenId = json['IKENID'] as String?
      ..salem = json['SALEM'] as String?
      ..vkgrp = json['VKGRP'] as String?
      ..vkorg = json['VKORG'] as String?;

Map<String, dynamic> _$EtStaffListModelToJson(EtStaffListModel instance) =>
    <String, dynamic>{
      'ORGHK': instance.orghk,
      'DPTCD': instance.dptcd,
      'DPTNM': instance.dptnm,
      'LOGID': instance.logid,
      'LEVELCDNM': instance.levelcdnm,
      'EMPNO': instance.empno,
      'SNAME': instance.sname,
      'IKENID': instance.ikenId,
      'SALEM': instance.salem,
      'VKGRP': instance.vkgrp,
      'VKORG': instance.vkorg,
      'PERNR': instance.pernr,
      'rStatus': instance.rStatus,
      'rChk': instance.rChk,
      'rSeq': instance.rSeq,
    };
