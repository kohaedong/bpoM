/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/model/rfc/table_T_ZLTSP0710_model.dart
 * Created Date: 2022-07-05 10:55:22
 * Last Modified: 2022-07-05 11:03:51
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'table_notice_T_ZLTSP0710_model.g.dart';

@JsonSerializable()
class TableNoticeZLTSP0710Model {
  @JsonKey(name: 'MANDT')
  String? mandt;
  @JsonKey(name: 'NOTICENO')
  String? noticeNo;
  @JsonKey(name: 'NTYPE')
  String? nType;
  @JsonKey(name: 'FRMDT')
  String? frmDt;
  @JsonKey(name: 'TODT')
  String? toDt;
  @JsonKey(name: 'NTITLE')
  String? nTitle;
  @JsonKey(name: 'LVORM')
  String? lvorm;
  @JsonKey(name: 'ERDAT')
  String? erdat;
  @JsonKey(name: 'ERZET')
  String? erzet;
  @JsonKey(name: 'ERNAM')
  String? erNam;
  @JsonKey(name: 'ERWID')
  String? erwId;
  @JsonKey(name: 'AEDAT')
  String? aedat;
  @JsonKey(name: 'AEZET')
  String? aezet;
  @JsonKey(name: 'AENAM')
  String? aenam;
  @JsonKey(name: 'AEWID')
  String? aewId;
  @JsonKey(name: 'SANUM_NM')
  String? sanumNm;

  TableNoticeZLTSP0710Model(
      this.aedat,
      this.aenam,
      this.aewId,
      this.aezet,
      this.erNam,
      this.erdat,
      this.erwId,
      this.erzet,
      this.frmDt,
      this.lvorm,
      this.mandt,
      this.nTitle,
      this.nType,
      this.noticeNo,
      this.sanumNm,
      this.toDt);
  factory TableNoticeZLTSP0710Model.fromJson(Object? json) =>
      _$TableNoticeZLTSP0710ModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$TableNoticeZLTSP0710ModelToJson(this);
}
