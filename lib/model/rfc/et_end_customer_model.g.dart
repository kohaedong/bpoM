// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'et_end_customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtEndCustomerModel _$EtEndCustomerModelFromJson(Map<String, dynamic> json) =>
    EtEndCustomerModel(
      json['DEFPA'] as String?,
      json['KUNNR'] as String?,
      json['KUNNR_NM'] as String?,
      json['ORT01'] as String?,
      json['REGIO'] as String?,
      json['REGIO_NM'] as String?,
      json['STRAS'] as String?,
      json['TELF1'] as String?,
    );

Map<String, dynamic> _$EtEndCustomerModelToJson(EtEndCustomerModel instance) =>
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
