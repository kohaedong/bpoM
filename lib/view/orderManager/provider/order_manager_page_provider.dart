/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/provider/order_manager_page_provider.dart
 * Created Date: 2022-07-05 09:57:03
 * Last Modified: 2022-09-07 13:05:07
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/util/is_super_account.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/et_cust_list_model.dart';
import 'package:medsalesportal/model/rfc/et_customer_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/model/rfc/recent_order_head_model.dart';
import 'package:medsalesportal/model/rfc/recent_order_t_item_model.dart';
import 'package:medsalesportal/model/rfc/recent_order_t_text_model.dart';
import 'package:medsalesportal/model/rfc/recent_order_response_model.dart';
import 'package:medsalesportal/model/rfc/et_cust_list_response_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_response_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_amount_response_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_search_meta_price_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_search_meta_price_response_model.dart';

class OrderManagerPageProvider extends ChangeNotifier {
  List<BulkOrderDetailSearchMetaPriceModel?> priceModelList = [];
  List<double> selectedQuantityList = [];
  List<double> selectedSurchargeList = [];
  RecentOrderResponseModel? recentOrderResponseModel;
  String? selectedSalseGroup;
  String? selectedStaffName;
  String? selectedSalseChannel;
  String? selectedProductFamily;
  String? selectedSalseOffice;
  String? deliveryConditionInputText;
  String? channelCode;
  String? orderDescriptionDetailInputText;
  EtStaffListModel? selectedSalsePerson;
  EtCustomerModel? selectedCustomerModel;
  EtCustListModel? selectedSupplierModel;
  EtCustListModel? selectedEndCustomerModel;
  List<String>? groupDataList;
  List<String>? productFamilyDataList;
  List<String>? channelList;
  List<RecentOrderTItemModel>? items;
  bool? isSingleData;
  bool isLoadData = false;
  double? amountAvalible;
  final _api = ApiService();
  RecentOrderTItemModel? test;

  String getCode(List<String> list, String val) {
    if (val != tr('all')) {
      var data = list.where((item) => item.contains(val)).single;
      pr('${data.substring(data.indexOf('-') + 1)}');
      return data.substring(data.indexOf('-') + 1);
    }

    return '';
  }

  Future<ResultModel> initData() async {
    groupDataList = await HiveService.getSalesGroup();
    productFamilyDataList = await HiveService.getProductFamily();
    channelList = await HiveService.getChannel();
    pr(channelList);
    if (!CheckSuperAccount.isMultiAccountOrLeaderAccount()) {
      var temp = channelList!.where((str) => str.contains('내수')).single;
      selectedSalseChannel = temp.substring(0, temp.indexOf('-'));
      channelCode = temp.substring(temp.indexOf('-') + 1);
    } else {
      selectedSalseChannel = tr('all');
    }

    return ResultModel(true);
  }

  void resetData({required int? level}) {
    switch (level) {
      case 1:
        selectedCustomerModel = null;
        selectedEndCustomerModel = null;
        selectedProductFamily = null;
        break;
      case 2:
        selectedCustomerModel = null;
        selectedEndCustomerModel = null;
        break;
      default:
    }
    isSingleData = null;
  }

  void resetOrderItem() {
    items = [];
    priceModelList = [];
    selectedQuantityList = [];
  }

  Future<void> insertItem(RecentOrderTItemModel model,
      {int? indexx, bool? isfromRecentModel}) async {
    isLoadData = true;
    notifyListeners();
    await Future.delayed(Duration.zero, () async {
      if (isfromRecentModel != null && isfromRecentModel) {
        model.kwmeng = 0.0;
        model.zfreeQty = 0.0;
      }
      items ??= [];
      var insertIndex = items!.isEmpty ? 0 : items!.length;
      var temp = <RecentOrderTItemModel>[];
      temp = [...items!];
      temp.insert(indexx ?? insertIndex, model);
      items = [...temp];
      insertPriceList(BulkOrderDetailSearchMetaPriceModel());
      insertSurchargeQuantityList(0);
      insertQuantityList(0);
      await checkPrice(indexx ?? insertIndex, isNotifier: false);
      await getAmountAvailableForOrderEntry(isNotifier: false);
    }).whenComplete(() {
      isLoadData = false;
      notifyListeners();
    }).catchError((e) {
      isLoadData = false;
      notifyListeners();
    });
  }

