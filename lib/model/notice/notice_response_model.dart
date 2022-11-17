import 'package:json_annotation/json_annotation.dart';
import 'package:bpom/model/notice/notice_model.dart';
part 'notice_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NoticeResponseModel {
  List<NoticeModel?> noticeFullScreen;
  List<NoticeModel?> noticeWorking;
  List<NoticeModel?> noticePopup;
  List<NoticeModel?> noticeError;
  List<NoticeModel?> noticeSurvey;
  List<int?> noticeOrder;
  List<NoticeModel?> noticeUrl;
  NoticeResponseModel(
      this.noticeFullScreen,
      this.noticeWorking,
      this.noticePopup,
      this.noticeError,
      this.noticeSurvey,
      this.noticeOrder,
      this.noticeUrl);
  factory NoticeResponseModel.fromJson(Object? json) =>
      _$NoticeResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$NoticeResponseModelToJson(this);
}
