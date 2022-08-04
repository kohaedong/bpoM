/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activityManeger/provider/activity_manager_page_provider.dart
 * Created Date: 2022-07-05 09:48:24
 * Last Modified: 2022-08-04 13:26:47
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_month_response_model.dart';
import 'package:medsalesportal/model/rfc/search_key_response_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class SalseActivityManagerPageProvider extends ChangeNotifier {
  SalesActivityMonthResponseModel? monthResponseModel;
  SalesActivityDayResponseModel? dayResponseModel;
  SearchKeyResponseModel? searchKeyResponseModel;
  bool isLoadData = false;
  bool isLoadDayData = false;
  bool? isShowConfirm;
  int? tabIndex;
  DateTime? selectedMonth;
  DateTime? selectedDay;
  final _api = ApiService();
  void setTabIndex(int index) {
    this.tabIndex = index;
    notifyListeners();
  }

  void setSelectedDate(DateTime dt) {
    selectedDay = dt;
    notifyListeners();
  }

  void setIsShowConfirm(bool val) {
    isShowConfirm = val;
    notifyListeners();
  }

  void resetDayData() {
    dayResponseModel = null;
    notifyListeners();
  }

  void getNextMonthData() {
    if (selectedMonth == null) {
      selectedMonth = DateUtil.getDate(DateUtil.nextMonth());
    } else {
      selectedMonth = DateUtil.getDate(DateUtil.nextMonth(dt: selectedMonth));
    }
    getMonthData(isWithLoading: true);
  }

  void checkShowConfirm() async {
    isShowConfirm = true;
    notifyListeners();
  }

  void getLastMonthData() {
    if (selectedMonth == null) {
      selectedMonth = DateUtil.getDate(DateUtil.prevMonth());
    } else {
      selectedMonth = DateUtil.getDate(DateUtil.prevMonth(dt: selectedMonth));
    }
    getMonthData(isWithLoading: true);
  }

  void getNextDayData() {
    if (selectedDay == null) {
      selectedDay = DateUtil.nextDay();
    } else {
      selectedDay = DateUtil.nextDay(dt: selectedDay);
    }
    getDayData(isWithLoading: true);
    notifyListeners();
  }

  void getLastDayData() {
    if (selectedDay == null) {
      selectedDay = DateUtil.lastDay();
    } else {
      selectedDay = DateUtil.lastDay(dt: selectedDay);
    }
    getDayData(isWithLoading: true);
    notifyListeners();
  }

  void getSelectedMonthData(DateTime date) {
    if (selectedMonth != null &&
        selectedMonth!.month == date.month &&
        selectedMonth!.year == date.year) {
      return;
    }
    selectedMonth = date;
    getMonthData(isWithLoading: true);
  }

  void getSelectedDayData(DateTime date) {
    selectedDay = date;
    notifyListeners();
    getDayData(isWithLoading: true);
  }

  Future<ResultModel> searchPartmentKeyZBIZ() async {
    _api.init(RequestType.SEARCH_PARTMENT_KEY_ZIBI);
    var isLogin = CacheService.getIsLogin();
    Map<String, dynamic> _body = {
      "methodName": RequestType.SEARCH_PARTMENT_KEY_ZIBI.serverMethod,
      "methodParamMap": {
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.SEARCH_PARTMENT_KEY_ZIBI.resultTable,
        "functionName": RequestType.SEARCH_PARTMENT_KEY_ZIBI.serverMethod
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      searchKeyResponseModel =
          SearchKeyResponseModel.fromJson(result.body['data']);
      pr(searchKeyResponseModel?.toJson());
      return ResultModel(true);
    }
    return ResultModel(false);
  }

  Future<ResultModel> getMonthData({bool? isWithLoading}) async {
    if (isWithLoading != null && isWithLoading) {
      isLoadData = true;
      notifyListeners();
    }
    if (searchKeyResponseModel == null) {
      await searchPartmentKeyZBIZ();
    }
    _api.init(RequestType.SALESE_ACTIVITY_MONTH_DATA);
    var esLogin = CacheService.getEsLogin();
    var isLogin = CacheService.getIsLogin();
    Map<String, dynamic> _body = {
      "methodName": RequestType.SALESE_ACTIVITY_MONTH_DATA.serverMethod,
      "methodParamMap": {
        "IV_ZBIZ": searchKeyResponseModel!.tList!.first.zbiz,
        "IV_RESID": esLogin!.logid!.toUpperCase(),
        "IS_LOGIN": isLogin,
        "IV_VKGRP": esLogin.vkgrp,
        "IV_SPMON": DateUtil.getMonthStr(
            selectedMonth != null ? selectedMonth! : DateTime.now()),
        "resultTables": RequestType.SALESE_ACTIVITY_MONTH_DATA.resultTable,
        "functionName": RequestType.SALESE_ACTIVITY_MONTH_DATA.serverMethod
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      if (isWithLoading != null && isWithLoading) {
        isLoadData = false;
        notifyListeners();
      }
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      monthResponseModel =
          SalesActivityMonthResponseModel.fromJson(result.body['data']);
      if (isWithLoading != null && isWithLoading) {
        isLoadData = false;
      }
      notifyListeners();
      return ResultModel(true);
    }
    if (isWithLoading != null && isWithLoading) {
      isLoadData = false;
    }
    notifyListeners();
    return ResultModel(true);
  }

  Future<ResultModel> getDayData({bool? isWithLoading}) async {
    if (selectedDay != null &&
        dayResponseModel != null &&
        dayResponseModel!.table250 != null &&
        dayResponseModel!.table250!.isNotEmpty &&
        dayResponseModel!.table250!.first.adate ==
            FormatUtil.removeDash(DateUtil.getDateStr('', dt: selectedDay))) {
      pr('back!!!');
      return ResultModel(true);
    }

    if (isWithLoading != null && isWithLoading) {
      isLoadDayData = true;
      notifyListeners();
    }

    _api.init(RequestType.SALESE_ACTIVITY_DAY_DATA);
    var isLogin = CacheService.getIsLogin();
    Map<String, dynamic> _body = {
      "methodName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      "methodParamMap": {
        "IV_PTYPE": "R",
        "IV_ADATE": FormatUtil.removeDash(
            DateUtil.getDateStr('', dt: selectedDay ?? DateTime.now())),
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.SALESE_ACTIVITY_DAY_DATA.resultTable,
        "functionName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      if (isWithLoading != null && isWithLoading) {
        isLoadDayData = false;
        notifyListeners();
      }
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      dayResponseModel =
          SalesActivityDayResponseModel.fromJson(result.body['data']);

      dayResponseModel?.table260!.forEach((element) {
        pr(element.toJson());
      });
      if (isWithLoading != null && isWithLoading) {
        isLoadDayData = false;
      }
      checkShowConfirm();
      return ResultModel(true);
    }
    if (isWithLoading != null && isWithLoading) {
      isLoadDayData = false;
    }
    notifyListeners();
    return ResultModel(true);
  }
}
