/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/model/rfc/add_activity_suggetion_response_model.dart
 * Created Date: 2022-08-17 20:21:35
 * Last Modified: 2022-11-15 11:16:11
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:bpom/model/common/add_activity_suggetion_item_model.dart';
import 'package:bpom/model/common/es_return_model.dart';
part 'add_activity_suggetion_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AddActivitySuggetionResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'ET_OUTPUT')
  List<AddActivitySuggetionItemModel>? etOutput;
  AddActivitySuggetionResponseModel(this.esReturn, this.etOutput);
  factory AddActivitySuggetionResponseModel.fromJson(Object? json) =>
      _$AddActivitySuggetionResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() =>
      _$AddActivitySuggetionResponseModelToJson(this);
}
