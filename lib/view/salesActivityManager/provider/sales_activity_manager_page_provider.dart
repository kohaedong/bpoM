/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activityManeger/provider/activity_manager_page_provider.dart
 * Created Date: 2022-07-05 09:48:24
 * Last Modified: 2022-08-05 13:49:57
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
  List<List<DateTime?>> weekListForMonth = [];
  bool isLoadData = false;
  bool isLoadDayData = false;
  bool isShowAnimation = false;
  bool? isShowConfirm;
  bool? isResetDay;
  bool? isShowPopup;
  DateTime? selectedMonth;
  DateTime? selectedDay;
  DateTime? lastWorkDay;
  DateTime? lastWorkDaysNextWorkDay;
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

  void setIsShowAnimation() {
    isShowAnimation = !isShowAnimation;
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

  void checkShowConfirm() {
    isShowConfirm = (selectedDay!.day == DateTime.now().day);
    notifyListeners();
  }

  bool isHaveUnconfirmedActivity(
      bool isNotConfirm, String? val1, String? val2) {
    return isNotConfirm &&
        (int.parse(val1 != null && val1.isNotEmpty ? val1.trim() : '0') !=
            int.parse(val2 != null && val2.isNotEmpty ? val2.trim() : '0'));
  }

  Future<void> checkIsShowPopup() async {
    await checkLastWorkDaysNextWorkDay(DateTime.now());
    var weekListIndex = 0;
    var weekRowIndex = 0;
    weekListForMonth.asMap().entries.forEach((map) {
      var lastworkDay = DateUtil.getDate(
          FormatUtil.removeDash(DateUtil.getDateStr('', dt: lastWorkDay)));
      if (map.value.contains(lastworkDay)) {
        weekListIndex = map.key;
        weekRowIndex = map.value.indexOf(lastworkDay);
      }
    });
    pr('listIndex::: $weekListIndex');
    pr('weekRowIndex::: $weekRowIndex');
    var model = monthResponseModel!.tList![weekListIndex];
    var isLastDayNotConfirm = (weekRowIndex == 0
        ? isHaveUnconfirmedActivity(
            model.day04 != 'C', model.day01, model.day02)
        : weekRowIndex == 1
            ? isHaveUnconfirmedActivity(
                model.day14 != 'C', model.day11, model.day12)
            : weekRowIndex == 2
                ? isHaveUnconfirmedActivity(
                    model.day24 != 'C', model.day21, model.day22)
                : weekRowIndex == 3
                    ? isHaveUnconfirmedActivity(
                        model.day34 != 'C', model.day31, model.day32)
                    : weekRowIndex == 4
                        ? isHaveUnconfirmedActivity(
                            model.day44 != 'C', model.day41, model.day42)
                        : weekRowIndex == 5
                            ? isHaveUnconfirmedActivity(
                                model.day54 != 'C', model.day51, model.day52)
                            : isHaveUnconfirmedActivity(
                                model.day64 != 'C', model.day61, model.day62));
    // &&   DateUtil.getDate(model.!)
    // .isBefore(DateTime.now());

    isShowPopup = (lastWorkDaysNextWorkDay!.day == DateTime.now().day) &&
        isLastDayNotConfirm;
    pr('show popup ???? $isShowPopup');
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

  Future<void> checkLastWorkDaysNextWorkDay(DateTime dt) async {
    await checkLastDay('', dt: dt);
    lastWorkDaysNextWorkDay = DateUtil.nextDay(dt: lastWorkDay);
    pr('lastWorkDaysNextWorkDay is not holiday, lastWorkDaysNextWorkDay :: ${lastWorkDaysNextWorkDay!.weekday}');
    while (lastWorkDaysNextWorkDay!.weekday == 7 ||
        lastWorkDaysNextWorkDay!.weekday == 6 ||
        holidayList.contains(lastWorkDaysNextWorkDay)) {
      lastWorkDaysNextWorkDay = DateUtil.nextDay(dt: lastWorkDaysNextWorkDay);
      pr('lastWorkDaysNextWorkDay :: ${lastWorkDaysNextWorkDay!.weekday}');
    }
  }

  Future<void> checkLastDay(String day, {DateTime? dt}) async {
    lastWorkDay = DateUtil.lastDay(dt: dt ?? DateUtil.getDate(day));
    pr('lastWorkDay is not holiday, LastWorkDay :: ${lastWorkDay!.weekday}');
    while (lastWorkDay!.weekday == 7 ||
        lastWorkDay!.weekday == 6 ||
        holidayList.contains(lastWorkDay)) {
      lastWorkDay = DateUtil.lastDay(dt: lastWorkDay);
      pr('lastWorkDay:: ${lastWorkDay!.weekday}');
    }
  }

  Future<ResultModel> getHolidayListForMonth(DateTime date) async {
    pr(date.toIso8601String());
    if (holidayList.isEmpty ||
        (holidayList.isNotEmpty && holidayList.first.month != date.month)) {
      _api.init(RequestType.CHECK_HOLIDAY);
      final result = await _api.request(body: {
        'year': date.year,
        'month': date.month,
      });
      if (result != null && result.statusCode != 200) {
        return ResultModel(false);
      }
      if (result != null && result.statusCode == 200) {
        holidayList.clear();
        holidayResponseModel = HolidayResponseModel.fromJson(result.body);
        pr(holidayResponseModel?.toJson());
        if (holidayResponseModel!.data != null &&
            holidayResponseModel!.data!.isNotEmpty) {
          holidayResponseModel!.data!.forEach((holidayModel) {
            holidayList.add(DateUtil.getDate(holidayModel.locdate!));
          });
        }
        return ResultModel(true);
      }
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
      monthResponseModel =
          SalesActivityMonthResponseModel.fromJson(result.body['data']);
      if (monthResponseModel != null && monthResponseModel!.tList!.isNotEmpty) {
        weekListForMonth.clear();
        monthResponseModel!.tList!.forEach((e) {
          var week0 = e.day0 != null ? DateUtil.getDate(e.day0!) : null;
          var week1 = e.day1 != null ? DateUtil.getDate(e.day1!) : null;
          var week2 = e.day2 != null ? DateUtil.getDate(e.day2!) : null;
          var week3 = e.day3 != null ? DateUtil.getDate(e.day3!) : null;
          var week4 = e.day4 != null ? DateUtil.getDate(e.day4!) : null;
          var week5 = e.day5 != null ? DateUtil.getDate(e.day5!) : null;
          var week6 = e.day6 != null ? DateUtil.getDate(e.day6!) : null;
          weekListForMonth
              .add([week0, week1, week2, week3, week4, week5, week6]);
        });
        pr(weekListForMonth);
      }
      await getHolidayListForMonth(selectedMonth ?? DateTime.now());
      await checkIsShowPopup();

      if (isWithLoading != null && isWithLoading) {
        isLoadData = false;
      }
      var now = DateTime.now();
      //  검색 하고자 하는 월의 2번쨰주?(data not null) data 가져와  <당월 여부> 확인.
      var randomDayOfMonth =
          DateUtil.getDate(monthResponseModel!.tList![2].day0!);
      if (randomDayOfMonth.year == now.year &&
          randomDayOfMonth.month == now.month) {
        checkLastDay('', dt: now);
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
    await getHolidayListForMonth(selectedDay ?? DateTime.now());
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
      // checkLastDay('', dt: selectedDay);
      await checkLastWorkDaysNextWorkDay(selectedDay!);
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
