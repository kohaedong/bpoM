// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_result_history_page_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitResultHistoryPageResponseModel
    _$VisitResultHistoryPageResponseModelFromJson(Map<String, dynamic> json) =>
        VisitResultHistoryPageResponseModel(
          json['ES_RETURN'] == null
              ? null
              : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
          (json['T_LIST'] as List<dynamic>?)
              ?.map((e) => VisitResultHistoryPageModel.fromJson(e as Object))
              .toList(),
        );

Map<String, dynamic> _$VisitResultHistoryPageResponseModelToJson(
        VisitResultHistoryPageResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'T_LIST': instance.tList?.map((e) => e.toJson()).toList(),
    };
