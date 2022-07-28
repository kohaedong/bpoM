/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/detail_book_response_model.dart
 * Created Date: 2022-07-28 12:38:45
 * Last Modified: 2022-07-28 12:40:46
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/detail_book_t_list_model.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
part 'detail_book_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DetailBookResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_LIST')
  List<DetailBookTListModel>? tList;

  DetailBookResponseModel(this.esReturn, this.tList);
  factory DetailBookResponseModel.fromJson(Object? json) =>
      _$DetailBookResponseModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$DetailBookResponseModelToJson(this);
}