  void updateItem(int indexx, RecentOrderTItemModel updateModel) {
    var temp = <RecentOrderTItemModel>[];
    temp = [...items!];
    var model = RecentOrderTItemModel.fromJson(updateModel.toJson());
    temp.removeAt(indexx);
    temp.insert(indexx, model);
    items = [...temp];
    notifyListeners();
  }

  void removeItem(int indexx) {
    var temp = <RecentOrderTItemModel>[];
    temp = [...items!];
    temp.removeAt(indexx);
    items = [...temp];
    removePriceList(indexx);
    removeQuantityList(indexx);
    removeSurchargeQuantityList(indexx);
    notifyListeners();
  }

  Future<void> insertPriceList(BulkOrderDetailSearchMetaPriceModel model,
      {int? indexx, bool? isNotifier}) async {
    var insertIndex = priceModelList.isEmpty ? 0 : priceModelList.length;
    var temp = <BulkOrderDetailSearchMetaPriceModel?>[];
    temp = [...priceModelList];
    temp.insert(indexx ?? insertIndex, model);
    priceModelList = [...temp];
    if (isNotifier != null && isNotifier) {
      notifyListeners();
    }
  }

  void removePriceList(int indexx, {bool? isNotifier}) {
    priceModelList.removeAt(indexx);
    if (isNotifier != null && isNotifier) {
      notifyListeners();
    }
  }

  Future<void> updatePriceList(
      int indexx, BulkOrderDetailSearchMetaPriceModel updateModel,
      {bool? isNotifier}) async {
    var temp = <BulkOrderDetailSearchMetaPriceModel?>[];
    temp = [...priceModelList];
    var model =
        BulkOrderDetailSearchMetaPriceModel.fromJson(updateModel.toJson());
    temp.removeAt(indexx);
    temp..insert(indexx, model);
    priceModelList = [...temp];
    if (isNotifier != null && isNotifier) {
      notifyListeners();
    }
  }

  void insertQuantityList(double quantity, {int? indexx, bool? isNotifier}) {
    var insertIndex =
        selectedQuantityList.isEmpty ? 0 : selectedQuantityList.length;
    var temp = <double>[];
    temp = [...selectedQuantityList];
    temp.insert(indexx ?? insertIndex, quantity);
    selectedQuantityList = [...temp];
    if (isNotifier != null && isNotifier) {
      notifyListeners();
    }
  }

  void updateQuantityList(int indexx, double quantity) {
    var temp = <double>[];
    temp = [...selectedQuantityList];
    temp.removeAt(indexx);
    temp..insert(indexx, quantity);
    selectedQuantityList = [...temp];
  }

  void removeQuantityList(int indexx, {bool? isNotifier}) {
    selectedQuantityList.removeAt(indexx);
    if (isNotifier != null && isNotifier) {
      notifyListeners();
    }
  }

  void insertSurchargeQuantityList(double quantity,
      {int? indexx, bool? isNotifier}) {
    var insertIndex =
        selectedSurchargeList.isEmpty ? 0 : selectedSurchargeList.length;
    var temp = <double>[];
    temp = [...selectedSurchargeList];
    pr('insertIndex???!!!!!! $insertIndex');
    temp.insert(indexx ?? insertIndex, quantity);
    selectedSurchargeList = [...temp];
    if (isNotifier != null && isNotifier) {
      notifyListeners();
    }
  }

  void updateSurchargeQuantityList(int indexx, double quantity) {
    var temp = <double>[];
    temp = [...selectedSurchargeList];
    temp.removeAt(indexx);
    temp..insert(indexx, quantity);
    selectedSurchargeList = [...temp];
  }

  void removeSurchargeQuantityList(int indexx, {bool? isNotifier}) {
    selectedSurchargeList.removeAt(indexx);
    if (isNotifier != null && isNotifier) {
      notifyListeners();
    }
  }

  void setTableQuantity(int indexx, double quantity,
      {bool? isResetTotal}) async {
    var tempModel = items![indexx];
    tempModel.kwmeng = quantity;
    if (isResetTotal != null) {
      tempModel.kwmeng = 0;
      tempModel.netpr = 0;
      tempModel.mwsbp = 0;
    }
    updateItem(indexx, tempModel);
    notifyListeners();
  }

  void setTableSurchargeQuantity(int indexx, double quantity) {
    var tempModel = items![indexx];
    tempModel.zfreeQty = quantity;
    updateItem(indexx, tempModel);
    notifyListeners();
  }

  void setSalseGroup(String str) {
    selectedSalseGroup = str;
    notifyListeners();
  }

