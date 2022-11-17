/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sap_login_info_model.dart
 * Created Date: 2022-07-04 14:48:28
 * Last Modified: 2022-11-15 11:02:17
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:bpom/model/common/es_login_model.dart';
import 'package:bpom/model/common/et_orghk_model.dart';
import 'package:bpom/model/commonCode/t_code_model.dart';
import 'package:bpom/model/common/es_return_model.dart';

part 'sap_login_info_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SapLoginInfoDataModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'ES_LOGIN')
  EsLoginModel? esLogin;
  @JsonKey(name: 'ET_ORGHK')
  List<EtOrghkModel>? etOrghk;
  @JsonKey(name: 'T_CODE')
  List<TCodeModel>? tCode;
  @JsonKey(name: 'IS_LOGIN')
  String? isLogin;
  SapLoginInfoDataModel(this.esLogin, this.esReturn, this.etOrghk, this.tCode);
  factory SapLoginInfoDataModel.fromJson(Object? json) =>
      _$SapLoginInfoDataModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$SapLoginInfoDataModelToJson(this);
}
