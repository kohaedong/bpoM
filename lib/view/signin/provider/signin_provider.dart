import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medsalesportal/globalProvider/app_auth_provider.dart';
import 'package:medsalesportal/model/user/access_permission_model.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/model/user/user.dart';
import 'package:medsalesportal/enums/account_type.dart';
import 'package:medsalesportal/enums/hive_box_type.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/enums/app_theme_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/http/token_model.dart';
import 'package:medsalesportal/model/user/user_settings.dart';
import 'package:medsalesportal/service/deviceInfo_service.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/buildConfig/kolon_build_config.dart';
import 'package:medsalesportal/globalProvider/app_theme_provider.dart';
import 'package:medsalesportal/globalProvider/water_marke_provider.dart';
import 'package:medsalesportal/model/rfc/sap_login_info_response_model.dart';

class SigninProvider extends ChangeNotifier {
  String errorMessage = '';
  String? userAccount;
  String? password;
  bool isCheckedSaveIdBox = false;
  bool isCheckedAutoSigninBox = false;
  User? user;
  bool? isFindKolonApps;
  bool isLoadData = false;
  UserSettings? userSettings;
  SapLoginInfoResponseModel? sapLoginInfoResponseModel;
  var _api = ApiService();
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

  Future<Map<String, dynamic>?> setDefaultData({String? id, String? pw}) async {
    Map<String, dynamic>? map = {};
    var isSavedId = await isSaveId();

    if (isSavedId) {
      print('saveID???$isSavedId');
      isCheckedSaveIdBox = true;
      if (id != null && pw != null) {
        map.putIfAbsent('id', () => id);
        map.putIfAbsent('pw', () => pw);
      } else {
        var account = await getIdonly();
        map.putIfAbsent('id', () => account);
      }
    }
    return map;
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
    // if (str == null || str.length == 1 || str == '') {}
    notifyListeners();
  }

  void setPassword(String? password) {
    this.password = (password == '' ? null : password);
    // if (password == null || password.length == 1 || password == '') {}
    notifyListeners();
  }

  Future<TokenModel?> requestToken(String username, String password) async {
    Map<String, dynamic> tokenBody = {
      'username': username,
      'password': password,
      'grant_type': 'password',
      'scope': 'read',
      'client_id': 'default',
      'client_secret': 'secret'
    };

    _api.init(RequestType.REQEUST_TOKEN);
    final tokenResult = await _api.request(
      body: tokenBody,
    );

    if (tokenResult == null || tokenResult.statusCode != 200) {
      return null;
    }
    return TokenModel.fromJson(tokenResult.body);
  }

  Future<Map<String, dynamic>> getUserIdAndPasswordFromSSO() async {
    var tempResult = Platform.isIOS
        ? await getIosSSOLibUserData()
        : await getAndroidSSOLibUserData();
    return tempResult;
  }

  Future<bool> saveUserIdAndPasswordToSSO(
      String userAccount, String password) async {
    if (Platform.isIOS) {
      final idResult = await iosPlatform.invokeMethod('setUserId', userAccount);
      final passwordResult =
          await iosPlatform.invokeMethod('setUserPw', password);
      pr('passwordResult::$passwordResult');
      return idResult == 'success' && passwordResult == 'success';
    } else {
      final saveResult = await androidPlatform.invokeMethod(
          'saveIdAndPasswordToAndroidSSO', {
        'userAccount': '$userAccount',
        'password': '$password',
        'type': buildType
      });
      pr('passwordResult::${saveResult == 'success'}');
      return saveResult == 'success';
    }
  }

  Future<bool> setIsSaveId(bool value) async {
    if (Platform.isIOS) {
      final idResult =
          await iosPlatform.invokeMethod('setIsSaveId', {"value": value});
      return idResult == 'success';
    }
    if (Platform.isAndroid) {
      final saveResult = await androidPlatform.invokeMethod(
          'setIsSaveId', {'isSaveId': value ? 'Y' : 'N', 'type': buildType});
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

  // Future<bool> findKolonApps() async {
  //   final findResult = await androidPlatform.invokeMethod(
  //       'findKolonApps', buildType) as String;
  //   print('isFind .....$findResult');

  //   return (findResult == 'success') ? true : false;
  // }

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
      return {
        'isLogedinOtherApps': false,
      };
    }
    return {
      'isLogedinOtherApps': false,
    };
  }

