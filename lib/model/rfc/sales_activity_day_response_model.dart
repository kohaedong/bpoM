/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_day_response_model.dart
 * Created Date: 2022-08-03 11:31:55
 * Last Modified: 2022-08-03 13:40:18
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_250.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_260.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_270.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_280.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_290.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_291.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_300.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_301.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_310.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_320.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_321.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_330.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_340.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_350.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_361.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_430.dart';
part 'sales_activity_day_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SalesActivityDayResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_ZLTSP0250S')
  List<SalesActivityDayTable250>? table250;
  @JsonKey(name: 'T_ZLTSP0260S')
  List<SalesActivityDayTable260>? table260;
  @JsonKey(name: 'T_ZLTSP0270S')
  List<SalesActivityDayTable270>? table270;
  @JsonKey(name: 'T_ZLTSP0280S')
  List<SalesActivityDayTable280>? table280;
  @JsonKey(name: 'T_ZLTSP0290S')
  List<SalesActivityDayTable290>? table290;
  @JsonKey(name: 'T_ZLTSP0291S')
  List<SalesActivityDayTable291>? table291;
  @JsonKey(name: 'T_ZLTSP0300S')
  List<SalesActivityDayTable300>? table300;
  @JsonKey(name: 'T_ZLTSP0301S')
  List<SalesActivityDayTable301>? table301;
  @JsonKey(name: 'T_ZLTSP0310S')
  List<SalesActivityDayTable310>? table310;
  @JsonKey(name: 'T_ZLTSP0320S')
  List<SalesActivityDayTable320>? table320;
  @JsonKey(name: 'T_ZLTSP0321S')
  List<SalesActivityDayTable321>? table321;
  @JsonKey(name: 'T_ZLTSP0330S')
  List<SalesActivityDayTable330>? table330;
  @JsonKey(name: 'T_ZLTSP0340S')
  List<SalesActivityDayTable340>? table340;
  @JsonKey(name: 'T_ZLTSP0350S')
  List<SalesActivityDayTable350>? table350;
  @JsonKey(name: 'T_ZLTSP0361S')
  List<SalesActivityDayTable361>? table361;
  @JsonKey(name: 'T_ZLTSP0430S')
  List<SalesActivityDayTable430>? table430;

  SalesActivityDayResponseModel(
      this.esReturn,
      this.table250,
      this.table260,
      this.table270,
      this.table280,
      this.table290,
      this.table291,
      this.table300,
      this.table301,
      this.table310,
      this.table320,
      this.table321,
      this.table330,
      this.table340,
      this.table350,
      this.table361,
      this.table430);
  factory SalesActivityDayResponseModel.fromJson(Object? json) =>
      _$SalesActivityDayResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalesActivityDayResponseModelToJson(this);
}
