/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/model/rfc/add_activity_key_man_model.dart
 * Created Date: 2022-08-15 10:47:56
 * Last Modified: 2022-08-16 22:08:24
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'add_activity_key_man_model.g.dart';

@JsonSerializable()
class AddActivityKeyManModel {
  @JsonKey(name: 'ZSKUNNR')
  String? zskunnr;
  @JsonKey(name: 'ZSKUNNR_NM')
  String? zskunnrNm;
  @JsonKey(name: 'ZKMNO')
  String? zkmno;
  @JsonKey(name: 'ZKMNO_NM')
  String? zkmnoNm;
  @JsonKey(name: 'ZKMTRUST')
  String? zkmTrust;
  @JsonKey(name: 'XREPKM')
  String? xrepkm;
  @JsonKey(name: 'ZKMTYPE')
  String? zkmType;
  @JsonKey(name: 'ZTRAITMENT')
  String? zTraitment;
  @JsonKey(name: 'TELF2')
  String? telf2;
  @JsonKey(name: 'ZEMAIL')
  String? zeMail;
  @JsonKey(name: 'ZADD_NAME1')
  String? zaddName1;
  @JsonKey(name: 'ZADD_NAME2')
  String? zaddName2;
  AddActivityKeyManModel(
      {this.telf2,
      this.xrepkm,
      this.zTraitment,
      this.zaddName1,
      this.zaddName2,
      this.zeMail,
      this.zkmTrust,
      this.zkmType,
      this.zkmno,
      this.zkmnoNm,
      this.zskunnr,
      this.zskunnrNm});
  factory AddActivityKeyManModel.fromJson(Object? json) =>
      _$AddActivityKeyManModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AddActivityKeyManModelToJson(this);
}
