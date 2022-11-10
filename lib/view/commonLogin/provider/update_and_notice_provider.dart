// ignore_for_file: import_of_legacy_library_into_null_safe, deprecated_member_use

/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/splash/commonLogin/provider/common_login_provider.dart
 * Created Date: 2021-10-06 03:26:46
 * Last Modified: 2022-11-10 10:37:32
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart' as openfile;
import 'package:medsalesportal/model/user/user.dart';
import 'package:medsalesportal/enums/notice_type.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/enums/update_type.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/user/user_settings.dart';
import 'package:medsalesportal/service/permission_service.dart';
import 'package:medsalesportal/model/notice/notice_model.dart';
import 'package:medsalesportal/service/local_file_servicer.dart';
import 'package:medsalesportal/service/package_info_service.dart';
import 'package:medsalesportal/globalProvider/login_provider.dart';
import 'package:medsalesportal/buildConfig/kolon_build_config.dart';
import 'package:medsalesportal/model/update/check_update_model.dart';
import 'package:medsalesportal/model/notice/notice_response_model.dart';
import 'package:medsalesportal/globalProvider/special_notice_provider.dart';
import 'package:medsalesportal/model/commonCode/common_code_response_model.dart';

class UpdateAndNoticeProvider extends ChangeNotifier {
  bool isdownloadStart = false;
  bool isShowWebView = false;
  bool isPopupTypeNotShowAgain = false;
  bool isUrlTypeNotShowAgain = false;
  User? user;
  CommonCodeResponseModel? commonCodeModel;
  CheckUpdateModel? updateItemModel;
  UpdateData? updateData;
  double? progress;
  int? updateFileSize;

  void setNotShowAgainForPopupType() {
    this.isPopupTypeNotShowAgain = !isPopupTypeNotShowAgain;
    notifyListeners();
  }

  void setNotShowAgainForUrlType() {
    this.isUrlTypeNotShowAgain = !isUrlTypeNotShowAgain;
    notifyListeners();
  }

  /// bakboem 2022.08.25
  /// 공지. 추석 특별추가.
  Future<ResultData> checkSpecialNotice() async {
    var result = ResultData(false);
    Map<String, dynamic> _param = {'appId': Platform.isIOS ? '2' : '1'};
    final _baseOption = BaseOptions(
        method: RequestType.SPECIAL_NOTICE.httpMethod,
        connectTimeout: 2000,
        receiveTimeout: 2000,
        sendTimeout: 2000,
        contentType: 'application/x-www-form-urlencoded');
    var dio = Dio(_baseOption);
    try {
      var rrs = await dio
          .request('${RequestType.SPECIAL_NOTICE.url()}',
              queryParameters: _param)
          .then((r) => r.data);
      print('?????$rrs');
      if (rrs != null && rrs is List) {
        var np =
            KeyService.baseAppKey.currentContext!.read<SpecialNoticeProvider>();
        np.setIsShowSpecialNotice(false);
        return result =
            rrs.isEmpty ? ResultData(false) : ResultData(true, data: rrs);
      }
    } catch (e) {
      print('Error 무시하기');
      return result;
    }
    return result;
  }

// --------------------// update // -----------------------------
// --------------------// update // -----------------------------
// --------------------// update // -----------------------------
  Future<UpdateAndNoticeResult> checkUpdate() async {
    var signinProvider =
        KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    final isAutoLogin = await signinProvider.isAutoLogin();
    var userid = '';
    if (isAutoLogin) {
      userid = await signinProvider.getIdonly().then((id) => id ?? '');
    }
    final packageInfo = await PackageInfoService.getInfo();
    print('currentVersion:: ${packageInfo.version}');
    final updateBody = {
      "methodName": RequestType.CHECK_UPDATE.serverMethod,
      "methodParam": {
        "currentVersion": "${KolonBuildConfig.KOLON_APP_VERSION_NAME}",
        "userId": userid.isNotEmpty ? userid.toUpperCase() : ''
      }
    };
    print('userid ::  $userid');
    var _api = ApiService();
    _api.init(RequestType.CHECK_UPDATE);
    final updateResult = await _api.request(body: updateBody);
    if (updateResult == null || updateResult.statusCode != 200) {
      return UpdateAndNoticeResult(false);
    }
    print(updateResult.body);
    if (updateResult.statusCode == 200 && updateResult.body['code'] != 'NG') {
      if (updateResult.body != null) {
        updateItemModel = CheckUpdateModel.fromJson(updateResult.body['data']);
        print(updateItemModel!.toJson());
        updateData = UpdateData(
            type: await prosseseUpdateType(updateItemModel!),
            model: updateItemModel!);
        notifyListeners();
        print(await prosseseUpdateType(updateItemModel!));
        return UpdateAndNoticeResult(true, updateData: updateData);
      }
    }
    return UpdateAndNoticeResult(false);
  }

