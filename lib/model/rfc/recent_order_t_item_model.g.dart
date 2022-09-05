// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_order_t_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecentOrderTItemModel _$RecentOrderTItemModelFromJson(
        Map<String, dynamic> json) =>
    RecentOrderTItemModel(
        aedat: json['AEDAT'] as String?,
        aenam: json['AENAM'] as String?,
        aewid: json['AEWID'] as String?,
        aezet: json['AEZET'] as String?,
        erdat: json['ERDAT'] as String?,
        ernam: json['ERNAM'] as String?,
        erwid: json['ERWID'] as String?,
        erzet: json['ERZET'] as String?,
        kwmeng: json['KWMENG'] as double?,
        loevm: json['LOEVM'] as String?,
        loevmOr: json['LOEVM_OR'] as String?,
        maktx: json['MAKTX'] as String?,
        matnr: json['MATNR'] as String?,
        mwsbp: json['MWSBP'] as double?,
        netpr: json['NETPR'] as double?,
        netwr: json['NETWR'] as double?,
        orerr: json['ORERR'] as String?,
        posnr: json['POSNR'] as String?,
        umode: json['UMODE'] as String?,
        vbeln: json['VBELN'] as String?,
        vrkme: json['VRKME'] as String?,
        waerk: json['WAERK'] as String?,
        werks: json['WERKS'] as String?,
        werksNm: json['WERKS_NM'] as String?,
        zdisPrice: json['ZDIS_PRICE'] as double?,
        zdisRate: json['ZDIS_RATE'] as double?,
        zerr: json['ZERR'] as String?,
        zfree: json['ZFREE'] as String?,
        zfreeChk: json['ZFREE_CHK'] as String?,
        zfreeQty: json['ZFREE_QTY'] as double?,
        zmessage: json['ZMESSAGE'] as String?,
        zminQty: json['ZMIN_QTY'] as double?,
        zmsg: json['ZMSG'] as String?,
        znetpr: json['ZNETPR'] as double?,
        zreqNo: json['ZREQNO'] as String?,
        zreqpo: json['ZREQPO'] as String?,
        zstatus: json['ZSTATUS'] as String?,
        zststx: json['ZSTSTX'] as String?,
        isFromRecentOrder: json['isFromRecentOrder'] as bool?);

Map<String, dynamic> _$RecentOrderTItemModelToJson(
        RecentOrderTItemModel instance) =>
    <String, dynamic>{
      'ZREQNO': instance.zreqNo,
      'ZREQPO': instance.zreqpo,
      'MATNR': instance.matnr,
      'WERKS': instance.werks,
      'KWMENG': instance.kwmeng,
      'ZNETPR': instance.znetpr,
      'NETPR': instance.netpr,
      'ZDIS_RATE': instance.zdisRate,
      'ZDIS_PRICE': instance.zdisPrice,
      'ZFREE_QTY': instance.zfreeQty,
      'VRKME': instance.vrkme,
      'NETWR': instance.netwr,
      'MWSBP': instance.mwsbp,
      'WAERK': instance.waerk,
      'VBELN': instance.vbeln,
      'POSNR': instance.posnr,
      'ZMIN_QTY': instance.zminQty,
      'ZMESSAGE': instance.zmessage,
      'ZMSG': instance.zmsg,
      'ZSTSTX': instance.zststx,
      'LOEVM': instance.loevm,
      'ORERR': instance.orerr,
      'LOEVM_OR': instance.loevmOr,
      'ZFREE': instance.zfree,
      'ERDAT': instance.erdat,
      'ERZET': instance.erzet,
      'ERNAM': instance.ernam,
      'ERWID': instance.erwid,
      'AEDAT': instance.aedat,
      'AEZET': instance.aezet,
      'AENAM': instance.aenam,
      'AEWID': instance.aewid,
      'MAKTX': instance.maktx,
      'WERKS_NM': instance.werksNm,
      'ZERR': instance.zerr,
      'ZSTATUS': instance.zstatus,
      'UMODE': instance.umode,
      'ZFREE_CHK': instance.zfreeChk,
      'isFromRecentOrder': instance.isFromRecentOrder
    };
