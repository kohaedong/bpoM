/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/bulk_order_detail_search_meta_price_response_model.dart
 * Created Date: 2022-07-25 11:59:31
 * Last Modified: 2022-07-25 12:01:44
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_search_meta_price_model.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
part 'bulk_order_detail_search_meta_price_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BulkOrderDetailSearchMetaPriceResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_LIST')
  List<BulkOrderDetailSearchMetaPriceModel>? tList;

  BulkOrderDetailSearchMetaPriceResponseModel(this.esReturn, this.tList);
  factory BulkOrderDetailSearchMetaPriceResponseModel.fromJson(Object? json) =>
      _$BulkOrderDetailSearchMetaPriceResponseModelFromJson(
          json as Map<String, dynamic>);

  Map<String, dynamic> toJson() =>
      _$BulkOrderDetailSearchMetaPriceResponseModelToJson(this);
}
