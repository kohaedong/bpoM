// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't_list_search_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TlistSearchOrderModel _$TlistSearchOrderModelFromJson(
        Map<String, dynamic> json) =>
    TlistSearchOrderModel(
      json['KUNNR'] as String?,
      json['KUNNR_NM'] as String?,
      (json['KWMENG'] as num?)?.toDouble(),
      json['MAKTX'] as String?,
      json['MATKL'] as String?,
      json['MATNR'] as String?,
      (json['MWSBP'] as num?)?.toDouble(),
      (json['NETPR'] as num?)?.toDouble(),
      (json['NETWR'] as num?)?.toDouble(),
      json['ORGHK'] as String?,
      json['ORGHK_NM'] as String?,
      json['PERNR'] as String?,
      json['POSNR'] as String?,
      json['SNAME'] as String?,
      json['SPART'] as String?,
      json['VBELN'] as String?,
      json['VKGRP'] as String?,
      json['VKGRP_NM'] as String?,
      json['VRKME'] as String?,
      json['WAERK'] as String?,
      (json['ZDIS_PRICE'] as num?)?.toDouble(),
      (json['ZDIS_RATE'] as num?)?.toDouble(),
      json['ZFREE'] as String?,
      (json['ZFREE_QTY'] as num?)?.toDouble(),
      json['ZMESSAGE'] as String?,
      (json['ZNETPR'] as num?)?.toDouble(),
      json['ZREQ_DATE'] as String?,
      json['ZREQMSG'] as String?,
      json['ZREQNO'] as String?,
      json['ZSTATUS'] as String?,
      json['ZSTATUS_NM'] as String?,
      json['ZZKUNNR_END'] as String?,
      json['ZZKUNNR_END_NM'] as String?,
      (json['ZFREE_QTY_IN'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TlistSearchOrderModelToJson(
        TlistSearchOrderModel instance) =>
    <String, dynamic>{
      'ZREQNO': instance.zreqno,
      'VBELN': instance.vbeln,
      'POSNR': instance.posnr,
      'ZREQ_DATE': instance.zreqDate,
      'ZSTATUS': instance.zstatus,
      'ZSTATUS_NM': instance.zstatusNm,
      'KUNNR': instance.kunnr,
      'KUNNR_NM': instance.kunnrNm,
      'ZZKUNNR_END': instance.zzkunnrEnd,
      'ZZKUNNR_END_NM': instance.zzkunnrEndNm,
      'MATNR': instance.matnr,
      'MAKTX': instance.maktx,
      'KWMENG': instance.kwmeng,
      'ZNETPR': instance.znetpr,
      'ZDIS_RATE': instance.zdisRate,
      'NETPR': instance.netpr,
      'ZDIS_PRICE': instance.zdisPrice,
      'ZFREE_QTY': instance.zfreeQty,
      'ZFREE_QTY_IN': instance.zfreeQtyIn,
      'VRKME': instance.vrkme,
      'NETWR': instance.netwr,
      'MWSBP': instance.mwsbp,
      'WAERK': instance.waerk,
      'SPART': instance.spart,
      'MATKL': instance.matkl,
      'ORGHK': instance.orghk,
      'ORGHK_NM': instance.orghkNm,
      'PERNR': instance.pernr,
      'SNAME': instance.sname,
      'ZMESSAGE': instance.zmessage,
      'VKGRP': instance.vkgrp,
      'VKGRP_NM': instance.vkgrpNm,
      'ZREQMSG': instance.zreqmsg,
      'ZFREE': instance.zfree,
    };
