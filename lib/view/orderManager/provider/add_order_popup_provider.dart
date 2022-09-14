/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/provider/add_order_popup_provider.dart
 * Created Date: 2022-09-04 17:56:07
 * Last Modified: 2022-09-14 13:38:12
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
  RecentOrderTItemModel? editModel;
  bool isLoadData = false;
  final _api = ApiService();
  double height = AppSize.realHeight * .5;
  OrderManagerMaterialModel? selectedMateria;
  String? quantity;
  String? surcharge;
  Map<String, String> bodyMap = {};

  Future<bool> initData(Map<String, dynamic> bodyMapp,
      {RecentOrderTItemModel? editModell,
      BulkOrderDetailSearchMetaPriceModel? priceModell}) async {
    bodyMapp.forEach((key, value) {
      bodyMap.putIfAbsent(key, () => '$value');
    });
    if (editModell != null) {
      editModel = editModell;
      selectedMateria = OrderManagerMaterialModel.fromJson(editModell.toJson());
      pr(selectedMateria?.toJson());
    }
    if (priceModell != null) {
      priceModel =
          BulkOrderDetailSearchMetaPriceModel.fromJson(priceModell.toJson());
      pr(selectedMateria?.toJson());
      quantity = priceModel!.kwmeng != 0.0 ? '${priceModel!.kwmeng}' : null;
      surcharge =
          priceModel!.zfreeQty != 0.0 ? '${priceModel!.zfreeQty}' : null;
    }
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
    var temp = editModel != null
        ? RecentOrderTItemModel.fromJson(editModel!.toJson())
        : RecentOrderTItemModel();
    temp.kwmeng = double.parse(quantity!);
    temp.matnr = priceModel!.matnr;
    temp.maktx = priceModel!.maktx;
    temp.mwsbp = priceModel!.mwsbp; // 세액(전표 통화)
    temp.netpr = priceModel!.netpr; // 단가.
    temp.netwr = priceModel!.netwr; //정가(전표 통화)
    temp.vrkme = priceModel!.vrkme; // 판매 단위
    temp.waerk = priceModel!.waerk;
    temp.werks = priceModel!.werks;
    temp.werksNm = priceModel!.werksNm;
    temp.zdisPrice = priceModel!.zdisPrice;
    temp.zdisRate = priceModel!.zdisRate;
    temp.zerr = priceModel!.zerr;
    temp.zfreeQty = surcharge != null ? double.parse(surcharge!) : 0.0;
    temp.zminQty = priceModel!.mainQty; // 제약 주문 최소 수량
    temp.zmsg = priceModel!.zmsg; // 메시지
    temp.znetpr = priceModel!.znetpr; // 기준판가.
    temp.erdat = ''; // 생성일
    temp.ernam = ''; // 생성자 이름
    temp.erwid = ''; // 생성자 id
    temp.erzet = ''; // 생성 시간
    temp.umode = 'I';
    // temp.aenam = ''; // 변경자 이름
    // temp.aewid = ''; // 변경자 id
    // temp.aezet = ''; // 변경시간
    // temp.loevm = ''; // 삭제지시자.
    // temp.loevmOr = ''; // 삭제지시자2
    // temp.orerr = ''; // 주문생성상태 (' ':미생성 or 정상, 'X':주문생성오류)
    // temp.posnr = ''; // SD 문서의 품목 번호
    // temp.vbeln = ''; // 판매 관리 문서 번호
    // temp.zfree = ''; // 무상 여부
    // temp.zfreeChk = ''; //단일 문자 표시
    // temp.zmessage = ''; //주문 미생성 사유
    // temp.zreqNo = ''; // 주문요청번호
    // temp.zreqpo = ''; // 주문요청번호 (아이템)
    // temp.zstatus = ''; // 주문처리 상태코드
    // temp.zststx = ''; // 주문상태 텍스트(아이템)
    return temp;
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
