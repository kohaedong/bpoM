/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/t_vkgrp_model.dart
 * Created Date: 2022-07-05 15:54:43
 * Last Modified: 2022-07-05 16:04:40
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 't_vkgrp_model.g.dart';

@JsonSerializable()
class TVkgrpModel {
  @JsonKey(name: 'VKGRP')
  String? vkgrp;
  @JsonKey(name: 'VKGRP_NM')
  String? vkgrpNm;

  TVkgrpModel(this.vkgrp, this.vkgrpNm);
  factory TVkgrpModel.fromJson(Object? json) =>
      _$TVkgrpModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$TVkgrpModelToJson(this);
}
