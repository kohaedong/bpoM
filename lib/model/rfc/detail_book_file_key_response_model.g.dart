// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_book_file_key_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailBookFileKeyResponseModel _$DetailBookFileKeyResponseModelFromJson(
        Map<String, dynamic> json) =>
    DetailBookFileKeyResponseModel(
      json['ES_RETURN'] == null
          ? null
          : EsReturnModel.fromJson(json['ES_RETURN'] as Object),
      json['ATTACH_INFO'] == null
          ? null
          : DetailBookAttachInfoModel.fromJson(json['ATTACH_INFO'] as Object),
    );

Map<String, dynamic> _$DetailBookFileKeyResponseModelToJson(
        DetailBookFileKeyResponseModel instance) =>
    <String, dynamic>{
      'ES_RETURN': instance.esReturnModel,
      'ATTACH_INFO': instance.attachInfo,
    };
