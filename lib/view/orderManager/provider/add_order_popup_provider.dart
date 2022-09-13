/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/provider/add_order_popup_provider.dart
 * Created Date: 2022-09-04 17:56:07
 * Last Modified: 2022-09-13 11:12:36
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
import 'package:medsalesportal/model/rfc/bulk_order_detail_search_meta_price_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_search_meta_price_response_model.dart';
import 'package:medsalesportal/model/rfc/order_manager_material_model.dart';
import 'package:medsalesportal/model/rfc/recent_order_t_item_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class AddOrderPopupProvider extends ChangeNotifier {
  BulkOrderDetailSearchMetaPriceModel? priceModel;
  bool isLoadData = false;
  final _api = ApiService();
  double height = AppSize.realHeight * .5;
  OrderManagerMaterialModel? selectedMateria;
  String? quantity;
  String? surcharge;
  Map<String, String> bodyMap = {};

  Future<bool> initData(Map<String, dynamic> bodyMapp) async {
    bodyMapp.forEach((key, value) {
      bodyMap.putIfAbsent(key, () => '$value');
    });
    return true;
  }

  void setHeight(double val, {bool? isNotNotifier}) {
    height = val;
    if (isNotNotifier == null) {
      notifyListeners();
    }
  }

  void setMaterial(OrderManagerMaterialModel? mat) {
    selectedMateria = mat;

    notifyListeners();
  }

  void setQuantity(String? str, {bool? isNotNotifier}) {
    quantity = str;
    if (str == null) {
      setHeight(AppSize.realHeight * .5, isNotNotifier: true);
    }
    if (isNotNotifier == null) {
      notifyListeners();
    }
  }

  void setSurcharge(String? str) {
    surcharge = str;
    notifyListeners();
  }

  Future<RecentOrderTItemModel> createOrderItemModel() async {
    var temp = RecentOrderTItemModel();
    // temp.
    return RecentOrderTItemModel();
  }

  Future<ResultModel> checkPrice() async {
    isLoadData = true;
    notifyListeners();
    // 한번만 호출.
    _api.init(RequestType.CHECK_META_PRICE_AND_STOCK);
    var temp = BulkOrderDetailSearchMetaPriceModel();
    temp.matnr = selectedMateria!.matnr;
    temp.vrkme = selectedMateria!.vrkme ?? '0';
    temp.kwmeng = double.parse(quantity!);
    temp.zfreeQtyIn = double.parse(surcharge ?? '0');
    var tListBase64 = await EncodingUtils.base64Convert(temp.toJson());
    Map<String, dynamic> _body = {
      "methodName": RequestType.CHECK_META_PRICE_AND_STOCK.serverMethod,
      "methodParamMap": {
        "IV_KWMENG": quantity,
        "IV_MATNR": selectedMateria!.matnr,
        "IV_PRSDT": '',
        "T_LIST": tListBase64,
        "IS_LOGIN": CacheService.getIsLogin(),
        "functionName": RequestType.CHECK_META_PRICE_AND_STOCK.serverMethod,
        "resultTables": RequestType.CHECK_META_PRICE_AND_STOCK.resultTable,
      }
    };
    _body['methodParamMap'].addAll(bodyMap);
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      return ResultModel(false, message: result.message);
    }
    if (result != null && result.statusCode == 200) {
      var temp = BulkOrderDetailSearchMetaPriceResponseModel.fromJson(
          result.body['data']);
      pr(temp.toJson());
      var isSuccess = temp.esReturn!.mtype == 'S';
      if (isSuccess) {
        priceModel = temp.tList!.single;
      }
      // netpr 단가.netwr 정가.
      isLoadData = false;
      notifyListeners();
      return ResultModel(isSuccess,
          message: !isSuccess ? temp.esReturn!.message! : '');
    }
    return ResultModel(false);
  }
}
