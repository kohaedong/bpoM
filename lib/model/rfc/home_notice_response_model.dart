/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/home_notice_response_model.dart
 * Created Date: 2022-07-05 11:06:29
 * Last Modified: 2022-07-05 15:09:37
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'package:medsalesportal/model/rfc/table_notice_T_ZLTSP0710_model.dart';
part 'home_notice_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HomeNoticeResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_ZLTSP0710')
  List<TableNoticeZLTSP0710Model>? tZltsp0710;
  HomeNoticeResponseModel(this.esReturn, this.tZltsp0710);
  factory HomeNoticeResponseModel.fromJson(Object? json) =>
      _$HomeNoticeResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$HomeNoticeResponseModelToJson(this);
}
