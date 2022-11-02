/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activityManeger/provider/activity_manager_page_provider.dart
 * Created Date: 2022-07-05 09:48:24
 * Last Modified: 2022-11-02 21:52:02
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/model/common/holiday_response_model.dart';
import 'package:medsalesportal/model/rfc/search_key_response_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_weeks_model.dart';
import 'package:medsalesportal/globalProvider/activity_state_provder.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_260.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_361.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_280.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_month_response_model.dart';
import 'package:medsalesportal/model/rfc/salse_activity_location_response_model.dart';

typedef IsThisActivityFrom361 = bool Function(SalesActivityDayTable361);
typedef IsThisActivityFrom280 = bool Function(SalesActivityDayTable280);

class SalseActivityManagerPageProvider extends ChangeNotifier {
  SalseActivityLocationResponseModel? locationResponseModel;
  SalesActivityMonthResponseModel? monthResponseModel;
  SalesActivityDayResponseModel? dayResponseModel;
  SearchKeyResponseModel? searchKeyResponseModel;
  HolidayResponseModel? holidayResponseModel;
  List<List<DateTime?>> weekListForMonth = [];

  bool isLoadMonthData = false;
  bool isLoadDayData = false;
  bool isLoadUpdateData = false;
  bool isLoadConfirmData = false;
  bool isShowAnimation = false;
  bool? isShowConfirm;
  bool? isResetDay;
  bool? isShowPopup;

  // -------- menu scope ------
  ActivityStatus? activityStatus;
  // -------- menu scope ------
  DateTime? selectedMonth;
  DateTime? selectedDay;
  // DateTime? previousWorkingDay;
  DateTime? checkPreviousWorkingDaysNextWorkingDay;
  List<DateTime> holidayList = [];

