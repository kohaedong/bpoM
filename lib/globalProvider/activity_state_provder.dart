/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/globalProvider/activity_state_provder.dart
 * Created Date: 2022-10-06 01:55:53
 * Last Modified: 2022-10-07 18:28:31
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/model/common/holiday_response_model.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/util/date_util.dart';

class ActivityStateProvider extends ChangeNotifier {
  HolidayResponseModel? holidayResponseModel;
  List<DateTime> holidayList = [];
  bool isNeedUpdateDayData = false;
  DateTime? previousWorkingDay;
  void setIsNeedUpdate(bool val) {
    isNeedUpdateDayData = val;
    notifyListeners();
  }

  void setPrevWorkingDay(DateTime dt) {
    previousWorkingDay = dt;
    notifyListeners();
  }

  Future<DateTime> checkPreviousWorkingDay() async {
    if (holidayResponseModel == null) {
      await getHolidayListForMonth();
    }
    previousWorkingDay = DateUtil.previousDay(dt: DateTime.now());
    while ((previousWorkingDay!.weekday == 7) ||
        (previousWorkingDay!.weekday == 6) ||
        holidayList.contains(previousWorkingDay)) {
      previousWorkingDay = DateUtil.previousDay(dt: previousWorkingDay);
    }
    notifyListeners();
    return previousWorkingDay!;
  }

  Future<ResultModel> getHolidayListForMonth() async {
    final _api = ApiService();
    var today = DateTime.now();
    _api.init(RequestType.CHECK_HOLIDAY);
    final holidayResult = await _api.request(body: {
      'year': today.year,
      'month': today.month < 10 ? '0${today.month}' : '${today.month}',
    });
    if (holidayResult != null && holidayResult.statusCode != 200) {
      return ResultModel(false);
    }
    if (holidayResult != null && holidayResult.statusCode == 200) {
      holidayResponseModel = HolidayResponseModel.fromJson(holidayResult.body);
      if (holidayResponseModel!.data != null &&
          holidayResponseModel!.data!.isNotEmpty) {
        holidayResponseModel!.data?.forEach((holidayModel) {
          holidayList.add(DateUtil.getDate(holidayModel.locdate!));
        });
      }
      return ResultModel(true);
    }
    return ResultModel(false);
  }
}
