// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'et_staff_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtStaffListResponseModel _$EtStaffListResponseModelFromJson(
        Map<String, dynamic> json) =>
    EtStaffListResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      (json['ET_STAFFLIST'] as List<dynamic>?)
          ?.map((e) => EtStaffListModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$EtStaffListResponseModelToJson(
        EtStaffListResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturn?.toJson(),
      'ET_STAFFLIST': instance.staffList?.map((e) => e.toJson()).toList(),
    };
