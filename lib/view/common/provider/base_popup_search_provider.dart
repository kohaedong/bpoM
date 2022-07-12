/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/provider/base_popup_search_provider.dart
 * Created Date: 2021-09-11 17:15:06
 * Last Modified: 2022-07-12 09:14:28
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/enums/hive_box_type.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/util/hive_select_data_util.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/model/commonCode/is_login_model.dart';
import 'package:medsalesportal/model/rfc/et_kunnr_response_model.dart';
import 'package:medsalesportal/model/rfc/et_customer_response_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_response_model.dart';

class BasePopupSearchProvider extends ChangeNotifier {
  bool isLoadData = false;
  bool isFirestRun = true;
  String? personInputText;
  String? customerInputText;
  String? selectedProductCategory;
  String? selectedProductFamily;
  String? selectedBusinessGroup;
  List<String>? productCategoryDataList;
  List<String>? productBusinessDataList;
  List<String>? productFamilyDataList;
  IsLoginModel? isLoginModel;

  EtStaffListModel? selectedSalesPerson;
  EtStaffListResponseModel? staList;
  EtKunnrResponseModel? etKunnrResponseModel;
  EtCustomerResponseModel? etCustomerResponseModel;
  OneCellType? type;
  Map<String, dynamic>? bodyMap;

  bool isTeamLeader = false;
  String? staffName;
//--------------- plant Code----------
  String? selectedOrganizationCode;
  String? seletedCirculationCode;
  bool get isOneRowValue2Selected => personInputText != null;

//------ pageing ----------
  int pos = 0;
  int partial = 30;
  bool hasMore = true;
  Future<void> refresh() async {
    pos = 0;
    etKunnrResponseModel = null;
    etCustomerResponseModel = null;
    staList = null;
    hasMore = true;
    onSearch(type!, true);
  }

  Future<bool?> nextPage() async {
    if (hasMore) {
      pos = partial + pos;
      return onSearch(type!, false).then((result) => result.isSuccessful);
    }
    return null;
  }

  Future<void> initData() async {
    if (isFirestRun && bodyMap != null) {
      staffName = bodyMap?['staff'];
      selectedProductFamily = bodyMap?['product_family'];
    }
  }

  void setPersonInputText(String? value) {
    this.personInputText = value;
    if (value == null || (value.length == 1) || value == '') {
      notifyListeners();
    }
  }

  void setSalesPerson(dynamic str) {
    str as EtStaffListModel;
    selectedSalesPerson = str;
    staffName = selectedSalesPerson!.sname;
    notifyListeners();
  }

  void setStaffName(String? str) {
    staffName = str;
    notifyListeners();
  }

  void setProductsCategory(String? value) {
    selectedProductCategory = value;
    notifyListeners();
  }

  void setProductsFamily(String? value) {
    selectedProductFamily = value;
    notifyListeners();
  }

  void setBusinessGroup(String? value) {
    selectedBusinessGroup = value;
    notifyListeners();
  }

  void setCustomerInputText(String? value) {
    this.customerInputText = value;
    if (value == null || (value.length == 1) || value == '') {
      notifyListeners();
    }
  }

  Future<List<String>?> getProductCategory() async {
    productCategoryDataList = await HiveService.getBusinessCategory();
    var dataStr = <String>[];
    productCategoryDataList!.forEach((data) {
      dataStr.add(data.substring(0, data.indexOf('-')));
    });
    return dataStr;
  }

  Future<List<String>?> getBusinessGroup() async {
    productBusinessDataList = await HiveService.getBusinessGroup();
    var dataStr = <String>[];
    productBusinessDataList!.forEach((data) {
      dataStr.add(data.substring(0, data.indexOf('-')));
    });
    return dataStr;
  }

  Future<List<String>?> getProductFamily() async {
    productFamilyDataList = await HiveService.getProductFamily();
    var dataStr = <String>[];
    productFamilyDataList!.forEach((data) {
      dataStr.add(data.substring(0, data.indexOf('-')));
    });
    return dataStr;
  }

  Future<List<String>?> getOrganizationFromDB() async {
    final resultList = await HiveSelectDataUtil.select(
      HiveBoxType.T_VALUE,
      searchLevel: 0,
      tvalueConditional: (tValue) {
        return tValue.tname == 'H_TVKO';
      },
    );
    return resultList.strList;
  }

