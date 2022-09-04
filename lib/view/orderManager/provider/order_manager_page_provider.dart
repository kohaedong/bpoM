/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/provider/order_manager_page_provider.dart
 * Created Date: 2022-07-05 09:57:03
 * Last Modified: 2022-09-04 15:25:17
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/et_cust_list_model.dart';
import 'package:medsalesportal/model/rfc/et_cust_list_response_model.dart';
import 'package:medsalesportal/model/rfc/et_customer_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_response_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/util/is_super_account.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class OrderManagerPageProvider extends ChangeNotifier {
  String? selectedSalseGroup;
  String? selectedStaffName;
  String? selectedSalseChannel;
  String? selectedProductFamily;
  String? selectedSalseOffice;
  String? deliveryConditionInputText;
  String? orderDescriptionDetailInputText;
  EtStaffListModel? selectedSalsePerson;
  EtCustomerModel? selectedCustomerModel;
  EtCustListModel? selectedSupplierModel;
  EtCustListModel? selectedEndCustomerModel;
  List<String>? groupDataList;
  List<String>? productFamilyDataList;
  bool? isSingleData;
  bool isLoadData = false;
  final _api = ApiService();
  final channelList = ['내수-10', '수출-20', 'Local-30'];

  Future<ResultModel> initData() async {
    if (!CheckSuperAccount.isMultiAccountOrLeaderAccount()) {
      var temp = channelList.where((str) => str.contains('내수')).single;
      selectedSalseChannel = temp.substring(0, temp.indexOf('-'));
    } else {
      selectedSalseChannel = tr('all');
    }
    groupDataList = await HiveService.getSalesGroup();
    productFamilyDataList = await HiveService.getProductFamily();
    return ResultModel(true);
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

  void setSalseChannel(String str) {
    selectedSalseChannel = str;
    notifyListeners();
  }

  void setProductFamily(String str) {
    selectedProductFamily = str;
    notifyListeners();
  }

  void setCustomerModel(dynamic map) async {
    if (map != null) {
      map as Map<String, dynamic>;
      selectedProductFamily = map['product_family'] as String?;
      selectedSalsePerson = EtStaffListModel();
      selectedSalsePerson!.sname = map['staff'] as String?;
      if (map['dptnm'] != null) {
        selectedSalsePerson!.dptnm = map['dptnm'];
        searchPerson(dptnm: map['dptnm']);
      }
      var model = map['model'] as EtCustomerModel?;
      selectedCustomerModel = model;
      var supplierResult = await searchSupplierAndEndCustomer(true);
      var endCustomerResult = await searchSupplierAndEndCustomer(false);
      isSingleData = supplierResult.data && endCustomerResult.data;
      pr('isSingleData???? $isSingleData');
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
    channelList.forEach((item) {
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
