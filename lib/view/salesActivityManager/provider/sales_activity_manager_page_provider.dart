/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activityManeger/provider/activity_manager_page_provider.dart
 * Created Date: 2022-07-05 09:48:24
 * Last Modified: 2022-08-04 17:56:08
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/model/common/holiday_response_model.dart';
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
  HolidayResponseModel? holidayResponseModel;
  bool isLoadData = false;
  bool isLoadDayData = false;
  bool isLastDayNotConfirm = false;
  bool? isShowConfirm;
  bool? isResetDay;
  DateTime? selectedMonth;
  DateTime? selectedDay;
  DateTime? lastWorkDay;
  List<DateTime> holidayList = [];
  final _api = ApiService();

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

  void setIsResetDay(bool val) {
    isResetDay = val;
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

  Future<void> checkHoliday(String day) async {
    lastWorkDay = DateUtil.lastDay(dt: DateUtil.getDate(day));
    pr('@!@!@!@!@${lastWorkDay!.weekday}');
    while (lastWorkDay!.weekday == 7 ||
        lastWorkDay!.weekday == 6 ||
        holidayList.contains(lastWorkDay)) {
      lastWorkDay = DateUtil.lastDay(dt: lastWorkDay);
      pr(lastWorkDay!.toIso8601String());
    }
  }

  Future<ResultModel> getHolidayListForMonth(DateTime date) async {
    _api.init(RequestType.CHECK_HOLIDAY);
    final result = await _api.request(body: {
      'year': date.year,
      'month': date.month,
    });
    if (result != null && result.statusCode != 200) {
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      holidayResponseModel = HolidayResponseModel.fromJson(result.body);
      pr(holidayResponseModel?.toJson());
      return ResultModel(true);
    }
    return ResultModel(false);
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
      holidayList.clear();
      await getHolidayListForMonth(selectedMonth ?? DateTime.now())
          .whenComplete(() {
        if (holidayResponseModel!.data != null &&
            holidayResponseModel!.data!.isNotEmpty) {
          holidayResponseModel!.data!.forEach((holidayModel) {
            holidayList.add(DateUtil.getDate(holidayModel.locdate!));
          });
        }
      });
      monthResponseModel =
          SalesActivityMonthResponseModel.fromJson(result.body['data']);
      if (isWithLoading != null && isWithLoading) {
        isLoadData = false;
      }
      var now = DateTime.now();
      //  검색 하고자 하는 월의 2번쨰주?(data not null) data 가져와  <당월 여부> 확인.
      var randomDayOfMonth =
          DateUtil.getDate(monthResponseModel!.tList![2].day0!);
      if (randomDayOfMonth.year == now.year &&
          randomDayOfMonth.month == now.month) {
        var tempList = monthResponseModel!.tList!;
        for (var i = 0; i < tempList.length; i++) {
          (int index) {
            if (tempList[index].day0 != null &&
                tempList[index].day0!.isNotEmpty &&
                DateUtil.getDate(tempList[index].day0!).day == now.day) {
              pr('$index  ${tempList[index].day0}');
              lastWorkDay =
                  DateUtil.lastDay(dt: DateUtil.getDate(tempList[index].day0!));
              return;
            }
            if (tempList[index].day1 != null &&
                tempList[index].day1!.isNotEmpty &&
                DateUtil.getDate(tempList[index].day1!).day == now.day) {
              pr('$index  ${tempList[index].day1}');
              lastWorkDay =
                  DateUtil.lastDay(dt: DateUtil.getDate(tempList[index].day1!));
              checkHoliday(tempList[index].day1!);
              return;
            }
            if (tempList[index].day2 != null &&
                tempList[index].day2!.isNotEmpty &&
                DateUtil.getDate(tempList[index].day2!).day == now.day) {
              pr('$index  ${tempList[index].day2}');
              lastWorkDay =
                  DateUtil.lastDay(dt: DateUtil.getDate(tempList[index].day2!));
              checkHoliday(tempList[index].day2!);
              return;
            }
            if (tempList[index].day3 != null &&
                tempList[index].day3!.isNotEmpty &&
                DateUtil.getDate(tempList[index].day3!).day == now.day) {
              pr('$index  ${tempList[index].day3}');
              lastWorkDay =
                  DateUtil.lastDay(dt: DateUtil.getDate(tempList[index].day3!));
              checkHoliday(tempList[index].day3!);
              return;
            }
            if (tempList[index].day4 != null &&
                tempList[index].day4!.isNotEmpty &&
                DateUtil.getDate(tempList[index].day4!).day == now.day) {
              pr('$index  ${tempList[index].day4}');
              lastWorkDay =
                  DateUtil.lastDay(dt: DateUtil.getDate(tempList[index].day4!));
              checkHoliday(tempList[index].day4!);
              return;
            }
            if (tempList[index].day5 != null &&
                tempList[index].day5!.isNotEmpty &&
                DateUtil.getDate(tempList[index].day5!).day == now.day) {
              pr('$index  ${tempList[index].day5}');
              lastWorkDay =
                  DateUtil.lastDay(dt: DateUtil.getDate(tempList[index].day5!));
              checkHoliday(tempList[index].day5!);

              return;
            }
            if (tempList[index].day6 != null &&
                tempList[index].day6!.isNotEmpty &&
                DateUtil.getDate(tempList[index].day6!).day == now.day) {
              pr('$index  ${tempList[index].day6}');
              checkHoliday(tempList[index].day6!);
              return;
            }
          }(i);
        }
      } else {
        isLastDayNotConfirm = false;
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
      isResetDay = null;
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
