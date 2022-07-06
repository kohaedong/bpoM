/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/et_customer_response_model.dart
 * Created Date: 2022-07-06 22:28:46
 * Last Modified: 2022-07-06 22:35:20
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'package:medsalesportal/model/rfc/et_customer_model.dart';
part 'et_customer_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EtCustomerResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'ET_KUNNR')
  List<EtCustomerModel>? etKunnr;
  EtCustomerResponseModel(this.esReturn, this.etKunnr);
  factory EtCustomerResponseModel.fromJson(Object? json) =>
      _$EtCustomerResponseModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EtCustomerResponseModelToJson(this);
}
