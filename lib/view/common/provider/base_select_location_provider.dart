/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/select_location_provider.dart
 * Created Date: 2022-08-07 20:01:39
 * Last Modified: 2022-08-11 15:29:04
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/salse_activity_location_response_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';

class BaseSelectLocationProvider extends ChangeNotifier {
  SalseActivityLocationResponseModel? locationResponseModel;
  final _api = ApiService();
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

  Future<ResultModel> getOfficeAddress() async {
    _api.init(RequestType.GET_OFFICE_ADDRESS);
    final esLogin = CacheService.getEsLogin();
    final isLogin = CacheService.getIsLogin();
    Map<String, dynamic> _body = {
      "methodName": RequestType.GET_OFFICE_ADDRESS.httpMethod,
      "methodParamMap": {
        "IV_ADDCAT": "",
        "IV_PTYPE": "R",
        "IV_VKGRP": esLogin!.vkgrp,
        "IV_LOGID": esLogin.logid!.toUpperCase(),
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.GET_OFFICE_ADDRESS.resultTable,
        "functionName": RequestType.GET_OFFICE_ADDRESS.httpMethod
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      locationResponseModel =
          SalseActivityLocationResponseModel.fromJson(result.body);
      return ResultModel(true);
    }
    return ResultModel(false);
  }
}
