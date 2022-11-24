/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/globalProvider/login_provider.dart
 * Created Date: 2022-10-18 00:31:14
 * Last Modified: 2022-11-15 11:19:59
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';

import 'package:bpom/buildConfig/kolon_build_config.dart';
import 'package:bpom/enums/request_type.dart';
import 'package:bpom/globalProvider/water_marke_provider.dart';
import 'package:bpom/model/common/et_orghk_model.dart';
import 'package:bpom/model/common/result_model.dart';
import 'package:bpom/model/common/sap_login_info_response_model.dart';
import 'package:bpom/model/notice/notice_settings_response_model.dart';
import 'package:bpom/model/user/access_permission_model.dart';
import 'package:bpom/model/user/user.dart';
import 'package:bpom/model/user/user_settings.dart';
import 'package:bpom/service/api_service.dart';
import 'package:bpom/service/cache_service.dart';
import 'package:bpom/service/deviceInfo_service.dart';
import 'package:bpom/service/key_service.dart';
import 'package:bpom/view/common/function_of_print.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginProvider extends ChangeNotifier {
  final _api = ApiService();
  final buildType = KolonBuildConfig.KOLON_APP_BUILD_TYPE;
  final MethodChannel iosPlatform = MethodChannel('kolonbase/keychain');
  final MethodChannel androidPlatform = MethodChannel('mKolon.sso.channel');

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

  void setUserSettings(UserSettings settingss) {
    userSettings = settingss;
  }

  void setIsShowErrorMessage(bool? val) {
    isShowErrorMessage = val;
    notifyListeners();
  }

  void setSsalseGroupList(List<EtOrghkModel> list) {
    salseGroupList.clear();
    salseGroupList = list;
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
    pr(tempResult);
    return tempResult;
  }

  Future<ResultModel> saveUserIdAndPasswordToSSO() async {
    pr('in');
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
          await iosPlatform.invokeMethod('setIsSaveId', {'value': val});
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
          await iosPlatform.invokeMethod('saveAutoLogin', {'value': value});
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
      'methodName': RequestType.GET_ENV.serverMethod,
      'methodParam': {
        'categoryCode':
            userAccont != null ? 'envKey_$userAccont' : 'envKey_$userId',
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

  Future<ResultModel> getDeviceInfo() async {
    final deviceInfo = await DeviceInfoService.getDeviceInfo();
    print(deviceInfo.toJson());
    Map<String, dynamic> deviceInfoBody = {
      'methodName': RequestType.SAVE_DEVICE_INFO.serverMethod,
      'methodParam': {
        'deviceId': deviceInfo.deviceId,
        'deviceModelNo': deviceInfo.deviceModel,
        'devicePlatformName': Platform.isIOS ? 'iOS' : 'Android',
        'userId': userId!
      }
    };

    _api.init(RequestType.SAVE_DEVICE_INFO);
    final deviceInfoResult = await _api.request(body: deviceInfoBody);
    if (deviceInfoResult == null || deviceInfoResult.statusCode != 200) {
      return ResultModel(false,
          message: 'get device info faild',
          isNetworkError: deviceInfoResult?.statusCode == -2,
          isServerError: deviceInfoResult?.statusCode == -1);
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
      userId = '${ssoResultMap['userAccount']}'.trim();
      userPw = '${ssoResultMap['password']}'.trim();
      signBody = {'userAccount': userId, 'passwd': userPw};
    } else {
      assert(id != null && pw != null);
      userId = id!;
      userPw = pw!;
      signBody = {'userAccount': userId, 'passwd': userPw};
    }
    _api.init(RequestType.SIGNIN);
    final signResult = await _api.request(body: signBody);
    if (signResult!.statusCode == 200 && signResult.body['code'] == 'NG') {
      var message = signResult.body['message'] as String;
      var isMessageStartWithNumber =
          int.tryParse(message.trim().substring(0, 1)) != null;
      if (isMessageStartWithNumber) {
        isShowErrorMessage = true;
        var number = int.tryParse(message.trim().substring(0, 1));
        if (number != null)
          message = number < 10
              ? tr('password_wrong')
              : tr('password_wrong_five_time');
      }
      pr(signResult.body);
      var isShowPopup =
          !isMessageStartWithNumber && signResult.body['data'] == null;
      if (isShowPopup) message = tr('permission_denied');

      return ResultModel(false,
          message: message, isShowErrorText: !isShowPopup);
    }
    if (signResult.statusCode == 200 &&
        signResult.body['code'] != 'NG' &&
        signResult.body['data'] != null) {
      var isSuccess = true;
      pr('@@@@code:: ${signResult.body['code']}');
      user = User.fromJson(signResult.body['data']);
      CacheService.saveUser(user);
      var accessPermissionResult = await checkAccessPermmision(userId!);
      if (!accessPermissionResult.isSuccessful) {
        isSuccess = false;
        message = accessPermissionResult.message == '앱실행불가'
            ? tr('permission_denied')
            : accessPermissionResult.message ?? '';
      }
      return ResultModel(isSuccess, message: message);
    }
    return ResultModel(false,
        message: message,
        isNetworkError: signResult.statusCode == -2,
        isServerError: signResult.statusCode == -1);
  }

  Future<ResultModel> getAndSaveNotice(
      {bool? isSave, String? startTime, String? endTime}) async {
    final _api = ApiService();
    Map<String, dynamic> _body = {
      'methodName': isSave ?? false
          ? RequestType.SET_PUSH_INFO.serverMethod
          : RequestType.GET_PUSH_INFO.serverMethod,
      'methodParam': isSave ?? false
          ? {
              'notiUseYn': userSettings!.isShowNotice ? 'y' : 'n',
              'stopNotiTimeUseYn': userSettings!.isSetNotDisturb ? 'y' : 'n',
              'stopNotiTimeBeginTime': startTime ?? '0700',
              'stopNotiTimeEndTime': endTime ?? '2300'
            }
          : {}
    };
    _api.init(isSave ?? false
        ? RequestType.SET_PUSH_INFO
        : RequestType.GET_PUSH_INFO);
    final result = await _api.request(body: _body);
    if (result == null || result.statusCode != 200) {
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }
    if (result.statusCode == 200) {
      var temp = NoticeSettingsResponseModel.fromJson(result.body);
      var isSuccess = temp.code == 'OK' && temp.message == 'Success';
      pr(temp.toJson());
      return ResultModel(isSuccess, data: temp.data);
    }
    return ResultModel(false);
  }

  Future<ResultModel> startSignin(String userId, String userPw,
      {bool? isAutoLogin}) async {
    ResultModel? result;
    result = await webSignIn(userId, userPw, isAutoLogin: isAutoLogin);
    if (!result.isSuccessful) return result;
    //result = await requestToken();
    //if (!result.isSuccessful) return result;
    //result = await sapSignIn();
    //if (!result.isSuccessful) return result;
    result = await saveUserIdAndPasswordToSSO();
    if (!result.isSuccessful) return result;
    //result = await saveLoginInfo();
    //if (!result.isSuccessful) return result;
    result = await getDeviceInfo();
    if (!result.isSuccessful) return result;
    //result = await checkUserEnvironment();
    //if (!result.isSuccessful) return result;
    //result = await saveUserEnvironment(isFirstSave: true);
    //if (!result.isSuccessful) return result;
    //result = await sendFcmToken();
    //if (result.isSuccessful) isLogedin = true;
    return result;
  }
}
