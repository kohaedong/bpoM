/*
 * Filename: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/sales_activity_day_table_
 * Path: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc
 * Created Date: Wednesday, August 3rd 2022, 9:58:02 am
 * Author: bakbeom
 * 
 * Copyright (c) 2022 KOLON GROUP.
 */

import 'package:json_annotation/json_annotation.dart';

part 'sales_activity_day_table_250.g.dart';

@JsonSerializable()
class SalesActivityDayTable250 {
  @JsonKey(name: 'ADATE')
  String? adate;
  @JsonKey(name: 'BZACTNO')
  String? bzactno;
  @JsonKey(name: 'STAT')
  String? stat;
  @JsonKey(name: 'ADDCAT')
  String? addcat;
  @JsonKey(name: 'ZADDR')
  String? zaddr;
  @JsonKey(name: 'SADDCAT')
  String? saddcat;
  @JsonKey(name: 'SZADDR')
  String? szaddr;
  @JsonKey(name: 'FADDCAT')
  String? faddcat;
  @JsonKey(name: 'FZADDR')
  String? fzaddr;
  @JsonKey(name: 'RTN_DIST')
  String? rtnDist;
  @JsonKey(name: 'TOT_DIST')
  String? totDist;
  @JsonKey(name: 'BUKRS')
  String? bukrs;
  @JsonKey(name: 'VKORG')
  String? vkorg;
  @JsonKey(name: 'DPTCD')
  String? dptcd;
  @JsonKey(name: 'ORGHK')
  String? orghk;
  @JsonKey(name: 'SANUM')
  String? sanum;
  @JsonKey(name: 'SLNUM')
  String? slnum;
  @JsonKey(name: 'ERDAT')
  String? erdat;
  @JsonKey(name: 'ERZET')
  String? erzet;
  @JsonKey(name: 'ERNAM')
  String? ernam;
  @JsonKey(name: 'ERWID')
  String? erwid;
  @JsonKey(name: 'AEDAT')
  String? aedat;
  @JsonKey(name: 'AEZET')
  String? aezet;
  @JsonKey(name: 'AENAM')
  String? aenam;
  @JsonKey(name: 'AEWID')
  String? aewid;
  @JsonKey(name: 'ORGHK_NM')
  String? orghkNm;
  @JsonKey(name: 'SANUM_NM')
  String? sanumNm;
  @JsonKey(name: 'ZADDR1')
  String? zaddr1;
  @JsonKey(name: 'CALL_TYPE')
  String? callType;
  @JsonKey(name: 'UMODE')
  String? umode;

  SalesActivityDayTable250(
      this.adate,
      this.addcat,
      this.aedat,
      this.aenam,
      this.aewid,
      this.aezet,
      this.bukrs,
      this.bzactno,
      this.callType,
      this.dptcd,
      this.erdat,
      this.ernam,
      this.erwid,
      this.erzet,
      this.faddcat,
      this.fzaddr,
      this.orghk,
      this.orghkNm,
      this.rtnDist,
      this.saddcat,
      this.sanum,
      this.sanumNm,
      this.slnum,
      this.stat,
      this.szaddr,
      this.totDist,
      this.umode,
      this.vkorg,
      this.zaddr,
      this.zaddr1);
  factory SalesActivityDayTable250.fromJson(Object? json) =>
      _$SalesActivityDayTable250FromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SalesActivityDayTable250ToJson(this);
}