  DateTime get minYear => DateTime(DateTime.now().year - 10);
  DateTime get maxYear => DateTime(DateTime.now().year + 10);

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
    isShowPopup = false;
    notifyListeners();
  }

  Future<void> checkShowConfirm() async {
    var t250 = dayResponseModel!.table250;
    var isStoped = t250 != null &&
        t250.isNotEmpty &&
        t250.single.faddcat != null &&
        t250.single.faddcat!.isNotEmpty &&
        t250.single.ftime != null &&
        t250.single.ftime!.isNotEmpty;
    var isConfirmed =
        t250 != null && t250.isNotEmpty && t250.single.stat == 'C';
    var ap =
        KeyService.baseAppKey.currentContext!.read<ActivityStateProvider>();
    var previouWorkday = ap.previousWorkingDay;
    var isToday = DateUtil.equlse(selectedDay!, DateTime.now());
    var isPrevWorkday = DateUtil.equlse(selectedDay!, previouWorkday!);
    isShowConfirm = (isToday || isPrevWorkday) ? true : null;
    if (isPrevWorkday) {
      activityStatus = isConfirmed
          ? ActivityStatus.FINISH
          : isStoped
              ? ActivityStatus.PREV_WORK_DAY_STOPED
              : ActivityStatus.PREV_WORK_DAY_EN_STOPED;
    } else if (isToday) {
      var table250 = dayResponseModel!.table250!;
      if (table250.isEmpty) {
        activityStatus = ActivityStatus.INIT;
      }

      if (table250.isNotEmpty) {
        var arrivalLatLonIsNull =
            table250.last.fxLatitude! == 0 && table250.last.fylongitude! == 0;
        var isStarted = table250.last.scallType == 'M' &&
            table250.last.sxLatitude != null &&
            table250.last.syLongitude != null &&
            table250.last.stime!.isNotEmpty &&
            table250.last.faddcat!.isEmpty &&
            arrivalLatLonIsNull;
        var isConfirmed = table250.last.stat == 'C';
        var isStoped = table250.last.scallType == 'M' &&
            table250.last.sxLatitude != null &&
            table250.last.syLongitude != null &&
            table250.last.stime!.isNotEmpty &&
            table250.last.faddcat!.isNotEmpty &&
            table250.last.fcallType == 'M' &&
            table250.last.ftime!.isNotEmpty;

        activityStatus = isConfirmed
            ? ActivityStatus.FINISH
            : isStarted
                ? ActivityStatus.STARTED
                : isStoped
                    ? ActivityStatus.STOPED
                    : ActivityStatus.INIT;
      }
    } else {
      activityStatus = ActivityStatus.NONE;
    }
    pr(activityStatus);
    try {
      notifyListeners();
    } catch (e) {}
  }

  bool isHaveUnconfirmedActivity(
      bool isNotConfirm, String? val1, String? val2) {
    var temp1 = int.parse(val1 != null && val1.isNotEmpty ? val1.trim() : '0');
    var temp2 = int.parse(val2 != null && val2.isNotEmpty ? val2.trim() : '0');
    return isNotConfirm && (temp2 > 0 || temp1 > 0);
  }

  Future<ResultModel> searchMonthData() async {
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
        "IV_SPMON":
            DateUtil.getMonthStr(DateUtil.getDate(DateUtil.prevMonth())),
        "resultTables": RequestType.SALESE_ACTIVITY_MONTH_DATA.resultTable,
        "functionName": RequestType.SALESE_ACTIVITY_MONTH_DATA.serverMethod
      }
    };
    final result = await _api.request(body: _body);
    if (result == null || result.statusCode != 200) {
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }
    if (result.statusCode == 200) {
      pr(result.body);
      List<List<DateTime?>> dateList = [];
      var temp = SalesActivityMonthResponseModel.fromJson(result.body['data']);
      if (monthResponseModel!.esReturn!.mtype != 'S') {
        return ResultModel(false,
            errorMassage: monthResponseModel!.esReturn!.message);
      } else {
        if (temp.tList != null && temp.tList!.isNotEmpty) {
          temp.tList!.forEach((e) {
            var week0 = e.day0 != null ? DateUtil.getDate(e.day0!) : null;
            var week1 = e.day1 != null ? DateUtil.getDate(e.day1!) : null;
            var week2 = e.day2 != null ? DateUtil.getDate(e.day2!) : null;
            var week3 = e.day3 != null ? DateUtil.getDate(e.day3!) : null;
            var week4 = e.day4 != null ? DateUtil.getDate(e.day4!) : null;
            var week5 = e.day5 != null ? DateUtil.getDate(e.day5!) : null;
            var week6 = e.day6 != null ? DateUtil.getDate(e.day6!) : null;
            dateList.add([week0, week1, week2, week3, week4, week5, week6]);
          });
        }
        return ResultModel(true,
            data: {'weekList': dateList, 'monthModel': temp});
      }
    }
    return ResultModel(false);
  }

  Future<bool> checkConfiremStatus({required DateTime datetime}) async {
    var weekListIndex = 0;
    var weekRowIndex = 0;
    var dateList = <List<DateTime?>>[];
    SalesActivityWeeksModel? model;
    SalesActivityMonthResponseModel? monthResponse;
    if (DateUtil.diffMounth(datetime, DateTime.now())) {
      var result = await searchMonthData();
      if (result.isSuccessful) {
        dateList = result.data['weekList'];
        monthResponse =
            result.data['monthModel'] as SalesActivityMonthResponseModel;
      }
    } else {
      dateList = weekListForMonth;
      monthResponse = monthResponseModel;
    }

    dateList.asMap().entries.forEach((map) {
      if (map.value.contains(datetime)) {
        weekListIndex = map.key;
        weekRowIndex = map.value.indexOf(datetime);
        pr('weekListIndex ::: ${weekListIndex}');
        pr('weekRowIndex ::: ${weekRowIndex}');
      }
    });

    model = monthResponse!.tList![weekListIndex];

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
    pr('isNotConfirmed  $isNotConfirmed');
    return isNotConfirmed;
  }

  Future<void> checkIsShowPopup() async {
    // 지난영업일 확인.

    var isCurrenMonth =
        !(DateUtil.diffMounth(selectedMonth ?? DateTime.now(), DateTime.now()));
    var isPrevMonth = !(DateUtil.diffMounth(selectedMonth ?? DateTime.now(),
        DateUtil.getDate(DateUtil.prevMonth())));
    if (isCurrenMonth || isPrevMonth) {
      var ap =
          KeyService.baseAppKey.currentContext!.read<ActivityStateProvider>();
      await checkPreviousWorkingDay(dt: DateTime.now());
      var previouWorkday = ap.previousWorkingDay;
      isShowPopup = await checkConfiremStatus(datetime: previouWorkday!);
      pr('isShowPopup::: $previouWorkday  $isShowPopup');
    }
    notifyListeners();
  }

  void setIsResetDay(bool val) {
    isResetDay = val;
    notifyListeners();
  }

  void getPreviousMonthData() {
    selectedMonth = DateUtil.getDate(
        DateUtil.prevMonth(dt: selectedMonth, minYear: minYear));
    getMonthData(isWithLoading: true);
  }

  void getNextMonthData() {
    selectedMonth = DateUtil.getDate(
        DateUtil.nextMonth(dt: selectedMonth, maxYear: maxYear));
    getMonthData(isWithLoading: true);
  }

  void getPreviousDayData() {
    selectedDay = DateUtil.previousDay(dt: selectedDay, minYear: minYear);
    getDayData(isWithLoading: true);
  }

  void getNextDayData() {
    selectedDay = DateUtil.nextDay(dt: selectedDay, maxYear: maxYear);
    getDayData(isWithLoading: true);
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

  Future<void> checkPreviousWorkingDay({required DateTime? dt}) async {
    var temp = DateUtil.previousDay();
    var isNotConfirmed = await checkConfiremStatus(datetime: temp);
    while ((temp.weekday == 7 ||
            temp.weekday == 6 ||
            holidayList.contains(temp)) &&
        !isNotConfirmed) {
      temp = DateUtil.previousDay(dt: temp);
      isNotConfirmed = await checkConfiremStatus(datetime: temp);
    }
    var ap =
        KeyService.baseAppKey.currentContext!.read<ActivityStateProvider>();
    ap.setPrevWorkingDay(temp);
  }

  Future<ResultModel> getOfficeAddress() async {
    _api.init(RequestType.GET_OFFICE_ADDRESS);
    final esLogin = CacheService.getEsLogin();
    final isLogin = CacheService.getIsLogin();
    Map<String, dynamic> _body = {
      "methodName": RequestType.GET_OFFICE_ADDRESS.serverMethod,
      "methodParamMap": {
        "IV_ADDCAT": "",
        "IV_PTYPE": "R",
        "IV_VKGRP": esLogin!.vkgrp,
        "IV_LOGID": esLogin.logid!.toUpperCase(),
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.GET_OFFICE_ADDRESS.resultTable,
        "functionName": RequestType.GET_OFFICE_ADDRESS.serverMethod
      }
    };
    final result = await _api.request(body: _body);
    if (result == null || result.statusCode != 200) {
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }
    if (result.statusCode == 200) {
      locationResponseModel =
          SalseActivityLocationResponseModel.fromJson(result.body['data']);
      return ResultModel(true);
    }
    return ResultModel(false);
  }

  Future<ResultModel> getHolidayListForMonth(DateTime date) async {
    if (holidayList.isEmpty ||
        (holidayList.isNotEmpty &&
            (holidayList.first.month != date.month ||
                holidayList.first.year != date.year))) {
      _api.init(RequestType.CHECK_HOLIDAY);
      final result = await _api.request(body: {
        'year': date.year,
        'month': date.month < 10 ? '0${date.month}' : '${date.month}',
      });
      if (result == null || result.statusCode != 200) {
        return ResultModel(false,
            isNetworkError: result?.statusCode == -2,
            isServerError: result?.statusCode == -1);
      }
      if (result.statusCode == 200) {
        holidayList.clear();
        holidayResponseModel = HolidayResponseModel.fromJson(result.body);
        pr(holidayResponseModel?.toJson());
        if (holidayResponseModel!.data != null &&
            holidayResponseModel!.data!.isNotEmpty) {
          holidayResponseModel!.data!.forEach((holidayModel) {
            holidayList.add(DateUtil.getDate(holidayModel.locdate!));
            pr(holidayList);
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
    if (result == null || result.statusCode != 200) {
      isLoadMonthData = false;
      notifyListeners();
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }
    if (result.statusCode == 200) {
      searchKeyResponseModel =
          SearchKeyResponseModel.fromJson(result.body['data']);
      return ResultModel(true);
    }
    isLoadMonthData = false;
    notifyListeners();
    return ResultModel(false);
  }

  Future<ResultModel> getMonthData(
      {bool? isWithLoading, bool? isCurrenMonth, DateTime? searchMonth}) async {
    isLoadMonthData = true;
    if (isWithLoading != null && isWithLoading) {
      notifyListeners();
    }
    if (searchKeyResponseModel == null) {
      await searchPartmentKeyZBIZ();
    }

    var isDiffMonth =
        DateUtil.diffMounth(DateTime.now(), selectedMonth ?? DateTime.now());
    if (isDiffMonth || monthResponseModel == null) {
      pr('diff month?? $isDiffMonth');
      pr('selectedMonth?? $selectedMonth');
      await getHolidayListForMonth(selectedMonth ?? DateTime.now());
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
        "IV_SPMON": DateUtil.getMonthStr(searchMonth ??
            (isCurrenMonth != null && isCurrenMonth
                ? DateTime.now()
                : selectedMonth != null
                    ? selectedMonth!
                    : DateTime.now())),
        "resultTables": RequestType.SALESE_ACTIVITY_MONTH_DATA.resultTable,
        "functionName": RequestType.SALESE_ACTIVITY_MONTH_DATA.serverMethod
      }
    };
    final result = await _api.request(body: _body);
    if (result == null || result.statusCode != 200) {
      isLoadMonthData = false;
      notifyListeners();
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }
    if (result.statusCode == 200) {
      monthResponseModel =
          SalesActivityMonthResponseModel.fromJson(result.body['data']);
      if (monthResponseModel!.esReturn!.mtype != 'S') {
        isLoadMonthData = false;
        notifyListeners();
        return ResultModel(false,
            errorMassage: monthResponseModel!.esReturn!.message);
      } else {
        if (monthResponseModel != null &&
            monthResponseModel!.tList!.isNotEmpty) {
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

        await checkIsShowPopup();
        isLoadMonthData = false;
        notifyListeners();
        return ResultModel(true);
      }
    }
    isLoadMonthData = false;
    notifyListeners();
    return ResultModel(false);
  }

  Future<ResultModel> getDayData(
      {bool? isWithLoading, bool? isUpdateLoading}) async {
    pr('inin??????');
    isShowConfirm = false;
    activityStatus = ActivityStatus.NONE;
    notifyListeners();
    selectedMonth ??= DateTime.now();
    // if (selectedDay != null &&
    //     (selectedDay!.year != selectedMonth!.year ||
    //         selectedDay!.month != selectedMonth!.month)) {
    //   setSelectedMonth(selectedDay!);
    //   getMonthData();
    // }
    if (isWithLoading != null && isWithLoading) {
      isLoadDayData = true;
      notifyListeners();
    }
    if (isUpdateLoading != null && isUpdateLoading) {
      isLoadUpdateData = true;
      notifyListeners();
    }

    // var isDiffMonth =
    //     DateUtil.diffMounth(DateTime.now(), selectedDay ?? DateTime.now());
    // if (isDiffMonth) {
    //   pr('diff month!!!!!');
    //   await getHolidayListForMonth(selectedDay ?? DateTime.now());
    // }
    await getOfficeAddress();
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
    if (result == null || result.statusCode != 200) {
      if (isWithLoading != null && isWithLoading) {
        isLoadDayData = false;
      }
      if (isUpdateLoading != null && isUpdateLoading) {
        isLoadUpdateData = false;
      }
      try {
        notifyListeners();
      } catch (e) {}
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }
    if (result.statusCode == 200) {
      pr(result.body);
      dayResponseModel =
          SalesActivityDayResponseModel.fromJson(result.body['data']);

      // 영업활동 종료 후 다시 페이지로 돌아 왔을때 대비.
      var t250 = dayResponseModel!.table250;
      var isStoped = t250 != null &&
          t250.isNotEmpty &&
          t250.single.faddcat != null &&
          t250.single.faddcat!.isNotEmpty &&
          t250.single.ftime != null &&
          t250.single.ftime!.isNotEmpty;
      if (isStoped) {
        activityStatus = ActivityStatus.STOPED;
      }
      isResetDay = null;
      await checkShowConfirm();
      isLoadDayData = false;
      isLoadUpdateData = false;
      try {
        notifyListeners();
      } catch (e) {}
      return ResultModel(true);
    }
    isLoadDayData = false;
    isLoadUpdateData = false;
    notifyListeners();
    return ResultModel(false);
  }

  Future<ResultModel> confirmeAcitivityTable() async {
    isLoadConfirmData = true;
    notifyListeners();
    var isSuccessfulList = <ConfirmModel>[];
    var validateTables = () async {
      if (dayResponseModel!.table260!.isNotEmpty) {
        await Future.forEach(dayResponseModel!.table260!.asMap().entries,
            (map) async {
          map as MapEntry<int, SalesActivityDayTable260>;
          var table = map.value;
          var message = '';
          final isNeedCheckAmount = table.actcat1 == 'A15';
          var isAmountNotEmpty = true;
          var isActivityTypeNotEmpty = true;
          var isActivityResultNotEmpty = true;
          var isSuggetionItemNotEmpty = true;
          var isMeetFailReasonNotEmpty = true;
          var isNotVisitReasonNotEmpty = true;
          var t280List = <SalesActivityDayTable280>[];
          var t361List = <SalesActivityDayTable361>[];
          IsThisActivityFrom280 isTable280MatchThisCondition =
              (SalesActivityDayTable280 t) {
            return table.bzactno == t.bzactno && table.seqno == t.seqno;
          };

          IsThisActivityFrom361 isTable361MatchThisCondition =
              (SalesActivityDayTable361 t) {
            return table.bzactno == t.bzactno && table.seqno == t.seqno;
          };
          if (dayResponseModel!.table280!.isNotEmpty) {
            dayResponseModel!.table280!.forEach((t280) {
              isTable280MatchThisCondition(t280)
                  ? t280List.add(t280)
                  : DoNothingAction();
            });
          }
          if (dayResponseModel!.table361!.isNotEmpty) {
            dayResponseModel!.table361!.forEach((t361) {
              isTable361MatchThisCondition(t361)
                  ? t361List.add(t361)
                  : DoNothingAction();
            });
          }
          if (table.xvisit == 'Y') {
            if (table.xmeet == 'S') {
              isActivityTypeNotEmpty =
                  table.actcat1 != null && table.actcat1!.isNotEmpty;
              isActivityResultNotEmpty =
                  table.rslt != null && table.rslt!.isNotEmpty;
              if (isAmountNotEmpty) {
                isSuggetionItemNotEmpty =
                    t280List.where((t) => table.seqno == t.seqno).isNotEmpty;
              }
              if (isNeedCheckAmount) {
                isAmountNotEmpty = t280List
                    .where(
                        (t280) => t280.amount1 != null && t280.amount1 != 0.0)
                    .isNotEmpty;
              }
              if (!isActivityTypeNotEmpty) {
                message = '${table.zskunnrNm}의 활동유형을 입력해 주세요.';
              }
              if (!isActivityResultNotEmpty) {
                message = '${table.zskunnrNm}의 방문 결과를 입력해 주세요.';
              }
              if (!isSuggetionItemNotEmpty) {
                message = '${table.zskunnrNm}의 제안품목을 1개 이상 추가해주세요';
              }
              if (!isAmountNotEmpty) {
                message = '${table.zskunnrNm}의 예상매출액을 입력해 주세요.';
              }
            } else {
              isMeetFailReasonNotEmpty =
                  table.meetRmk != null && table.meetRmk!.isNotEmpty;
              if (!isMeetFailReasonNotEmpty) {
                message = '${table.zskunnrNm}의 면담 실패 사유를 입력해 주세요.';
              }
            }
          } else {
            isNotVisitReasonNotEmpty =
                table.visitRmk != null && table.visitRmk!.isNotEmpty;
            if (!isNotVisitReasonNotEmpty) {
              message = '${table.zskunnrNm}의 미방문 사유를 입력해 주세요.';
            }
          }
          var validate = isAmountNotEmpty &&
              isActivityTypeNotEmpty &&
              isActivityResultNotEmpty &&
              isSuggetionItemNotEmpty &&
              isMeetFailReasonNotEmpty &&
              isNotVisitReasonNotEmpty;
          isSuccessfulList.add(ConfirmModel(
              isSuccessful: validate,
              seqNo: map.value.seqno,
              message: message));
        });
      }
      isSuccessfulList.forEach((element) {
        pr('seqNo ${element.seqNo}');
        pr('isSuccessful ${element.isSuccessful}');
        pr('message ${element.message}');
      });
      return isSuccessfulList;
    };
    var comfirmList = await validateTables();
    var failedList = comfirmList.where((confirm) => !confirm.isSuccessful);
    if (failedList.isNotEmpty) {
      // var indexx = comfirmList.first.index;
      // var message = comfirmList.first.message;
      var seqNo = failedList.first.seqNo;
      var message = failedList.first.message;
      isLoadConfirmData = false;
      notifyListeners();
      return ResultModel(false, data: {'seqNo': seqNo, 'message': message});
    } else {
      var t250Base64 = ''; // base
      var t260Base64 = ''; // 영업활동 상세
      var t280Base64 = ''; // 활동유형
      var t361Base64 = ''; // 동행
      var t270Base64 = ''; // 관계구축 및 관계형성 정보
      var t290Base64 = ''; // 처방/판매/반품 정보
      var t291Base64 = ''; // 처방/판매/반품 상세 정보
      var t300Base64 = ''; // 정보획득
      var t301Base64 = ''; // 정보획득 상세
      var t310Base64 = ''; // 인수인계
      var t320Base64 = ''; // 수금
      var t321Base64 = ''; // 수금 상세
      var t330Base64 = ''; // 세미나
      var t340Base64 = ''; // Landing / DC
      var t350Base64 = ''; // 입찰
      var t430Base64 = ''; // 시나리오

      var temp = <Map<String, dynamic>>[];
      var t250List = dayResponseModel!.table250;
      if (t250List != null && t250List.isNotEmpty) {
        var temp250 = t250List.single;
        temp250.stat = 'C';
        temp250.umode = 'U';
        if (activityStatus == ActivityStatus.PREV_WORK_DAY_EN_STOPED ||
            activityStatus == ActivityStatus.PREV_WORK_DAY_STOPED) {
          pr(temp250.toJson());
        }
        temp.clear();
        temp.add(temp250.toJson());
        t250Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }

      var t260List = dayResponseModel!.table260;
      if (t260List != null && t260List.isNotEmpty) {
        temp.clear();
        temp.addAll([...t260List.map((table) => table.toJson())]);
        t260Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
      var t270List = dayResponseModel!.table270;
      if (t270List != null && t270List.isNotEmpty) {
        temp.clear();
        temp.addAll([...t270List.map((table) => table.toJson())]);
        t270Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
      var t280List = dayResponseModel!.table280;
      if (t280List != null && t280List.isNotEmpty) {
        temp.clear();
        temp.addAll([...t280List.map((table) => table.toJson())]);
        t280Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
      var t290List = dayResponseModel!.table290;
      if (t290List != null && t290List.isNotEmpty) {
        temp.clear();
        temp.addAll([...t290List.map((table) => table.toJson())]);
        t290Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
      var t291List = dayResponseModel!.table291;
      if (t291List != null && t291List.isNotEmpty) {
        temp.clear();
        temp.addAll([...t291List.map((table) => table.toJson())]);
        t291Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
      var t300List = dayResponseModel!.table300;
      if (t300List != null && t300List.isNotEmpty) {
        temp.clear();
        temp.addAll([...t300List.map((table) => table.toJson())]);
        t300Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
      var t301List = dayResponseModel!.table301;
      if (t301List != null && t301List.isNotEmpty) {
        temp.clear();
        temp.addAll([...t301List.map((table) => table.toJson())]);
        t301Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
      var t310List = dayResponseModel!.table310;
      if (t310List != null && t310List.isNotEmpty) {
        temp.clear();
        temp.addAll([...t310List.map((table) => table.toJson())]);
        t310Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
      var t320List = dayResponseModel!.table320;
      if (t320List != null && t320List.isNotEmpty) {
        temp.clear();
        temp.addAll([...t320List.map((table) => table.toJson())]);
        t320Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
      var t321List = dayResponseModel!.table321;
      if (t321List != null && t321List.isNotEmpty) {
        temp.clear();
        temp.addAll([...t321List.map((table) => table.toJson())]);
        t321Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
      var t330List = dayResponseModel!.table330;
      if (t330List != null && t330List.isNotEmpty) {
        temp.clear();
        temp.addAll([...t330List.map((table) => table.toJson())]);
        t330Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
      var t340List = dayResponseModel!.table340;
      if (t340List != null && t340List.isNotEmpty) {
        temp.clear();
        temp.addAll([...t340List.map((table) => table.toJson())]);
        t340Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
      var t350List = dayResponseModel!.table350;
      if (t350List != null && t350List.isNotEmpty) {
        temp.clear();
        temp.addAll([...t350List.map((table) => table.toJson())]);
        t350Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
      var t430List = dayResponseModel!.table430;
      if (t430List != null && t430List.isNotEmpty) {
        temp.clear();
        temp.addAll([...t430List.map((table) => table.toJson())]);
        t430Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
      var t361List = dayResponseModel!.table361;
      if (t361List != null && t361List.isNotEmpty) {
        temp.clear();
        temp.addAll([...t361List.map((table) => table.toJson())]);
        t361Base64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
      var isLogin = CacheService.getIsLogin();
      _api.init(RequestType.SALESE_ACTIVITY_DAY_DATA);
      Map<String, dynamic> _body = {
        "methodName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
        "methodParamMap": {
          "IV_PTYPE": "U",
          "confirmType": "Y",
          "IV_ADATE": FormatUtil.removeDash(
              DateUtil.getDateStr(DateTime.now().toIso8601String())),
          "T_ZLTSP0250S": t250Base64,
          "T_ZLTSP0260S": t260Base64,
          "T_ZLTSP0280S": t280Base64,
          "T_ZLTSP0361S": t361Base64,
          "T_ZLTSP0270S": t270Base64,
          "T_ZLTSP0290S": t290Base64,
          "T_ZLTSP0291S": t291Base64,
          "T_ZLTSP0300S": t300Base64,
          "T_ZLTSP0301S": t301Base64,
          "T_ZLTSP0310S": t310Base64,
          "T_ZLTSP0320S": t320Base64,
          "T_ZLTSP0321S": t321Base64,
          "T_ZLTSP0330S": t330Base64,
          "T_ZLTSP0340S": t340Base64,
          "T_ZLTSP0350S": t350Base64,
          "T_ZLTSP0430S": t430Base64,
          "IS_LOGIN": isLogin,
          "resultTables": RequestType.SALESE_ACTIVITY_DAY_DATA.resultTable,
          "functionName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
        }
      };

      final result = await _api.request(body: _body);
      if (result == null || result.statusCode != 200) {
        isLoadConfirmData = false;
        notifyListeners();
        return ResultModel(false,
            isNetworkError: result?.statusCode == -2,
            isServerError: result?.statusCode == -1);
      }
      if (result.statusCode == 200) {
        var temp = SalesActivityDayResponseModel.fromJson(result.body['data']);
        var isSuccess = temp.esReturn != null && temp.esReturn!.mtype == 'S';
        if (isSuccess) {
          getDayData(isWithLoading: true);
        }
        isLoadConfirmData = false;
        notifyListeners();
        return ResultModel(true);
      }
      isLoadConfirmData = false;
      try {
        notifyListeners();
      } catch (e) {}
      return ResultModel(false);
    }
  }
}

class ConfirmModel {
  bool isSuccessful;
  String? seqNo;
  String? message;
  ConfirmModel({required this.isSuccessful, this.seqNo, this.message});
}
