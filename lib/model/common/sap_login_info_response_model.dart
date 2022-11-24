/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/model/rfc/sap_login_info_response_model.dart
 * Created Date: 2022-07-04 14:45:52
 * Last Modified: 2022-11-15 11:18:15
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:bpom/model/common/sap_login_info_data_model.dart';
part 'sap_login_info_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SapLoginInfoResponseModel {
  String? code;
  String? message;
  SapLoginInfoDataModel? data;
  SapLoginInfoResponseModel(this.code, this.message, this.data);
  factory SapLoginInfoResponseModel.fromJson(Object? json) =>
      _$SapLoginInfoResponseModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$SapLoginInfoResponseModelToJson(this);
}
