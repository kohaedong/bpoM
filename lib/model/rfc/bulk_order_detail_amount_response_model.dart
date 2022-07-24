/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/bulk_order_detail_amount_response_model.dart
 * Created Date: 2022-07-24 18:22:33
 * Last Modified: 2022-07-24 18:25:43
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_amount_available_model.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
part 'bulk_order_detail_amount_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BulkOrderDetailAmountResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_CREDIT_LIMIT')
  List<BulkOrderDetailAmountAvaliableModel>? tCreditLimit;

  BulkOrderDetailAmountResponseModel(this.esReturn, this.tCreditLimit);
  factory BulkOrderDetailAmountResponseModel.fromJson(Object? json) =>
      _$BulkOrderDetailAmountResponseModelFromJson(
          json as Map<String, dynamic>);
  Map<String, dynamic> toJson() =>
      _$BulkOrderDetailAmountResponseModelToJson(this);
}
