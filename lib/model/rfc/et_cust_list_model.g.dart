// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'et_cust_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtCustListModel _$EtCustListModelFromJson(Map<String, dynamic> json) =>
    EtCustListModel(
      json['KUNNR'] as String?,
      json['KUNNR_NM'] as String?,
      json['REGIO'] as String?,
      json['REGIO_NM'] as String?,
      json['ORT01'] as String?,
      json['STRAS'] as String?,
      json['TELF1'] as String?,
      json['DEFPA'] as String?,
    );

Map<String, dynamic> _$EtCustListModelToJson(EtCustListModel instance) =>
    <String, dynamic>{
      'KUNNR': instance.kunnr,
      'KUNNR_NM': instance.kunnrNm,
      'REGIO': instance.regio,
      'REGIO_NM': instance.regioNm,
      'ORT01': instance.ort01,
      'STRAS': instance.stras,
      'TELF1': instance.telf1,
      'DEFPA': instance.defpa,
    };
