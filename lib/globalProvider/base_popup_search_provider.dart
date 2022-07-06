/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/provider/base_popup_search_provider.dart
 * Created Date: 2021-09-11 17:15:06
 * Last Modified: 2022-07-07 00:22:16
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/hive_box_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/model/rfc/et_customer_response_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_response_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/util/hive_select_data_util.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class BasePopupSearchProvider extends ChangeNotifier {
  bool isLoadData = false;
  String? selectedOneRowValue1;
  String? personInputText;
  String? customerInputText;
  String? selectedThreeRowValue1;
  String? selectedThreeRowValue2;
  String? selectedThreeRowValue3;
  String? selectedThreeRowValue4;
  String? selectedOneRowValue1DefaultValue;
  EtStaffListResponseModel? staList;
  EtCustomerResponseModel? etCustomerResponseModel;
  // List<PlantResultModel>? plantList;
  OneCellType? type;
  Map<String, dynamic>? bodyMap;

//--------------- plant Code----------
  String? selectedOrganizationCode;
  String? seletedCirculationCode;

  bool get isOneRowValue1Selected => selectedOneRowValue1 != null;
  bool get isOneRowValue2Selected => personInputText != null;
  bool get isThreeRowValue1Selected => selectedThreeRowValue1 != null;
  bool get isThreeRowValue2Selected => selectedThreeRowValue2 != null;
  bool get isThreeRowValue3Selected => selectedThreeRowValue3 != null;
  bool get isThreeRowValue4Selected => selectedThreeRowValue4 != null;

//------ pageing ----------
  int pos = 0;
  int partial = 30;
  bool hasMore = true;
  Future<void> refresh() async {
    pos = 0;
    staList = null;
    etCustomerResponseModel = null;
    onSearch(type!, true);
  }

  Future<bool?> nextPage() async {
    if (hasMore) {
      pos = partial + pos;
      return onSearch(type!, false).then((result) => result.isSuccessful);
    }
    return null;
  }

  void setDefaultOrganization({Map<String, dynamic>? bodyMaps}) async {
    if (this.bodyMap == null) {
      this.bodyMap = bodyMaps;
    }
    if (bodyMap != null) {
      if (bodyMap!['IV_VKORG'] != null &&
          bodyMap!['IV_VKORG'].toString().trim() != '') {
        selectedOrganizationCode = bodyMap!['IV_VKORG'].toString().trim();
        await HiveService.getSingleDataBySearchKey(
                selectedOrganizationCode!, 'H_TVKO',
                searchLevel: 1, group1SearchKey: selectedOrganizationCode!)
            .then((result) => selectedThreeRowValue1 = result);
      }
      if (bodyMap!['IV_VTWEG'] != null) {
        seletedCirculationCode = bodyMap!['IV_VTWEG'];
        await HiveService.getDataFromTValue(
                group1SearchKey: selectedOrganizationCode!,
                group2SearchKey: seletedCirculationCode,
                searchLevel: 2,
                tname: 'H_TVKOV')
            .then((list) => selectedThreeRowValue2 = list!.single);
      } else {
        // default
        seletedCirculationCode = '10';
        selectedThreeRowValue2 = '내수';
      }
    }
    notifyListeners();
  }

  setPersonInputText(String? value) {
    this.personInputText = value;
    if (value == null || (value.length == 1) || value == '') {
      notifyListeners();
    }
  }

  setCustomerInputText(String? value) {
    this.customerInputText = value;
    if (value == null || (value.length == 1) || value == '') {
      notifyListeners();
    }
  }

  setThreeRowValue1(String value) async {
    this.selectedThreeRowValue1 = value;
    this.selectedThreeRowValue2 = null;
    this.selectedThreeRowValue4 = null;
    selectedOrganizationCode = await HiveService.getSingleDataBySearchKey(
        selectedThreeRowValue1!, 'H_TVKO',
        searchLevel: 1,
        group1SearchKey: selectedThreeRowValue1,
        isMatchGroup1KeyList: true);
    // notifyListeners();
  }

  setThreeRowValue2(String value) async {
    this.selectedThreeRowValue2 = value;
    seletedCirculationCode = await HiveService.getSingleDataBySearchKey(
      selectedThreeRowValue2!,
      'H_TVKOV',
      searchLevel: 2,
      group1SearchKey: selectedOrganizationCode,
      group2SearchKey: selectedThreeRowValue2,
      isMatchGroup2KeyList: true,
    );
    notifyListeners();
  }

  setThreeRowValue3(String? value) {
    this.selectedThreeRowValue3 = value;
    notifyListeners();
  }

  setThreeRowValue4(String? value) {
    if (value == null) {}
    this.selectedThreeRowValue4 = value;
    notifyListeners();
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
    print(selectedOneRowValue1);
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

  Future<BasePoupSearchResult> searchCustomer(
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
      "methodName": RequestType.SEARCH_CUSTOMER.serverMethod,
      "methodParamMap": {
        "IV_ZBIZ": "",
        "IV_DORMA": "X",
        "IV_ZKIND": "",
        "IV_SALES": "X",
        "IV_ZLOEVM": "A",
        "IV_ZCLASS": "",
        "IV_VKGRP": "",
        "IV_POSSIB": "X",
        "IV_ZADD_NAME1": "",
        "IV_SPART": "",
        "IV_ZIMPORT": "",
        "IV_ZTREAT3": "",
        "IV_HIDDEN": "",
        "IV_CLOSE": "",
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
      var temp = EtCustomerResponseModel.fromJson(result.body['data']);
      pr(temp.toJson());
      if (temp.etKunnr!.length != partial) {
        hasMore = false;
      }
      if (etCustomerResponseModel == null) {
        etCustomerResponseModel = temp;
      } else {
        etCustomerResponseModel!.etKunnr!.addAll(temp.etKunnr!);
      }
      if (etCustomerResponseModel != null &&
          etCustomerResponseModel!.etKunnr == null) {
        etCustomerResponseModel = null;
      }
      isLoadData = false;
      notifyListeners();
      return BasePoupSearchResult(true);
    }
    isLoadData = false;
    return BasePoupSearchResult(false);
  }

  Future<BasePoupSearchResult> onSearch(OneCellType type, bool isMounted,
      {Map<String, dynamic>? bodyMaps}) async {
    if (bodyMaps != null && bodyMaps != bodyMap) {
      this.bodyMap = bodyMaps;
    }
    this.type = type;

    switch (type) {
      case OneCellType.SEARCH_SALSE_PERSON:
        return await searchPerson(isMounted);
      case OneCellType.SEARCH_CUSTOMER:
        return await searchCustomer(isMounted);
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
