/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/menu_provider.dart
 * Created Date: 2022-08-04 23:17:24
 * Last Modified: 2022-08-17 11:48:20
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/model/rfc/salse_activity_location_response_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

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
  SalseActivityLocationResponseModel? locationResponseModel;
  final _api = ApiService();
  bool isNeedUpdate = false;
  ActivityStatus? activityStatus;
  bool isLoadData = false;

  void setActivityStatus(ActivityStatus? status) {
    activityStatus = status;
    notifyListeners();
  }

  void setIsNeedUpdate(bool val) {
    isNeedUpdate = val;
    notifyListeners();
  }

  void setSelectedIndex(int indexx) {}
  Future<ResultModel> addActivity() async {
    return ResultModel(false);
  }

  Future<ResultModel> getOfficeAddress() async {
    if (locationResponseModel != null) {
      return ResultModel(true);
    }
    _api.init(RequestType.GET_OFFICE_ADDRESS);
    final esLogin = CacheService.getEsLogin();
    final isLogin = CacheService.getIsLogin();
    Map<String, dynamic> _body = {
      "methodName": RequestType.GET_OFFICE_ADDRESS.serverMethod,
      "methodParamMap": {
        "IV_ADDCAT": "",
        "IV_PTYPE": "R",
        "IV_VKGRP": esLogin!.vkgrp,
        "IV_LOGID": esLogin.logid!.toUpperCase(),
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.GET_OFFICE_ADDRESS.resultTable,
        "functionName": RequestType.GET_OFFICE_ADDRESS.serverMethod
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      locationResponseModel =
          SalseActivityLocationResponseModel.fromJson(result.body['data']);
      pr(locationResponseModel?.toJson());
      return ResultModel(true);
    }
    return ResultModel(false);
  }

  Future<void> initData(SalesActivityDayResponseModel fromParentWindowModel,
      ActivityStatus? status) async {
    getOfficeAddress();
    editModel =
        SalesActivityDayResponseModel.fromJson(fromParentWindowModel.toJson());
    pr(editModel?.toJson());
    activityStatus = status;
  }
}
