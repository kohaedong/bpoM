/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/et_vkgrp_model.dart
 * Created Date: 2022-07-04 14:42:15
 * Last Modified: 2022-07-04 14:58:18
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'et_vkgrp_model.g.dart';

@JsonSerializable()
class EtVkgrpModel {
  @JsonKey(name: 'VKGRP')
  String? vkgrp;
  @JsonKey(name: 'VKGRP_NM')
  String? vkgrpNm;
  @JsonKey(name: 'AREAD')
  String? aread;
  @JsonKey(name: 'ACHNG')
  String? achng;

  EtVkgrpModel(this.vkgrp, this.achng, this.aread, this.vkgrpNm);
  factory EtVkgrpModel.fromJson(Object? json) =>
      _$EtVkgrpModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EtVkgrpModelToJson(this);
}
