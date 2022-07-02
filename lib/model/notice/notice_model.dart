import 'package:json_annotation/json_annotation.dart';
part 'notice_model.g.dart';

@JsonSerializable()
class NoticeModel {
  int? id;
  String? appGrpIdParticipant;
  String? targetParticipant;
  String? appNtcGbCd;
  String? appNtcSbjctNm;
  String? appCbgtYn;
  DateTime? ntcBltnDttm;
  DateTime? ntcEndDttm;
  String? ntcTmpltCd;
  String? ntcDscr;
  String? ntcLnkAddr;
  String? relyAppId;
  String? recnfrmYn;
  String? relyAppPackageNm;
  String? relyAppSchm;
  String? modrId;
  DateTime? modDttm;
  String? creatrId;
  String? creatrNm;
  DateTime? creatDttm;
  bool? ext;

  NoticeModel(
      this.id,
      this.appGrpIdParticipant,
      this.targetParticipant,
      this.appNtcGbCd,
      this.appNtcSbjctNm,
      this.appCbgtYn,
      this.ntcBltnDttm,
      this.ntcEndDttm,
      this.ntcTmpltCd,
      this.ntcDscr,
      this.ntcLnkAddr,
      this.relyAppId,
      this.recnfrmYn,
      this.relyAppPackageNm,
      this.relyAppSchm,
      this.modrId,
      this.modDttm,
      this.creatrId,
      this.creatrNm,
      this.creatDttm,
      this.ext);

  factory NoticeModel.fromJson(Object? json) =>
      _$NoticeModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$NoticeModelToJson(this);
}
