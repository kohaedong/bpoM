/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/trans_ledger_t_list_model.g.dart
 * Created Date: 2022-07-13 16:12:07
 * Last Modified: 2022-07-13 16:12:10
 * Author: bakbeom
 * Modified By: 
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */



// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trans_ledger_t_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransLedgerTListModel _$TransLedgerTListModelFromJson(
        Map<String, dynamic> json) =>
    TransLedgerTListModel(
      json['ARKTX'] as String?,
      json['ATWRT'] as String?,
      json['ATWRT1'] as String?,
      json['ATWRT2'] as String?,
      json['AUART'] as String?,
      json['BELNR'] as String?,
      json['BLART'] as String?,
      json['BSCHL_TX'] as String?,
      json['BUKRS'] as String?,
      json['BUZEI'] as String?,
      json['DELETE'] as String?,
      json['DMBTR'] as String?,
      json['DMBTR_C'] as String?,
      json['ERDAT'] as String?,
      json['ERZET'] as String?,
      json['FKART'] as String?,
      json['FKDAT'] as String?,
      json['FKIMG'] as String?,
      json['FKIMG_C'] as String?,
      json['FREE_QTY'] as String?,
      json['FREE_QTY_C'] as String?,
      json['FWSTE'] as String?,
      json['FWSTE_C'] as String?,
      json['HWBAS'] as String?,
      json['HWBAS_C'] as String?,
      json['KKBER'] as String?,
      json['KUNNR'] as String?,
      json['KUNNR_END'] as String?,
      json['KUNNR_END_TX'] as String?,
      json['KUNNR_TX'] as String?,
      json['MATNR'] as String?,
      json['MWSBP'] as String?,
      json['MWSBP_C'] as String?,
      json['NETWR'] as String?,
      json['NETWR_C'] as String?,
      json['NETWR_T'] as String?,
      json['NETWR_T_C'] as String?,
      json['OTHER'] as String?,
      json['OTHER_C'] as String?,
      json['PERNR'] as String?,
      json['POSNR'] as String?,
      json['PSTYV'] as String?,
      json['SEQNO'] as String?,
      json['SPART'] as String?,
      json['SPMON'] as String?,
      json['VBELN'] as String?,
      json['VKGRP'] as String?,
      json['VRKME'] as String?,
      json['WAERK'] as String?,
      json['ZACCT_BSCHL'] as String?,
      json['ZFBDT'] as String?,
      json['ZNOTE_DIV'] as String?,
      json['ZNOTE_KIND'] as String?,
      json['ZNOTE_NO'] as String?,
      json['ZNOTE_TYPE'] as String?,
      json['ZTADESC'] as String?,
    );

Map<String, dynamic> _$TransLedgerTListModelToJson(
        TransLedgerTListModel instance) =>
    <String, dynamic>{
      'SPMON': instance.spmon,
      'BSCHL_TX': instance.bschlTx,
      'MATNR': instance.matnr,
      'FKIMG_C': instance.fkimgC,
      'FREE_QTY_C': instance.freeQtyC,
      'NETWR_C': instance.netwrC,
      'MWSBP_C': instance.mwsbpC,
      'NETWR_T_C': instance.netwrTC,
      'DMBTR_C': instance.dmbtrC,
      'OTHER_C': instance.otherC,
      'KUNNR_END': instance.kunnrEnd,
      'KUNNR_END_TX': instance.kunnrEndTx,
      'KUNNR': instance.kunnr,
      'KUNNR_TX': instance.kunnrTx,
      'ZFBDT': instance.zfbdt,
      'ZTADESC': instance.ztadesc,
      'SEQNO': instance.seqno,
      'FKDAT': instance.fkdat,
      'ZACCT_BSCHL': instance.zacctBschl,
      'ARKTX': instance.arktx,
      'ATWRT': instance.atwrt,
      'FKIMG': instance.fkimg,
      'FREE_QTY': instance.freeQty,
      'VRKME': instance.vrkme,
      'NETWR': instance.netwr,
      'DMBTR': instance.dmbtr,
      'WAERK': instance.waerk,
      'VBELN': instance.vbeln,
      'POSNR': instance.posnr,
      'BELNR': instance.belnr,
      'BUZEI': instance.buzei,
      'SPART': instance.spart,
      'FKART': instance.fkart,
      'PSTYV': instance.pstyv,
      'KKBER': instance.kkber,
      'BUKRS': instance.bukrs,
      'ERDAT': instance.erdat,
      'ERZET': instance.erzet,
      'AUART': instance.auart,
      'BLART': instance.blart,
      'VKGRP': instance.vkgrp,
      'PERNR': instance.pernr,
      'DELETE': instance.delete,
      'MWSBP': instance.mwsbp,
      'NETWR_T': instance.netwrT,
      'OTHER': instance.other,
      'ZNOTE_DIV': instance.znoteDiv,
      'ZNOTE_KIND': instance.znoteKind,
      'ZNOTE_TYPE': instance.zonteType,
      'ZNOTE_NO': instance.zonteNo,
      'ATWRT1': instance.atwrt1,
      'ATWRT2': instance.atwrt2,
      'HWBAS': instance.hwbas,
      'FWSTE': instance.fwste,
      'HWBAS_C': instance.hwbasC,
      'FWSTE_C': instance.fwsteC,
    };
