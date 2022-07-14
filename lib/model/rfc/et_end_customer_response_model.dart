/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/et_end_customer_response_model.dart
 * Created Date: 2022-07-14 16:55:54
 * Last Modified: 2022-07-14 16:58:24
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'package:medsalesportal/model/rfc/et_end_customer_model.dart';
part 'et_end_customer_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EtEndCustomerResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'ET_CUSTLIST')
  List<EtEndCustomerModel>? etCustList;
  EtEndCustomerResponseModel(this.esReturn, this.etCustList);
  factory EtEndCustomerResponseModel.fromJson(Object? json) =>
      _$EtEndCustomerResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$EtEndCustomerResponseModelToJson(this);
}
