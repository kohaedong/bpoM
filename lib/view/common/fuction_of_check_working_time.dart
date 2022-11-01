/*
 * Project Name:  [koreaJob]
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/fuction_of_check_working_time.dart
 * Created Date: 2022-11-01 17:25:02
 * Last Modified: 2022-11-01 19:53:07
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  MOMONETWORK ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/globalProvider/timer_provider.dart';
import 'package:medsalesportal/view/common/function_of_pop_to_first.dart';

void showWorkingTimePopup({BuildContext? contextt}) async {
  final context = contextt ?? KeyService.baseAppKey.currentContext!;
  final tp = context.read<TimerProvider>();
  AppDialog.showDangermessage(
      context,
      tr('plz_check_working_time', args: [
        '${tp.startWorkingHour}:${tp.startMinute}',
        '${tp.stopWorkingHour}:${tp.stopMinute}'
      ]));
}

void showOverTimePopup({BuildContext? contextt}) async {
  final context = contextt ?? KeyService.baseAppKey.currentContext!;
  final tp = context.read<TimerProvider>();

  var fill = (int val) {
    var temp = (val == 0) ? '00' : ('$val'.length == 1 ? '0$val' : '$val');
    return temp;
  };
  var popupResult = await AppDialog.showDangermessage(
      context,
      tr('plz_check_over_time', args: [
        '${fill(tp.startWorkingHour)}:${fill(tp.startMinute)}',
        '${fill(tp.stopWorkingHour)}:${fill(tp.stopMinute)}'
      ]));
  if (popupResult != null && popupResult) {
    tp.setLastActionTime();
    popToFirst(context);
  }
}

bool isNotWoringTime() {
  final context = KeyService.baseAppKey.currentContext!;
  final tp = context.read<TimerProvider>();
  return tp.isNotWorkingTime;
}

bool isOverTime() {
  final context = KeyService.baseAppKey.currentContext!;
  final tp = context.read<TimerProvider>();
  return tp.isOverTime;
}

void setActionTime({BuildContext? contextt}) {
  final context = contextt ?? KeyService.baseAppKey.currentContext!;
  final tp = context.read<TimerProvider>();
  tp.setLastActionTime();
}
