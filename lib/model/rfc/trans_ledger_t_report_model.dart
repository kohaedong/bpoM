/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/trans_t_report_model.dart
 * Created Date: 2022-07-14 12:59:03
 * Last Modified: 2022-07-14 14:07:12
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'trans_ledger_t_report_model.g.dart';

@JsonSerializable()
class TransLedgerTReportModel {
  @JsonKey(name: 'SPMON')
  String? spmon;
  @JsonKey(name: 'BSCHL_TX')
  String? bschlTx;
  @JsonKey(name: 'MATNR')
  String? matnr;
  @JsonKey(name: 'ATWRT1')
  String? atwrt1;
  @JsonKey(name: 'ARKTX')
  String? arktx;
  @JsonKey(name: 'ATWRT2')
  String? atwrt2;
  @JsonKey(name: 'FKIMG_C')
  String? fkimgC;
  @JsonKey(name: 'NETWR_T_C')
  String? netwrTC;
  @JsonKey(name: 'FKIMG_B')
  String? fkimgB;
  @JsonKey(name: 'NETWR_T_B')
  String? netwrTB;
  @JsonKey(name: 'NETWR_T_E')
  String? netwrTE;
  @JsonKey(name: 'DMBTR_C')
  String? dmbtrC;
  @JsonKey(name: 'KUNNR_END')
  String? kunnrEnd;
  @JsonKey(name: 'VRKME')
  String? vrkme;
  @JsonKey(name: 'FKIMG')
  double? fkimg;
  @JsonKey(name: 'FKIMGB')
  double? fkimgb;
  @JsonKey(name: 'NETWRC')
  int? netwrc;
  @JsonKey(name: 'NETWRB')
  int? netwrb;
  @JsonKey(name: 'NETWRE')
  int? netwre;
  @JsonKey(name: 'DMBTRC')
  int? dmbtrc;
  @JsonKey(name: 'ZBALANCE')
  double? zbalance;
  @JsonKey(name: 'ZBALANCE_C')
  String? zbalanceC;

  TransLedgerTReportModel(
      this.arktx,
      this.atwrt1,
      this.atwrt2,
      this.bschlTx,
      this.dmbtrC,
      this.dmbtrc,
      this.fkimg,
      this.fkimgB,
      this.fkimgC,
      this.fkimgb,
      this.kunnrEnd,
      this.matnr,
      this.netwrTB,
      this.netwrTC,
      this.netwrTE,
      this.netwrb,
      this.netwrc,
      this.netwre,
      this.spmon,
      this.vrkme,
      this.zbalance,
      this.zbalanceC);
  factory TransLedgerTReportModel.fromJson(Object? json) =>
      _$TransLedgerTReportModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TransLedgerTReportModelToJson(this);
}
