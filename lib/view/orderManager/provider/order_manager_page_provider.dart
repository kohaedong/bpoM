/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/provider/order_manager_page_provider.dart
 * Created Date: 2022-07-05 09:57:03
 * Last Modified: 2022-10-13 06:54:33
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/util/date_util.dart';
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
  List<EtCustListModel> supplierList = [];
  List<EtCustListModel> endCustList = [];
  RecentOrderResponseModel? recentOrderResponseModel;
  String? selectedSalseGroup;
  // String? selectedStaffName;
  String? selectedSalseChannel;
  String? selectedProductFamily;
  String? selectedSalseOffice;
  String? channelCode;
  String? deliveryConditionInputText;
  String? orderDescriptionDetailInputText;
  EtStaffListModel? selectedSalsePerson;
  EtCustomerModel? selectedCustomerModel;
  EtCustListModel? selectedSupplierModel;
  EtCustListModel? selectedEndCustomerModel;
  List<String>? groupDataList;
  List<String>? productFamilyDataList;
  List<String>? channelList;
  List<RecentOrderTItemModel>? items;
  bool isLoadData = false;
  bool isModified = false;
  double? amountAvalible;
  final _api = ApiService();

  bool get isModifiyByNewCase => isModified;

  double get totalPrice => items != null && items!.isNotEmpty
      ? items!
          .reduce((left, right) => RecentOrderTItemModel(
              netwr: (left.netwr ?? 0) + (right.netwr ?? 0)))
          .netwr!
      : 0;
  bool get isValidate =>
      selectedCustomerModel != null &&
      selectedEndCustomerModel != null &&
      selectedProductFamily != null &&
      selectedSalseChannel != null &&
      items != null &&
      items!.isNotEmpty &&
      items!.where((item) => item.kwmeng != 0.0).toList().length ==
          items!.length &&
      priceModelList
              .where((price) => price != null && price.netwr != 0.0)
              .toList()
              .length ==
          priceModelList.length;

  Map<String, dynamic>? get commonBodyMap => {
        "IV_VKORG": CheckSuperAccount.isMultiAccount()
            ? selectedSalsePerson != null
                ? selectedSalsePerson!.orghk
                : CacheService.getEsLogin()!.vkorg
            : CacheService.getEsLogin()!.vkorg,
        "IV_VTWEG": selectedSalseChannel != tr('all')
            ? getCode(channelList!, selectedSalseChannel!)
            : '10', // default 10
        "IV_SPART": getCode(productFamilyDataList!, selectedProductFamily!),
        "IV_KUNNR": selectedCustomerModel!.kunnr,
        "IV_ZZKUNNR_END": selectedCustomerModel!.kunnr,
      };

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
    var temp = channelList!.where((str) => str.contains('내수')).single;
    selectedSalseChannel = temp.substring(0, temp.indexOf('-'));
    channelCode = temp.substring(temp.indexOf('-') + 1);

    return ResultModel(true);
  }

  void resetData({required int? level}) {
    switch (level) {
      case 0:
        selectedSalsePerson = null;
        selectedSalseChannel = null;
        selectedCustomerModel = null;
        selectedEndCustomerModel = null;
        selectedProductFamily = null;
        resetOrderItem();
        break;
      case 1:
        selectedCustomerModel = null;
        selectedEndCustomerModel = null;
        selectedProductFamily = null;
        resetOrderItem();
        break;
      case 2:
        selectedCustomerModel = null;
        selectedEndCustomerModel = null;
        resetOrderItem();
        break;
      default:
    }
  }

  void resetOrderItem() {
    items = [];
    priceModelList = [];
    selectedQuantityList = [];
    selectedSurchargeList = [];
  }

  Future<void> insertItem(RecentOrderTItemModel model,
      {int? indexx,
      bool? isfromRecentModel,
      BulkOrderDetailSearchMetaPriceModel? priceModel}) async {
    isLoadData = true;
    notifyListeners();
    await Future.delayed(Duration.zero, () async {
      if (isfromRecentModel != null && isfromRecentModel) {
        model.kwmeng = 0.0;
        model.zfreeQty = 0.0;
      }
      items ??= [];
      var insertIndex = (isfromRecentModel != null && isfromRecentModel)
          ? 0
          : items!.isEmpty
              ? 0
              : items!.length;
      var temp = <RecentOrderTItemModel>[];
      temp = [...items!];
      temp.insert(indexx ?? insertIndex, model);
      items = [...temp];
      insertPriceList(priceModel ?? BulkOrderDetailSearchMetaPriceModel(),
          indexx ?? insertIndex);
      insertSurchargeQuantityList(model.zfreeQty!, indexx ?? insertIndex);
      insertQuantityList(model.kwmeng!, indexx ?? insertIndex);
      if (priceModel == null) {
        await checkPrice(indexx ?? insertIndex, isNotifier: false);
      }
      await getAmountAvailableForOrderEntry(isNotifier: false);
    }).whenComplete(() {
      isLoadData = false;
      notifyListeners();
    }).catchError((e) {
      isLoadData = false;
      notifyListeners();
    });
  }

  void updateItem(int indexx, RecentOrderTItemModel updateModel,
      {bool? isNotifier}) {
    var temp = <RecentOrderTItemModel>[];
    temp = [...items!];
    var model = RecentOrderTItemModel.fromJson(updateModel.toJson());
    temp.removeAt(indexx);
    temp.insert(indexx, model);
    items = [...temp];
    if (isNotifier != null && isNotifier) {
      notifyListeners();
    }
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

  Future<void> insertPriceList(
      BulkOrderDetailSearchMetaPriceModel model, int indexx,
      {bool? isNotifier}) async {
    var temp = <BulkOrderDetailSearchMetaPriceModel?>[];
    temp = [...priceModelList];
    temp.insert(indexx, model);
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

  void insertQuantityList(double quantity, int indexx, {bool? isNotifier}) {
    var temp = <double>[];
    temp = [...selectedQuantityList];
    temp.insert(indexx, quantity);
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
    notifyListeners();
  }

  void removeQuantityList(int indexx, {bool? isNotifier}) {
    selectedQuantityList.removeAt(indexx);
    if (isNotifier != null && isNotifier) {
      notifyListeners();
    }
  }

  void insertSurchargeQuantityList(double quantity, int indexx,
      {bool? isNotifier}) {
    var temp = <double>[];
    temp = [...selectedSurchargeList];
    temp.insert(indexx, quantity);
    selectedSurchargeList = [...temp];
    if (isNotifier != null && isNotifier) {
      notifyListeners();
    }
  }

  void updateSurchargeQuantityList(int indexx, double surchargee,
      {bool? isNotifier}) {
    var temp = <double>[];
    temp = [...selectedSurchargeList];
    temp.removeAt(indexx);
    temp..insert(indexx, surchargee);
    selectedSurchargeList = [...temp];
    pr(selectedSurchargeList);
    if (isNotifier != null && isNotifier) {
      notifyListeners();
    }
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
    pr('4444:${tempModel.zfreeQty}');
    updateItem(indexx, tempModel);
    notifyListeners();
  }

  void setSalseGroup(String str) {
    selectedSalseGroup = str;
    resetData(level: 0);
    notifyListeners();
  }

  // void setIsSingleData(bool val) {
  //   isSingleData = val;
  //   notifyListeners();
  // }

  // void setStaffName(String? str) {
  //   selectedStaffName = str;
  //   resetData(level: 0);
  //   notifyListeners();
  // }

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

  void resetSupplierAndEndCustData() {
    selectedSupplierModel = null;
    selectedEndCustomerModel = null;
    supplierList = [];
    endCustList = [];
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
        await searchSupplierAndEndCustomer(true);
        await searchSupplierAndEndCustomer(false);
        pr('${selectedEndCustomerModel?.toJson()}');
        pr('${selectedSupplierModel?.toJson()}');
        endCustList.forEach((element) {
          pr('end ${element.toJson()}');
        });
        supplierList.forEach((element) {
          pr('supp ${element.toJson()}');
        });
      }
      resetOrderItem();
      notifyListeners();
    } else {
      resetSupplierAndEndCustData();
      resetData(level: 2);
    }
    notifyListeners();
  }

  void setSupplier(String? str) {
    if (str != null) {
      var temp = str.substring(str.indexOf('/') + 1);
      selectedSupplierModel = supplierList
                  .where((supplier) => supplier.kunnr == temp)
                  .length >
              1
          ? supplierList
              .where((supplier) => supplier.kunnr == temp)
              .toList()
              .where((model) => model.defpa != null && model.defpa!.isNotEmpty)
              .single
          : supplierList.where((supplier) => supplier.kunnr == temp).single;
    } else {
      selectedSupplierModel = null;
    }
    notifyListeners();
  }

  void setEndCust(String? str) {
    if (str != null) {
      var temp = str.substring(str.indexOf('/') + 1);
      selectedEndCustomerModel = endCustList
                  .where((endCust) => endCust.kunnr == temp)
                  .length >
              1
          ? endCustList
              .where((endCust) => endCust.kunnr == temp)
              .toList()
              .where((model) => model.defpa != null && model.defpa!.isNotEmpty)
              .single
          : endCustList.where((endCust) => endCust.kunnr == temp).single;
    } else {
      selectedSupplierModel = null;
    }
    notifyListeners();
  }

  void setSalseOffice(String str) {
    selectedSalseOffice = str;
    notifyListeners();
  }

  void setDeliveryCondition(String str) {
    if (str.isNotEmpty) {
      isModified = true;
    }
    deliveryConditionInputText = str;
  }

  void setOrderDescriptionDetai(String str) {
    if (str.isNotEmpty) {
      isModified = true;
    }
    orderDescriptionDetailInputText = str;
  }

  void setSalsePerson(saler) {
    saler as EtStaffListModel?;
    selectedSalsePerson = saler;
    // selectedStaffName = selectedSalsePerson!.sname;
    notifyListeners();
  }

  Future<ResultModel> getAmountAvailableForOrderEntry(
      {required bool isNotifier}) async {
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

  Future<List<String>> getsupplierList() async {
    var temp = <String>[];
    supplierList.forEach((supplier) {
      temp.add('${supplier.kunnrNm!}/${supplier.kunnr!}');
    });
    return temp;
  }

  Future<List<String>> getEndCustList() async {
    var temp = <String>[];
    endCustList.forEach((end) {
      temp.add('${end.kunnrNm!}/${end.kunnr!}');
    });
    return temp;
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
    temp.kwmeng =
        selectedQuantityList.isNotEmpty ? selectedQuantityList[indexx] : 0;
    temp.zfreeQtyIn = items![indexx].zfreeQty;
    var tListBase64 = await EncodingUtils.base64Convert(temp.toJson());
    Map<String, dynamic> _body = {
      "methodName": RequestType.CHECK_META_PRICE_AND_STOCK.serverMethod,
      "methodParamMap": {
        "IV_KWMENG": items![indexx].kwmeng,
        "IV_MATNR": items![indexx].matnr,
        "IV_PRSDT": '',
        "T_LIST": tListBase64,
        "IS_LOGIN": CacheService.getIsLogin(),
        "functionName": RequestType.CHECK_META_PRICE_AND_STOCK.serverMethod,
        "resultTables": RequestType.CHECK_META_PRICE_AND_STOCK.resultTable,
      }
    };
    _body['methodParamMap'].addAll(commonBodyMap);

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
      var message = '';
      if (isSuccess) {
        var model = temp.tList!.single;
        pr(temp.toJson());
        await getAmountAvailableForOrderEntry(isNotifier: false)
            .then((_) async {
          var sum = totalPrice + model.netwr!;
          if (amountAvalible! > sum) {
            await updatePriceList(indexx,
                isSuccess ? model : BulkOrderDetailSearchMetaPriceModel());
          } else {
            isSuccess = false;
            message = tr('insufficient_balance');
          }
        });
      } else {
        message = '${temp.esReturn!.message!.replaceAll('  ', '')}';
      }
      if (isNotifier) {
        isLoadData = false;
        notifyListeners();
      }
      return ResultModel(isSuccess, message: !isSuccess ? message : '');
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
        "IV_ZZKUNNR_END": selectedEndCustomerModel!.kunnr,
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
      pr(recentOrderResponseModel?.toJson());
      var isExits = false;
      var isEmpty = true;
      var createModel = (RecentOrderTItemModel model) {
        model.zreqNo = '';
        model.zreqpo = '';
        model.vbeln = '';
        model.posnr = '';
        model.erdat = '';
        model.erzet = '';
        model.ernam = '';
        model.erwid = '';
        model.aedat = '';
        model.aezet = '';
        model.aenam = '';
        model.aewid = '';
        model.zstatus = '';
        model.umode = '';
        return model;
      };
      RecentOrderTItemModel? lastModel;
      if (recentOrderResponseModel!.esReturn!.mtype == 'S') {
        isEmpty = recentOrderResponseModel!.tItem!.isEmpty;
        if (!isEmpty) {
          lastModel = recentOrderResponseModel!.tItem!.last;
          if (items != null && items!.isNotEmpty) {
            isExits = items!
                .where((item) => item.matnr == lastModel!.matnr)
                .toList()
                .isNotEmpty;
            if (!isExits) {
              await insertItem(createModel(lastModel), isfromRecentModel: true);
            }
          } else {
            await insertItem(createModel(lastModel), isfromRecentModel: true);
          }
        }
      }
      isLoadData = false;
      notifyListeners();
      return ResultModel(true,
          data: {'isExits': isExits, 'isEmpty': isEmpty, 'model': lastModel});
    }
    isLoadData = false;
    notifyListeners();
    return ResultModel(false);
  }

  Future<ResultModel> searchSupplierAndEndCustomer(bool isSupplier) async {
    _api.init(RequestType.SEARCH_END_OR_DELIVERY_CUSTOMER);
    final isLogin = CacheService.getIsLogin();
    final isloginModel = EncodingUtils.decodeBase64ForIsLogin(isLogin!);
    isloginModel.kunag = selectedCustomerModel!.kunnr;
    var newIslogin = await EncodingUtils.base64Convert(isloginModel.toJson());
    Map<String, dynamic> _body = {
      "methodName": RequestType.SEARCH_END_OR_DELIVERY_CUSTOMER.serverMethod,
      "methodParamMap": {
        "IV_VTWEG": selectedSalseChannel != tr('all')
            ? getCode(channelList!, selectedSalseChannel!)
            : '10',
        "IV_KEYWORD": "",
        "IS_LOGIN": newIslogin,
        "pos": "-1",
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
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      var temp = EtCustListResponseModel.fromJson(result.body['data']);
      temp.etCustList?.forEach((element) {
        pr('isSup: $isSupplier ${element.toJson()} ');
      });
      if (temp.esReturn!.mtype == 'S') {
        if (temp.etCustList!.isNotEmpty) {
          var list = temp.etCustList!;
          if (isSupplier) {
            supplierList = [];
            selectedSupplierModel = null;
            if (list.length == 1) {
              selectedSupplierModel = list.single;
              supplierList.add(list.single);
            } else {
              var moreEntityKunnrList = <String>[];

              list.asMap().entries.forEach((map) {
                var isMoreEntity = list
                        .where((element) => element.kunnr == map.value.kunnr)
                        .length >
                    1;
                if (isMoreEntity) {
                  moreEntityKunnrList.add(map.value.kunnr!);
                } else {
                  supplierList.add(map.value);
                }
              });
              moreEntityKunnrList.toSet().forEach((kunnr) {
                var model = list
                    .where((model) =>
                        model.kunnr == kunnr && model.defpa!.isNotEmpty)
                    .single;
                supplierList.add(model);
              });
              if (supplierList.length == 1) {
                selectedSupplierModel = supplierList.single;
              } else {
                selectedSupplierModel = null;
              }
              pr('aiai$supplierList');
              return ResultModel(true);
            }
          } else {
            endCustList = [];
            selectedEndCustomerModel = null;
            if (list.length == 1) {
              selectedEndCustomerModel = list.single;
              endCustList.add(list.single);
            } else {
              var moreEntityKunnrList = <String>[];
              list.asMap().entries.forEach((map) {
                var isMoreEntity = list
                        .where((element) => element.kunnr == map.value.kunnr)
                        .length >
                    1;
                if (isMoreEntity) {
                  moreEntityKunnrList.add(map.value.kunnr!);
                } else {
                  endCustList.add(map.value);
                }
              });
              moreEntityKunnrList.toSet().forEach((kunnr) {
                var model = list
                    .where((model) =>
                        model.kunnr == kunnr && model.defpa!.isNotEmpty)
                    .single;
                endCustList.add(model);
              });
              if (endCustList.length == 1) {
                selectedEndCustomerModel = endCustList.single;
              } else {
                selectedEndCustomerModel = null;
              }
              return ResultModel(true);
            }
          }
        } else {
          pr('reset??');
          resetSupplierAndEndCustData();
        }
      }
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
      pr(result.body);
      var temp = EtStaffListResponseModel.fromJson(result.body['data']);
      var staffList = <EtStaffListModel>[];
      if (CheckSuperAccount.isMultiAccountOrLeaderAccount()) {
        staffList = temp.staffList!
            .where((model) =>
                model.sname == selectedSalsePerson!.sname &&
                model.logid == selectedSalsePerson!.logid)
            .toList();
      } else {
        staffList = temp.staffList!
            .where((model) =>
                model.sname == esLogin!.ename && model.logid == esLogin.logid)
            .toList();
      }
      selectedSalsePerson = staffList.isNotEmpty ? staffList.first : null;
      return ResultModel(true);
    }
    return ResultModel(false);
  }

  Future<ResultModel> onSubmmit() async {
    isLoadData = true;
    notifyListeners();
    var temp = <Map<String, dynamic>>[];
    var headBase64 = '';
    var itemBase64 = '';
    var textBase64 = '';
    var head = RecentOrderHeadModel();
    var esLogin = CacheService.getEsLogin();
    if (!CheckSuperAccount.isMultiAccountOrLeaderAccount()) {
      await searchPerson();
    }
    var getGroupName = () {
      var data = groupDataList!
          .where((group) => selectedSalsePerson != null
              ? group.contains(selectedSalsePerson!.vkgrp!)
              : group.contains(esLogin!.vkgrp!))
          .single;
      return data.substring(0, data.indexOf('-'));
    };
    if (selectedSalsePerson != null) {
      pr(selectedSalsePerson!.toJson());
      head.dptcd = selectedSalsePerson!.dptcd;
      head.orghk = selectedSalsePerson!.orghk;
      head.vkorg = selectedSalsePerson!.vkorg;
      head.vkgrp = selectedSalsePerson!.vkgrp;
      head.empno = selectedSalsePerson!.empno;
      head.pernr = selectedSalsePerson!.pernr;
      head.vkgrpNm = getGroupName();
    }

    head.zreqDate = DateUtil.getDateStr(DateTime.now().toIso8601String());
    head.vtweg = getCode(channelList!, selectedSalseChannel!);
    head.spart = getCode(productFamilyDataList!, selectedProductFamily!);

    head.kunnr = selectedCustomerModel!.kunnr;
    head.kunnrNm = selectedCustomerModel!.kunnrNm;
    head.kunwe = selectedSupplierModel!.kunnr;
    head.kunweNm = selectedSupplierModel!.kunnrNm;
    head.zzkunnrEnd = selectedEndCustomerModel!.kunnr;
    head.zzkunnrEndNm = selectedEndCustomerModel!.kunnrNm;
    head.xconf = 'X';
    head.umode = 'I';
    head.bukrs = esLogin!.bukrs;

    head.erdat = DateUtil.getDateStr(DateTime.now().toIso8601String());
    head.erzet = DateUtil.getTimeNow(isNotWithColon: true);
    head.ernam = selectedSalsePerson!.sname;
    head.erwid = selectedSalsePerson!.logid;
    head.sanum = selectedSalsePerson!.sname;
    head.slnum = selectedSalsePerson!.sname;
    temp.addAll([head.toJson()]);
    headBase64 = await EncodingUtils.base64ConvertForListMap(temp);

    var createItemModel = (int indexx, RecentOrderTItemModel item) async {
      item = RecentOrderTItemModel.fromJson(priceModelList[indexx]!.toJson());
      item.kwmeng = selectedQuantityList[indexx];
      item.zfreeQty = selectedSurchargeList[indexx];
      item.erdat = DateUtil.getDateStr(DateTime.now().toIso8601String());
      item.erzet = DateUtil.getTimeNow(isNotWithColon: true);
      item.ernam = selectedSalsePerson!.sname;
      item.erwid = selectedSalsePerson!.logid;
      item.zmsg = '';
      item.umode = 'I';
      return item;
    };

    temp.clear();
    await Future.forEach(items!.asMap().entries, (map) async {
      map as MapEntry<int, RecentOrderTItemModel>;
      var model = await createItemModel(map.key, map.value);
      temp.add(model.toJson());
    });
    itemBase64 = await EncodingUtils.base64ConvertForListMap(temp);

    temp.clear();
    if (deliveryConditionInputText != null &&
        deliveryConditionInputText!.isNotEmpty) {
      var textModel = RecentOrderTTextModel();
      textModel.cdgrp = 'TEXTID';
      textModel.cditm = 'Z003';
      textModel.seqno = '001';
      textModel.umode = 'U';
      textModel.ztext = deliveryConditionInputText;
      temp.add(textModel.toJson());
    }
    if (orderDescriptionDetailInputText != null &&
        orderDescriptionDetailInputText!.isNotEmpty) {
      var textModel = RecentOrderTTextModel();
      textModel.cdgrp = 'TEXTID';
      textModel.cditm = 'Z004';
      textModel.seqno = '001';
      textModel.umode = 'U';
      textModel.ztext = orderDescriptionDetailInputText;
      temp.add(textModel.toJson());
    }
    if (temp.isNotEmpty) {
      textBase64 = await EncodingUtils.base64ConvertForListMap(temp);
    }
    _api.init(RequestType.CREATE_ORDER);
    Map<String, dynamic> _body = {
      "methodName": RequestType.CREATE_ORDER.serverMethod,
      "methodParamMap": {
        "IV_PTYPE": "C",
        "IS_LOGIN": CacheService.getIsLogin(),
        "resultTables": RequestType.CREATE_ORDER.resultTable,
        "T_HEAD": headBase64,
        "T_ITEM": itemBase64,
        "T_TEXT": textBase64,
        "IV_ZREQNO": "",
        "functionName": RequestType.CREATE_ORDER.serverMethod
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(true);
    }
    isLoadData = false;
    try {
      notifyListeners();
    } catch (e) {}
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
