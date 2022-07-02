/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/model/rfc/alarm_confirm_response_model.dart
 * Created Date: 2022-01-12 16:40:45
 * Last Modified: 2022-07-02 14:44:02
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'package:medsalesportal/model/rfc/t_alarm_model.dart';
part 'alarm_confirm_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AlamConfirmResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_ALARM')
  List<TAlarmModel>? alarmList;
  AlamConfirmResponseModel(this.esReturn, this.alarmList);
  factory AlamConfirmResponseModel.fromJson(Object? json) =>
      _$AlamConfirmResponseModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$AlamConfirmResponseModelToJson(this);
}
