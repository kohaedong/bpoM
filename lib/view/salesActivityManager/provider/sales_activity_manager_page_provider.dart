/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activityManeger/provider/activity_manager_page_provider.dart
 * Created Date: 2022-07-05 09:48:24
 * Last Modified: 2022-08-01 15:54:03
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
import 'package:medsalesportal/model/rfc/sales_activity_month_response_model.dart';
import 'package:medsalesportal/model/rfc/search_key_response_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class SalseActivityManagerPageProvider extends ChangeNotifier {
  SalesActivityMonthResponseModel? monthResponseModel;
  SearchKeyResponseModel? searchKeyResponseModel;
  bool isLoadData = false;
  int? tabIndex;
  DateTime? selectedMonth;
  final _api = ApiService();
  void setTabIndex(int index) {
    this.tabIndex = index;
    notifyListeners();
  }

  void setMonth(DateTime dt) {
    selectedMonth = dt;
    notifyListeners();
  }

  Future<ResultModel> searchPartmentKeyZBIZ() async {
    _api.init(RequestType.SEARCH_PARTMENT_KEY_ZIBI);
    var isLogin = CacheService.getIsLogin();
    Map<String, dynamic> _body = {
      "methodName": RequestType.SEARCH_PARTMENT_KEY_ZIBI.serverMethod,
      "methodParamMap": {
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.SEARCH_PARTMENT_KEY_ZIBI.resultTable,
        "functionName": RequestType.SEARCH_PARTMENT_KEY_ZIBI.serverMethod
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      searchKeyResponseModel =
          SearchKeyResponseModel.fromJson(result.body['data']);
      pr(searchKeyResponseModel?.toJson());
      return ResultModel(true);
    }
    return ResultModel(false);
  }

  Future<ResultModel> getData({bool? isWithLoading}) async {
    if (isWithLoading != null && isWithLoading) {
      isLoadData = true;
      notifyListeners();
    }
    if (searchKeyResponseModel == null) {
      await searchPartmentKeyZBIZ();
    }
    _api.init(RequestType.SALESE_ACTIVITY_MONTH_DATA);
    var esLogin = CacheService.getEsLogin();
    var isLogin = CacheService.getIsLogin();
    Map<String, dynamic> _body = {
      "methodName": RequestType.SALESE_ACTIVITY_MONTH_DATA.serverMethod,
      "methodParamMap": {
        "IV_ZBIZ": searchKeyResponseModel!.tList!.first.zbiz,
        "IV_RESID": esLogin!.logid!.toUpperCase(),
        "IS_LOGIN": isLogin,
        "IV_VKGRP": esLogin.vkgrp,
        "IV_SPMON": DateUtil.getMonthStr(
            selectedMonth != null ? selectedMonth! : DateTime.now()),
        "resultTables": RequestType.SALESE_ACTIVITY_MONTH_DATA.resultTable,
        "functionName": RequestType.SALESE_ACTIVITY_MONTH_DATA.serverMethod
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      if (isWithLoading != null && isWithLoading) {
        isLoadData = false;
        notifyListeners();
      }
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      monthResponseModel =
          SalesActivityMonthResponseModel.fromJson(result.body['data']);
      pr(monthResponseModel?.toJson());
      if (isWithLoading != null && isWithLoading) {
        isLoadData = false;
      }
      notifyListeners();
      return ResultModel(true);
    }
    if (isWithLoading != null && isWithLoading) {
      isLoadData = false;
    }
    notifyListeners();
    return ResultModel(true);
  }
}
