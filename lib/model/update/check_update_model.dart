import 'package:json_annotation/json_annotation.dart';
part 'check_update_model.g.dart';

@JsonSerializable()
class CheckUpdateModel {
  String? appVerDscr;
  String? hckMngYn;
  String? updateKind;
  String? cmpsYn;
  String? appUpdUrlAddr;
  String? scrnshtPrevntYn;
  String? message;
  String? currentVersion;
  String? targetVersion;
  String? result;
  String? appInstallAddr;
  String? wtmkUseYn;
  String? appInstlltnFileSiz;
  int? targetVersionId;

  CheckUpdateModel(
      this.appVerDscr,
      this.hckMngYn,
      this.updateKind,
      this.cmpsYn,
      this.appUpdUrlAddr,
      this.scrnshtPrevntYn,
      this.message,
      this.currentVersion,
      this.targetVersion,
      this.result,
      this.appInstallAddr,
      this.wtmkUseYn,
      this.appInstlltnFileSiz,
      this.targetVersionId);
  factory CheckUpdateModel.fromJson(Object? json) =>
      _$CheckUpdateModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$CheckUpdateModelToJson(this);
}
