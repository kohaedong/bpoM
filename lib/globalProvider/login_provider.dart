/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/globalProvider/login_provider.dart
 * Created Date: 2022-10-18 00:31:14
 * Last Modified: 2022-10-18 05:30:22
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/model/user/user.dart';
import 'package:medsalesportal/enums/account_type.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/enums/hive_box_type.dart';
import 'package:medsalesportal/enums/app_theme_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/http/token_model.dart';
import 'package:medsalesportal/model/user/user_settings.dart';
import 'package:medsalesportal/model/rfc/et_orghk_model.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/service/deviceInfo_service.dart';
import 'package:medsalesportal/buildConfig/kolon_build_config.dart';
import 'package:medsalesportal/globalProvider/app_theme_provider.dart';
import 'package:medsalesportal/globalProvider/water_marke_provider.dart';
import 'package:medsalesportal/model/rfc/sap_login_info_response_model.dart';
import 'package:medsalesportal/model/user/access_permission_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class LoginProvider extends ChangeNotifier {
  final _api = ApiService();
  final buildType = KolonBuildConfig.KOLON_APP_BUILD_TYPE;
  final MethodChannel iosPlatform = MethodChannel('kolonbase/keychain');
  final MethodChannel androidPlatform = MethodChannel("mKolon.sso.channel");

  SapLoginInfoResponseModel? sapResponseModel;
  List<EtOrghkModel?> salseGroupList = [];
  UserSettings? userSettings;
  User? user;
  bool? isShowErrorMessage;
  bool? isLogedin;
  String? userId;
  String? userPw;
  bool get isPermidedSalseGroup {
    var esLogin = CacheService.getEsLogin();
    pr(esLogin!.toJson());
    if (salseGroupList.isEmpty) {
      return false;
    } else {
      return salseGroupList
          .where((group) => group!.orghk == esLogin.orghk)
          .toList()
          .isNotEmpty;
    }
  }

  void setIsLogedin(bool val) {
    isLogedin = val;
  }

  void setIsShowErrorMessage(bool? val) {
    isShowErrorMessage = val;
    notifyListeners();
  }

  void setSsalseGroupList(List<EtOrghkModel> list) {
    salseGroupList.clear();
    salseGroupList = list;
  }

  Future<ResultModel> requestToken() async {
    Map<String, dynamic> tokenBody = {
      'username': userId,
      'password': userPw,
      'grant_type': 'password',
      'scope': 'read',
      'client_id': 'default',
      'client_secret': 'secret'
    };

    _api.init(RequestType.REQEUST_TOKEN);
    final tokenResult = await _api.request(
      body: tokenBody,
    );
    if (tokenResult != null && tokenResult.statusCode == 200) {
      var temp = TokenModel.fromJson(tokenResult.body);
      user!.tokenInfo = temp;
      return ResultModel(true);
    }
    return ResultModel(false, message: tokenResult?.errorMessage);
  }

  Future<Map<String, dynamic>> getIosSSOLibUserData() async {
    try {
      final resultMap = await Future.delayed(Duration.zero, () async {
        final String? userAccount = await iosPlatform.invokeMethod('userId');
        final String? password = await iosPlatform.invokeMethod('userPw');
        final isLogedinOtherApps = userAccount != '' &&
            userAccount != null &&
            password != null &&
            password != '';
        return {
          'isLogedinOtherApps': isLogedinOtherApps,
          'userAccount': '$userAccount',
          'password': '$password'
        };
      });
      return resultMap;
    } catch (e) {
      print('$e');
      // emulator not support keychain.
      return {'isLogedinOtherApps': false};
    }
  }

  Future<Map<String, dynamic>> getAndroidSSOLibUserData() async {
    try {
      final methodCallResult =
          await androidPlatform.invokeMethod('getSsoByAndroid', buildType);
      print(methodCallResult);
      if (methodCallResult['isLogedinOtherApps']) {
        return {
          'isLogedinOtherApps': true,
          'userAccount': methodCallResult['userAccount'],
          'password': methodCallResult['password']
        };
      }
    } catch (e) {
      return {'isLogedinOtherApps': false};
    }
    return {'isLogedinOtherApps': false};
  }

  Future<Map<String, dynamic>> getUserIdAndPasswordFromSSO() async {
    var tempResult = Platform.isIOS
        ? await getIosSSOLibUserData()
        : await getAndroidSSOLibUserData();
    return tempResult;
  }

  Future<ResultModel> saveUserIdAndPasswordToSSO() async {
    if (Platform.isIOS) {
      final idResult = await iosPlatform.invokeMethod('setUserId', userId!);
      final passwordResult =
          await iosPlatform.invokeMethod('setUserPw', userPw!);
      pr('passwordResult::$passwordResult');
      return ResultModel(idResult == 'success' && passwordResult == 'success');
    } else {
      final saveResult = await androidPlatform.invokeMethod(
          'saveIdAndPasswordToAndroidSSO',
          {'userAccount': userId!, 'password': userPw!, 'type': buildType});
      pr('passwordResult::${saveResult == 'success'}');
      return ResultModel(saveResult == 'success');
    }
  }

  Future<bool> setIsSaveId(bool val) async {
    if (Platform.isIOS) {
      final idResult =
          await iosPlatform.invokeMethod('setIsSaveId', {"value": val});
      return idResult == 'success';
    }
    if (Platform.isAndroid) {
      final saveResult = await androidPlatform.invokeMethod(
          'setIsSaveId', {'isSaveId': val ? 'Y' : 'N', 'type': buildType});
      return saveResult == 'success';
    }
    return false;
  }

  Future<bool> isSaveId() async {
    if (Platform.isIOS) {
      return await iosPlatform.invokeMethod('isSaveId') as bool;
    } else {
      final result =
          await androidPlatform.invokeMethod('isSaveId', buildType) as String;
      return result == 'Y' ? true : false;
    }
  }

  Future<bool> isAutoLogin() async {
    if (Platform.isIOS) {
      return await iosPlatform.invokeMethod('isAutoLogin') as bool;
    } else {
      return androidPlatform
          .invokeMethod('isAutoLogin', buildType)
          .then((result) {
        result as String;
        return (result == 'Y' ? true : false);
      });
    }
  }

  Future<bool> setAutoLogin(bool value) async {
    pr('autoLogin value???:::$value');
    if (Platform.isIOS) {
      final idResult =
          await iosPlatform.invokeMethod('saveAutoLogin', {"value": value});
      return idResult == 'success';
    }
    if (Platform.isAndroid) {
      final saveResult = await androidPlatform.invokeMethod('saveAutoLogin',
          {'isAutoLogin': value ? 'Y' : 'N', 'type': buildType});
      pr('setAutoLogin ${saveResult == 'success'} ');
      return saveResult == 'success';
    }
    return false;
  }

  Future<void> setIsWaterMarkeUser() async {
    if (Platform.isIOS) {
      MethodChannel iosPlatform = MethodChannel('kolonbase/keychain');
      var isShowWatermarkUser =
          await iosPlatform.invokeMethod('isShowWatermarkUser');
      var isAllowScreenshotUser =
          await iosPlatform.invokeMethod('isAllowScreenshotUser');
      print('isShowWatermarkUser:: $isShowWatermarkUser');
      print('isAllowScreenshotUser $isAllowScreenshotUser');
      if (isShowWatermarkUser) {
        final p =
            KeyService.baseAppKey.currentContext!.read<WaterMarkeProvider>();
        p.setShowWaterMarke(true);
      }
    }
  }

  Future<String?> getIdonly() async {
    String? id = '';
    if (Platform.isIOS) {
      id = await iosPlatform.invokeMethod('userId');
      return id;
    }
    if (Platform.isAndroid) {
      return await androidPlatform.invokeMethod('getIdOnly', buildType);
    }
    return null;
  }

  Future<void> saveTcode() async {
    final commonTCODE = sapResponseModel!.data!.tCode!;
    var isNeedDownLoad = await HiveService.isNeedDownLoad();
    // var isTvalueDownLoadDone = CacheService.isTValueDownLoadDone();
    if (isNeedDownLoad) {
      commonTCODE.forEach((tcode) {
        tcode.timestamp = DateTime.now();
      });
      await HiveService.init(HiveBoxType.T_CODE);
      await HiveService.deleteBox();
      await HiveService.getBox();
      await HiveService.save(commonTCODE);
      print('new CommonCode downLoaded!');
    }
  }

  Future<ResultModel> checkAccessPermmision(String userId) async {
    _api.init(RequestType.ACCESS_PERMISSION);
    var url =
        '${RequestType.ACCESS_PERMISSION.url()}/${Platform.isIOS ? '80' : '79'}/$userId';
    final result = await _api.request(passingUrl: url);
    if (result != null && result.body != null) {
      var accessPermmisionModel =
          AccessPermissionModel.fromJson(result.body['data']);
      pr(accessPermmisionModel.toJson());
      return ResultModel(
        accessPermmisionModel.accessApp!,
        data: accessPermmisionModel,
        message: accessPermmisionModel.accessMsg!,
      );
    }
    return ResultModel(false, message: tr('permmison biden'));
  }

  Future<ResultModel> checkUserEnvironment({String? userAccont}) async {
    Map<String, dynamic> _body = {
      "methodName": RequestType.GET_ENV.serverMethod,
      "methodParam": {
        "categoryCode":
            userAccont != null ? "envKey_$userAccont" : "envKey_$userId",
      }
    };
    _api.init(RequestType.GET_ENV);

    final envResult = await _api.request(body: _body);
    if (envResult!.body['code'] != 'NG' && envResult.body['data'] != null) {
      userSettings =
          UserSettings.fromJson(envResult.body['data']['description']);
      pr(userSettings!.toJson());
      return ResultModel(true, data: userSettings);
    } else {
      userSettings = UserSettings(
        isSetNotDisturb: true,
        isShowNotice: true,
        notDisturbStartHour: '23',
        notDisturbStartMine: '00',
        notDisturbStopHour: '07',
        notDisturbStopMine: '00',
        textScale: 'big',
      );
      return ResultModel(true, data: userSettings);
    }
  }

  Future<ResultModel> saveUserEnvironment(
      {UserSettings? passingUserSettings, String? userAccount}) async {
    var _api = ApiService();
    Map<String, dynamic> saveEnvBody = {
      "methodName": RequestType.SAVE_ENV.serverMethod,
      "methodParam": {
        "categoryCode":
            userAccount != null ? "envKey_$userAccount" : "envKey_$userId",
        "description": passingUserSettings != null
            ? passingUserSettings.toJson()
            : userSettings!.toJson()
      }
    };
    _api.init(RequestType.SAVE_ENV);
    final envRequest = await _api.request(body: saveEnvBody);
    if (envRequest!.statusCode == 200) {
      var type = getThemeType(userSettings!.textScale!);
      KeyService.baseAppKey.currentContext!
          .read<AppThemeProvider>()
          .setThemeType(type);
      setIsWaterMarkeUser();
      return ResultModel(true);
    }
    return ResultModel(false, message: 'save Environment faild');
  }

  Future<ResultModel> getDeviceInfo() async {
    final deviceInfo = await DeviceInfoService.getDeviceInfo();
    print(deviceInfo.toJson());
    Map<String, dynamic> deviceInfoBody = {
      "methodName": RequestType.SAVE_DEVICE_INFO.serverMethod,
      "methodParam": {
        "deviceId": deviceInfo.deviceId,
        "deviceModelNo": deviceInfo.deviceModel,
        "devicePlatformName": Platform.isIOS ? 'iOS' : 'Android',
        "userId": userId!
      }
    };

    _api.init(RequestType.SAVE_DEVICE_INFO);
    final deviceInfoResult = await _api.request(body: deviceInfoBody);
    if (deviceInfoResult == null && deviceInfoResult!.statusCode != 200) {
      return ResultModel(false, message: 'get device info faild');
    }
    if (deviceInfoResult.statusCode == 200) {
      return ResultModel(true);
    }
    return ResultModel(false, message: 'get device info faild');
  }

  Future<ResultModel> webSignIn(String? id, String? pw,
      {bool? isAutoLogin}) async {
    var signBody = <String, dynamic>{};
    var message = '';
    if (isAutoLogin != null && isAutoLogin) {
      var ssoResultMap = await getUserIdAndPasswordFromSSO();
      userId = "${ssoResultMap['userAccount']}".trim();
      userPw = "${ssoResultMap['password']}".trim();
      signBody = {"userAccount": userId, "passwd": userPw};
    } else {
      assert(id != null && pw != null);
      userId = id!;
      userPw = pw!;
      signBody = {"userAccount": userId, "passwd": userPw};
    }
    _api.init(RequestType.SIGNIN);
    final signResult = await _api.request(body: signBody);
    if (signResult!.statusCode == 200 && signResult.body['code'] == "NG") {
      isShowErrorMessage = true;
      var message = signResult.body['message'] as String;
      var isSuccess = false;
      pr(message);
      var isMessageStartWithNumber =
          int.tryParse(message.trim().substring(0, 1)) != null;
      if (isMessageStartWithNumber) {
        pr(message.trim().substring(0, 1));
        var number = int.parse(message.trim().substring(0, 1));
        if (number < 5) {
          message = tr('password_wrong');
        }
      }
      if (!isMessageStartWithNumber && signResult.body['data'] == null) {
        message = tr('permission_denied');
      }
      return ResultModel(isSuccess, message: message);
    }
    if (signResult.statusCode == 200 &&
        signResult.body['code'] != "NG" &&
        signResult.body['data'] != null) {
      var isSuccess = true;
      pr('@@@@code:: ${signResult.body['code']}');
      user = User.fromJson(signResult.body['data']);
      var accessPermissionResult = await checkAccessPermmision(userId!);
      if (!accessPermissionResult.isSuccessful) {
        isSuccess = false;
        message = accessPermissionResult.message == '앱실행불가'
            ? tr('permission_denied')
            : accessPermissionResult.message ?? '';
      }
      return ResultModel(isSuccess, message: message);
    }
    return ResultModel(false, message: message);
  }

  Future<ResultModel> sapSignIn() async {
    Map<String, dynamic>? sapBody = {
      "methodName": RequestType.SAP_SIGNIN_INFO.serverMethod,
      "methodParamMap": {
        "functionName": RequestType.SAP_SIGNIN_INFO.serverMethod,
        "IV_LOGID": userId!.toUpperCase(),
        "resultTables": RequestType.SAP_SIGNIN_INFO.resultTable,
        "appName": "medsalesportal"
      }
    };
    _api.init(RequestType.SAP_SIGNIN_INFO);
    final sapResult = await _api.request(body: sapBody);
    if (sapResult != null && sapResult.statusCode != 200) {
      return ResultModel(false, message: sapResult.message);
    }
    if (sapResult != null && sapResult.statusCode == 200) {
      sapResponseModel = SapLoginInfoResponseModel.fromJson(sapResult.body);
      var isSuccessfull = sapResponseModel!.data!.esReturn!.mtype == 'S';
      var message = tr('permission_denied');
      return ResultModel(isSuccessfull, message: message);
    }
    return ResultModel(false, message: sapResult?.errorMessage ?? '');
  }

  Future<ResultModel> saveLoginInfo() async {
    var esLogin = sapResponseModel!.data!.esLogin!;
    var isLogin = sapResponseModel!.data!.isLogin!;
    var isTeamLeader = esLogin.xtm == 'X';
    var isMultiAccount =
        (esLogin.xtm == '' && esLogin.vkgrp == '' && esLogin.salem == '');
    CacheService.saveEsLogin(esLogin);
    CacheService.saveIsLogin(isLogin);
    CacheService.saveUser(user!);
    CacheService.saveAccountType(isMultiAccount
        ? AccountType.MULTI
        : isTeamLeader
            ? AccountType.LEADER
            : AccountType.NORMAL);

    setSsalseGroupList(sapResponseModel!.data!.etOrghk!);
    pr('xtm ::${esLogin.xtm}\n');
    pr('vkgrp ::${esLogin.vkgrp}\n');
    pr('salem ::${esLogin.salem}\n');
    pr('p.isSalseGroup  $isPermidedSalseGroup');
    await saveTcode();
    return ResultModel(true);
  }

  Future<ResultModel> startSignin(String userId, String userPw,
      {bool? isAutoLogin}) async {
    ResultModel? result;
    try {
      result = await webSignIn(userId, userPw, isAutoLogin: isAutoLogin);
      if (!result.isSuccessful) return result;
      result = await requestToken();
      if (!result.isSuccessful) return result;
      result = await saveUserIdAndPasswordToSSO();
      if (!result.isSuccessful) return result;
      result = await sapSignIn();
      if (!result.isSuccessful) return result;
      result = await saveLoginInfo();
      if (!result.isSuccessful) return result;
      result = await getDeviceInfo();
      if (!result.isSuccessful) return result;
      result = await checkUserEnvironment();
      if (!result.isSuccessful) return result;
      result = await saveUserEnvironment();
      if (result.isSuccessful) isLogedin = true;
    } catch (e) {
      return ResultModel(false, message: tr('server_error'));
    }
    return result;
  }
}
