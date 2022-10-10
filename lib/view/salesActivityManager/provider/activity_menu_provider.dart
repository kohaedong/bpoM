/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/menu_provider.dart
 * Created Date: 2022-08-04 23:17:24
 * Last Modified: 2022-10-11 00:43:03
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/globalProvider/activity_state_provder.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/model/rfc/salse_activity_location_response_model.dart';

// ----------------- discription ----------------------
//     ______________________
//    |                      | --->>> 일별  provider.
//    |                      |
//    |                      |
//    |                      |
//    |                      |
//    |                      |
//    |                      |
//    |           최종활동삭제  |
//    |           영업활동추가  |--->>> 영업활동 시작 or 엉업활동 추가 누를때  location 선택 popup으로  editModel 전달 (from this provider)
//    |           영업활동시작  |       // 전달 목적 :  영업활동 위치 선택후 바로 table 저장 작업 있기 때문이다. table저장에 성공하면 영업활동 등록 화면으로 간다.
//    |                      |                    table 내용이 변경되면 isNeedUpdate = true ; (부모창에서 이 값에 따라 update 여부 판단 한다.)
//    |           (추가/닫기)  | --->>> 추가눌러 popup 열때 model 전달 (from 일별provider).
//    | _____________________| --->>> 닫기눌러 popup 닫힐 때 result로(isNeedUpdate) 부모창에 update여부를 알려준다. update가 필요하면 부모창에서 최신 일별데이터를 가져온다.

class ActivityMenuProvider extends ChangeNotifier {
  SalesActivityDayResponseModel? editModel;
  SalseActivityLocationResponseModel? officeAddressResponseModel;
  final _api = ApiService();
  bool isNeedUpdate = false;
  ActivityStatus? activityStatus;
  bool isLoadData = false;
  DateTime? goinToMenuTime;
  bool get isDifreentGoinTime => goinToMenuTime!.day != DateTime.now().day;
  void setActivityStatus(ActivityStatus? status) {
    activityStatus = status;
    notifyListeners();
  }

  void setIsNeedUpdate(bool val) {
    isNeedUpdate = val;
    try {
      notifyListeners();
    } catch (e) {
      pr(e);
    }
  }

  Future<void> initData(SalesActivityDayResponseModel fromParentWindowModel,
      ActivityStatus? status,
      {SalseActivityLocationResponseModel? officeAddress,
      bool? isMounted}) async {
    goinToMenuTime = DateTime.now();
    editModel =
        SalesActivityDayResponseModel.fromJson(fromParentWindowModel.toJson());
    if (officeAddress != null) {
      officeAddressResponseModel = officeAddress;
    }

    pr('??? status $status');
    activityStatus = status;
    if (isMounted != null && isMounted) {
      notifyListeners();
    }
  }

  Future<ResultModel> deletLastActivity() async {
    isLoadData = true;
    notifyListeners();
    var ap =
        KeyService.baseAppKey.currentContext!.read<ActivityStateProvider>();
    _api.init(RequestType.SALESE_ACTIVITY_DAY_DATA);
    var isLogin = CacheService.getIsLogin();
    Map<String, dynamic> _body = {
      "methodName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      "methodParamMap": {
        "IV_PTYPE": "R",
        "IV_ADATE": FormatUtil.removeDash(DateUtil.getDateStr('',
            dt: activityStatus == ActivityStatus.PREV_WORK_DAY_EN_STOPED ||
                    activityStatus == ActivityStatus.PREV_WORK_DAY_STOPED
                ? await ap.previousWorkingDay!
                : DateTime.now())),
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.SALESE_ACTIVITY_DAY_DATA.resultTable,
        "functionName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      }
    };
    final dayResult = await _api.request(body: _body);
    if (dayResult != null && dayResult.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(false);
    }
    if (dayResult != null && dayResult.statusCode == 200) {
      editModel =
          SalesActivityDayResponseModel.fromJson(dayResult.body['data']);
      if (editModel != null && editModel!.table260!.isEmpty) {
        isLoadData = false;
        notifyListeners();
        return ResultModel(false, data: 'empty');
      }

      _api.init(RequestType.DELETE_LAST_ACTIVITY);
      var isLogin = CacheService.getIsLogin();
      var esLogin = CacheService.getEsLogin();
      Map<String, dynamic> _body = {
        "methodName": RequestType.DELETE_LAST_ACTIVITY.serverMethod,
        "methodParamMap": {
          "IV_PTYPE": "D",
          "confirmType": "Y",
          "IS_LOGIN": isLogin,
          "IV_SANUM": esLogin!.logid!.toUpperCase(),
          "IV_ADATE": DateUtil.getDateStr(DateTime.now().toIso8601String()),
          "resultTables": RequestType.DELETE_LAST_ACTIVITY.resultTable,
          "functionName": RequestType.DELETE_LAST_ACTIVITY.serverMethod
        }
      };
      final result = await _api.request(body: _body);
      if (result != null && result.statusCode != 200) {
        isLoadData = false;
        notifyListeners();
        return ResultModel(false, errorMassage: result.errorMessage);
      }
      if (result != null && result.statusCode == 200) {
        pr(result.body);
        isLoadData = false;
        notifyListeners();
        return ResultModel(true);
      }
    }

    return ResultModel(false, errorMassage: dayResult!.errorMessage);
  }
}
