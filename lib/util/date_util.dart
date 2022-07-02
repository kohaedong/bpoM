/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/util/date_util.dart
 * Created Date: 2021-11-23 07:56:54
 * Last Modified: 2022-07-02 13:54:29
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/view/common/app_dialog.dart';

// 날짜 관련 도구
class DateUtil {
  static String prevMonth() {
    var date = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');

    return formatter.format(DateTime(date.year, date.month - 1, date.day));
  }

  static String getDateStr(String date) {
    var temp = getDate(date);
    var formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(temp);
  }

  static String now() {
    var date = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  static String getTimeNow() {
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
