// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_order_detail_search_meta_price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkOrderDetailSearchMetaPriceModel
    _$BulkOrderDetailSearchMetaPriceModelFromJson(Map<String, dynamic> json) =>
        BulkOrderDetailSearchMetaPriceModel(
          boxUmrez: json['BOX_UMREZ'] as int?,
          ean11: json['EAN11'] as String?,
          kwmeng: (json['KWMENG'] as num?)?.toDouble(),
          mainQty: (json['ZMIN_QTY'] as num?)?.toDouble(),
          maktx: json['MAKTX'] as String?,
          matnr: json['MATNR'] as String?,
          mwsbp: (json['MWSBP'] as num?)?.toDouble(),
          netpr: (json['NETPR'] as num?)?.toDouble(),
          netwr: (json['NETWR'] as num?)?.toDouble(),
          setUmrez: json['SET_UMREZ'] as int?,
          vrkme: json['VRKME'] as String?,
          waerk: json['WAERK'] as String?,
          werks: json['WERKS'] as String?,
          werksNm: json['WERKS_NM'] as String?,
          zdisPrice: (json['ZDIS_PRICE'] as num?)?.toDouble(),
          zdisRate: (json['ZDIS_RATE'] as num?)?.toDouble(),
          zerr: json['ZERR'] as String?,
          zfreeQty: (json['ZFREE_QTY'] as num?)?.toDouble(),
          zfreeQtyIn: (json['ZFREE_QTY_IN'] as num?)?.toDouble(),
          zmsg: json['ZMSG'] as String?,
          znetpr: (json['ZNETPR'] as num?)?.toDouble(),
        );

Map<String, dynamic> _$BulkOrderDetailSearchMetaPriceModelToJson(
        BulkOrderDetailSearchMetaPriceModel instance) =>
    <String, dynamic>{
      'MATNR': instance.matnr,
      'MAKTX': instance.maktx,
      'WERKS': instance.werks,
      'WERKS_NM': instance.werksNm,
      'KWMENG': instance.kwmeng,
      'NETPR': instance.netpr,
      'ZDIS_RATE': instance.zdisRate,
      'ZDIS_PRICE': instance.zdisPrice,
      'ZFREE_QTY': instance.zfreeQty,
      'ZFREE_QTY_IN': instance.zfreeQtyIn,
      'VRKME': instance.vrkme,
      'ZNETPR': instance.znetpr,
      'NETWR': instance.netwr,
      'MWSBP': instance.mwsbp,
      'WAERK': instance.waerk,
      'ZMIN_QTY': instance.mainQty,
      'ZMSG': instance.zmsg,
      'ZERR': instance.zerr,
      'SET_UMREZ': instance.setUmrez,
      'BOX_UMREZ': instance.boxUmrez,
      'EAN11': instance.ean11,
    };