  void setIsSingleData(bool val) {
    isSingleData = val;
    notifyListeners();
  }

  void setStaffName(String? str) {
    selectedStaffName = str;
    notifyListeners();
  }

  void setChannelCode() {
    var temp = channelList
        ?.where((item) => item.contains(selectedSalseChannel ?? '내수'))
        .single;
    channelCode = temp!.substring(temp.indexOf('-') + 1);
  }

  void setSalseChannel(String str) {
    selectedSalseChannel = str;
    if (str == tr('all')) {
      channelCode = '';
    } else {
      setChannelCode();
    }
    resetData(level: 1);
    notifyListeners();
  }

  void setProductFamily(String str) {
    selectedProductFamily = str;
    resetData(level: 2);
    notifyListeners();
  }

  void setCustomerModel(dynamic map) async {
    pr(map);
    if (map != null) {
      map as Map<String, dynamic>;
      selectedProductFamily = map['product_family'] as String?;
      selectedSalsePerson = EtStaffListModel();
      selectedSalsePerson!.sname = map['staff'] as String?;
      if (map['dptnm'] != null) {
        selectedSalsePerson!.dptnm = map['dptnm'];
        searchPerson(dptnm: map['dptnm']);
      }
      selectedCustomerModel = map['model'] as EtCustomerModel?;
      if (selectedCustomerModel != null) {
        var supplierResult = await searchSupplierAndEndCustomer(true);
        var endCustomerResult = await searchSupplierAndEndCustomer(false);
        isSingleData = supplierResult.data && endCustomerResult.data;
        pr('isSingleData???? $isSingleData');
      } else {
        isSingleData = null;
      }
      notifyListeners();
    } else {
      selectedCustomerModel = null;
      isSingleData = null;
      resetOrderItem();
      notifyListeners();
    }
  }

  void setSupplier(EtCustListModel? supplier) {
    selectedSupplierModel = supplier;
    notifyListeners();
  }

  void setEndCustomer(EtCustListModel? end) {
    selectedEndCustomerModel = end;
    notifyListeners();
  }

  void setSalseOffice(String str) {
    selectedSalseOffice = str;
    notifyListeners();
  }

  void setDeliveryCondition(String str) {
    deliveryConditionInputText = str;
  }

  void setOrderDescriptionDetai(String str) {
    orderDescriptionDetailInputText = str;
  }

  void setSalsePerson(saler) {
    saler as EtStaffListModel?;
    selectedSalsePerson = saler;
    selectedStaffName = selectedSalsePerson!.sname;
    notifyListeners();
  }

