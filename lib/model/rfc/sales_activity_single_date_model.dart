/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_signle_date_model.dart
 * Created Date: 2022-08-01 14:11:01
 * Last Modified: 2022-08-01 14:16:16
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'sales_activity_single_date_model.g.dart';

@JsonSerializable()
class SalesActivitySingleDateModel {
  String? dateStr;
  String? column1;
  String? column2;
  String? column3;
  String? column4;
  SalesActivitySingleDateModel(
      this.dateStr, this.column1, this.column2, this.column3, this.column4);
  factory SalesActivitySingleDateModel.fromJson(Object? json) =>
      _$SalesActivitySingleDateModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalesActivitySingleDateModelToJson(this);
}
