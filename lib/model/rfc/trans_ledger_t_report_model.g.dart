// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trans_ledger_t_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransLedgerTReportModel _$TransLedgerTReportModelFromJson(
        Map<String, dynamic> json) =>
    TransLedgerTReportModel(
      json['ARKTX'] as String?,
      json['ATWRT1'] as String?,
      json['ATWRT2'] as String?,
      json['BSCHL_TX'] as String?,
      json['DMBTR_C'] as String?,
      json['DMBTRC'] as int?,
      (json['FKIMG'] as num?)?.toDouble(),
      json['FKIMG_B'] as String?,
      json['FKIMG_C'] as String?,
      (json['FKIMGB'] as num?)?.toDouble(),
      json['KUNNR_END'] as String?,
      json['MATNR'] as String?,
      json['NETWR_T_B'] as String?,
      json['NETWR_T_C'] as String?,
      json['NETWR_T_E'] as String?,
      json['NETWRB'] as int?,
      json['NETWRC'] as int?,
      json['NETWRE'] as int?,
      json['SPMON'] as String?,
      json['VRKME'] as String?,
      (json['ZBALANCE'] as num?)?.toDouble(),
      json['ZBALANCE_C'] as String?,
    );

Map<String, dynamic> _$TransLedgerTReportModelToJson(
        TransLedgerTReportModel instance) =>
    <String, dynamic>{
      'SPMON': instance.spmon,
      'BSCHL_TX': instance.bschlTx,
      'MATNR': instance.matnr,
      'ATWRT1': instance.atwrt1,
      'ARKTX': instance.arktx,
      'ATWRT2': instance.atwrt2,
      'FKIMG_C': instance.fkimgC,
      'NETWR_T_C': instance.netwrTC,
      'FKIMG_B': instance.fkimgB,
      'NETWR_T_B': instance.netwrTB,
      'NETWR_T_E': instance.netwrTE,
      'DMBTR_C': instance.dmbtrC,
      'KUNNR_END': instance.kunnrEnd,
      'VRKME': instance.vrkme,
      'FKIMG': instance.fkimg,
      'FKIMGB': instance.fkimgb,
      'NETWRC': instance.netwrc,
      'NETWRB': instance.netwrb,
      'NETWRE': instance.netwre,
      'DMBTRC': instance.dmbtrc,
      'ZBALANCE': instance.zbalance,
      'ZBALANCE_C': instance.zbalanceC,
    };