  Future<ResultModel> getAmountAvailableForOrderEntry(
      {required bool isNotifier}) async {
    if (amountAvalible != null) {
      return ResultModel(true);
    }
    if (isNotifier) {
      isLoadData = true;
      notifyListeners();
    }
    _api.init(RequestType.AMOUNT_AVAILABLE_FOR_ORDER_ENTRY);
    Map<String, dynamic> _body = {
      "methodName": RequestType.AMOUNT_AVAILABLE_FOR_ORDER_ENTRY.serverMethod,
      "methodParamMap": {
        "IV_VKORG": CheckSuperAccount.isMultiAccountOrLeaderAccount()
            ? selectedSalsePerson != null
                ? selectedSalsePerson!.orghk
                : ''
            : CacheService.getEsLogin()!.vkorg,
        "IV_VTWEG": getCode(channelList!, selectedSalseChannel!),
        "IV_SPART": getCode(productFamilyDataList!, selectedProductFamily!),
        "IV_KUNNR": selectedCustomerModel!.kunnr,
        "IS_LOGIN": CacheService.getIsLogin(),
        "functionName":
            RequestType.AMOUNT_AVAILABLE_FOR_ORDER_ENTRY.serverMethod,
        "resultTables": RequestType.AMOUNT_AVAILABLE_FOR_ORDER_ENTRY.resultTable
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      if (isNotifier) {
        isLoadData = false;
        notifyListeners();
      }
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      var temp =
          BulkOrderDetailAmountResponseModel.fromJson(result.body['data']);
      var isSuccess = temp.esReturn!.mtype == 'S';
      pr(temp.toJson());
      amountAvalible = double.tryParse(
          temp.tCreditLimit!.single.amount!.replaceAll(',', ''));
      pr(amountAvalible);
      if (isNotifier) {
        isLoadData = false;
        notifyListeners();
      }
      return ResultModel(isSuccess, message: temp.esReturn!.message);
    }
    return ResultModel(false);
  }

  Future<ResultModel> checkPrice(int indexx, {required bool isNotifier}) async {
    if (isNotifier) {
      isLoadData = true;
      notifyListeners();
    }
    // 한번만 호출.
    _api.init(RequestType.CHECK_META_PRICE_AND_STOCK);
    var temp = BulkOrderDetailSearchMetaPriceModel();
    temp.matnr = items![indexx].matnr;
    temp.vrkme = items![indexx].vrkme;
    // temp.kwmeng = items![indexx].kwmeng;
    temp.kwmeng =
        selectedQuantityList.isNotEmpty ? selectedQuantityList[indexx] : 0;
    temp.zfreeQtyIn = items![indexx].zfreeQty;
    var tListBase64 = await EncodingUtils.base64Convert(temp.toJson());
    Map<String, dynamic> _body = {
      "methodName": RequestType.CHECK_META_PRICE_AND_STOCK.serverMethod,
      "methodParamMap": {
        "IV_VKORG": CheckSuperAccount.isMultiAccountOrLeaderAccount()
            ? selectedSalsePerson != null
                ? selectedSalsePerson!.orghk
                : ''
            : CacheService.getEsLogin()!.vkorg,
        "IV_VTWEG": getCode(channelList!, selectedSalseChannel!),
        "IV_SPART": getCode(productFamilyDataList!, selectedProductFamily!),
        "IV_KUNNR": selectedCustomerModel!.kunnr,
        "IV_ZZKUNNR_END": selectedCustomerModel!.kunnr,
        "IV_KWMENG": items![indexx].kwmeng,
        "IV_MATNR": items![indexx].matnr,
        "IV_PRSDT": '',
        "T_LIST": tListBase64,
        "IS_LOGIN": CacheService.getIsLogin(),
        "functionName": RequestType.CHECK_META_PRICE_AND_STOCK.serverMethod,
        "resultTables": RequestType.CHECK_META_PRICE_AND_STOCK.resultTable,
      }
    };

    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      if (isNotifier) {
        isLoadData = false;
        notifyListeners();
      }
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      var temp = BulkOrderDetailSearchMetaPriceResponseModel.fromJson(
          result.body['data']);
      var isSuccess = temp.esReturn!.mtype == 'S';
      // netpr 단가.netwr 정가.
      await updatePriceList(
          indexx,
          isSuccess
              ? temp.tList!.single
              : BulkOrderDetailSearchMetaPriceModel());
      if (isNotifier) {
        isLoadData = false;
        notifyListeners();
      }
      return ResultModel(isSuccess,
          message: !isSuccess ? temp.tList!.single.zmsg : '');
    }
    if (isNotifier) {
      isLoadData = false;
      notifyListeners();
    }
    return ResultModel(false, message: result?.errorMessage);
  }

