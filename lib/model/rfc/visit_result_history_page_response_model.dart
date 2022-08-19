/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/add_activity_page_history_for_visit_response_model.dart
 * Created Date: 2022-08-19 23:29:22
 * Last Modified: 2022-08-19 23:38:53
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/visit_result_history_page_model.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
part 'visit_result_history_page_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VisitResultHistoryPageResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_LIST')
  List<VisitResultHistoryPageModel>? tList;
  VisitResultHistoryPageResponseModel(this.esReturn, this.tList);
  factory VisitResultHistoryPageResponseModel.fromJson(Object? json) =>
      _$VisitResultHistoryPageResponseModelFromJson(
          json as Map<String, dynamic>);
  Map<String, dynamic> toJson() =>
      _$VisitResultHistoryPageResponseModelToJson(this);
}
