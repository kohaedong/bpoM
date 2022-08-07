/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/select_location_provider.dart
 * Created Date: 2022-08-07 20:01:39
 * Last Modified: 2022-08-07 22:30:10
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';

class BaseSelectLocationProvider extends ChangeNotifier {
  double height = 200;
  int selectedIndex = 0;
  void setHeight(double val) {
    height = val;
    notifyListeners();
  }

  void setSelectedIndex(int val) {
    selectedIndex = val;
    notifyListeners();
  }
}
