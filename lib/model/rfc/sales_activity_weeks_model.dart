/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_date_model.dart
 * Created Date: 2022-08-01 13:34:38
 * Last Modified: 2022-08-01 14:19:51
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'sales_activity_weeks_model.g.dart';

@JsonSerializable()
class SalesActivityWeeksModel {
  @JsonKey(name: 'DAY0')
  String? day0;
  @JsonKey(name: 'DAY0_1')
  String? day01;
  @JsonKey(name: 'DAY0_2')
  String? day02;
  @JsonKey(name: 'DAY0_3')
  String? day03;
  @JsonKey(name: 'DAY0_4')
  String? day04;

  @JsonKey(name: 'DAY1')
  String? day1;
  @JsonKey(name: 'DAY1_1')
  String? day11;
  @JsonKey(name: 'DAY1_2')
  String? day12;
  @JsonKey(name: 'DAY1_3')
  String? day13;
  @JsonKey(name: 'DAY1_4')
  String? day14;

  @JsonKey(name: 'DAY2')
  String? day2;
  @JsonKey(name: 'DAY2_1')
  String? day21;
  @JsonKey(name: 'DAY2_2')
  String? day22;
  @JsonKey(name: 'DAY2_3')
  String? day23;
  @JsonKey(name: 'DAY2_4')
  String? day24;

  @JsonKey(name: 'DAY3')
  String? day3;
  @JsonKey(name: 'DAY3_1')
  String? day31;
  @JsonKey(name: 'DAY3_2')
  String? day32;
  @JsonKey(name: 'DAY3_3')
  String? day33;
  @JsonKey(name: 'DAY3_4')
  String? day34;

  @JsonKey(name: 'DAY4')
  String? day4;
  @JsonKey(name: 'DAY4_1')
  String? day41;
  @JsonKey(name: 'DAY4_2')
  String? day42;
  @JsonKey(name: 'DAY4_3')
  String? day43;
  @JsonKey(name: 'DAY4_4')
  String? day44;

  @JsonKey(name: 'DAY5')
  String? day5;
  @JsonKey(name: 'DAY5_1')
  String? day51;
  @JsonKey(name: 'DAY5_2')
  String? day52;
  @JsonKey(name: 'DAY5_3')
  String? day53;
  @JsonKey(name: 'DAY5_4')
  String? day54;

  @JsonKey(name: 'DAY6')
  String? day6;
  @JsonKey(name: 'DAY6_1')
  String? day61;
  @JsonKey(name: 'DAY6_2')
  String? day62;
  @JsonKey(name: 'DAY6_3')
  String? day63;
  @JsonKey(name: 'DAY6_4')
  String? day64;

  SalesActivityWeeksModel(
      this.day0,
      this.day01,
      this.day02,
      this.day03,
      this.day04,
      this.day1,
      this.day11,
      this.day12,
      this.day13,
      this.day14,
      this.day2,
      this.day21,
      this.day22,
      this.day23,
      this.day24,
      this.day3,
      this.day31,
      this.day32,
      this.day33,
      this.day34,
      this.day4,
      this.day41,
      this.day42,
      this.day43,
      this.day44,
      this.day5,
      this.day51,
      this.day52,
      this.day53,
      this.day54,
      this.day6,
      this.day61,
      this.day62,
      this.day63,
      this.day64);
  factory SalesActivityWeeksModel.fromJson(Object? json) =>
      _$SalesActivityWeeksModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalesActivityWeeksModelToJson(this);
}
