import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/commonCode/common_object.dart';
part 't_code_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class TCodeModel extends CommonCodeObject {
  @HiveField(1)
  @JsonKey(name: 'MANDT')
  String? mandt;
  @HiveField(2)
  @JsonKey(name: 'SPRAS')
  String? spras;
  @HiveField(3)
  @JsonKey(name: 'CDCLS')
  String? cdcls;
  @HiveField(4)
  @JsonKey(name: 'CDGRP')
  String? cdgrp;
  @HiveField(5)
  @JsonKey(name: 'CDITM')
  String? cditm;
  @HiveField(6)
  @JsonKey(name: 'SORTF')
  String? sortf;
  @HiveField(7)
  @JsonKey(name: 'CDNAM')
  String? cdnam;
  @HiveField(8)
  @JsonKey(name: 'DESC3')
  String? desc3;
  @HiveField(9)
  @JsonKey(name: 'LVORM')
  String? lvorm;
  @HiveField(10)
  @JsonKey(name: 'ERDAT')
  String? erdat;
  @HiveField(11)
  @JsonKey(name: 'ERZET')
  String? erzet;
  @HiveField(12)
  @JsonKey(name: 'ERNAM')
  String? ernam;
  @HiveField(13)
  @JsonKey(name: 'ERWID')
  String? erwid;
  @HiveField(14)
  @JsonKey(name: 'AEDAT')
  String? aedat;
  @HiveField(15)
  @JsonKey(name: 'AEZET')
  String? aezet;
  @HiveField(16)
  @JsonKey(name: 'AEWID')
  String? aewid;
  @HiveField(17)
  @JsonKey(name: 'rStatus')
  String? rstatus;
  @HiveField(18)
  @JsonKey(name: 'rChk')
  String? rchk;
  @HiveField(19)
  @JsonKey(name: 'rSeq')
  String? rseq;
  @HiveField(20)
  DateTime? timestamp;
  TCodeModel(
      {this.mandt,
      this.spras,
      this.cdcls,
      this.cdgrp,
      this.cditm,
      this.sortf,
      this.cdnam,
      this.desc3,
      this.lvorm,
      this.erdat,
      this.erzet,
      this.ernam,
      this.erwid,
      this.aedat,
      this.aezet,
      this.aewid,
      this.rstatus,
      this.rchk,
      this.rseq,
      this.timestamp});
  factory TCodeModel.fromJson(Object? json) =>
      _$TCodeModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$TCodeModelToJson(this);
}