  Future<ResultModel> checkRecentOrders() async {
    assert(selectedCustomerModel != null);
    isLoadData = true;
    notifyListeners();
    var isLogin = CacheService.getIsLogin();
    var tHead = RecentOrderHeadModel();
    var tItem = RecentOrderTItemModel();
    var tText = RecentOrderTTextModel();
    var tHeadBase64 = '';
    var tItemBase64 = '';
    var tTextBase64 = '';
    var temp = <Map<String, dynamic>>[];
    temp.addAll([tHead.toJson()]);
    tHeadBase64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([tItem.toJson()]);
    tItemBase64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([tText.toJson()]);
    tTextBase64 = await EncodingUtils.base64ConvertForListMap(temp);
    _api.init(RequestType.CHECK_RECENT_ORDER);
    Map<String, dynamic> _body = {
      "methodName": RequestType.CHECK_RECENT_ORDER.serverMethod,
      "methodParamMap": {
        "IV_KUNNR": selectedCustomerModel!.kunnr,
        "IV_KUNWE": selectedSupplierModel != null
            ? selectedSupplierModel!.kunnr
            : selectedCustomerModel!.kunnr,
        "IV_ZZKUNNR_END": selectedCustomerModel!.kunnr,
        "IV_SPART": getCode(productFamilyDataList!, selectedProductFamily!),
        "T_HEAD": tHeadBase64,
        "T_ITEM": tItemBase64,
        "T_TEXT": tTextBase64,
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.CHECK_RECENT_ORDER.resultTable,
        "functionName": RequestType.CHECK_RECENT_ORDER.serverMethod,
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      recentOrderResponseModel =
          RecentOrderResponseModel.fromJson(result.body['data']);

      isLoadData = false;
      notifyListeners();
      var orderList = recentOrderResponseModel!.tItem!;
      RecentOrderTItemModel? lastItem;
      if (orderList.length > 1) {
        pr('@!@!@!@!@!@!@!@!');
        test = RecentOrderTItemModel.fromJson(orderList.first.toJson());
      }
      var isExits = false;
      if (orderList.isNotEmpty) {
        lastItem = orderList.last;
        items?.forEach((item) {
          if (item.matnr == lastItem!.matnr) {
            isExits = true;
          }
        });
      }

      if (!isExits) {
        await insertItem(lastItem!, isfromRecentModel: true);
      }
      return ResultModel(true, data: {
        'isExits': isExits,
        'isEmpty': orderList.isEmpty,
        'model': lastItem
      });
    }
    isLoadData = false;
    notifyListeners();
    return ResultModel(false);
  }

  Future<ResultModel> searchSupplierAndEndCustomer(bool isSupplier) async {
    isLoadData = true;
    notifyListeners();
    _api.init(RequestType.SEARCH_END_OR_DELIVERY_CUSTOMER);
    final isLogin = CacheService.getIsLogin();
    final isloginModel = EncodingUtils.decodeBase64ForIsLogin(isLogin!);
    isloginModel.kunag = selectedCustomerModel!.kunnr;
    var newIslogin = await EncodingUtils.base64Convert(isloginModel.toJson());
    Map<String, dynamic> _body = {
      "methodName": RequestType.SEARCH_END_OR_DELIVERY_CUSTOMER.serverMethod,
      "methodParamMap": {
        "IV_VTWEG": "10",
        "IV_KEYWORD": "",
        "IS_LOGIN": newIslogin,
        "pos": "0",
        "IV_PARVW": isSupplier ? 'WE' : 'Z1',
        "IV_KFM2": "",
        "groupid": "",
        "functionName":
            RequestType.SEARCH_END_OR_DELIVERY_CUSTOMER.serverMethod,
        "resultTables": RequestType.SEARCH_END_OR_DELIVERY_CUSTOMER.resultTable
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      var temp = EtCustListResponseModel.fromJson(result.body['data']);
      if (isSupplier) {
        selectedSupplierModel = temp.etCustList!.first;
      } else {
        selectedEndCustomerModel = temp.etCustList!.first;
      }
      isLoadData = false;
      notifyListeners();
      return ResultModel(true, data: temp.etCustList!.length == 1);
    }
    return ResultModel(false);
  }

  Future<ResultModel> searchPerson({String? dptnm}) async {
    final isLogin = CacheService.getIsLogin();
    final esLogin = CacheService.getEsLogin();
    Map<String, dynamic>? body;
    body = {
      "methodName": RequestType.SEARCH_STAFF.serverMethod,
      "methodParamMap": {
        "IV_SALESM": '',
        "IV_SNAME": '',
        "IV_DPTNM": dptnm != null ? dptnm : esLogin!.dptnm,
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.SEARCH_STAFF.resultTable,
        "functionName": RequestType.SEARCH_STAFF.serverMethod,
      }
    };
    _api.init(RequestType.SEARCH_STAFF);
    final result = await _api.request(body: body);
    if (result == null || result.statusCode != 200) {
      return ResultModel(false);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      var temp = EtStaffListResponseModel.fromJson(result.body['data']);
      var staffList = temp.staffList!
          .where((model) => model.sname == selectedSalsePerson!.sname)
          .toList();
      selectedSalsePerson = staffList.isNotEmpty ? staffList.first : null;
      return ResultModel(true);
    }
    return ResultModel(false);
  }

  Future<List<String>?> getSalesGroup({bool? isFirstRun}) async {
    // isSuperAccount.
    var dataStr = <String>[];
    groupDataList!.forEach((data) {
      dataStr.add(data.substring(0, data.indexOf('-')));
    });
    return dataStr;
  }

  Future<List<String>?> getChannelFromDB() async {
    var dataStr = <String>[];
    channelList!.forEach((item) {
      dataStr.add(item.substring(0, item.indexOf('-')));
    });
    return dataStr;
  }

  Future<List<String>?> getProductFamilyFromDB() async {
    var dataStr = <String>[];
    productFamilyDataList?.forEach((item) {
      dataStr.add(item.substring(0, item.indexOf('-')));
    });
    return dataStr;
  }
}
