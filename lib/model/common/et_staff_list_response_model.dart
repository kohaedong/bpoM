/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/model/rfc/et_staff_list_response_model.dart
 * Created Date: 2021-09-23 14:15:23
 * Last Modified: 2022-11-15 11:01:51
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:bpom/model/common/es_return_model.dart';

import './et_staff_list_model.dart';
part 'et_staff_list_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EtStaffListResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;

  @JsonKey(name: 'ET_STAFFLIST')
  List<EtStaffListModel>? staffList;

  EtStaffListResponseModel(this.esReturn, this.staffList);
  factory EtStaffListResponseModel.fromJson(Object? json) =>
      _$EtStaffListResponseModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EtStaffListResponseModelToJson(this);
}
