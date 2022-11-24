/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/globalProvider/activity_state_provder.dart
 * Created Date: 2022-10-06 01:55:53
 * Last Modified: 2022-11-02 21:17:38
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:bpom/view/common/function_of_print.dart';

class ActivityStateProvider extends ChangeNotifier {
  bool isNeedUpdateDayData = false;
  DateTime? previousWorkingDay;

  void setIsNeedUpdate(bool val) {
    isNeedUpdateDayData = val;
    notifyListeners();
  }

  void setPrevWorkingDay(DateTime dt) {
    previousWorkingDay = dt;
    pr('prev working date!!! $dt');
    notifyListeners();
  }
}
