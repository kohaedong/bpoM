/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/model/rfc/add_activity_key_man_response_model.dart
 * Created Date: 2022-08-15 10:56:06
 * Last Modified: 2022-11-15 11:15:59
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:bpom/model/common/add_activity_key_man_model.dart';
import 'package:bpom/model/common/es_return_model.dart';
part 'add_activity_key_man_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AddActivityKeyManResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'ET_LIST')
  List<AddActivityKeyManModel>? etList;
  AddActivityKeyManResponseModel(this.esReturn, this.etList);
  factory AddActivityKeyManResponseModel.fromJson(Object? json) =>
      _$AddActivityKeyManResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AddActivityKeyManResponseModelToJson(this);
}