  Future<UpdateType> prosseseUpdateType(CheckUpdateModel model) async {
    final isChoose = model.cmpsYn == 'y';
    final isWeb = model.updateKind == 'web';
    if (isChoose && isWeb) {
      return UpdateType.WEB_CHOOSE;
    }
    if (isChoose && !isWeb) {
      return UpdateType.NOT_WEB_ENFORCE;
    }
    if (!isChoose && isWeb) {
      return UpdateType.WEB_ENFORCE;
    }
    return UpdateType.WEB_CHOOSE;
  }

  Future doUpdate(BuildContext context, UpdateData updateData) async {
    if (Platform.isIOS) {
      iosUpdate(context, updateData);
    } else {
      androidUpdate(context, updateData);
    }
  }

  Future<void> iosUpdate(BuildContext context, UpdateData updateData) async {
    if (await canLaunch(updateData.model!.appUpdUrlAddr!)) {
      final isOpen =
          await launch(updateData.model!.appUpdUrlAddr!, forceSafariVC: false);
      if (isOpen) {
        print('open updateUrl successful');
        exit(0);
      }
    }
  }

  /// 다운로드 완료 후 바로 파일 오픈하기 위해 권한을 요청한다. [AppPermissionType.storage]
  /// 권한 부여 완료 후 [openFile] 함수 호출하여 apk파일을 열어준다.
  /// [OpenFile]은 네이티브 파일 열어주는 plugin이다.
  Future<void> androidUpdate(
      BuildContext context, UpdateData updateData) async {
    await PermissionService.requestPermission(Permission.storage);
    var _api = ApiService();
    final String dirName = 'download';
    final exists = await LocalFileService().checkDirectoryExits('$dirName');
    Directory? dir;
    if (exists) {
      dir = await LocalFileService().getDir(dirName);
    } else {
      dir = await LocalFileService().createDirectory('$dirName');
    }
    await Future.delayed(Duration.zero, () async {
      final file = await _api.downloadAndroid(
          updateData.model!.appUpdUrlAddr!,
          dir!.path,
          (progress, fileSize) => progressListener(progress, fileSize),
          '${dir.path}/SalesPortal${KolonBuildConfig.KOLON_APP_VERSION_NAME}.apk');
      if (file != null && file.path.isNotEmpty)
        await openFile(context, file.path).then((isOpend) {
          if (isOpend) {
            return exit(0);
          }
        });
    });
  }

  /// [_api.downloadAndroid]함수에서 콜백으로 [progressListener]를 실행해준다.
  /// [progress]는 progressindicator 에 사용된다.
  progressListener(int progress, int fileSize) {
    this.updateFileSize = fileSize;
    setProgress(progress);
    if (!isdownloadStart) {
      isdownloadStart = !isdownloadStart;
    }
  }

  setProgress(int progress) {
    this.progress = (progress / updateFileSize!);
    notifyListeners();
  }

  Future<bool> openFile(BuildContext context, String filepath) async {
    return await openfile.OpenFile.open(filepath).then((value) => true);
  }

  //  ------------------  // notice // ----------------------------
  //  ------------------  // notice // ----------------------------
  //  ------------------  // notice // ----------------------------
  bool isNotShowAgain = false;
  List<Map<NoticeType, List<NoticeModel?>>> noticeList = [];
  UserSettings? settings;

