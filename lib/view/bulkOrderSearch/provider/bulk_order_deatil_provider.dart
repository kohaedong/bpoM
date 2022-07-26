/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/bulkOrderSearch/provider/bulk_order_deatil_provider.dart
 * Created Date: 2022-07-21 14:21:16
 * Last Modified: 2022-07-26 19:42:20
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_amount_response_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_search_meta_price_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_search_meta_price_response_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_t_item_model.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/util/is_super_account.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/model/rfc/bulk_order_et_t_list_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_response_model.dart';

class BulkOrderDetailProvider extends ChangeNotifier {
  BulkOrderDetailResponseModel? bulkOrderDetailResponseModel;
  BulkOrderDetailAmountResponseModel? bulkOrderDetailAmountResponseModel;
  BulkOrderDetailSearchMetaPriceResponseModel? searchMetaPriceResponseModel;
  List<BulkOrderDetailTItemModel> editItemList = [];
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

  void setQuantityAndCheckPrice(String str, int index) {
    editItemList[index].kwmeng = double.parse(str);
    checkMetaPriceAndStock(index);
    notifyListeners();
  }

  Future<ResultModel> checkMetaPriceAndStock(int index) async {
    _api.init(RequestType.CHECK_META_PRICE_AND_STOCK);
    var temp = BulkOrderDetailSearchMetaPriceModel();
    temp.matnr = editItemList[index].matnr;
    temp.kwmeng = editItemList[index].kwmeng;
    temp.vrkme = editItemList[index].vrkme;
    temp.zfreeQtyIn = editItemList[index].zfreeQtyIn;

    var itemBase64 = await EncodingUtils.base64Convert(temp.toJson());
    Map<String, dynamic> _body = {
      "methodName": RequestType.CHECK_META_PRICE_AND_STOCK.serverMethod,
      "methodParamMap": {
        // input에서 요청수량 변경시 editItemList[index].kwmeng의 값이 변경 됨.
        "IV_KWMENG": editItemList[index].kwmeng,
        "IV_MATNR": editItemList[index].matnr,
        "IV_ZZKUNNR_END":
            bulkOrderDetailResponseModel!.tHead!.single.zzkunnrEnd,
        "IV_VKORG": bulkOrderDetailResponseModel!.tHead!.single.vkorg,
        "IV_VTWEG": bulkOrderDetailResponseModel!.tHead!.single.vtweg,
        "IV_SPART": bulkOrderDetailResponseModel!.tHead!.single.spart,
        "IV_KUNNR": bulkOrderDetailResponseModel!.tHead!.single.kunnr,
        "IV_PRSDT": FormatUtil.removeDash(DateTime.now().toIso8601String()),
        "T_LIST": itemBase64,
        "IS_LOGIN": CacheService.getIsLogin(),
        "functionName": RequestType.CHECK_META_PRICE_AND_STOCK.serverMethod,
        "resultTables": RequestType.CHECK_META_PRICE_AND_STOCK.resultTable,
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      searchMetaPriceResponseModel =
          BulkOrderDetailSearchMetaPriceResponseModel.fromJson(
              result.body['data']);
      var temp =
          BulkOrderDetailTItemModel.fromJson(editItemList[index].toJson());
      temp.zmsg = searchMetaPriceResponseModel!.tList!.single.zmsg;
      editItemList[index] = BulkOrderDetailTItemModel.fromJson(temp.toJson());
      pr(editItemList[index].zmsg);
      notifyListeners();
      return ResultModel(true);
    }
    return ResultModel(false);
  }

  Future<ResultModel> getAmountAvailableForOrderEntry() async {
    assert(bulkOrderDetailResponseModel != null);
    _api.init(RequestType.AMOUNT_AVAILABLE_FOR_ORDER_ENTRY);
    Map<String, dynamic> _body = {
      "methodName": RequestType.AMOUNT_AVAILABLE_FOR_ORDER_ENTRY.serverMethod,
      "methodParamMap": {
        "IV_VKORG": bulkOrderDetailResponseModel!.tHead!.single.vkorg,
        "IV_VTWEG": bulkOrderDetailResponseModel!.tHead!.single.vtweg,
        "IV_SPART": bulkOrderDetailResponseModel!.tHead!.single.spart,
        "IV_KUNNR": bulkOrderDetailResponseModel!.tHead!.single.kunnr,
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
      isAnimationNotReady = false; // animation 준비완료(작동 가능).
      editItemList.clear();
      var isStatusAorB =
          bulkOrderDetailResponseModel!.tHead!.single.zdmstatus == 'A' ||
              bulkOrderDetailResponseModel!.tHead!.single.zdmstatus == 'B';
      bulkOrderDetailResponseModel?.tItem?.forEach((item) {
        orderTotal += item.znetpr!;
        isStatusAorB
            ? editItemList
                .add(BulkOrderDetailTItemModel.fromJson(item.toJson()))
            : DoNothingAction();
      });
      getAmountAvailableForOrderEntry();
      return ResultModel(true);
    }

    return ResultModel(false);
  }
}
