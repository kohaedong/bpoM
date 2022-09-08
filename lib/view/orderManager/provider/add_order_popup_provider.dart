/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/provider/add_order_popup_provider.dart
 * Created Date: 2022-09-04 17:56:07
 * Last Modified: 2022-09-08 15:50:30
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
import 'package:medsalesportal/model/rfc/order_manager_material_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/util/encoding_util.dart';

class AddOrderPopupProvider extends ChangeNotifier {
  bool isLoadData = false;
  final _api = ApiService();
  double height = AppSize.realHeight * .5;
  OrderManagerMaterialModel? selectedMateria;
  String? quantity;
  String? surcharge;
  Map<String, dynamic>? _bodyMap;

  Future<void> initData(Map<String, dynamic> bodyMap) async {
    _bodyMap = bodyMap;
  }

  void setHeight(double val) {
    height = val;
    notifyListeners();
  }

  void setMaterial(OrderManagerMaterialModel? mat) {
    selectedMateria = mat;
    notifyListeners();
  }

  void setQuantity(String? str) {
    quantity = str;
    notifyListeners();
  }

  void setSurcharge(String? str) {
    surcharge = str;
    notifyListeners();
  }

  Future<ResultModel> checkPrice(int indexx, {required bool isNotifier}) async {
    if (isNotifier) {
      isLoadData = true;
      notifyListeners();
    }
    // 한번만 호출.
    _api.init(RequestType.CHECK_META_PRICE_AND_STOCK);
    var temp = BulkOrderDetailSearchMetaPriceModel();
    temp.matnr = selectedMateria!.matnr;
    temp.vrkme = selectedMateria!.vrkme;
    // temp.kwmeng = items![indexx].kwmeng;
    temp.kwmeng = double.parse(quantity!);
    temp.zfreeQtyIn = double.parse(surcharge!);
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
    _body.addAll(_bodyMap!);
    return ResultModel(false);
  }
}
