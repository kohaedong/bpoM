/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/trans_ledger_response_model.dart
 * Created Date: 2022-07-14 13:30:31
 * Last Modified: 2022-07-14 13:39:18
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'package:medsalesportal/model/rfc/trans_ledger_es_head_model.dart';
import 'package:medsalesportal/model/rfc/trans_ledger_t_list_model.dart';
import 'package:medsalesportal/model/rfc/trans_ledger_t_report_model.dart';

part 'trans_ledger_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TransLedgerResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'ES_HEAD')
  TransLedgerEsHeadModel? esHead;
  @JsonKey(name: 'T_LIST')
  List<TransLedgerTListModel>? tList;
  @JsonKey(name: 'T_REPORT')
  List<TransLedgerTReportModel>? tReport;

  TransLedgerResponseModel(
      this.esHead, this.esReturn, this.tList, this.tReport);
  factory TransLedgerResponseModel.fromJson(Object? json) =>
      _$TransLedgerResponseModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$TransLedgerResponseModelToJson(this);
}
