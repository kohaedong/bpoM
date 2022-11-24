/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/model/common/holiday_model.dart
 * Created Date: 2022-08-04 16:27:59
 * Last Modified: 2022-08-04 16:31:55
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:json_annotation/json_annotation.dart';

part 'holiday_model.g.dart';

@JsonSerializable()
class HolidayModel {
  int? id;
  String? dateKind;
  String? dateName;
  String? isHoliday;
  String? locdate;
  String? seq;
  String? year;
  int? modrId;
  DateTime? modDttm;
  int? creatrId;
  DateTime? creatDttm;

  HolidayModel(
      this.creatDttm,
      this.creatrId,
      this.dateKind,
      this.dateName,
      this.id,
      this.isHoliday,
      this.locdate,
      this.modDttm,
      this.modrId,
      this.seq,
      this.year);
  factory HolidayModel.fromJson(Object? json) =>
      _$HolidayModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$HolidayModelToJson(this);
}
