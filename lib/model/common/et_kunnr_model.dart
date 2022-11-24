/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/model/rfc/et_customer_model.dart
 * Created Date: 2022-07-06 21:38:39
 * Last Modified: 2022-08-16 22:02:45
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
part 'et_kunnr_model.g.dart';

@JsonSerializable()
class EtKunnrModel {
  @JsonKey(name: 'ZHKUNNR')
  String? zhkunnr;
  @JsonKey(name: 'ZSKUNNR')
  String? zskunnr;
  @JsonKey(name: 'NAME')
  String? name;
  @JsonKey(name: 'ZSTATUS')
  String? zstatus;
  @JsonKey(name: 'TELF1')
  String? telf1;
  @JsonKey(name: 'POST_CODE1')
  String? postCode1;
  @JsonKey(name: 'ZADD_NAME1')
  String? zaddName1;
  @JsonKey(name: 'ZADD_NAME2')
  String? zaddName2;
  @JsonKey(name: 'ZADD_NAME3')
  String? zadoName3;
  @JsonKey(name: 'ZADD_NAME4')
  String? zadoName4;
  @JsonKey(name: 'PERNR')
  String? pernr;
  @JsonKey(name: 'VKGRP')
  String? vkgrp;
  @JsonKey(name: 'ZLOEVM')
  String? zloevm;
  @JsonKey(name: 'POOLCK')
  String? poolck;
  @JsonKey(name: 'ZTREAT2')
  String? ztreat2;
  @JsonKey(name: 'ZTREAT2_NM')
  String? ztreat2Nm;
  @JsonKey(name: 'ZOPENDAT')
  String? zopendat;
  @JsonKey(name: 'ZPNO1')
  String? zpno1;
  @JsonKey(name: 'ZBNO')
  String? zbno;
  @JsonKey(name: 'ZBTNO')
  String? zbtno;
  @JsonKey(name: 'ZDIRECTOR')
  String? zdirector;
  @JsonKey(name: 'ZCHIEF')
  String? zchief;
  @JsonKey(name: 'ZEMP_NO')
  String? zempNo;
  @JsonKey(name: 'ZSALES_NO1')
  String? zsalesNo1;
  @JsonKey(name: 'ZTRD_AREA')
  String? ztrdArea;
  @JsonKey(name: 'ZSALES_AVG')
  String? zsalesAvg;
  @JsonKey(name: 'ZYAR_AMT')
  String? zyarAmt;
  @JsonKey(name: 'ZSALES_NO2')
  String? zsalesNo2;
  @JsonKey(name: 'ZPARMA_NO')
  String? zparmaNo;
  @JsonKey(name: 'ZREMARK')
  String? zremark;
  @JsonKey(name: 'ZIMPORT')
  String? zimport;
  @JsonKey(name: 'ZSTATUS_NM')
  String? zstatusNm;
  @JsonKey(name: 'SANUM')
  String? sanum;
  @JsonKey(name: 'SANUM_NM')
  String? sanumNm;
  @JsonKey(name: 'ORGHK')
  String? orghk;
  @JsonKey(name: 'ORGHK_NM')
  String? orghkNm;
  @JsonKey(name: 'ZKIND')
  String? zkind;
  @JsonKey(name: 'ZKIND_NM')
  String? zkindNm;
  @JsonKey(name: 'ZTREAT3')
  String? ztreat3;
  @JsonKey(name: 'ZTREAT3_NM')
  String? ztreat3Nm;
  @JsonKey(name: 'ZCLASS')
  String? zclass;
  @JsonKey(name: 'ZBIZ')
  String? zbiz;
  @JsonKey(name: 'ZBIZ_NM')
  String? zbizNm;
  @JsonKey(name: 'KUNNR')
  String? kunnr;
  @JsonKey(name: 'ZINPUT_CLSS')
  String? zinputClss;
  @JsonKey(name: 'PER_NAM')
  String? perNam;
  @JsonKey(name: 'ISVALID')
  String? isvalid;
  @JsonKey(name: 'YOYANG_NO')
  String? yoyangNo;
  @JsonKey(name: 'ZCLOSEYN')
  String? zcloseyn;
  EtKunnrModel(
      {this.isvalid,
      this.kunnr,
      this.name,
      this.orghk,
      this.orghkNm,
      this.perNam,
      this.pernr,
      this.poolck,
      this.postCode1,
      this.sanum,
      this.sanumNm,
      this.telf1,
      this.vkgrp,
      this.yoyangNo,
      this.zaddName1,
      this.zaddName2,
      this.zadoName3,
      this.zadoName4,
      this.zbiz,
      this.zbizNm,
      this.zbno,
      this.zbtno,
      this.zchief,
      this.zclass,
      this.zcloseyn,
      this.zdirector,
      this.zempNo,
      this.zhkunnr,
      this.zimport,
      this.zinputClss,
      this.zkind,
      this.zkindNm,
      this.zloevm,
      this.zopendat,
      this.zparmaNo,
      this.zpno1,
      this.zremark,
      this.zsalesAvg,
      this.zsalesNo1,
      this.zsalesNo2,
      this.zskunnr,
      this.zstatus,
      this.zstatusNm,
      this.ztrdArea,
      this.ztreat2,
      this.ztreat2Nm,
      this.ztreat3,
      this.ztreat3Nm,
      this.zyarAmt});
  factory EtKunnrModel.fromJson(Object? json) =>
      _$EtKunnrModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EtKunnrModelToJson(this);
}
