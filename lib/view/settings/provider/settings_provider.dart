import 'dart:io';
import 'dart:async';
import 'package:bpom/model/user/user.dart';
import 'package:flutter/material.dart';
import 'package:bpom/model/common/es_login_model.dart';
import 'package:provider/provider.dart';
import 'package:bpom/enums/swich_type.dart';
import 'package:bpom/enums/request_type.dart';
import 'package:bpom/service/key_service.dart';
import 'package:bpom/service/api_service.dart';
import 'package:bpom/service/cache_service.dart';
import 'package:bpom/model/user/user_settings.dart';
import 'package:bpom/globalProvider/login_provider.dart';
import 'package:bpom/model/update/check_update_model.dart';
import 'package:bpom/view/commonLogin/provider/update_and_notice_provider.dart';

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
    final user = CacheService.getUser();
    if (isFromFontSettinsPage ?? false) {
      await checkUpdate();
    }
    return SettingsResult(true,
        updateInfo: updateInfo, user: user);
  }

  Future<void> checkUpdate() async {
    var updateAndNoticeProvider =
        KeyService.baseAppKey.currentContext!.read<UpdateAndNoticeProvider>();
    final result = await updateAndNoticeProvider.checkUpdate();
    updateInfo = result.updateData!.model;
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

  Future<void> setNoticeSettings(SwichType swichType, bool val) async {
    var lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    var settings = UserSettings.fromJson(lp.userSettings!.toJson());
    switch (swichType) {
      case SwichType.SWICH_IS_NOT_DISTURB:
        settings.isSetNotDisturb = val;
        break;
      case SwichType.SWICH_IS_USE_NOTICE:
        settings.isShowNotice = val;
        break;
    }
    lp.setUserSettings(settings);
    lp.getAndSaveNotice(
        isSave: true,
        startTime:
            '${notDisturbStartHour != null && notDisturbStartHour!.isNotEmpty ? notDisturbStartHour : '07'}${notDisturbStartMinute != null && notDisturbStartMinute!.isNotEmpty ? notDisturbStartMinute : '00'}',
        endTime:
            '${notDisturbEndHour != null && notDisturbEndHour!.isNotEmpty ? notDisturbEndHour : '23'}${notDisturbEndMinute != null && notDisturbEndMinute!.isNotEmpty ? notDisturbEndMinute : '00'}');
  }

  void setNotDisturbStartHourValue(String hour) {
    var lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    var settings = UserSettings.fromJson(lp.userSettings!.toJson());
    this.notDisturbStartHour = hour;
    settings.notDisturbStartHour = hour;
    lp.setUserSettings(settings);
    notifyListeners();
  }

  void setNotDisturbStartMinuteValue(String minute) {
    var lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    var settings = UserSettings.fromJson(lp.userSettings!.toJson());
    this.notDisturbStartMinute = minute;
    settings.notDisturbStartMine = minute;
    lp.setUserSettings(settings);
    notifyListeners();
  }

  void setNotDisturbEndHourValue(String hour) {
    var lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    var settings = UserSettings.fromJson(lp.userSettings!.toJson());
    this.notDisturbEndHour = hour;
    settings.notDisturbStopHour = hour;
    lp.setUserSettings(settings);
    notifyListeners();
  }

  void setNotDisturbEndMinuteValue(String minute) {
    var lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    var settings = UserSettings.fromJson(lp.userSettings!.toJson());
    notDisturbEndMinute = minute;
    settings.notDisturbStopMine = minute;
    lp.setUserSettings(settings);
    notifyListeners();
  }

  void setSuggestion(String? text) {
    suggetionText = text;
    notifyListeners();
  }

  Future<bool> sendSuggestion() async {
    final user = CacheService.getUser();
    final _body = {
      "methodName": RequestType.SEND_SUGGETION.serverMethod,
      "methodParam": {
        "appId": Platform.isIOS ? '16893' : '16892',
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
  User?          user;
  SettingsResult(this.isSuccessful, {this.updateInfo, this.user});
}
