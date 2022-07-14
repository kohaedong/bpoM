// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trans_ledger_es_head_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransLedgerEsHeadModel _$TransLedgerEsHeadModelFromJson(
        Map<String, dynamic> json) =>
    TransLedgerEsHeadModel(
      json['CARD_AMT_E'] as String?,
      json['CARD_AMT_S'] as String?,
      json['CARD_DUE_E'] as int?,
      json['CARD_DUE_S'] as int?,
      json['DMBTR'] as String?,
      json['DMBTR_D'] as String?,
      json['KUNNR'] as String?,
      json['KUNNR_NM'] as String?,
      json['RE_AMT'] as String?,
      json['RE_AMT_T'] as String?,
      json['REAL_AMT_E'] as String?,
      json['REAL_AMT_S'] as String?,
      json['REAL_DUE_E'] as int?,
      json['REAL_DUE_S'] as int?,
      json['SALE_AMT'] as String?,
      json['SALE_AMT_T'] as String?,
      json['WAERK'] as String?,
    );

Map<String, dynamic> _$TransLedgerEsHeadModelToJson(
        TransLedgerEsHeadModel instance) =>
    <String, dynamic>{
      'KUNNR': instance.kunnr,
      'KUNNR_NM': instance.kunnrNm,
      'CARD_AMT_S': instance.cardAmtS,
      'CARD_AMT_E': instance.cardAmtE,
      'CARD_DUE_S': instance.cardDueS,
      'CARD_DUE_E': instance.cardDueE,
      'REAL_AMT_S': instance.realAmtS,
      'REAL_AMT_E': instance.realAmtE,
      'REAL_DUE_S': instance.realDueS,
      'REAL_DUE_E': instance.realDueE,
      'SALE_AMT': instance.saleAmt,
      'RE_AMT': instance.reAmt,
      'DMBTR': instance.dmbtr,
      'DMBTR_D': instance.dmbtrD,
      'SALE_AMT_T': instance.saleAmtT,
      'RE_AMT_T': instance.reAmtT,
      'WAERK': instance.waerk,
    };
