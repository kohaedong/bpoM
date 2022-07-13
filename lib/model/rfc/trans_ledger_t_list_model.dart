/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/trans_ledger_t_list_model.dart
 * Created Date: 2022-07-13 15:56:14
 * Last Modified: 2022-07-13 16:12:37
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'trans_ledger_t_list_model.g.dart';

@JsonSerializable()
class TransLedgerTListModel {
  @JsonKey(name: 'SPMON')
  String? spmon;
  @JsonKey(name: 'BSCHL_TX')
  String? bschlTx;
  @JsonKey(name: 'MATNR')
  String? matnr;
  @JsonKey(name: 'FKIMG_C')
  String? fkimgC;
  @JsonKey(name: 'FREE_QTY_C')
  String? freeQtyC;
  @JsonKey(name: 'NETWR_C')
  String? netwrC;
  @JsonKey(name: 'MWSBP_C')
  String? mwsbpC;
  @JsonKey(name: 'NETWR_T_C')
  String? netwrTC;
  @JsonKey(name: 'DMBTR_C')
  String? dmbtrC;
  @JsonKey(name: 'OTHER_C')
  String? otherC;
  @JsonKey(name: 'KUNNR_END')
  String? kunnrEnd;
  @JsonKey(name: 'KUNNR_END_TX')
  String? kunnrEndTx;
  @JsonKey(name: 'KUNNR')
  String? kunnr;
  @JsonKey(name: 'KUNNR_TX')
  String? kunnrTx;
  @JsonKey(name: 'ZFBDT')
  String? zfbdt;
  @JsonKey(name: 'ZTADESC')
  String? ztadesc;
  @JsonKey(name: 'SEQNO')
  String? seqno;
  @JsonKey(name: 'FKDAT')
  String? fkdat;
  @JsonKey(name: 'ZACCT_BSCHL')
  String? zacctBschl;
  @JsonKey(name: 'ARKTX')
  String? arktx;
  @JsonKey(name: 'ATWRT')
  String? atwrt;
  @JsonKey(name: 'FKIMG')
  String? fkimg;
  @JsonKey(name: 'FREE_QTY')
  String? freeQty;
  @JsonKey(name: 'VRKME')
  String? vrkme;
  @JsonKey(name: 'NETWR')
  String? netwr;
  @JsonKey(name: 'DMBTR')
  String? dmbtr;
  @JsonKey(name: 'WAERK')
  String? waerk;
  @JsonKey(name: 'VBELN')
  String? vbeln;
  @JsonKey(name: 'POSNR')
  String? posnr;
  @JsonKey(name: 'BELNR')
  String? belnr;
  @JsonKey(name: 'BUZEI')
  String? buzei;
  @JsonKey(name: 'SPART')
  String? spart;
  @JsonKey(name: 'FKART')
  String? fkart;
  @JsonKey(name: 'PSTYV')
  String? pstyv;
  @JsonKey(name: 'KKBER')
  String? kkber;
  @JsonKey(name: 'BUKRS')
  String? bukrs;
  @JsonKey(name: 'ERDAT')
  String? erdat;
  @JsonKey(name: 'ERZET')
  String? erzet;
  @JsonKey(name: 'AUART')
  String? auart;
  @JsonKey(name: 'BLART')
  String? blart;
  @JsonKey(name: 'VKGRP')
  String? vkgrp;
  @JsonKey(name: 'PERNR')
  String? pernr;
  @JsonKey(name: 'DELETE')
  String? delete;
  @JsonKey(name: 'MWSBP')
  String? mwsbp;
  @JsonKey(name: 'NETWR_T')
  String? netwrT;
  @JsonKey(name: 'OTHER')
  String? other;
  @JsonKey(name: 'ZNOTE_DIV')
  String? znoteDiv;
  @JsonKey(name: 'ZNOTE_KIND')
  String? znoteKind;
  @JsonKey(name: 'ZNOTE_TYPE')
  String? zonteType;
  @JsonKey(name: 'ZNOTE_NO')
  String? zonteNo;
  @JsonKey(name: 'ATWRT1')
  String? atwrt1;
  @JsonKey(name: 'ATWRT2')
  String? atwrt2;
  @JsonKey(name: 'HWBAS')
  String? hwbas;
  @JsonKey(name: 'FWSTE')
  String? fwste;
  @JsonKey(name: 'HWBAS_C')
  String? hwbasC;
  @JsonKey(name: 'FWSTE_C')
  String? fwsteC;

  TransLedgerTListModel(
      this.arktx,
      this.atwrt,
      this.atwrt1,
      this.atwrt2,
      this.auart,
      this.belnr,
      this.blart,
      this.bschlTx,
      this.bukrs,
      this.buzei,
      this.delete,
      this.dmbtr,
      this.dmbtrC,
      this.erdat,
      this.erzet,
      this.fkart,
      this.fkdat,
      this.fkimg,
      this.fkimgC,
      this.freeQty,
      this.freeQtyC,
      this.fwste,
      this.fwsteC,
      this.hwbas,
      this.hwbasC,
      this.kkber,
      this.kunnr,
      this.kunnrEnd,
      this.kunnrEndTx,
      this.kunnrTx,
      this.matnr,
      this.mwsbp,
      this.mwsbpC,
      this.netwr,
      this.netwrC,
      this.netwrT,
      this.netwrTC,
      this.other,
      this.otherC,
      this.pernr,
      this.posnr,
      this.pstyv,
      this.seqno,
      this.spart,
      this.spmon,
      this.vbeln,
      this.vkgrp,
      this.vrkme,
      this.waerk,
      this.zacctBschl,
      this.zfbdt,
      this.znoteDiv,
      this.znoteKind,
      this.zonteNo,
      this.zonteType,
      this.ztadesc);
  factory TransLedgerTListModel.fromJson(Object? json) =>
      _$TransLedgerTListModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$TransLedgerTListModelToJson(this);
}
