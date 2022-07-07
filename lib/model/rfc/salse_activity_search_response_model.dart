/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/salse_activity_search_response_model.dart
 * Created Date: 2022-07-07 09:45:23
 * Last Modified: 2022-07-07 09:47:33
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'package:medsalesportal/model/rfc/t_list_model.dart';
part 'salse_activity_search_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SalseActivitySearchResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_LIST')
  List<TlistModel>? tList;
  SalseActivitySearchResponseModel(this.esReturn, this.tList);
  factory SalseActivitySearchResponseModel.fromJson(Object? json) =>
      _$SalseActivitySearchResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() =>
      _$SalseActivitySearchResponseModelToJson(this);
}
