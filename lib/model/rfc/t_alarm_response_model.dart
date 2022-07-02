/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/model/rfc/t_alarm_response_model.dart
 * Created Date: 2021-09-08 14:33:52
 * Last Modified: 2022-07-02 13:58:26
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
part 't_alarm_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TalarmResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_ALARM')
  List<TAlarmModel>? list;
  TalarmResponseModel(this.list, this.esReturn);
  factory TalarmResponseModel.fromJson(Object? json) =>
      _$TalarmResponseModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$TalarmResponseModelToJson(this);
}
