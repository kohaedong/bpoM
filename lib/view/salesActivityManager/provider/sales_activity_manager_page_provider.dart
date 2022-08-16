/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activityManeger/provider/activity_manager_page_provider.dart
 * Created Date: 2022-07-05 09:48:24
 * Last Modified: 2022-08-16 15:06:44
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/model/common/holiday_response_model.dart';
import 'package:medsalesportal/model/rfc/search_key_response_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_month_response_model.dart';

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

  // -------- menu scope ------
  ActivityStatus? activityStatus;
  // -------- menu scope ------
  DateTime? selectedMonth;
  DateTime? selectedDay;
  DateTime? previousWorkingDay;
  DateTime? checkPreviousWorkingDaysNextWorkingDay;
  List<DateTime> holidayList = [];
  final _api = ApiService();

  void setSelectedDate(DateTime dt) {
    selectedDay = dt;
    notifyListeners();
  }

  void setSelectedMonth(DateTime dt) {
    selectedMonth = dt;
    notifyListeners();
  }

  void setActivityStatus(ActivityStatus? status) {
    activityStatus = status;
    notifyListeners();
  }

  void setIsShowConfirm(bool val) {
    isShowConfirm = val;
    notifyListeners();
  }

  void setIsShowAnimation() {
    isShowAnimation = !isShowAnimation;
    notifyListeners();
  }

  void resetIsShowPopup() {
    isShowPopup = null;
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
    await checkPreviousWorkingDay('', dt: DateTime.now());
    var previouWorkday = previousWorkingDay;
    var isToday = (selectedDay!.year == DateTime.now().year) &&
        (selectedDay!.month == DateTime.now().month) &&
        (selectedDay!.day == DateTime.now().day);

    var seletedDayIsWorkingDayBeforeToday =
        selectedDay!.day == previouWorkday!.day;
    var isPreviouDayNotConfirmed =
        await checkConfiremStatus(datetime: previouWorkday);
    isShowConfirm =
        (isToday || seletedDayIsWorkingDayBeforeToday) ? true : null;
    pr('isShowConfirm:: $isShowConfirm');
    if (seletedDayIsWorkingDayBeforeToday) {
      activityStatus = isPreviouDayNotConfirmed
          ? ActivityStatus.STOPED
          : ActivityStatus.FINISH;
    } else if (isToday) {
      var table250 = dayResponseModel!.table250!;
      if (table250.isEmpty) {
        activityStatus = ActivityStatus.INIT;
      }

      if (table250.length > 0) {
        var arrivalLatLonIsNull =
            table250.last.fxLatitude! == 0 && table250.last.fylongitude! == 0;
        var isStarted = table250.last.scallType == 'M' &&
            table250.last.sxLatitude != null &&
            table250.last.syLongitude != null &&
            table250.last.stime!.isNotEmpty &&
            table250.last.faddcat!.isEmpty &&
            arrivalLatLonIsNull;
        var isStoped = isStarted &&
            !arrivalLatLonIsNull &&
            table250.last.faddcat!.isNotEmpty &&
            table250.last.fcallType == 'M' &&
            table250.last.ftime!.isNotEmpty;
        activityStatus = isStarted
            ? ActivityStatus.STARTED
            : isStoped
                ? ActivityStatus.STOPED
                : ActivityStatus.INIT;
      }
    } else {
      activityStatus = ActivityStatus.NONE;
    }
    pr(activityStatus);
    notifyListeners();
  }

  bool isHaveUnconfirmedActivity(
      bool isNotConfirm, String? val1, String? val2) {
    return isNotConfirm &&
        (int.parse(val1 != null && val1.isNotEmpty ? val1.trim() : '0') !=
            int.parse(val2 != null && val2.isNotEmpty ? val2.trim() : '0'));
  }

  Future<bool> checkConfiremStatus(
      {bool? isWithLastWorkdaysNextWorkDay, DateTime? datetime}) async {
    var weekListIndex = 0;
    var weekRowIndex = 0;
    weekListForMonth.asMap().entries.forEach((map) {
      var day = DateUtil.getDate(FormatUtil.removeDash(DateUtil.getDateStr('',
          // datetime :: passing된 date에 대한 확정여부 확인.
          // isWithLastWorkdaysNextWorkDay::  null 일 경우 지난 영업일에 대한 확정여부 확인.[previousWorkingDay]
          // 그외에 금일 확정여부 확인.  checkPreviousWorkingDaysNextWorkingDay 사실상 오늘이다.
          dt: datetime != null
              ? datetime
              : isWithLastWorkdaysNextWorkDay == null
                  ? previousWorkingDay
                  : checkPreviousWorkingDaysNextWorkingDay)));
      if (map.value.contains(day)) {
        weekListIndex = map.key;
        weekRowIndex = map.value.indexOf(day);
      }
    });
    pr('listIndex::: $weekListIndex $datetime');
    pr('weekRowIndex::: $weekRowIndex $datetime');
    var model = monthResponseModel!.tList![weekListIndex];
    var isNotConfirmed = (weekRowIndex == 0
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
    return isNotConfirmed;
  }

  Future<void> checkIsShowPopup() async {
    // 지난영업일 확인.
    await checkNextWorkingDayForPreviousWorkingDay(DateTime.now());
    var isNotConfirmed = await checkConfiremStatus();
    isShowPopup =
        (checkPreviousWorkingDaysNextWorkingDay!.day == DateTime.now().day) &&
            isNotConfirmed;
    pr('show popup ???? $isShowPopup');
    notifyListeners();
  }

  void setIsResetDay(bool val) {
    isResetDay = val;
    notifyListeners();
  }

  void getPreviousMonthData() {
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

  void getPreviousDayData() {
    if (selectedDay == null) {
      selectedDay = DateUtil.previousDay();
    } else {
      selectedDay = DateUtil.previousDay(dt: selectedDay);
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

  Future<void> checkNextWorkingDayForPreviousWorkingDay(DateTime dt) async {
    await checkPreviousWorkingDay('', dt: dt);
    checkPreviousWorkingDaysNextWorkingDay =
        DateUtil.nextDay(dt: previousWorkingDay);
    var isNotConfirmed = await checkConfiremStatus(
        datetime: checkPreviousWorkingDaysNextWorkingDay);
    pr('-- not confirmed????${checkPreviousWorkingDaysNextWorkingDay?.toIso8601String()} $isNotConfirmed');
    pr('-- is not holiday, ${checkPreviousWorkingDaysNextWorkingDay!.weekday}');
    while ((checkPreviousWorkingDaysNextWorkingDay!.weekday == 7 &&
            !isNotConfirmed) ||
        (checkPreviousWorkingDaysNextWorkingDay!.weekday == 6 &&
            !isNotConfirmed) ||
        holidayList.contains(checkPreviousWorkingDaysNextWorkingDay)) {
      checkPreviousWorkingDaysNextWorkingDay =
          DateUtil.nextDay(dt: checkPreviousWorkingDaysNextWorkingDay);
      isNotConfirmed = await checkConfiremStatus(
          datetime: checkPreviousWorkingDaysNextWorkingDay);
      pr('-- while: not confirmed????${checkPreviousWorkingDaysNextWorkingDay?.toIso8601String()} $isNotConfirmed');
      pr('-- while:: weekDay: ${checkPreviousWorkingDaysNextWorkingDay!.weekday}');
    }
  }

  Future<void> checkPreviousWorkingDay(String day, {DateTime? dt}) async {
    previousWorkingDay = DateUtil.previousDay(dt: dt ?? DateUtil.getDate(day));
    var isNotConfirmed =
        await checkConfiremStatus(datetime: previousWorkingDay);
    pr('++ not confirmed????${previousWorkingDay?.toIso8601String()} $isNotConfirmed');
    pr('++ is not holiday, LastWorkDay :: ${previousWorkingDay!.weekday}');
    while ((previousWorkingDay!.weekday == 7 && !isNotConfirmed) ||
        (previousWorkingDay!.weekday == 6 && !isNotConfirmed) ||
        holidayList.contains(previousWorkingDay)) {
      previousWorkingDay = DateUtil.previousDay(dt: previousWorkingDay);
      isNotConfirmed = await checkConfiremStatus(datetime: previousWorkingDay);
      pr('++ while : not confirmed ????${previousWorkingDay?.toIso8601String()} $isNotConfirmed');
      pr('++ while weekDay:: ${previousWorkingDay!.weekday}');
    }
  }

  Future<ResultModel> getHolidayListForMonth(DateTime date) async {
    pr(date.toIso8601String());
    if (holidayList.isEmpty ||
        (holidayList.isNotEmpty &&
            (holidayList.first.month != date.month ||
                holidayList.first.year != date.year))) {
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
      }
      await getHolidayListForMonth(selectedMonth ?? DateTime.now());
      await checkIsShowPopup();
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
    isShowConfirm = false;
    activityStatus = ActivityStatus.NONE;
    notifyListeners();
    selectedMonth ??= DateTime.now();
    if (selectedDay != null &&
        (selectedDay!.year != selectedMonth!.year ||
            selectedDay!.month != selectedMonth!.month)) {
      setSelectedMonth(selectedDay!);
      getMonthData();
    }
    if (isWithLoading != null && isWithLoading) {
      isLoadDayData = true;
      notifyListeners();
    }

    await getHolidayListForMonth(selectedDay ?? DateTime.now());
    _api.init(RequestType.SALESE_ACTIVITY_DAY_DATA);
    var isLogin = CacheService.getIsLogin();
    pr(isLogin);
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
      pr(dayResponseModel?.toJson());
      dayResponseModel?.table250?.forEach((e) {
        pr(e.toJson());
      });
      // dayResponseModel?.table250?.forEach((element) {
      //   pr(element.toJson());
      // });
      // checkIsAllConfirmed();
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