  Future<SigninResult> sapLogin(String id) async {
    Map<String, dynamic>? sapBody = {
      "methodName": RequestType.SAP_SIGNIN_INFO.serverMethod,
      "methodParamMap": {
        "functionName": RequestType.SAP_SIGNIN_INFO.serverMethod,
        "IV_LOGID": id.toUpperCase(),
        "resultTables": RequestType.SAP_SIGNIN_INFO.resultTable,
        "appName": "medsalesportal"
      }
    };
    _api.init(RequestType.SAP_SIGNIN_INFO);
    final sapResult = await _api.request(body: sapBody);
    if (sapResult != null && sapResult.statusCode != 200) {
      return SigninResult(false, sapResult.message);
    }
    if (sapResult != null && sapResult.statusCode == 200) {
      sapLoginInfoResponseModel =
          SapLoginInfoResponseModel.fromJson(sapResult.body);
      var isSuccessfull =
          sapLoginInfoResponseModel?.data?.esReturn?.mtype == 'S';
      var message = tr('permission_denied');
      return SigninResult(isSuccessfull, message, isShowPopup: false);
    }
    return SigninResult(false, sapResult?.errorMessage ?? '');
  }

  Future<void> saveTcode() async {
    final commonTCODE = sapLoginInfoResponseModel!.data!.tCode!;
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

  Future<SigninResult> checkAccessPermmision(String userId) async {
    _api.init(RequestType.ACCESS_PERMISSION);
    var url =
        '${RequestType.ACCESS_PERMISSION.url()}/${Platform.isIOS ? '80' : '79'}/$userId';
    final result = await _api.request(passingUrl: url);
    if (result != null && result.body != null) {
      var accessPermmisionModel =
          AccessPermissionModel.fromJson(result.body['data']);
      pr(accessPermmisionModel.toJson());
      return SigninResult(
          accessPermmisionModel.accessApp!, accessPermmisionModel.accessMsg!,
          accessPermissionModel: accessPermmisionModel);
    }
    return SigninResult(false, tr('permmison biden'));
  }

  Future<SigninResult> signIn({bool? isWithAutoLogin}) async {
    var ssoUserId = '';
    var ssoUserPw = '';
    isLoadData = true;
    notifyListeners();
    Map<String, dynamic>? signBody;
    if (isWithAutoLogin != null && isWithAutoLogin) {
      var ssoResultMap = await getUserIdAndPasswordFromSSO();
      ssoUserId = "${ssoResultMap['userAccount']}".trim();
      ssoUserPw = "${ssoResultMap['password']}".trim();
      signBody = {"userAccount": ssoUserId, "passwd": ssoUserPw};
    } else {
      signBody = {
        "userAccount": userAccount != null ? userAccount!.trim() : '',
        "passwd": password != null ? password!.trim() : ''
      };
    }
    _api.init(RequestType.SIGNIN);
    final signResult = await _api.request(body: signBody);
    pr(signResult?.body);
    if (signResult!.statusCode == 200 && signResult.body['code'] == "NG") {
      var message = signResult.body['message'] as String;
      pr(message);
      var isMessageStartWithNumber =
          int.tryParse(message.trim().substring(0, 1)) != null;
      var isShowPopup = false;

      if (isMessageStartWithNumber) {
        pr(message.trim().substring(0, 1));
        var number = int.parse(message.trim().substring(0, 1));
        if (number < 5) {
          // message = tr('password_wrong_for_time', args: ['$number']);
          message = tr('password_wrong');
        } else {
          message = tr('password_wrong_five_time');
          isShowPopup = true;
        }
      }
      if (!isMessageStartWithNumber && signResult.body['data'] == null) {
        isShowPopup = true;
        message = tr('permission_denied');
      }
      isLoadData = false;
      notifyListeners();
      return SigninResult(false, message, isShowPopup: isShowPopup);
    }

    if (signResult.statusCode == 200 &&
        signResult.body['code'] != "NG" &&
        signResult.body['data'] != null) {
      pr('@@@@@@@${signResult.body}');
      pr('@@@@code:: ${signResult.body['code']}');
      user = User.fromJson(signResult.body['data']);
      var accessPermissionResult = await checkAccessPermmision(
          isWithAutoLogin != null && isWithAutoLogin
              ? ssoUserId
              : userAccount!);
      if (!accessPermissionResult.isSuccessful) {
        isLoadData = false;
        notifyListeners();
        return SigninResult(
            false,
            accessPermissionResult.message == '앱실행불가'
                ? tr('permission_denied')
                : accessPermissionResult.message,
            isShowPopup: true);
      }
      final tokenResult =
          await requestToken(signBody['userAccount'], signBody['passwd']);
      if (tokenResult != null) {
        user!.tokenInfo = tokenResult;
      } else {
        isLoadData = false;
        notifyListeners();
        return SigninResult(false, "token faild");
      }
      if (isWithAutoLogin == null) {
        setAutoLogin(isCheckedAutoSigninBox);
        setIsSaveId(isCheckedSaveIdBox);
      }

      await saveUserIdAndPasswordToSSO(
          signBody['userAccount'], signBody['passwd']);
      return await sapLogin(signBody['userAccount'].toUpperCase())
          .then((sapResult) async {
        if (sapResult.isSuccessful) {
          pr('ok successful');
          var esLogin = sapLoginInfoResponseModel!.data!.esLogin!;
          var isLogin = sapLoginInfoResponseModel!.data!.isLogin!;
          var isTeamLeader = esLogin.xtm == 'X';
          var isMultiAccount =
              esLogin.xtm == '' && esLogin.vkgrp == '' && esLogin.salem == '';
          CacheService.saveEsLogin(esLogin);
          CacheService.saveIsLogin(isLogin);
          CacheService.saveUser(user!);
          CacheService.saveAccountType(isMultiAccount
              ? AccountType.MULTI
              : isTeamLeader
                  ? AccountType.LEADER
                  : AccountType.NORMAL);

          var p = KeyService.baseAppKey.currentContext!.read<AppAuthProvider>();
          p.setSsalseGroupList(sapLoginInfoResponseModel!.data!.etOrghk!);
          pr('xtm ::${esLogin.xtm}\n');
          pr('vkgrp ::${esLogin.vkgrp}\n');
          pr('salem ::${esLogin.salem}\n');
          pr('p.isSalseGroup  ${p.isPermidedSalseGroup}');
          await saveTcode();
          final deviceInfoResult =
              await getDeviceInfo(signBody!['userAccount']);
          if (deviceInfoResult.isSuccessful) {
            // ------------ save  Environments ---------
            final envnResult =
                await checkUserEnvironment(signBody['userAccount']);
            if (envnResult != null) {
              var isSaveSuccessful =
                  await saveUserEven(envnResult, signBody['userAccount']);
              if (isSaveSuccessful) {
                var type = getThemeType(envnResult.textScale!);
                KeyService.baseAppKey.currentContext!
                    .read<AppThemeProvider>()
                    .setThemeType(type);
                setIsWaterMarkeUser();
                isLoadData = false;
                try {
                  notifyListeners();
                } catch (e) {}
                return SigninResult(true, 'ok');
              }
            }
          } else {
            return SigninResult(false, '${deviceInfoResult.message}',
                id: userAccount, pw: password, isShowPopup: true);
          }
          return SigninResult(true, '');
        } else {
          isWithAutoLogin = null;
          isLoadData = false;
          notifyListeners();
          return SigninResult(false, '${sapResult.message}',
              id: userAccount,
              pw: password,
              isShowPopup: sapResult.message.isNotEmpty);
        }
      });
    }
    isLoadData = false;
    notifyListeners();
    return SigninResult(false, tr('server_error'),
        id: userAccount, pw: password, isShowPopup: true);
  }

  Future<UserSettings?> checkUserEnvironment(String userAccount) async {
    Map<String, dynamic> _body = {
      "methodName": RequestType.GET_ENV.serverMethod,
      "methodParam": {
        "categoryCode": "envKey_$userAccount",
      }
    };
    _api.init(RequestType.GET_ENV);

    final envResult = await _api.request(body: _body);
    if (envResult!.body['code'] != 'NG') {
      if (envResult.body['data'] != null) {
        final temp =
            UserSettings.fromJson(envResult.body['data']['description']);
        print('from server! user Env ${temp.toJson()}');
        return temp;
      } else {
        print('new userSettings');
        final temp = UserSettings(
          isSetNotDisturb: true,
          isShowNotice: true,
          notDisturbStartHour: '23',
          notDisturbStartMine: '00',
          notDisturbStopHour: '07',
          notDisturbStopMine: '00',
          textScale: 'big',
        );
        return temp;
      }
    }
    return null;
  }

  Future<bool> saveUserEven(
      UserSettings passingUserSettings, String userAccount) async {
    var _api = ApiService();
    Map<String, dynamic> saveEnvBody = {
      "methodName": RequestType.SAVE_ENV.serverMethod,
      "methodParam": {
        "categoryCode": "envKey_$userAccount",
        "description": passingUserSettings.toJson()
      }
    };
    _api.init(RequestType.SAVE_ENV);
    final envRequest = await _api.request(body: saveEnvBody);
    if (envRequest!.statusCode == 200) {
      print('save Env successful ${envRequest.body}');
      return true;
    }
    return false;
  }

  Future<SigninResult> getDeviceInfo(String account) async {
    final deviceInfo = await DeviceInfoService.getDeviceInfo();
    print(deviceInfo.toJson());
    Map<String, dynamic> deviceInfoBody = {
      "methodName": RequestType.SAVE_DEVICE_INFO.serverMethod,
      "methodParam": {
        "deviceId": deviceInfo.deviceId,
        "deviceModelNo": deviceInfo.deviceModel,
        "devicePlatformName": Platform.isIOS ? 'iOS' : 'Android',
        "userId": account
      }
    };

    _api.init(RequestType.SAVE_DEVICE_INFO);
    final deviceInfoResult = await _api.request(body: deviceInfoBody);
    if (deviceInfoResult == null && deviceInfoResult!.statusCode != 200) {
      return SigninResult(false, 'Device not register');
    }
    if (deviceInfoResult.statusCode == 200) {
      return SigninResult(true, 'Device register successful');
    }
    return SigninResult(false, 'Device not register');
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