  Future<UpdateAndNoticeResult> checkNotice(bool isHome) async {
    print('inin11');
    var _api = ApiService();
    user = CacheService.getUser();
    // -------------- http request -------------
    _api.init(RequestType.CHECK_NOTICE);
    Map<String, dynamic> body = {
      'methodName': RequestType.CHECK_NOTICE.serverMethod,
      'methodParam': {"userId": user != null ? '${user!.userAccount}' : ''}
    };
    final noticeResult = await _api.request(body: body);
    if (noticeResult == null || noticeResult.statusCode != 200)
      return UpdateAndNoticeResult(false);
    // -------------- http request -------------
    if (noticeResult.statusCode == 200 && noticeResult.body['code'] != 'NG') {
      pr(noticeResult.body);
      // result.
      final result = NoticeResponseModel.fromJson(noticeResult.body['data']);
      print(result.toJson());
      print('result.noticeUrl.length ::: ${result.noticeUrl.length}');
      print('result.noticeError.length ::: ${result.noticeError.length}');
      print('result.noticeWorking.length ::: ${result.noticeWorking.length}');
      print(
          'result.noticeFullScreen.length ::: ${result.noticeFullScreen.length}');
      print('result.noticePopup.length ::: ${result.noticePopup.length}');
      result.noticeUrl.forEach((element) {
        print(element!.toJson());
      });
      print(result.noticeOrder);
      // 노출 순서 정열.
      if (result.noticeOrder.isEmpty) return UpdateAndNoticeResult(false);
      await Future.delayed(Duration.zero, () async {
        if (isHome) {
          selectData(result.noticeOrder, result.noticeSurvey,
              NoticeType.SURVEY_NOTICE);
          selectData(
              result.noticeOrder, result.noticeUrl, NoticeType.URL_NOTICE);
          selectData(result.noticeOrder, result.noticeFullScreen,
              NoticeType.FULL_SCREEN_NOTICE);
          selectData(
              result.noticeOrder, result.noticePopup, NoticeType.POP_UP_NOTICE);
        } else {
          selectData(
              result.noticeOrder, result.noticeError, NoticeType.ERROR_NOTICE);
          selectData(
              result.noticeOrder, result.noticeWorking, NoticeType.WORK_NOTICE);
        }
      });
      var isHaveNotice = false;
      noticeList.forEach((map) =>
          map.values.isNotEmpty ? isHaveNotice = true : DoNothingAction());
      if (isHaveNotice) {
        notifyListeners();
        return UpdateAndNoticeResult(true, noticeData: NoticeData(noticeList));
      }
    }
    return UpdateAndNoticeResult(false);
  }

  void selectData(
      List<int?> orderList, List<NoticeModel?> data, NoticeType type) {
    var temp = <NoticeModel>[];
    data.forEach((notice) {
      if (orderList.contains(notice!.id)) {
        temp.add(notice);
        notice.toJson().forEach((key, value) {
          print('key:: $key');
          print('value::$value');
        });
      }
    });
    if (temp.isNotEmpty) {
      noticeList.add({type: temp});
    }
  }

  Future<void> changeNotShowAgain(bool? ischeked) async {
    if (ischeked != null) {
      this.isNotShowAgain = ischeked;
    }
  }

  // -------- Don't show again ----------
  Future<UpdateAndNoticeResult> dontShowAgain(int noticeId) async {
    final user = CacheService.getUser();
    var _api = ApiService();
    Map<String, dynamic> body = {
      "methodName": RequestType.NOTICE_DONT_SHOW_AGAIN.serverMethod,
      "methodParam": {
        "noticeId": '$noticeId',
        "userId": "${user != null ? user.id : ''}"
      }
    };
    _api.init(RequestType.NOTICE_DONT_SHOW_AGAIN);
    final result = await _api.request(body: body);
    if (result == null || result.statusCode != 200) {
      return UpdateAndNoticeResult(false);
    }
    if (result.body['code'] == 'OK' && result.statusCode == 200) {
      return UpdateAndNoticeResult(true);
    }

    return UpdateAndNoticeResult(false);
  }
}

class UpdateAndNoticeResult {
  bool isSuccessful;
  UpdateData? updateData;
  NoticeData? noticeData;
  UpdateAndNoticeResult(this.isSuccessful, {this.updateData, this.noticeData});
}

class UpdateData {
  UpdateType? type;
  CheckUpdateModel? model;
  UpdateData({this.type, this.model});
}

class NoticeData {
  List<Map<NoticeType, List<NoticeModel?>>>? noticeList;

  NoticeData(this.noticeList);
}

class ResultData {
  bool isSuccessful;
  dynamic data;
  ResultData(this.isSuccessful, {this.data});
}
