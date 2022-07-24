/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/bulk_order_detail_amount_available_model.dart
 * Created Date: 2022-07-24 18:20:48
 * Last Modified: 2022-07-24 18:23:00
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'bulk_order_detail_amount_available_model.g.dart';

@JsonSerializable()
class BulkOrderDetailAmountAvaliableModel {
  @JsonKey(name: 'AMOUNT')
  String? amount;
  BulkOrderDetailAmountAvaliableModel(this.amount);
  factory BulkOrderDetailAmountAvaliableModel.fromJson(Object? json) =>
      _$BulkOrderDetailAmountAvaliableModelFromJson(
          json as Map<String, dynamic>);
  Map<String, dynamic> toJson() =>
      _$BulkOrderDetailAmountAvaliableModelToJson(this);
}
