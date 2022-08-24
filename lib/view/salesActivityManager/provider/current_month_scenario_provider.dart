/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/current_month_scenario_provider.dart
 * Created Date: 2022-08-17 23:40:28
 * Last Modified: 2022-08-24 17:27:08
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_430.dart';

class CurrentMonthScenarioProvider extends ChangeNotifier {
  List<SalesActivityDayTable430>? table430;
  bool isFirstRun = true;
  String? index0Description;
  String? index1Description;
  String? index2Description;
  String? index3Description;
  String? index4Description;
  void setIsFirstRun(bool val) {
    isFirstRun = val;
  }

  void setIndex0Descriptiopn(String str) {
    index0Description = str;
  }

  void setIndex1Descriptiopn(String str) {
    index1Description = str;
  }

  void setIndex2Descriptiopn(String str) {
    index2Description = str;
  }

  void setIndex3Descriptiopn(String str) {
    index3Description = str;
  }

  void setIndex4Descriptiopn(String str) {
    index4Description = str;
  }

  Future<ResultModel> getCurrentMonthScenario(
      List<SalesActivityDayTable430> list430,
      String kunnr,
      String? keyManNumber) async {
    table430 = list430
        .where((element) =>
            element.zskunnr == kunnr && element.zkmno == keyManNumber)
        .toList();
    return ResultModel(true);
  }
}
