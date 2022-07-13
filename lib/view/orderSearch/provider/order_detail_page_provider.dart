/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderSearch/provider/order_detail_page_provider.dart
 * Created Date: 2022-07-13 09:31:34
 * Last Modified: 2022-07-13 17:13:01
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
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';

class OrderDetailPageProvider extends ChangeNotifier {
  Future<ResultModel> orderCancel(String orderNumber) async {
    final _api = ApiService();
    _api.init(RequestType.ORDER_CANCEL);
    final isLogin = CacheService.getIsLogin();
    final result = await _api.request(body: {
      "methodName": RequestType.ORDER_CANCEL.serverMethod,
      "methodParamMap": {
        'IV_VBELN': orderNumber,
        'IS_LOGIN': isLogin,
        'resultTables': RequestType.ORDER_CANCEL.resultTable,
        'functionName': RequestType.ORDER_CANCEL.serverMethod,
      },
    });
    if (result != null && result.statusCode != 200) {
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      final esReturn = EsReturnModel.fromJson(result.body['data']['ES_RETURN']);
      if (esReturn.mtype == 'S') {
        return ResultModel(true, message: esReturn.message);
      }
    }
    return ResultModel(false, message: result!.message);
  }
}
