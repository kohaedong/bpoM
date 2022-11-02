/*
 * Project Name:  [koreaJob]
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/pushNoticefacation/notifacation_model.dart
 * Created Date: 2022-11-02 16:51:02
 * Last Modified: 2022-11-02 22:23:20
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  MOMONETWORK ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'notification_noti_model.g.dart';

@JsonSerializable()
class NotificationDataModel {
  int? badge;
  String? sound;
  String? icon;
  String? title;
  String? body;
  @JsonKey(name: 'mutable-content')
  int? mutableContent;

  NotificationDataModel(this.badge, this.body, this.icon, this.mutableContent,
      this.sound, this.title);
  factory NotificationDataModel.fromJson(Object? json) =>
      _$NotificationDataModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$NotificationDataModelToJson(this);
}
