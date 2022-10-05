/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/globalProvider/activity_state_provder.dart
 * Created Date: 2022-10-06 01:55:53
 * Last Modified: 2022-10-06 01:59:05
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';

class ActivityStateProvider extends ChangeNotifier {
  bool isNeedUpdateDayData = false;
  void setIsNeedUpdate(bool val) {
    isNeedUpdateDayData = val;
    notifyListeners();
  }
}
