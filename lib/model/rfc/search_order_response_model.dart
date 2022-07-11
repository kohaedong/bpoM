/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/search_order_response_model.dart
 * Created Date: 2022-07-11 12:45:38
 * Last Modified: 2022-07-11 12:49:42
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'package:medsalesportal/model/rfc/t_list_search_order_model.dart';
part 'search_order_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchOrderResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_LIST')
  List<TlistSearchOrderModel>? tList;
  SearchOrderResponseModel(this.esReturn, this.tList);
  factory SearchOrderResponseModel.fromJson(Object? json) =>
      _$SearchOrderResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SearchOrderResponseModelToJson(this);
}
