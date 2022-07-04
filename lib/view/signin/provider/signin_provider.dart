import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medsalesportal/buildConfig/kolon_build_config.dart';
import 'package:medsalesportal/enums/app_theme_type.dart';
import 'package:medsalesportal/enums/hive_box_type.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/model/http/token_model.dart';
import 'package:medsalesportal/model/rfc/sap_login_info_response_model.dart';
import 'package:medsalesportal/model/user/user.dart';
import 'package:medsalesportal/model/user/user_settings.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/service/deviceInfo_service.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/service/navigator_service.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/view/common/provider/app_theme_provider.dart';
import 'package:medsalesportal/view/common/provider/water_marke_provider.dart';
import 'package:provider/provider.dart';

class SigninProvider extends ChangeNotifier {
  String errorMessage = '';
  String? userAccount;
  String? password;
  bool? isIdFocused;
  bool? isPwFocused;
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

  void setIdCheckBox() {
    this.isCheckedSaveIdBox = !isCheckedSaveIdBox;
    notifyListeners();
  }

  void setIsIdFocused(bool val) {
    isIdFocused = val;
    notifyListeners();
  }

  void setIsPwFocused(bool val) {
    isPwFocused = val;
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
    if (!this.isCheckedSaveIdBox) {
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
    if (str == null || str.length == 1 || str == '') {
      notifyListeners();
    }
  }

  void setPassword(String? password) {
    this.password = (password == '' ? null : password);
    if (password == null || password.length == 1 || password == '') {
      notifyListeners();
    }
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
      return idResult == 'success' && passwordResult == 'success';
    } else {
      final saveResult = await androidPlatform.invokeMethod(
          'saveIdAndPasswordToAndroidSSO', {
        'userAccount': '$userAccount',
        'password': '$password',
        'type': buildType
      });
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
    if (Platform.isIOS) {
      final idResult =
          await iosPlatform.invokeMethod('saveAutoLogin', {"value": value});
      return idResult == 'success';
    }
    if (Platform.isAndroid) {
      final saveResult = await androidPlatform.invokeMethod('saveAutoLogin',
          {'isAutoLogin': value ? 'Y' : 'N', 'type': buildType});

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
        final p = NavigationService.kolonAppKey.currentContext!
            .read<WaterMarkeProvider>();
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

  bool get isValueNotNull => this.userAccount != null && this.password != null;

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
      pr('????${sapLoginInfoResponseModel?.data?.isLogin}');
      return SigninResult(true, 'login successful', isShowPopup: false);
    }
    return SigninResult(false, '');
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

  Future<SigninResult> signIn({bool? isWithAutoLogin}) async {
    isLoadData = true;
    notifyListeners();
    Map<String, dynamic>? signBody;
    if (isWithAutoLogin != null && isWithAutoLogin) {
      var ssoResultMap = await getUserIdAndPasswordFromSSO();
      signBody = {
        "userAccount": "${ssoResultMap['userAccount']}",
        "passwd": "${ssoResultMap['password']}"
      };
    } else {
      signBody = {"userAccount": userAccount ?? '', "passwd": password ?? ''};
    }
    _api.init(RequestType.SIGNIN);
    final signResult = await _api.request(body: signBody);

    if (signResult!.statusCode == 200 && signResult.body['code'] == "NG") {
      isLoadData = false;
      notifyListeners();
      return SigninResult(false, "${tr('check_account')}");
    }
    if (signResult.statusCode == 200 && signResult.body['data'] != null) {
      user = User.fromJson(signResult.body['data']);
      final tokenResult =
          await requestToken(signBody['userAccount'], signBody['passwd']);

      if (tokenResult != null) {
        user!.tokenInfo = tokenResult;
      } else {
        isLoadData = false;
        notifyListeners();
        return SigninResult(false, "token faild");
      }
      return await sapLogin(userAccount!.toUpperCase()).then((sapResult) async {
        if (sapResult.isSuccessful) {
          pr('ok successful');
          CacheService.saveEsLogin(sapLoginInfoResponseModel!.data!.esLogin!);
          CacheService.saveIsLogin(sapLoginInfoResponseModel!.data!.isLogin!);
          CacheService.saveUser(user!);
          if (isWithAutoLogin == null) {
            setAutoLogin(isCheckedAutoSigninBox);
            setIsSaveId(isCheckedSaveIdBox);
          }
          saveUserIdAndPasswordToSSO(userAccount!, password!);
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
                NavigationService.kolonAppKey.currentContext!
                    .read<AppThemeProvider>()
                    .setThemeType(type);
                setIsWaterMarkeUser();
                isLoadData = false;
                notifyListeners();
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
          return SigninResult(false, '${sapResult.message}',
              id: userAccount, pw: password, isShowPopup: true);
        }
      });
    }
    isLoadData = false;
    notifyListeners();
    return SigninResult(false, '${signResult.errorMessage}',
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
          notDisturbStartHour: '',
          notDisturbStartMine: '',
          notDisturbStopHour: '',
          notDisturbStopMine: '',
          textScale: 'medium',
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
  SigninResult(this.isSuccessful, this.message,
      {this.id, this.pw, this.isShowPopup});
}
