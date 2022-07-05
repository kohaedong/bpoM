/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/t_text_model.dart
 * Created Date: 2022-07-05 15:50:19
 * Last Modified: 2022-07-05 16:04:24
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 't_text_model.g.dart';

@JsonSerializable()
class TTextModel {
  @JsonKey(name: 'MANDT')
  String? mandt;
  @JsonKey(name: 'OBJNR')
  String? objnr;
  @JsonKey(name: 'CDGRP')
  String? cdgrp;
  @JsonKey(name: 'CDITM')
  String? cditm;
  @JsonKey(name: 'SEQNO')
  String? seqNo;
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
  TTextModel(
      this.aedat,
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
      this.seqNo,
      this.umode,
      this.ztext);
  factory TTextModel.fromJson(Object? json) =>
      _$TTextModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$TTextModelToJson(this);
}
