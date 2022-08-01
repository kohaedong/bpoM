/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/search_key_response_model.dart
 * Created Date: 2022-08-01 14:49:42
 * Last Modified: 2022-08-01 14:54:25
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'package:medsalesportal/model/rfc/search_key_for_business_group_model.dart';
import 'package:medsalesportal/model/rfc/search_key_for_partment_model.dart';
part 'search_key_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchKeyResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_LIST')
  List<SearchKeyForPartmentModel>? tList;
  @JsonKey(name: 'T_LIST2')
  List<SearchKeyForBusinessGroupModel>? tList2;
  SearchKeyResponseModel(this.esReturn, this.tList, this.tList2);
  factory SearchKeyResponseModel.fromJson(Object? json) =>
      _$SearchKeyResponseModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$SearchKeyResponseModelToJson(this);
}
