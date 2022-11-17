/*
 * Project Name:  [koreaJob]
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/notice/notice_settings_response_data.dart
 * Created Date: 2022-11-12 13:01:33
 * Last Modified: 2022-11-12 13:13:16
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  MOMONETWORK ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:bpom/model/notice/notice_settings_data_model.dart';
part 'notice_settings_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NoticeSettingsResponseModel {
  String? code;
  String? message;
  NoticeSettingsDataModel? data;
  NoticeSettingsResponseModel(this.code, this.message, this.data);
  factory NoticeSettingsResponseModel.fromJson(Object? json) =>
      _$NoticeSettingsResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$NoticeSettingsResponseModelToJson(this);
}
