import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/rfc/es_login_model.dart';
import 'package:medsalesportal/model/user/user_settings.dart';
import 'package:medsalesportal/globalProvider/login_provider.dart';
import 'package:medsalesportal/model/update/check_update_model.dart';
import 'package:medsalesportal/view/commonLogin/provider/update_and_notice_provider.dart';

class SettingsProvider extends ChangeNotifier {
  CheckUpdateModel? updateInfo;
  bool? notdisturbSwichValue;
  bool? noticeSwichValue;
  String? textScale;
  String? notDisturbStartHour;
  String? notDisturbStartMinute;
  String? notDisturbEndHour;
  String? notDisturbEndMinute;
  String? suggetionText;
  final List<String> _timePickerHourList = [];
  final List<String> _timePickerminuteList = [];
  bool get isSuggestionTextNotEmpty =>
      suggetionText != null && suggetionText!.isNotEmpty && suggetionText != '';
  Future<SettingsResult> init(
      {bool? isFromSettingsPage,
      bool? isFromFontSettinsPage,
      bool? isFromNoticeSettingsPage}) async {
    final esLogin = CacheService.getEsLogin();
    var settings = await initData();
    if (isFromFontSettinsPage ?? false) {
      await checkUpdate();
    }
    return SettingsResult(true,
        updateInfo: updateInfo, settings: settings, esLogin: esLogin);
  }

  Future<UserSettings> initData() async {
    var lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    var settings = lp.userSettings!;
    noticeSwichValue = settings.isShowNotice;
    notdisturbSwichValue = settings.isSetNotDisturb;
    notDisturbStartHour = settings.notDisturbStartHour;
    notDisturbStartMinute = settings.notDisturbStartMine;
    notDisturbEndHour = settings.notDisturbStopHour;
    notDisturbEndMinute = settings.notDisturbStopMine;
    textScale = settings.textScale;
    return settings;
  }

  Future<void> checkUpdate() async {
    var updateAndNoticeProvider = UpdateAndNoticeProvider();
    final result = await updateAndNoticeProvider.checkUpdate();
    updateInfo = result.updateData!.model;
    updateAndNoticeProvider.dispose();
  }

  List<String> get timePickerHourList {
    if (_timePickerHourList.isEmpty) {
      for (var i = 0; i < 24; i++) {
        if (i < 10) {
          _timePickerHourList.add('0$i');
        } else {
          _timePickerHourList.add('$i');
        }
      }
    }
    return this._timePickerHourList;
  }

  List<String> get timePickerminuteList {
    if (_timePickerminuteList.isEmpty) {
      for (var i = 0; i < 60; i++) {
        if (i < 10) {
          _timePickerminuteList.add('0$i');
        } else {
          _timePickerminuteList.add('$i');
        }
      }
    }
    return this._timePickerminuteList;
  }

  setNotdisturbSwichValue(bool value) {
    var lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    var settings = lp.userSettings!;
    this.notdisturbSwichValue = value;
    settings.isSetNotDisturb = value;
    lp.setUserSettings(settings);
    notifyListeners();
  }

  setNoticeSwichValue(bool value) {
    var lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    var settings = UserSettings.fromJson(lp.userSettings!.toJson());
    this.noticeSwichValue = value;
    settings.isShowNotice = value;
    lp.setUserSettings(settings);
    notifyListeners();
  }

  setNotDisturbStartHourValue(String hour) {
    var lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    var settings = UserSettings.fromJson(lp.userSettings!.toJson());
    this.notDisturbStartHour = hour;
    settings.notDisturbStartHour = hour;
    lp.setUserSettings(settings);
    notifyListeners();
  }

  setNotDisturbStartMinuteValue(String minute) {
    var lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    var settings = UserSettings.fromJson(lp.userSettings!.toJson());
    this.notDisturbStartMinute = minute;
    settings.notDisturbStartMine = minute;
    lp.setUserSettings(settings);
    notifyListeners();
  }

  setNotDisturbEndHourValue(String hour) {
    var lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    var settings = UserSettings.fromJson(lp.userSettings!.toJson());
    this.notDisturbEndHour = hour;
    settings.notDisturbStopHour = hour;
    lp.setUserSettings(settings);
    notifyListeners();
  }

  setNotDisturbEndMinuteValue(String minute) {
    var lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    var settings = UserSettings.fromJson(lp.userSettings!.toJson());
    this.notDisturbEndMinute = minute;
    settings.notDisturbStopMine = minute;
    lp.setUserSettings(settings);
    notifyListeners();
  }

  setSuggestion(String text) {
    this.suggetionText = text;
    notifyListeners();
  }

  Future<bool> saveUserEvn() async {
    var loginProvider =
        KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    var result = await loginProvider.saveUserEnvironment();
    return result.data != null;
  }

  Future<bool> sendSuggestion() async {
    final user = CacheService.getUser();
    final _body = {
      "methodName": RequestType.SEND_SUGGETION.serverMethod,
      "methodParam": {
        "appId": Platform.isIOS ? '80' : '79',
        "appOpnnExpsrYn": "Y",
        "revicwDscr": "$suggetionText",
        "userId": "${user!.userAccount}"
      }
    };
    var _api = ApiService();
    _api.init(RequestType.SEND_SUGGETION);
    final result = await _api.request(body: _body);
    if (result == null || result.statusCode != 200) {
      return false;
    }
    if (result.statusCode == 200 || result.body['code'] == 'OK') {
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    var loginProvider =
        KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    await loginProvider
        .setAutoLogin(false)
        .then((value) => print('setAutoLogin to $value'));
  }
}

class SettingsResult {
  bool isSuccessful;
  CheckUpdateModel? updateInfo;
  UserSettings? settings;
  EsLoginModel? esLogin;
  SettingsResult(this.isSuccessful,
      {this.updateInfo, this.settings, this.esLogin});
}
