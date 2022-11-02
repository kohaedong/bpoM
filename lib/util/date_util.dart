/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/util/date_util.dart
 * Created Date: 2021-11-23 07:56:54
 * Last Modified: 2022-11-02 20:24:55
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';

// 날짜 관련 도구
class DateUtil {
  static String prevMonth({DateTime? dt, DateTime? minYear}) {
    var date = dt ?? DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    var temp = DateTime(date.year, date.month - 1, date.day);
    if (minYear != null && temp.isAfter(minYear)) {
      return formatter.format(temp);
    } else {
      return formatter.format(date);
    }
  }

  static String nextMonth({DateTime? dt, DateTime? maxYear}) {
    // 수정한 값 < maxYear
    var date = dt ?? DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    var temp = DateTime(date.year, date.month + 1, date.day);
    if (maxYear != null && temp.isBefore(maxYear)) {
      return formatter.format(temp);
    } else {
      return formatter.format(date);
    }
  }

  static DateTime previousDay({DateTime? dt, DateTime? minYear}) {
    var date = dt ?? DateTime.now();
    var temp = DateTime(date.year, date.month, date.day - 1);
    if (minYear != null && temp.isAfter(minYear)) {
      return temp;
    } else {
      return date;
    }
  }

  static DateTime nextDay({DateTime? dt, DateTime? maxYear}) {
    var date = dt ?? DateTime.now();
    var temp = DateTime(date.year, date.month, date.day + 1);
    if (maxYear != null && temp.isBefore(maxYear)) {
      return temp;
    } else {
      return date;
    }
  }

  static int dateCount(DateTime dt) {
    var dayCount = DateTime(dt.year, dt.month, 0).day;
    return dayCount;
  }

  static getDateWithWeek(DateTime date, {bool? isWithMonth}) {
    var week = date.weekday;
    var weekKr = ['월', '화', '수', '목', '금', '토', '일'];
    var formater = DateFormat('yyyy-MM-dd(${weekKr[week - 1]})');
    return formater.format(date);
  }

  static bool equlse(DateTime dt1, DateTime dt2, {bool? isForMonth}) {
    return isForMonth != null && isForMonth
        ? dt1.year == dt2.year && dt1.month == dt2.month
        : dt1.year == dt2.year && dt1.month == dt2.month && dt1.day == dt2.day;
  }

  static bool diffMounth(DateTime start, DateTime end) {
    return (start.year == end.year && start.month != end.month) ||
        (start.year != end.year);
  }

  static bool isToday(DateTime start, DateTime end) {
    return DateUtils.isSameDay(start, end);
  }

  static String prevWeek() {
    var date = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    var temp = date.millisecondsSinceEpoch - (24 * 60 * 60 * 1000) * 7;
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(temp));
  }

  static String getMonthStr(DateTime date) {
    return '${date.year}${date.month < 10 ? '0${date.month}' : '${date.month}'}';
  }

  static toKrWeekDateStr(DateTime date, {bool? isWithMonth}) {
    var week = date.weekday;
    var weekKr = ['월', '화', '수', '목', '금', '토', '일'];
    var formater = DateFormat('yyyy.MM.dd(${weekKr[week - 1]})');
    return formater.format(date);
  }

  static String getDateStr(String date, {DateTime? dt}) {
    var temp = dt ?? getDate(date);
    var formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(temp);
  }

  static String getDateStrForKR(DateTime date, {bool? isWithZero}) {
    var formatter = DateFormat('yyyy년 MM월 dd일');
    return isWithZero != null && isWithZero
        ? '${date.year}년 ${date.month}월 ${date.day}일'
        : formatter.format(date);
  }

  static String getMonthStrForKR(DateTime date, {bool? isWithZero}) {
    var formatter = DateFormat('yyyy년 MM월');
    return isWithZero != null && isWithZero
        ? '${date.year}년 ${date.month}월'
        : formatter.format(date);
  }

  static String now() {
    var date = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  static String getTimeNow({bool? isNotWithColon, DateTime? dt}) {
    var date = dt ?? DateTime.now();
    return '${date.hour < 10 ? '0${date.hour}' : '${date.hour}'}${date.minute < 10 ? '0${date.minute}' : '${date.minute}'}${date.second < 10 ? '0${date.second}' : '${date.second}'}';
  }

  static String getTimeNow2({bool? isNotWithColon, DateTime? dt}) {
    var date = dt ?? DateTime.now();
    return '${date.hour < 10 ? '0${date.hour}' : '${date.hour}'}${date.minute < 10 ? '0${date.minute}' : '${date.minute}'}';
  }

  static DateTime getDate(String dateStr) {
    return DateTime.parse(dateStr);
  }

  static Future<bool> checkDateIsBefore(
      BuildContext context, String? startDate, String? endDate) async {
    if (startDate != null && endDate != null) {
      var start = DateTime.parse(startDate);
      var end = DateTime.parse(endDate);
      var equal = start.year == end.year &&
          start.month == end.month &&
          start.day == end.day;
      var isBefore = start.isBefore(end) || equal;
      if (!isBefore) {
        AppDialog.showSignglePopup(
            context, '${tr('start_date_before_end_date')}');
        return false;
      }
    }
    return true;
  }
}
