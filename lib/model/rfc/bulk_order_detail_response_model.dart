/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/bulk_order_detail_response_model.dart
 * Created Date: 2022-07-21 15:13:16
 * Last Modified: 2022-07-21 16:02:47
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_t_header_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_t_item_model.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
part 'bulk_order_detail_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BulkOrderDetailResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_HEAD')
  List<BulkOrderDetailTHeaderModel>? tHead;
  @JsonKey(name: 'T_ITEM')
  List<BulkOrderDetailTItemModel>? tItem;
  BulkOrderDetailResponseModel(this.esReturn, this.tHead, this.tItem);
  factory BulkOrderDetailResponseModel.fromJson(Object? json) =>
      _$BulkOrderDetailResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BulkOrderDetailResponseModelToJson(this);
}
