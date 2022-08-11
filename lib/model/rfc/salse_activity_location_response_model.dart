/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/salse_activity_location_response_model.dart
 * Created Date: 2022-08-11 14:40:56
 * Last Modified: 2022-08-11 14:44:34
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'package:medsalesportal/model/rfc/salse_activity_location_model.dart';
part 'salse_activity_location_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SalseActivityLocationResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_LIST')
  List<SalseActivityLocationModel>? tList;
  SalseActivityLocationResponseModel(this.esReturn, this.tList);
  factory SalseActivityLocationResponseModel.fromJson(Object? json) =>
      _$SalseActivityLocationResponseModelFromJson(
          json as Map<String, dynamic>);
  Map<String, dynamic> toJson() =>
      _$SalseActivityLocationResponseModelToJson(this);
}
