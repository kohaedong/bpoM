/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/search_key_for_business_group_model.dart
 * Created Date: 2022-08-01 14:47:18
 * Last Modified: 2022-08-01 14:53:47
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'search_key_for_business_group_model.g.dart';

@JsonSerializable()
class SearchKeyForBusinessGroupModel {
  @JsonKey(name: 'ZBIZ')
  String? zbiz;
  @JsonKey(name: 'VKGRP')
  String? vkgrp;
  @JsonKey(name: 'VKGRP_NM')
  String? vkgrpNm;

  SearchKeyForBusinessGroupModel(this.zbiz, this.vkgrp, this.vkgrpNm);
  factory SearchKeyForBusinessGroupModel.fromJson(Object? json) =>
      _$SearchKeyForBusinessGroupModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$SearchKeyForBusinessGroupModelToJson(this);
}
