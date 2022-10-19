import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/model/user/user.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/model/user/user_settings.dart';
import 'package:medsalesportal/globalProvider/login_provider.dart';
import 'package:medsalesportal/buildConfig/kolon_build_config.dart';
import 'package:medsalesportal/model/user/access_permission_model.dart';
import 'package:medsalesportal/model/rfc/sap_login_info_response_model.dart';

class SigninPageProvider extends ChangeNotifier {
  String errorMessage = '';
  String? userAccount;
  String? password;
  bool isCheckedSaveIdBox = false;
  bool isCheckedAutoSigninBox = false;
  User? user;
  bool? isFindKolonApps;
  bool isLoadData = false;
  double keybordHeight = 0;
  UserSettings? userSettings;
  SapLoginInfoResponseModel? sapLoginInfoResponseModel;
  static const MethodChannel iosPlatform = MethodChannel('kolonbase/keychain');
  static const MethodChannel androidPlatform =
      MethodChannel("mKolon.sso.channel");

  var buildType = '${KolonBuildConfig.KOLON_APP_BUILD_TYPE}';

  bool get isValueNotNull =>
      userAccount != null &&
      userAccount!.trim().isNotEmpty &&
      password != null &&
      password!.trim().isNotEmpty;

  void setIdCheckBox() {
    this.isCheckedSaveIdBox = !isCheckedSaveIdBox;
    if (!this.isCheckedSaveIdBox) {
      isCheckedAutoSigninBox = false;
    }
    notifyListeners();
  }

  // void setKeyBordHeight(double val) {
  //   keybordHeight = val;
  // }

  Future<Map<String, dynamic>?> setDefaultData({String? id, String? pw}) async {
    Map<String, dynamic>? map = {};
    var lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    var isSavedId = await lp.isSaveId();
    if (isSavedId) {
      print('saveID???$isSavedId');
      isCheckedSaveIdBox = true;
      if (id != null && pw != null) {
        map.putIfAbsent('id', () => id);
        map.putIfAbsent('pw', () => pw);
        userAccount = id;
        password = pw;
      } else {
        var account = await lp.getIdonly();
        map.putIfAbsent('id', () => account);
        userAccount = account;
      }
    }

    return map;
  }

  void setAutoLogin() {
    final lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    lp.setAutoLogin(isCheckedAutoSigninBox);
    lp.setIsSaveId(isCheckedSaveIdBox);
  }

  void setAutoSigninCheckBox() {
    this.isCheckedAutoSigninBox = !isCheckedAutoSigninBox;
    if (isCheckedAutoSigninBox) {
      this.isCheckedSaveIdBox = true;
    }
    notifyListeners();
  }

  void startErrorMessage(String message) {
    errorMessage = message;
    notifyListeners();
  }

  void setAccount(String? str) {
    this.userAccount = (str == '' ? null : str);
    final lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    startErrorMessage(lp.isShowErrorMessage == null ? '' : errorMessage);
    notifyListeners();
  }

  void startLoading() {
    isLoadData = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoadData = false;
    notifyListeners();
  }

  void setPassword(String? password) {
    this.password = (password == '' ? null : password);
    // if (password == null || password.length == 1 || password == '') {}
    final lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    startErrorMessage(lp.isShowErrorMessage == null ? '' : errorMessage);
    notifyListeners();
  }
}

class SigninResult {
  bool isSuccessful;
  String message;
  String? id;
  String? pw;
  bool? isShowPopup;
  AccessPermissionModel? accessPermissionModel;
  SigninResult(this.isSuccessful, this.message,
      {this.id, this.pw, this.isShowPopup, this.accessPermissionModel});
}
