/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/salse_activity_coordinate_model.dart
 * Created Date: 2022-08-11 14:45:46
 * Last Modified: 2022-08-11 14:53:18
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'salse_activity_coordinate_model.g.dart';

@JsonSerializable()
class SalseActivityCoordinateModel {
  String? matchFlate;
  String? lon;
  String? latEntr;
  @JsonKey(name: 'city_do')
  String? cityDo;
  @JsonKey(name: 'gu_gun')
  String? guGun;
  String? adminDongCode;
  String? legalDongCode;
  String? lat;
  String? bunji;
  String? newLat;
  String? newRoadName;
  String? lonEntr;
  String? newMatchFlag;
  String? newBuildingIndex;
  String? newLon;
  String? zipcode;
  String? buildingName;
  String? legalDong;
  String? buildingDong;
  String? adminDong;
  String? newBuildingName;
  String? ri;
  @JsonKey(name: 'eup_myun')
  String? eupMyun;
  String? newBuildingCateName;
  String? newLatEntr;
  String? newBuildingDong;
  String? remainder;
  String? newLonEntr;

  SalseActivityCoordinateModel(
      this.adminDong,
      this.adminDongCode,
      this.buildingDong,
      this.buildingName,
      this.bunji,
      this.cityDo,
      this.eupMyun,
      this.guGun,
      this.lat,
      this.latEntr,
      this.legalDong,
      this.legalDongCode,
      this.lon,
      this.lonEntr,
      this.matchFlate,
      this.newBuildingCateName,
      this.newBuildingDong,
      this.newBuildingIndex,
      this.newBuildingName,
      this.newLat,
      this.newLatEntr,
      this.newLon,
      this.newLonEntr,
      this.newMatchFlag,
      this.newRoadName,
      this.remainder,
      this.ri,
      this.zipcode);

  factory SalseActivityCoordinateModel.fromJson(Object? json) =>
      _$SalseActivityCoordinateModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalseActivityCoordinateModelToJson(this);
}
