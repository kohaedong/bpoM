/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_month_response_model.dart
 * Created Date: 2022-08-01 14:17:02
 * Last Modified: 2022-08-01 14:20:47
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_weeks_model.dart';
part 'sales_activity_month_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SalesActivityMonthResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_LIST')
  List<SalesActivityWeeksModel>? tList;

  SalesActivityMonthResponseModel(this.esReturn, this.tList);
  factory SalesActivityMonthResponseModel.fromJson(Object? json) =>
      _$SalesActivityMonthResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() =>
      _$SalesActivityMonthResponseModelToJson(this);
}
