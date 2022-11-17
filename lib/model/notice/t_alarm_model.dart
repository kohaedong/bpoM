import 'package:json_annotation/json_annotation.dart';
part 't_alarm_model.g.dart';

@JsonSerializable()
class TAlarmModel {
  @JsonKey(name: 'MANDT')
  String? mandt;
  @JsonKey(name: 'ALMNO')
  String? almon;
  @JsonKey(name: 'SEQNO')
  String? seqno;
  @JsonKey(name: 'DOCTY')
  String? docty;
  @JsonKey(name: 'DOCNO')
  String? docno;
  @JsonKey(name: 'ALMCD')
  String? almcd;
  @JsonKey(name: 'RCWID')
  String? rcwid;
  @JsonKey(name: 'WRWID')
  String? wrwid;
  @JsonKey(name: 'KUNNR')
  String? kunnr;
  @JsonKey(name: 'KEY01')
  String? key01;
  @JsonKey(name: 'KEY02')
  String? key02;
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
  @JsonKey(name: 'MESSAGE')
  String? message;
  @JsonKey(name: 'TTEXT')
  String? ttext;
  @JsonKey(name: 'RCVCK')
  String? rcvck;
  @JsonKey(name: 'REDCK')
  String? redck;
  @JsonKey(name: 'OPDCK')
  String? opdck;
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
  @JsonKey(name: 'UMODE')
  String? umode;
  @JsonKey(name: 'rStatus')
  String? rStatus;
  @JsonKey(name: 'rChk')
  String? rChk;
  @JsonKey(name: 'rSeq')
  String? rSeq;

  TAlarmModel(
      this.mandt,
      this.almon,
      this.seqno,
      this.docty,
      this.docno,
      this.almcd,
      this.rcwid,
      this.wrwid,
      this.kunnr,
      this.key01,
      this.key02,
      this.bukrs,
      this.vkorg,
      this.dptcd,
      this.orghk,
      this.sanum,
      this.slnum,
      this.message,
      this.ttext,
      this.rcvck,
      this.redck,
      this.opdck,
      this.erdat,
      this.erzet,
      this.ernam,
      this.erwid,
      this.aedat,
      this.aezet,
      this.aenam,
      this.aewid,
      this.umode,
      this.rStatus,
      this.rChk,
      this.rSeq);
  factory TAlarmModel.fromJson(Object? json) =>
      _$TAlarmModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$TAlarmModelToJson(this);
}
