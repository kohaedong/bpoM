/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/bulk_order_response_model.dart
 * Created Date: 2022-07-17 21:41:25
 * Last Modified: 2022-07-17 21:45:07
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/bulk_order_et_t_list_model.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
part 'bulk_order_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BulkOrderResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_LIST')
  List<BulkOrderEtTListModel>? tList;
  BulkOrderResponseModel(this.esReturn, this.tList);
  factory BulkOrderResponseModel.fromJson(Object? json) =>
      _$BulkOrderResponseModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$BulkOrderResponseModelToJson(this);
}
