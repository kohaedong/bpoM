// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trans_ledger_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransLedgerResponseModel _$TransLedgerResponseModelFromJson(
        Map<String, dynamic> json) =>
    TransLedgerResponseModel(
      json['ES_HEAD'] == null
          ? null
          : TransLedgerEsHeadModel.fromJson(json['ES_HEAD'] as Object),
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['T_LIST'] as List<dynamic>?)
          ?.map((e) => TransLedgerTListModel.fromJson(e as Object))
          .toList(),
      (json['T_REPORT'] as List<dynamic>?)
          ?.map((e) => TransLedgerTReportModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$TransLedgerResponseModelToJson(
        TransLedgerResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'ES_HEAD': instance.esHead?.toJson(),
      'T_LIST': instance.tList?.map((e) => e.toJson()).toList(),
      'T_REPORT': instance.tReport?.map((e) => e.toJson()).toList(),
    };
