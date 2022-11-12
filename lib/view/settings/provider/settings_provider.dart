import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medsalesportal/model/notice/notice_settings_data_model.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/enums/swich_type.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/rfc/es_login_model.dart';
import 'package:medsalesportal/model/user/user_settings.dart';
import 'package:medsalesportal/globalProvider/timer_provider.dart';
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
    NoticeSettingsDataModel? noticeDataModel;
    //! 현재 2중으로 저장하고 있음.
    // 유저환경저장 + notice Api 저장. (유저환경저장 methodName getOfAppUserEnv )
    // 수정 해야 할것!:
    // - 글씨크기는 local에 저장하고
    // - Notice 관련 정보는 신규개발될 noticeApi로 실시간 저장처리.

    var settings = lp.userSettings!;
    // var result = await lp.getAndSaveNotice();
    // if (result.isSuccessful) {
    //   noticeDataModel = result.data as NoticeSettingsDataModel;
    //   noticeSwichValue = noticeDataModel.notiUseYn == 'y';
    //   notdisturbSwichValue = noticeDataModel.stopNotiTimeUseYn == 'y';
    //   notDisturbStartHour =
    //       noticeDataModel.stopNotiTimeBeginTime?.substring(0, 2);
    //   notDisturbStartMinute =
    //       noticeDataModel.stopNotiTimeBeginTime?.substring(2);
    //   notDisturbEndHour = noticeDataModel.stopNotiTimeEndTime?.substring(0, 2);
    //   notDisturbEndMinute = noticeDataModel.stopNotiTimeEndTime?.substring(2);
    //   textScale = lp.userSettings!.textScale;
    // } else {
    //   noticeSwichValue = settings.isShowNotice;
    //   notdisturbSwichValue = settings.isSetNotDisturb;
    //   notDisturbStartHour = settings.notDisturbStartHour;
    //   notDisturbStartMinute = settings.notDisturbStartMine;
    //   notDisturbEndHour = settings.notDisturbStopHour;
    //   notDisturbEndMinute = settings.notDisturbStopMine;
    //   textScale = settings.textScale;
    // }

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
    var tp = KeyService.baseAppKey.currentContext!.read<TimerProvider>();
    tp.executeLastAction(
      lp.getAndSaveNotice(
          isSave: true,
          startTime:
              '${notDisturbStartHour ?? ''}${notDisturbStartMinute ?? ''}',
          endTime: '${notDisturbEndHour ?? ''}${notDisturbEndMinute ?? ''}'),
    );
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
    this.notDisturbEndMinute = minute;
    settings.notDisturbStopMine = minute;
    lp.setUserSettings(settings);
    notifyListeners();
  }

  void setSuggestion(String? text) {
    suggetionText = text;
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
