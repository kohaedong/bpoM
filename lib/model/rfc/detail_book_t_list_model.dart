/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/detail_book_t_list_model.dart
 * Created Date: 2022-07-28 12:24:57
 * Last Modified: 2022-07-28 12:30:53
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'detail_book_t_list_model.g.dart';

@JsonSerializable()
class DetailBookTListModel {
  @JsonKey(name: 'ICLS')
  String? icls;
  @JsonKey(name: 'ITEM')
  String? item;
  @JsonKey(name: 'ICLSNM')
  String? iclsnm;
  @JsonKey(name: 'ITEMNM')
  String? itemnm;
  @JsonKey(name: 'FNAME')
  String? fname;
  @JsonKey(name: 'FILEID')
  String? fileid;
  @JsonKey(name: 'LVORM')
  String? lvorm;
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

  DetailBookTListModel(
      this.aedat,
      this.aenam,
      this.aewid,
      this.aezet,
      this.erdat,
      this.ernam,
      this.fileid,
      this.erwid,
      this.erzet,
      this.fname,
      this.icls,
      this.iclsnm,
      this.item,
      this.itemnm,
      this.lvorm);
  factory DetailBookTListModel.fromJson(Object? json) =>
      _$DetailBookTListModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$DetailBookTListModelToJson(this);
}
