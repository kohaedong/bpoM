import 'package:json_annotation/json_annotation.dart';
part 'es_login_model.g.dart';

@JsonSerializable()
class EsLoginModel {
  @JsonKey(name: 'LOGID')
  String? logid;
  @JsonKey(name: 'ENAME')
  String? ename;
  @JsonKey(name: 'BUKRS')
  String? bukrs;
  @JsonKey(name: 'VKORG')
  String? vkorg;
  @JsonKey(name: 'DPTCD')
  String? dptcd;
  @JsonKey(name: 'DPTNM')
  String? dptnm;
  @JsonKey(name: 'ORGHK')
  String? orghk;
  @JsonKey(name: 'SALEM')
  String? salem;
  @JsonKey(name: 'SYSIP')
  String? sysip;
  @JsonKey(name: 'SPRAS')
  String? spras;
  @JsonKey(name: 'XTM')
  String? xtm;
  @JsonKey(name: 'VKGRP')
  String? vkgrp;

  EsLoginModel(
      this.logid,
      this.ename,
      this.bukrs,
      this.vkorg,
      this.dptcd,
      this.dptnm,
      this.orghk,
      this.salem,
      this.sysip,
      this.spras,
      this.xtm,
      this.vkgrp);

  factory EsLoginModel.fromJson(Object? json) =>
      _$EsLoginModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EsLoginModelToJson(this);
}
