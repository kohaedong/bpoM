/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/notice_detail_response_model.dart
 * Created Date: 2022-07-05 15:48:32
 * Last Modified: 2022-11-15 11:18:50
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:bpom/model/common/es_return_model.dart';
import 'package:bpom/model/notice/t_text_model.dart';
import 'package:bpom/model/notice/t_vkgrp_model.dart';
import 'package:bpom/model/notice/table_notice_T_ZLTSP0710_model.dart';

part 'home_notice_detail_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HomeNoticeDetailResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_TEXT')
  List<TTextModel>? tText;
  @JsonKey(name: 'T_VKGRP')
  List<TVkgrpModel>? tVkgrp;
  @JsonKey(name: 'T_ZLTSP0700')
  List<TableNoticeZLTSP0710Model>? tZLTSP0700;
  HomeNoticeDetailResponseModel(
      this.esReturn, this.tVkgrp, this.tZLTSP0700, this.tText);
  factory HomeNoticeDetailResponseModel.fromJson(Object? json) =>
      _$HomeNoticeDetailResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$HomeNoticeDetailResponseModelToJson(this);
}
