// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_activity_suggetion_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddActivitySuggetionItemModel _$AddActivitySuggetionItemModelFromJson(
        Map<String, dynamic> json) =>
    AddActivitySuggetionItemModel(
      kbetr1: json['KBETR1'] as String?,
      kbetr2: json['KBETR2'] as String?,
      maktx: json['MAKTX'] as String?,
      matkl: json['MATKL'] as String?,
      matnr: json['MATNR'] as String?,
      umode: json['UMODE'] as String?,
      wgbez: json['WGBEZ'] as String?,
      isChecked: json['isChecked'] as bool?,
    );

Map<String, dynamic> _$AddActivitySuggetionItemModelToJson(
        AddActivitySuggetionItemModel instance) =>
    <String, dynamic>{
      'MATNR': instance.matnr,
      'MAKTX': instance.maktx,
      'MATKL': instance.matkl,
      'WGBEZ': instance.wgbez,
      'KBETR1': instance.kbetr1,
      'KBETR2': instance.kbetr2,
      'UMODE': instance.umode,
      'isChecked': instance.isChecked,
    };
