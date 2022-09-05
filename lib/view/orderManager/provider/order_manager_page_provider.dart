/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/provider/order_manager_page_provider.dart
 * Created Date: 2022-07-05 09:57:03
 * Last Modified: 2022-09-05 15:30:29
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/et_cust_list_model.dart';
import 'package:medsalesportal/model/rfc/et_cust_list_response_model.dart';
import 'package:medsalesportal/model/rfc/et_customer_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_response_model.dart';
import 'package:medsalesportal/model/rfc/recent_order_head_model.dart';
import 'package:medsalesportal/model/rfc/recent_order_response_model.dart';
import 'package:medsalesportal/model/rfc/recent_order_t_item_model.dart';
import 'package:medsalesportal/model/rfc/recent_order_t_text_model.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/util/is_super_account.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class OrderManagerPageProvider extends ChangeNotifier {
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
  final _api = ApiService();

  String getCode(List<String> list, String val) {
    if (val != tr('all')) {
      var data = list.where((item) => item.contains(val)).single;
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

  void insertItem(RecentOrderTItemModel model,
      {int? indexx, bool? isfromRecentModel}) {
    if (isfromRecentModel != null && isfromRecentModel) {
      model.kwmeng = 0.0;
      model.zfreeQty = 0.0;
      model.isFromRecentOrder = true;
    }
    items ??= [];
    var insertIndex = items!.isEmpty ? 0 : items!.length;
    var temp = <RecentOrderTItemModel>[];

    temp = [...items!];
    temp.insert(indexx ?? insertIndex, model);
    items = [...temp];
    notifyListeners();
  }

  void updateItem(int indexx, {RecentOrderTItemModel? updateModel}) {
    var temp = <RecentOrderTItemModel>[];
    temp = [...items!];
    var model = RecentOrderTItemModel();
    if (updateModel == null) {
      model = RecentOrderTItemModel.fromJson(temp[indexx].toJson());
    } else {
      model = RecentOrderTItemModel.fromJson(updateModel.toJson());
    }
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
    notifyListeners();
  }

  void setOrderQuantity(int indexx, double quantity) {
    var tempModel = items![indexx];
    pr('----- ${tempModel.kwmeng}');
    tempModel.kwmeng = quantity;
    pr('+++++ ${tempModel.kwmeng}');
    updateItem(indexx, updateModel: tempModel);
  }

  void setSurchargeQuantity(int indexx, double quantity) {
    var tempModel = items![indexx];
    pr('----- ${tempModel.zfreeQty}');
    tempModel.zfreeQty = quantity;
    pr('+++++ ${tempModel.zfreeQty}');
    updateItem(indexx, updateModel: tempModel);
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

  bool checkIsFromRecentOrders() {
    if (items == null || items!.isEmpty) {
      return false;
    } else {
      return items!
              .where((item) =>
                  item.isFromRecentOrder != null && item.isFromRecentOrder!)
              .length >
          0;
    }
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
      pr(recentOrderResponseModel?.toJson());
      isLoadData = false;
      notifyListeners();
      var orderList = recentOrderResponseModel!.tItem!;
      var isExitsRecentOrder = orderList.isNotEmpty;

      if (isExitsRecentOrder) {
        pr(orderList.length);
        pr('first data ${orderList.first.aedat}');
        pr('last data ${orderList.last.aedat}');
        pr('json ${orderList.last.toJson()}');
        insertItem(orderList.first, isfromRecentModel: true);
      }
      return ResultModel(true, data: isExitsRecentOrder);
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
        "IV_SALESM": "",
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
