/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/menu_provider.dart
 * Created Date: 2022-08-04 23:17:24
 * Last Modified: 2022-08-08 18:12:05
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

  bool get isStarted => editModel!.table250!.isEmpty
      ? false
      : editModel!.table250!.last.scallType == 'M' &&
          editModel!.table250!.last.ftime!.isNotEmpty &&
          editModel!.table250!.last.fcallType != 'M' &&
          editModel!.table250!.last.ftime!.isEmpty;

  Future<void> initData(
      SalesActivityDayResponseModel fromParentWindowModel) async {
    editModel =
        SalesActivityDayResponseModel.fromJson(fromParentWindowModel.toJson());
    pr(editModel?.toJson());
    activitStatusText =
        isStarted ? tr('stop_sales_activity') : tr('start_sales_activity');
  }
}
