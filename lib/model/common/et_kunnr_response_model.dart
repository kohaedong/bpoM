/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/model/rfc/et_customer_response_model.dart
 * Created Date: 2022-07-06 22:28:46
 * Last Modified: 2022-11-15 11:04:21
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:bpom/model/common/es_return_model.dart';
import 'package:bpom/model/common/et_kunnr_model.dart';
part 'et_kunnr_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EtKunnrResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'ET_KUNNR')
  List<EtKunnrModel>? etKunnr;
  EtKunnrResponseModel(this.esReturn, this.etKunnr);
  factory EtKunnrResponseModel.fromJson(Object? json) =>
      _$EtKunnrResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$EtKunnrResponseModelToJson(this);
}
