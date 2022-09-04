/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/model/rfc/t_customer_report_model_text_model.dart
 * Created Date: 2021-09-26 13:37:38
 * Last Modified: 2022-09-04 16:08:43
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'recent_order_t_text_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RecentOrderTTextModel {
  @JsonKey(name: 'MANDT')
  String? mandt;
  @JsonKey(name: 'OBJNR')
  String? objnr;
  @JsonKey(name: 'CDGRP')
  String? cdgrp;
  @JsonKey(name: 'CDITM')
  String? cditm;
  @JsonKey(name: 'SEQNO')
  String? seqno;
  @JsonKey(name: 'ZTEXT')
  String? ztext;
  @JsonKey(name: 'ERDAT')
  String? erdat;
  @JsonKey(name: 'ERZET')
  String? erzet;
  @JsonKey(name: 'ERNAM')
  String? ernam;
  @JsonKey(name: 'ERWID')
  String? erwid;
  @JsonKey(name: 'AEDAT')
  String? aedat;
  @JsonKey(name: 'AEZET')
  String? aezet;
  @JsonKey(name: 'AENAM')
  String? aenam;
  @JsonKey(name: 'AEWID')
  String? aewid;
  @JsonKey(name: 'UMODE')
  String? umode;
  @JsonKey(name: 'rStatus')
  String? rStatus;
  @JsonKey(name: 'rChk')
  String? rChk;
  @JsonKey(name: 'rSeq')
  String? rSeq;

  RecentOrderTTextModel(
      {this.aedat,
      this.aenam,
      this.aewid,
      this.aezet,
      this.cdgrp,
      this.cditm,
      this.erdat,
      this.ernam,
      this.erwid,
      this.erzet,
      this.mandt,
      this.objnr,
      this.rChk,
      this.rSeq,
      this.rStatus,
      this.seqno,
      this.umode,
      this.ztext});

  factory RecentOrderTTextModel.fromJson(Object? json) =>
      _$RecentOrderTTextModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$RecentOrderTTextModelToJson(this);
}
