/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/bulk_order_et_t_list_model.g.dart
 * Created Date: 2022-07-17 21:40:53
 * Last Modified: 2022-07-17 21:50:45
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_order_et_t_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkOrderEtTListModel _$BulkOrderEtTListModelFromJson(
        Map<String, dynamic> json) =>
    BulkOrderEtTListModel(
      json['CDATE'] as String?,
      json['EMPNO'] as String?,
      json['KUNNR'] as String?,
      json['KUNNR_NM'] as String?,
      json['PERNR'] as String?,
      json['PERNR_NM'] as String?,
      json['SPART'] as String?,
      json['VBELN'] as String?,
      json['VKGRP'] as String?,
      json['VKGRP_NM'] as String?,
      json['WADAT_IST'] as String?,
      json['ZDMSTATUS'] as String?,
      json['ZREQ_DATE'] as String?,
      json['ZREQNO'] as String?,
      json['ZZKUNNR_END'] as String?,
      json['ZZKUNNR_END_NM'] as String?,
    );

Map<String, dynamic> _$BulkOrderEtTListModelToJson(
        BulkOrderEtTListModel instance) =>
    <String, dynamic>{
      'ZREQNO': instance.zreqno,
      'ZREQ_DATE': instance.zreqDate,
      'VBELN': instance.vbeln,
      'VKGRP': instance.vkgrp,
      'PERNR': instance.pernr,
      'EMPNO': instance.empno,
      'SPART': instance.spart,
      'KUNNR': instance.kunnr,
      'ZZKUNNR_END': instance.zzkunnrEnd,
      'KUNNR_NM': instance.kunnrNm,
      'ZZKUNNR_END_NM': instance.zzkunnrEndNm,
      'PERNR_NM': instance.pernrNm,
      'VKGRP_NM': instance.vkgrpNm,
      'ZDMSTATUS': instance.zdmstatus,
      'WADAT_IST': instance.wadatIst,
      'CDATE': instance.cdate,
    };
