/*
 * Project Name:  [koreaJob]
 * File: /Users/bakbeom/work/sm/si/bpom/lib/model/notice/notice_settings_data_model.dart
 * Created Date: 2022-11-12 12:51:45
 * Last Modified: 2022-11-12 12:59:16
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  MOMONETWORK ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:json_annotation/json_annotation.dart';
part 'notice_settings_data_model.g.dart';

@JsonSerializable()
class NoticeSettingsDataModel {
  int? id;
  int? appGrpId;
  String? userId;
  String? notiUseYn;
  String? stopNotiTimeUseYn;
  String? stopNotiTimeBeginTime;
  String? stopNotiTimeEndTime;
  String? creatrId;
  String? modrId;
  DateTime? creatDttm;
  DateTime? modDttm;

  NoticeSettingsDataModel(
      this.id,
      this.appGrpId,
      this.creatDttm,
      this.creatrId,
      this.modDttm,
      this.modrId,
      this.notiUseYn,
      this.stopNotiTimeBeginTime,
      this.stopNotiTimeEndTime,
      this.stopNotiTimeUseYn,
      this.userId);
  factory NoticeSettingsDataModel.fromJson(Object? json) =>
      _$NoticeSettingsDataModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$NoticeSettingsDataModelToJson(this);
}
