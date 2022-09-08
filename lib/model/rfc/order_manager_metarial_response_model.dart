/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/order_manager_metarial_response_model.dart
 * Created Date: 2022-09-08 11:11:37
 * Last Modified: 2022-09-08 11:15:46
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'package:medsalesportal/model/rfc/order_manager_material_model.dart';
part 'order_manager_metarial_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderManagerMetarialResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'ET_OUTPUT')
  List<OrderManagerMaterialModel>? etOutput;
  OrderManagerMetarialResponseModel(this.esReturn, this.etOutput);
  factory OrderManagerMetarialResponseModel.fromJson(Object? json) =>
      _$OrderManagerMetarialResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() =>
      _$OrderManagerMetarialResponseModelToJson(this);
}
