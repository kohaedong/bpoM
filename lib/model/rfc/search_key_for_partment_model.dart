/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/search_key_for_partment_model.dart
 * Created Date: 2022-08-01 14:44:52
 * Last Modified: 2022-08-01 14:54:04
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'search_key_for_partment_model.g.dart';

@JsonSerializable()
class SearchKeyForPartmentModel {
  @JsonKey(name: 'ZBIZ')
  String? zbiz;
  @JsonKey(name: 'ZBIZ_NM')
  String? zbizNm;

  SearchKeyForPartmentModel(this.zbiz, this.zbizNm);
  factory SearchKeyForPartmentModel.fromJson(Object? json) =>
      _$SearchKeyForPartmentModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$SearchKeyForPartmentModelToJson(this);
}
