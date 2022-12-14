/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/view/home/provider/alarm_provider.dart
 * Created Date: 2022-01-03 14:00:12
 * Last Modified: 2022-11-15 11:04:37
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:bpom/model/notice/home_notice_detail_response_model.dart';
import 'package:bpom/model/notice/home_notice_response_model.dart';
import 'package:bpom/util/date_util.dart';
import 'package:bpom/util/format_util.dart';
import 'package:bpom/enums/request_type.dart';
import 'package:bpom/service/api_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bpom/service/cache_service.dart';
import 'package:bpom/model/common/result_model.dart';
import 'package:bpom/view/common/function_of_print.dart';

class NoticeProvider extends ChangeNotifier {
  HomeNoticeResponseModel? homeNoticeResponseModel;
  HomeNoticeDetailResponseModel? homeNoticeDetailResponseModel;
  String? noticeDetailTitle;
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

  Future<ResultModel?> nextPage() async {
    if (hasMore) {
      return getNoticeList(false);
    }
    return null;
  }

  Future<ResultModel> getNoticeDetail({required String noticeNumber}) async {
    isLoadData = true;
    _api.init(RequestType.HOME_NOTICE_DETAIL);
    Map<String, dynamic> _body = {
      "methodName": RequestType.HOME_NOTICE_DETAIL.serverMethod,
      "methodParamMap": {
        "functionName": RequestType.HOME_NOTICE_DETAIL.serverMethod,
        "resultTables": RequestType.HOME_NOTICE_DETAIL.resultTable,
        "resultColumns": RequestType.HOME_NOTICE_DETAIL.resultColums,
        //! ????????????.
        // "IV_NOTICENO": noticeNumber,
        "IV_NOTICENO": noticeNumber,
        "IS_LOGIN": "$isLogin",
        "IV_PTYPE": "R",
      }
    };
    final result = await _api.request(body: _body);
    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      homeNoticeDetailResponseModel =
          HomeNoticeDetailResponseModel.fromJson(result.body['data']);
      pr(homeNoticeDetailResponseModel?.toJson());
      noticeDetailTitle =
          homeNoticeDetailResponseModel!.tZLTSP0700!.single.nType == 'A'
              ? tr('notice')
              : homeNoticeDetailResponseModel!.tZLTSP0700!.single.nType == 'B'
                  ? tr('sys_notice')
                  : '';
      isLoadData = false;
      notifyListeners();
    }
    isLoadData = false;
    notifyListeners();
    return ResultModel(false);
  }

  Future<ResultModel> getNoticeList(bool isMounted) async {
    isLoadData = true;
    //* ???????????? ?????? lastPageList =[]
    //* ???????????? ????????? ?????????  ?????????????????? ???????????? ??? ??? ????????? model ???????????? ??????. [redck = 'X']
    Map<String, dynamic> _body = {
      "methodName": RequestType.HOME_NOTICE.serverMethod,
      "methodParamMap": {
        "functionName": RequestType.HOME_NOTICE.serverMethod,
        "resultTables": RequestType.HOME_NOTICE.resultTable,
        // "resultColumns": RequestType.HOME_NOTICE.resultColums,
        "IS_LOGIN": "$isLogin",
        "IV_SANUM_NM": '',
        "partial": partial,
        "pos": pos,
        // "IV_FRMDT": FormatUtil.removeDash(DateUtil.prevMonth()), // start date
        "IV_FRMDT": '19990101', // start date
        "IV_TODT": FormatUtil.removeDash(
            DateUtil.getDateStr(DateTime.now().toIso8601String())), // end date
        "IV_NTYPE": ""
      }
    };

    _api.init(RequestType.HOME_NOTICE);
    final result = await _api.request(body: _body);

    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      var temp = HomeNoticeResponseModel.fromJson(result.body['data']);
      pr(temp.toJson());
      if (temp.tZltsp0710 != null && temp.tZltsp0710!.length != partial) {
        hasMore = false;
        try {
          notifyListeners();
        } catch (e) {}
      }

      if (homeNoticeResponseModel == null) {
        homeNoticeResponseModel = temp;
      } else {
        homeNoticeResponseModel!.tZltsp0710!.addAll(temp.tZltsp0710!);
      }
      isLoadData = false;
      try {
        notifyListeners();
      } catch (e) {}
      return ResultModel(true);
    }
    isLoadData = false;
    hasMore = false;
    notifyListeners();

    return ResultModel(false);
  }
}
