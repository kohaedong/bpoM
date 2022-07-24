/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/bulkOrderSearch/provider/bulk_order_deatil_provider.dart
 * Created Date: 2022-07-21 14:21:16
 * Last Modified: 2022-07-24 18:35:34
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_amount_response_model.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/util/is_super_account.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/model/rfc/bulk_order_et_t_list_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_response_model.dart';

class BulkOrderDetailProvider extends ChangeNotifier {
  BulkOrderDetailResponseModel? bulkOrderDetailResponseModel;
  BulkOrderDetailAmountResponseModel? bulkOrderDetailAmountResponseModel;
  final _api = ApiService();
  bool isShowShadow = true;
  bool isAnimationNotReady = true;
  bool isOpenBottomSheet = true;
  double orderTotal = 0.0;
  String amountAvailable = '';
  void setIsShowShadow() {
    isShowShadow = !isShowShadow;
    notifyListeners();
  }

  void setIsReadyForAnimation() {
    isAnimationNotReady = !isAnimationNotReady;
    notifyListeners();
  }

  void setIsOpenBottomSheet() {
    isOpenBottomSheet = !isOpenBottomSheet;
    Future.delayed(Duration(milliseconds: isOpenBottomSheet ? 140 : 0), () {
      setIsShowShadow();
    });
    notifyListeners();
  }

  Future<ResultModel> getAmountAvailableForOrderEntry() async {
    assert(bulkOrderDetailResponseModel != null);
    _api.init(RequestType.AMOUNT_AVAILABLE_FOR_ORDER_ENTRY);
    Map<String, dynamic> _body = {
      "methodName": RequestType.AMOUNT_AVAILABLE_FOR_ORDER_ENTRY.serverMethod,
      "methodParamMap": {
        "IV_VKORG": bulkOrderDetailResponseModel!.tHead!.first.vkorg,
        "IV_VTWEG": bulkOrderDetailResponseModel!.tHead!.first.vtweg,
        "IV_SPART": bulkOrderDetailResponseModel!.tHead!.first.spart,
        "IV_KUNNR": bulkOrderDetailResponseModel!.tHead!.first.kunnr,
        "IS_LOGIN": CacheService.getIsLogin(),
        "functionName":
            RequestType.AMOUNT_AVAILABLE_FOR_ORDER_ENTRY.serverMethod,
        "resultTables": RequestType.AMOUNT_AVAILABLE_FOR_ORDER_ENTRY.resultTable
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      bulkOrderDetailAmountResponseModel =
          BulkOrderDetailAmountResponseModel.fromJson(result.body['data']);
      pr(bulkOrderDetailAmountResponseModel?.tCreditLimit?.single.toJson());
      amountAvailable =
          bulkOrderDetailAmountResponseModel!.tCreditLimit!.single.amount!;
      notifyListeners();
      return ResultModel(true);
    }
    return ResultModel(false);
  }

  Future<ResultModel> getOrderDetail(BulkOrderEtTListModel model) async {
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
      pr(isLogin);
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
      pr(bulkOrderDetailResponseModel?.tHead?.first.toJson());
      isAnimationNotReady = false;
      bulkOrderDetailResponseModel?.tItem?.forEach((item) {
        orderTotal += item.znetpr!;
      });
      getAmountAvailableForOrderEntry();
      return ResultModel(true);
    }

    return ResultModel(false);
  }
}
