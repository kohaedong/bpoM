/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/visit_result_history_page_provider.dart
 * Created Date: 2022-08-17 23:32:54
 * Last Modified: 2022-08-24 17:28:55
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/model/rfc/visit_result_history_page_response_model.dart';

class VisitResultHistoryPageProvider extends ChangeNotifier {
  VisitResultHistoryPageResponseModel? visitResponseModel;
  final _api = ApiService();

  Future<ResultModel> getVisitHistory(String date, String zskunnr) async {
    _api.init(RequestType.GET_VISIT_HISTORY);
    Map<String, dynamic> _body = {
      "methodName": RequestType.GET_VISIT_HISTORY.serverMethod,
      "methodParamMap": {
        "IV_ADATE": date,
        "IV_ZSKUNNR": zskunnr,
        "IS_LOGIN": CacheService.getIsLogin(),
        "resultTables": RequestType.GET_VISIT_HISTORY.resultTable,
        "functionName": RequestType.GET_VISIT_HISTORY.serverMethod,
      }
    };

    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      visitResponseModel =
          VisitResultHistoryPageResponseModel.fromJson(result.body['data']);
      pr(visitResponseModel?.toJson());
      return ResultModel(true);
    }
    return ResultModel(false);
  }
}