  Future<List<String>?> getCirculationFromDB() async {
    final resultList = await HiveSelectDataUtil.select(HiveBoxType.T_VALUE,
        tvalueConditional: (tValue) {
      return tValue.tname == 'H_TVKOV' && tValue.helpValues!.isNotEmpty;
    }, searchLevel: 2, group1SearchKey: selectedOrganizationCode);

    return resultList.strList;
  }

  Future<BasePoupSearchResult> searchPerson(
    bool isMounted,
  ) async {
    isLoadData = true;
    if (isMounted) {
      notifyListeners();
    }
    var _api = ApiService();
    final isLogin = CacheService.getIsLogin();
    final esLogin = CacheService.getEsLogin();
    Map<String, dynamic>? body;
    body = {
      "methodName": RequestType.SEARCH_STAFF.serverMethod,
      "methodParamMap": {
        "IV_SALESM": "",
        "IV_SNAME": personInputText ?? '',
        "IV_DPTNM": esLogin!.dptnm,
        "IS_LOGIN": isLogin,
        "pos": "$pos",
        "partial": "$partial",
        "resultTables": RequestType.SEARCH_STAFF.resultTable,
        "functionName": RequestType.SEARCH_STAFF.serverMethod,
      }
    };
    _api.init(RequestType.SEARCH_STAFF);
    final result = await _api.request(body: body);
    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      staList = null;
      notifyListeners();
      return BasePoupSearchResult(false);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      var temp = EtStaffListResponseModel.fromJson(result.body['data']);
      if (temp.staffList!.length != partial) {
        hasMore = false;
      }
      if (staList == null) {
        staList = temp;
      } else {
        staList!.staffList!.addAll(temp.staffList!);
      }
      if (staList != null && staList!.staffList == null) {
        staList = null;
      }

      isLoadData = false;
      notifyListeners();
      return BasePoupSearchResult(true);
    }
    isLoadData = false;
    return BasePoupSearchResult(false);
  }

  Future<BasePoupSearchResult> searchCustomer(bool isMounted) async {
    if (isFirestRun) {
      isFirestRun = false;
      return BasePoupSearchResult(false);
    }
    isLoadData = true;
    if (isMounted) {
      notifyListeners();
    }
    var _api = ApiService();
    final isLogin = CacheService.getIsLogin();
    final esLogin = CacheService.getEsLogin();
    Map<String, dynamic>? body;
    var zbiz = '';
    var spart = '';
    if (selectedProductCategory != null) {
      var temp = productCategoryDataList!
          .where((data) => data.contains(selectedProductCategory!))
          .toList();
      zbiz = temp.isEmpty ? '' : temp.first.substring(temp.indexOf('-') + 1);
    }
    if (selectedProductFamily != null) {
      var temp = productFamilyDataList!
          .where((data) => data.contains(selectedProductFamily!))
          .toList();
      spart = temp.isEmpty ? '' : temp.first.substring(temp.indexOf('-') + 1);
    }

    body = {
      "methodName": RequestType.SEARCH_CUSTOMER.serverMethod,
      "methodParamMap": {
        "IV_DORMA": "X",
        "IV_ZKIND": "",
        "IV_SALES": "X",
        "IV_ZLOEVM": "A",
        "IV_ZCLASS": "",
        "IV_VKGRP": "",
        "IV_POSSIB": "X",
        "IV_ZADD_NAME1": "",
        "IV_ZIMPORT": "",
        "IV_ZTREAT3": "",
        "IV_HIDDEN": "",
        "IV_CLOSE": "",
        "IV_SPART": spart,
        "IV_ZBIZ": zbiz,
        "IV_SANUM": esLogin!.logid,
        "IV_NAME": customerInputText ?? '',
        "IV_ORGHK": esLogin.orghk,
        "IS_LOGIN": "$isLogin",
        "pos": "$pos",
        "partial": "$partial",
        "functionName": RequestType.SEARCH_CUSTOMER.serverMethod,
        "resultTables": RequestType.SEARCH_CUSTOMER.resultTable
      }
    };
    _api.init(RequestType.SEARCH_CUSTOMER);
    final result = await _api.request(body: body);
    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      staList = null;
      notifyListeners();
      return BasePoupSearchResult(false);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      var temp = EtKunnrResponseModel.fromJson(result.body['data']);
      if (temp.etKunnr!.length != partial) {
        hasMore = false;
      }
      if (etKunnrResponseModel == null) {
        etKunnrResponseModel = temp;
      } else {
        etKunnrResponseModel!.etKunnr!.addAll(temp.etKunnr!);
      }
      if (etKunnrResponseModel != null &&
          etKunnrResponseModel!.etKunnr == null) {
        etKunnrResponseModel = null;
      }
      isLoadData = false;
      notifyListeners();
      return BasePoupSearchResult(true);
    }
    isLoadData = false;
    return BasePoupSearchResult(false);
  }

  Future<BasePoupSearchResult> searchSaller(bool isMounted) async {
    if (isFirestRun) {
      isFirestRun = false;
      return BasePoupSearchResult(false);
    }
    isLoadData = true;
    if (isMounted) {
      notifyListeners();
    }
    var _api = ApiService();
    final isLogin = CacheService.getIsLogin();
    final esLogin = CacheService.getEsLogin();

    Map<String, dynamic>? _body;
    var spart = productFamilyDataList
        ?.where((str) => str.contains(selectedProductFamily!))
        .toList();
    var vkgrp = productBusinessDataList
        ?.where((str) => str.contains(selectedBusinessGroup!))
        .toList();
    _body = {
      "methodName": RequestType.SEARCH_SALLER.serverMethod,
      "methodParamMap": {
        "IV_VTWEG": "10",
        "IV_VKORG": esLogin!.vkorg,
        "IV_SPART": spart != null && spart.isNotEmpty
            ? spart.first.substring(spart.first.indexOf('-') + 1)
            : '',
        "IV_VKGRP": vkgrp != null && vkgrp.isNotEmpty
            ? vkgrp.first.substring(vkgrp.first.indexOf('-') + 1)
            : '',
        "IV_PERNR": staffName ?? '',
        "pos": pos,
        "partial": partial,
        "IV_KUNNR": "",
        "IV_KEYWORD": customerInputText ?? '',
        "IS_LOGIN": isLogin,
        "functionName": RequestType.SEARCH_SALLER.serverMethod,
        "resultTables": RequestType.SEARCH_SALLER.resultTable
      }
    };
    _api.init(RequestType.SEARCH_SALLER);
    final result = await _api.request(body: _body);
    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      staList = null;
      notifyListeners();
      return BasePoupSearchResult(false);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      var temp = EtCustomerResponseModel.fromJson(result.body['data']);
      if (temp.etCustomer!.length != partial) {
        hasMore = false;
      }
      if (etCustomerResponseModel == null) {
        etCustomerResponseModel = temp;
      } else {
        etCustomerResponseModel!.etCustomer!.addAll(temp.etCustomer!);
      }
      if (etCustomerResponseModel != null &&
          etCustomerResponseModel!.etCustomer == null) {
        etCustomerResponseModel = null;
      }
      isLoadData = false;
      notifyListeners();
      return BasePoupSearchResult(true);
    }
    isLoadData = false;
    return BasePoupSearchResult(false);
  }

  void setIsLoginModel() async {
    var isLogin = CacheService.getIsLogin();
    isLoginModel = EncodingUtils.decodeBase64ForIsLogin(isLogin!);
    isTeamLeader = isLoginModel!.xtm == 'X';
    if (isTeamLeader) {
      staffName = tr('all');
    } else {
      staffName = isLoginModel!.ename;
    }
  }

  Future<BasePoupSearchResult> onSearch(OneCellType type, bool isMounted,
      {Map<String, dynamic>? bodyMaps}) async {
    if (bodyMaps != null && bodyMaps != bodyMap) {
      this.bodyMap = bodyMaps;
    }
    this.type = type;
    setIsLoginModel();
    if (type == OneCellType.SEARCH_SALLER) {
      initData();
    }
    switch (type) {
      case OneCellType.SEARCH_SALSE_PERSON:
        return await searchPerson(isMounted);
      case OneCellType.SEARCH_CUSTOMER:
        return await searchCustomer(isMounted);
      case OneCellType.SEARCH_SALLER:
        return await searchSaller(isMounted);
      default:
        return BasePoupSearchResult(false);
    }
  }
}

class BasePoupSearchResult {
  bool isSuccessful;
  String? message;
  // SalesorderDefaultPersonResponseModel? defaultPersonResponseModel;
  BasePoupSearchResult(this.isSuccessful, {this.message});
}
