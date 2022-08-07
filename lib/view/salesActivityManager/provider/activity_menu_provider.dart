/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/menu_provider.dart
 * Created Date: 2022-08-04 23:17:24
 * Last Modified: 2022-08-07 22:46:52
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class ActivityMenuProvider extends ChangeNotifier {
  SalesActivityDayResponseModel? editModel;
  String activitStatusText = '';
  double popupHeight = 200;
  bool isLoadData = false;

  void setHeight(double val) {
    popupHeight = val;
    notifyListeners();
  }

  void changeIsLoad() {
    isLoadData = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 1), () {
      isLoadData = false;
      notifyListeners();
    });
  }

  void setActivityStatusText(String str) {
    activitStatusText = str;
    notifyListeners();
  }

  bool isStarted() {
    var table250 = editModel?.table250!;
    var startAddressIsNotEmpty = table250 != null &&
        table250.single.saddcat != null &&
        table250.single.saddcat!.isNotEmpty;
    var stopAddressIsNotEmpty = table250 != null &&
        table250.single.saddcat != null &&
        table250.single.faddcat!.isNotEmpty;
    var isStarted = startAddressIsNotEmpty && !stopAddressIsNotEmpty;
    return isStarted;
  }

  Future<void> initData(
      SalesActivityDayResponseModel fromParentWindowModel) async {
    editModel =
        SalesActivityDayResponseModel.fromJson(fromParentWindowModel.toJson());
    pr(editModel?.toJson());

    activitStatusText =
        isStarted() ? tr('stop_sales_activity') : tr('start_sales_activity');
  }
}
