/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/model/rfc/et_alarm_count_response_model.dart
 * Created Date: 2021-10-26 13:34:36
 * Last Modified: 2022-07-02 14:43:23
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'et_alarm_count_model.dart';
part 'et_alarm_count_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EtAlarmCountResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'ET_BASESUMMARY')
  List<EtAlarmCountModel?> model;

  EtAlarmCountResponseModel(this.esReturn, this.model);
  factory EtAlarmCountResponseModel.fromJson(Object? json) =>
      _$EtAlarmCountResponseModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EtAlarmCountResponseModelToJson(this);
}
