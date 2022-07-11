/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/cust_list_response_model.dart
 * Created Date: 2022-07-11 11:36:08
 * Last Modified: 2022-07-11 11:39:32
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/et_cust_list_model.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
part 'et_cust_list_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EtCustListResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'ET_CUSTLIST')
  List<EtCustListModel>? etCustList;

  EtCustListResponseModel(this.esReturn, this.etCustList);
  factory EtCustListResponseModel.fromJson(Object? json) =>
      _$EtCustListResponseModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EtCustListResponseModelToJson(this);
}
