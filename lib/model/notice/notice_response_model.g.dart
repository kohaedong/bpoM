// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeResponseModel _$NoticeResponseModelFromJson(Map<String, dynamic> json) =>
    NoticeResponseModel(
      (json['noticeFullScreen'] as List<dynamic>)
          .map((e) => e == null ? null : NoticeModel.fromJson(e as Object))
          .toList(),
      (json['noticeWorking'] as List<dynamic>)
          .map((e) => e == null ? null : NoticeModel.fromJson(e as Object))
          .toList(),
      (json['noticePopup'] as List<dynamic>)
          .map((e) => e == null ? null : NoticeModel.fromJson(e as Object))
          .toList(),
      (json['noticeError'] as List<dynamic>)
          .map((e) => e == null ? null : NoticeModel.fromJson(e as Object))
          .toList(),
      (json['noticeSurvey'] as List<dynamic>)
          .map((e) => e == null ? null : NoticeModel.fromJson(e as Object))
          .toList(),
      (json['noticeOrder'] as List<dynamic>).map((e) => e as int?).toList(),
      (json['noticeUrl'] as List<dynamic>)
          .map((e) => e == null ? null : NoticeModel.fromJson(e as Object))
          .toList(),
    );

Map<String, dynamic> _$NoticeResponseModelToJson(
        NoticeResponseModel instance) =>
    <String, dynamic>{
      'noticeFullScreen':
          instance.noticeFullScreen.map((e) => e?.toJson()).toList(),
      'noticeWorking': instance.noticeWorking.map((e) => e?.toJson()).toList(),
      'noticePopup': instance.noticePopup.map((e) => e?.toJson()).toList(),
      'noticeError': instance.noticeError.map((e) => e?.toJson()).toList(),
      'noticeSurvey': instance.noticeSurvey.map((e) => e?.toJson()).toList(),
      'noticeOrder': instance.noticeOrder,
      'noticeUrl': instance.noticeUrl.map((e) => e?.toJson()).toList(),
    };
