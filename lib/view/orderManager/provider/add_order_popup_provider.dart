/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/provider/add_order_popup_provider.dart
 * Created Date: 2022-09-04 17:56:07
 * Last Modified: 2022-09-04 17:58:28
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/styles/app_size.dart';

class AddOrderPopupProvider extends ChangeNotifier {
  double height = AppSize.defaultPopupHeight;

  void setHeight(double val) {
    height = val;
    notifyListeners();
  }
}
