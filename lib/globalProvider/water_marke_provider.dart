/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/view/common/provider/water_marke_provider.dart
 * Created Date: 2021-12-17 16:05:16
 * Last Modified: 2022-01-08 01:24:08
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';

class WaterMarkeProvider extends ChangeNotifier {
  bool isShowWaterMarke = false;
  setShowWaterMarke(bool value) {
    this.isShowWaterMarke = value;
    notifyListeners();
  }
}
