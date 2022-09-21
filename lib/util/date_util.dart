/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/util/date_util.dart
 * Created Date: 2021-11-23 07:56:54
 * Last Modified: 2022-09-21 18:36:15
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
import 'package:medsalesportal/view/common/function_of_print.dart';

// 날짜 관련 도구
class DateUtil {
  static String prevMonth({DateTime? dt}) {
    var date = dt ?? DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');

    return formatter.format(DateTime(date.year, date.month - 1, date.day));
  }

  static String nextMonth({DateTime? dt}) {
    var date = dt ?? DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(DateTime(date.year, date.month + 1, date.day));
  }

  static getDateWithWeek(DateTime date, {bool? isWithMonth}) {
    var week = date.weekday;
    var weekKr = ['월', '화', '수', '목', '금', '토', '일'];
    var formater = DateFormat('yyyy-MM-dd(${weekKr[week - 1]})');
    return formater.format(date);
  }

  static DateTime previousDay({DateTime? dt}) {
    var date = dt ?? DateTime.now();
    return DateTime(date.year, date.month, date.day - 1);
  }

  static DateTime nextDay({DateTime? dt}) {
    var date = dt ?? DateTime.now();
    return DateTime(date.year, date.month, date.day + 1);
  }

  static bool equlse(DateTime dt1, DateTime dt2, {bool? isForMonth}) {
    return isForMonth != null && isForMonth
        ? dt1.year == dt2.year && dt1.month == dt2.month
        : dt1.year == dt2.year && dt1.month == dt2.month && dt1.day == dt2.day;
  }

  static int diffMounth(DateTime start, DateTime end) {
    int v = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    pr(v);
    return v ~/ (86400000 * 30);
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

  static String getTimeNow({bool? isNotWithColon}) {
    return '${DateTime.now().hour < 10 ? '0${DateTime.now().hour}' : '${DateTime.now().hour}'}${DateTime.now().minute < 10 ? '0${DateTime.now().minute}' : '${DateTime.now().minute}'}${DateTime.now().second < 10 ? '0${DateTime.now().second}' : '${DateTime.now().second}'}';
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
