/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/model/rfc/et_alarm_count_model.dart
 * Created Date: 2021-10-26 10:13:28
 * Last Modified: 2022-01-08 01:24:08
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'et_alarm_count_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EtAlarmCountModel {
  @JsonKey(name: 'ALARM_CNT')
  String? alarmCnt;
  @JsonKey(name: 'KUNNR_CNT')
  String? kunnrCnt;
  @JsonKey(name: 'ACCNTPLAN_CNT')
  String? accntplanCnt;
  @JsonKey(name: 'SALESOPP_CNT')
  String? salesoppCnt;
  @JsonKey(name: 'CUSTCONSULT_CNT')
  String? custconsultCnt;
  String? rStatus;
  String? rChk;
  String? rSeq;

  EtAlarmCountModel(this.accntplanCnt, this.alarmCnt, this.custconsultCnt,
      this.kunnrCnt, this.rChk, this.rSeq, this.rStatus, this.salesoppCnt);
  factory EtAlarmCountModel.fromJson(Object? json) =>
      _$EtAlarmCountModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EtAlarmCountModelToJson(this);
}
