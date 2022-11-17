import 'package:json_annotation/json_annotation.dart';
import 'package:bpom/model/http/token_model.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  String? id;
  String? userAccount;
  String? userName;
  String? companyCd;
  String? hrCompanyCd;
  String? businessUnit;
  String? estabid;
  String? companyName;
  String? deptCode;
  String? deptName;
  String? deptOrder;
  String? absence;
  String? email;
  String? employeeNo;
  String? faxNum;
  String? fullPath;
  String? maindeptflag;
  String? mkolon;
  String? mobileNum;
  String? officeCode;
  String? personNumber;
  String? task;
  String? telNum;
  String? titleCode;
  String? titleName;
  String? titleOrder;
  String? securityLevel;
  String? roleCode;
  String? roleName;
  String? roleOrder;
  String? roles;
  String? birthDt;
  String? birthDtType;
  String? marriedYn;
  String? marriedDt;
  String? enterDt;
  String? modrId;
  String? modDttm;
  String? creatrId;
  String? creatDttm;
  TokenModel? tokenInfo;

  User(
      this.id,
      this.userAccount,
      this.userName,
      this.companyCd,
      this.hrCompanyCd,
      this.businessUnit,
      this.estabid,
      this.companyName,
      this.deptCode,
      this.deptName,
      this.deptOrder,
      this.absence,
      this.email,
      this.employeeNo,
      this.faxNum,
      this.fullPath,
      this.maindeptflag,
      this.mkolon,
      this.mobileNum,
      this.officeCode,
      this.personNumber,
      this.task,
      this.telNum,
      this.titleCode,
      this.titleName,
      this.titleOrder,
      this.securityLevel,
      this.roleCode,
      this.roleName,
      this.roleOrder,
      this.roles,
      this.birthDt,
      this.birthDtType,
      this.marriedYn,
      this.marriedDt,
      this.enterDt,
      this.modrId,
      this.modDttm,
      this.creatrId,
      this.creatDttm,
      {this.tokenInfo});
  factory User.fromJson(Object? json) =>
      _$UserFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
