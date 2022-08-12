/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/menu_provider.dart
 * Created Date: 2022-08-04 23:17:24
 * Last Modified: 2022-08-12 11:20:50
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

class ActivityMenuProvider extends ChangeNotifier {
  SalesActivityDayResponseModel? editModel;
  SalseActivityLocationResponseModel? locationResponseModel;
  final _api = ApiService();
  bool isNeedUpdate = false;
  ActivityStatus? activityStatus;
  bool isLoadData = false;

  void changeIsLoad() {
    isLoadData = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 1), () {
      isLoadData = false;
      notifyListeners();
    });
  }

  void setActivityStatus(ActivityStatus? status) {
    activityStatus = status;
    notifyListeners();
  }

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
