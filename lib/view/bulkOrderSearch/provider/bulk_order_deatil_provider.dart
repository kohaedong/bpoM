/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/bulkOrderSearch/provider/bulk_order_deatil_provider.dart
 * Created Date: 2022-07-21 14:21:16
 * Last Modified: 2022-07-21 17:12:04
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
import 'package:medsalesportal/model/rfc/bulk_order_detail_response_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_t_item_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_et_t_list_model.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/util/is_super_account.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class BulkOrderDetailProvider extends ChangeNotifier {
  BulkOrderDetailResponseModel? bulkOrderDetailResponseModel;

  Future<ResultModel> getOrderDetail(BulkOrderEtTListModel model) async {
    final _api = ApiService();
    _api.init(RequestType.GET_BULK_DETAIL);
    var type = 'R';
    var vkorg = '';
    var isLogin = '';
    if (CheckSuperAccount.isMultiAccount()) {
      final isloginModel =
          EncodingUtils.decodeBase64ForIsLogin(CacheService.getIsLogin()!);
      isLogin = await EncodingUtils.getSimpleIsLogin(isloginModel);
    } else {
      vkorg = CacheService.getEsLogin()!.vkorg!;
      isLogin = CacheService.getIsLogin()!;
    }
    Map<String, dynamic> _body = {
      "methodName": RequestType.GET_BULK_DETAIL.serverMethod,
      "methodParamMap": {
        "UMODE": "",
        "ZKWMENG": "",
        "IV_PTYPE": type,
        "IV_ZREQNO": model.zreqno,
        "IV_VKORG": vkorg,
        "IS_LOGIN": isLogin,
        "functionName": RequestType.GET_BULK_DETAIL.serverMethod,
        "resultTables": RequestType.GET_BULK_DETAIL.resultTable
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      bulkOrderDetailResponseModel =
          BulkOrderDetailResponseModel.fromJson(result.body['data']);
      pr(bulkOrderDetailResponseModel?.tItem?.first.toJson());
      return ResultModel(true);
    }

    return ResultModel(false);
  }
}
