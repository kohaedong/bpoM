/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/et_customer_model.g.dart
 * Created Date: 2022-07-11 11:19:21
 * Last Modified: 2022-07-11 12:33:26
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'et_customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtCustomerModel _$EtCustomerModelFromJson(Map<String, dynamic> json) =>
    EtCustomerModel(
      json['ERDAT'] as String?,
      json['J_1KFREPRE'] as String?,
      json['J_1KFTBUS'] as String?,
      json['J_1KFTIND'] as String?,
      json['KTOKD'] as String?,
      json['KTOKD_NM'] as String?,
      json['KUNNR'] as String?,
      json['KUNNR_NM'] as String?,
      json['LAND1'] as String?,
      json['LAND1_NM'] as String?,
      json['ORT01'] as String?,
      json['PSTLZ'] as String?,
      json['rChk'] as String?,
      json['rSeq'] as String?,
      json['rStatus'] as String?,
      json['STCD2'] as String?,
      json['STRAS'] as String?,
      json['TELF1'] as String?,
      json['TELFX'] as String?,
    );

Map<String, dynamic> _$EtCustomerModelToJson(EtCustomerModel instance) =>
    <String, dynamic>{
      'KUNNR': instance.kunnr,
      'KUNNR_NM': instance.kunnrNm,
      'KTOKD': instance.ktokd,
      'KTOKD_NM': instance.ktokdNm,
      'STCD2': instance.stcd2,
      'ERDAT': instance.erdat,
      'J_1KFTBUS': instance.j1kftbus,
      'J_1KFTIND': instance.j1kftind,
      'ORT01': instance.ort01,
      'STRAS': instance.stras,
      'PSTLZ': instance.pstlz,
      'LAND1': instance.land1,
      'LAND1_NM': instance.land1Nm,
      'J_1KFREPRE': instance.j1kfrepre,
      'TELF1': instance.telf1,
      'TELFX': instance.telfx,
      'rStatus': instance.rStatus,
      'rChk': instance.rChk,
      'rSeq': instance.rSeq,
    };
