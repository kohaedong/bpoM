/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/et_vkorghk_model.dart
 * Created Date: 2022-07-04 14:39:18
 * Last Modified: 2022-07-04 14:57:56
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'et_orghk_model.g.dart';

@JsonSerializable()
class EtOrghkModel {
  @JsonKey(name: 'DOCTY')
  String? docty;
  @JsonKey(name: 'ORGHK')
  String? orghk;
  @JsonKey(name: 'ORGHK_NM')
  String? orghkNm;
  EtOrghkModel(this.docty, this.orghk, this.orghkNm);
  factory EtOrghkModel.fromJson(Object? json) =>
      _$EtOrghkModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EtOrghkModelToJson(this);
}
