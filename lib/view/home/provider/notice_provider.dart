/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/view/home/provider/alarm_provider.dart
 * Created Date: 2022-01-03 14:00:12
 * Last Modified: 2022-07-07 16:31:03
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/model/rfc/home_notice_detail_response_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/rfc/home_notice_response_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class NoticeProvider extends ChangeNotifier {
  HomeNoticeResponseModel? homeNoticeResponseModel;
  HomeNoticeDetailResponseModel? homeNoticeDetailResponseModel;
  final _api = ApiService();
  final isLogin = CacheService.getIsLogin();
  //------ pageing ----------
  int pos = 0;
  int partial = 20;
  bool isLoadData = false;
  bool hasMore = true;
  Future<void> refresh() async {
    hasMore = true;
    homeNoticeResponseModel = null;
    notifyListeners();
    getNoticeList(true);
  }

  Future<NoticeResult?> nextPage() async {
    if (hasMore) {
      return getNoticeList(false);
    }
    return null;
  }

  Future<NoticeResult> getNoticeDetail({required String noticeNumber}) async {
    isLoadData = true;
    _api.init(RequestType.HOME_NOTICE_DETAIL);
    Map<String, dynamic> _body = {
      "methodName": RequestType.HOME_NOTICE_DETAIL.serverMethod,
      "methodParamMap": {
        "functionName": RequestType.HOME_NOTICE_DETAIL.serverMethod,
        "resultTables": RequestType.HOME_NOTICE_DETAIL.resultTable,
        "resultColumns": RequestType.HOME_NOTICE_DETAIL.resultColums,
        "IV_NOTICENO": "NT1000000080",
        "IS_LOGIN": "$isLogin",
        "IV_PTYPE": "R",
      }
    };
    final result = await _api.request(body: _body);
    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      return NoticeResult(false);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      homeNoticeDetailResponseModel =
          HomeNoticeDetailResponseModel.fromJson(result.body['data']);
      pr(homeNoticeDetailResponseModel?.toJson());
      isLoadData = false;
      notifyListeners();
    }
    isLoadData = false;
    notifyListeners();
    return NoticeResult(false);
  }

  Future<NoticeResult> getNoticeList(bool isMounted) async {
    isLoadData = true;
    //* 첫페이지 일때 lastPageList =[]
    //* 첫페이지 아닐때 아니면  전페이지중에 확인처리 된 건 있으면 model 읽음으로 수정. [redck = 'X']
    Map<String, dynamic> _body = {
      "methodName": RequestType.HOME_NOTICE.serverMethod,
      "methodParamMap": {
        "functionName": RequestType.HOME_NOTICE.serverMethod,
        "resultTables": RequestType.HOME_NOTICE.resultTable,
        "resultColumns": RequestType.HOME_NOTICE.resultColums,
        "IS_LOGIN": "$isLogin",
        "IV_SANUM_NM": "",
        "partial": partial,
        "pos": pos,
        "IV_FRMDT": "19990101", // start date
        "IV_TODT": "20211111", // end date
        "IV_NTYPE": ""
      }
    };

    _api.init(RequestType.HOME_NOTICE);
    final result = await _api.request(body: _body);

    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      return NoticeResult(false);
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
      return NoticeResult(true);
    }
    isLoadData = false;
    hasMore = false;
    notifyListeners();

    return NoticeResult(false);
  }
}

class NoticeResult {
  bool isSuccessful;
  NoticeResult(
    this.isSuccessful,
  );
}