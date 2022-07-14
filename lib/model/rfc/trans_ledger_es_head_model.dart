/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/trans_ledger_es_head_model.dart
 * Created Date: 2022-07-13 16:13:07
 * Last Modified: 2022-07-14 14:06:31
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'trans_ledger_es_head_model.g.dart';

@JsonSerializable()
class TransLedgerEsHeadModel {
  @JsonKey(name: 'KUNNR')
  String? kunnr;
  @JsonKey(name: 'KUNNR_NM')
  String? kunnrNm;
  @JsonKey(name: 'CARD_AMT_S')
  String? cardAmtS;
  @JsonKey(name: 'CARD_AMT_E')
  String? cardAmtE;
  @JsonKey(name: 'CARD_DUE_S')
  int? cardDueS;
  @JsonKey(name: 'CARD_DUE_E')
  int? cardDueE;
  @JsonKey(name: 'REAL_AMT_S')
  String? realAmtS;
  @JsonKey(name: 'REAL_AMT_E')
  String? realAmtE;
  @JsonKey(name: 'REAL_DUE_S')
  int? realDueS;
  @JsonKey(name: 'REAL_DUE_E')
  int? realDueE;
  @JsonKey(name: 'SALE_AMT')
  String? saleAmt;
  @JsonKey(name: 'RE_AMT')
  String? reAmt;
  @JsonKey(name: 'DMBTR')
  String? dmbtr;
  @JsonKey(name: 'DMBTR_D')
  String? dmbtrD;
  @JsonKey(name: 'SALE_AMT_T')
  String? saleAmtT;
  @JsonKey(name: 'RE_AMT_T')
  String? reAmtT;
  @JsonKey(name: 'WAERK')
  String? waerk;
  TransLedgerEsHeadModel(
      this.cardAmtE,
      this.cardAmtS,
      this.cardDueE,
      this.cardDueS,
      this.dmbtr,
      this.dmbtrD,
      this.kunnr,
      this.kunnrNm,
      this.reAmt,
      this.reAmtT,
      this.realAmtE,
      this.realAmtS,
      this.realDueE,
      this.realDueS,
      this.saleAmt,
      this.saleAmtT,
      this.waerk);

  factory TransLedgerEsHeadModel.fromJson(Object? json) =>
      _$TransLedgerEsHeadModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$TransLedgerEsHeadModelToJson(this);
}
