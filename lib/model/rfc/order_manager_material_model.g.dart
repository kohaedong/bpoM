// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_manager_material_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderManagerMaterialModel _$OrderManagerMaterialModelFromJson(
        Map<String, dynamic> json) =>
    OrderManagerMaterialModel(
      json['BOX_UMREZ'] as int?,
      json['EAN11'] as String?,
      json['KBETR1'] as String?,
      json['KBETR2'] as String?,
      json['KWMENG'] as double?,
      json['MAKTX'] as String?,
      json['MATKL'] as String?,
      json['MATNR'] as String?,
      json['MEINS'] as String?,
      json['SET_UMREZ'] as int?,
      json['UMODE'] as String?,
      json['VBAMG'] as double?,
      json['VRKME'] as String?,
      json['WGBEZ'] as String?,
      json['ZRE_CONSOL'] as String?,
      json['ZRE_MAX_QTY'] as double?,
      json['ZRE_MIN_QTY'] as double?,
      json['ZWH_CONSOL'] as String?,
      json['ZWH_MAX_QTY'] as double?,
      json['ZWH_MIN_QTY'] as double?,
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
