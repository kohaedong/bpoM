/*
 * Project Name:  [koreaJob]
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/pushNotification/notification_message_model.dart
 * Created Date: 2022-11-02 17:30:53
 * Last Modified: 2022-11-02 17:38:27
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  MOMONETWORK ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:json_annotation/json_annotation.dart';
part 'notification_message_model.g.dart';

@JsonSerializable()
class NotificationMessageModel {
  int? badge;
  String? link;
  String? title;
  String? message;
  NotificationMessageModel(this.badge, this.link, this.title, this.message);
  factory NotificationMessageModel.fromJson(Object? json) =>
      _$NotificationMessageModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$NotificationMessageModelToJson(this);
}
