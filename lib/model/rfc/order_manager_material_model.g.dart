// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_manager_material_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderManagerMaterialModel _$OrderManagerMaterialModelFromJson(
        Map<String, dynamic> json) =>
    OrderManagerMaterialModel(
      boxUmrez: json['BOX_UMREZ'] as int?,
      ean11: json['EAN11'] as String?,
      kbetr1: json['KBETR1'] as String?,
      kbetr2: json['KBETR2'] as String?,
      kwmeng: (json['KWMENG'] as num?)?.toDouble(),
      maktx: json['MAKTX'] as String?,
      matkl: json['MATKL'] as String?,
      matnr: json['MATNR'] as String?,
      meins: json['MEINS'] as String?,
      setUmrez: json['SET_UMREZ'] as int?,
      umode: json['UMODE'] as String?,
      vbamg: (json['VBAMG'] as num?)?.toDouble(),
      vrkme: json['VRKME'] as String?,
      wgbez: json['WGBEZ'] as String?,
      zreConsol: json['ZRE_CONSOL'] as String?,
      zreMaxQty: (json['ZRE_MAX_QTY'] as num?)?.toDouble(),
      zreMinQty: (json['ZRE_MIN_QTY'] as num?)?.toDouble(),
      zwhConsol: json['ZWH_CONSOL'] as String?,
      zwhMaxQty: (json['ZWH_MAX_QTY'] as num?)?.toDouble(),
      zwhMinWty: (json['ZWH_MIN_QTY'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OrderManagerMaterialModelToJson(
        OrderManagerMaterialModel instance) =>
    <String, dynamic>{
      'MATNR': instance.matnr,
      'MAKTX': instance.maktx,
      'MATKL': instance.matkl,
      'WGBEZ': instance.wgbez,
      'KBETR1': instance.kbetr1,
      'KBETR2': instance.kbetr2,
      'UMODE': instance.umode,
      'VRKME': instance.vrkme,
      'ZRE_MIN_QTY': instance.zreMinQty,
      'ZRE_MAX_QTY': instance.zreMaxQty,
      'ZRE_CONSOL': instance.zreConsol,
      'ZWH_MIN_QTY': instance.zwhMinWty,
      'ZWH_MAX_QTY': instance.zwhMaxQty,
      'ZWH_CONSOL': instance.zwhConsol,
      'VBAMG': instance.vbamg,
      'KWMENG': instance.kwmeng,
      'MEINS': instance.meins,
      'SET_UMREZ': instance.setUmrez,
      'BOX_UMREZ': instance.boxUmrez,
      'EAN11': instance.ean11,
    };
