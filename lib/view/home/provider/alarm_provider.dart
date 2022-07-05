/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/view/home/provider/alarm_provider.dart
 * Created Date: 2022-01-03 14:00:12
 * Last Modified: 2022-07-05 11:43:10
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/model/rfc/home_notice_response_model.dart';
import 'package:medsalesportal/model/rfc/t_alarm_response_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';

class AlarmProvider extends ChangeNotifier {
  HomeNoticeResponseModel? homeNoticeResponseModel;

  //------ pageing ----------
  int pos = 0;
  int partial = 20;
  bool isLoadData = false;
  bool hasMore = true;
  Future<void> refresh() async {
    hasMore = true;
    homeNoticeResponseModel = null;
    getAlarmList(true);
  }

  Future<AlarmResult?> nextPage() async {
    if (hasMore) {
      return getAlarmList(false);
    }
    return null;
  }

  Future<AlarmResult> getAlarmList(bool isMounted) async {
    isLoadData = true;
    if (isMounted) {
      notifyListeners();
    }
    final isLogin = CacheService.getIsLogin();
    //* 첫페이지 일때 lastPageList =[]
    //* 첫페이지 아닐때 아니면  전페이지중에 확인처리 된 건 있으면 model 읽음으로 수정. [redck = 'X']
    Map<String, dynamic> body = {
      "methodName": RequestType.NOTICE_ALARM.serverMethod,
      "methodParamMap": {
        "functionName": RequestType.NOTICE_ALARM.serverMethod,
        "resultTables": RequestType.NOTICE_ALARM.resultTable,
        "resultColumns": RequestType.NOTICE_ALARM.resultColums,
        "IS_LOGIN": "$isLogin",
        "IV_SANUM_NM": "",
        "partial": partial,
        "pos": pos,
        "IV_FRMDT": "19990101", // start date
        "IV_TODT": "20211111", // end date
        "IV_NTYPE": ""
      }
    };
    final _api = ApiService();
    _api.init(RequestType.NOTICE_ALARM);
    final result = await _api.request(body: body);

    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      return AlarmResult(false);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      var temp = HomeNoticeResponseModel.fromJson(result.body['data']);
      if (temp.tZltsp0710 != null && temp.tZltsp0710!.length != partial) {
        hasMore = false;
        notifyListeners();
      }
      if (homeNoticeResponseModel == null) {
        homeNoticeResponseModel = temp;
      } else {
        homeNoticeResponseModel!.tZltsp0710!.addAll(temp.tZltsp0710!);
      }
      isLoadData = false;
      notifyListeners();
      return AlarmResult(true);
    }
    isLoadData = false;
    hasMore = false;
    notifyListeners();

    return AlarmResult(false);
  }
}

class AlarmResult {
  bool isSuccessful;
  AlarmResult(
    this.isSuccessful,
  );
}
