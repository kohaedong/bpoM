/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/provider/base_popup_search_provider.dart
 * Created Date: 2021-09-11 17:15:06
 * Last Modified: 2022-10-13 02:53:33
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/model/rfc/add_activity_key_man_response_model.dart';
import 'package:medsalesportal/model/rfc/add_activity_suggetion_response_model.dart';
import 'package:medsalesportal/model/rfc/et_cust_list_response_model.dart';
import 'package:medsalesportal/model/rfc/order_manager_metarial_response_model.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/enums/hive_box_type.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/util/is_super_account.dart';
import 'package:medsalesportal/util/hive_select_data_util.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/util/regular.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/model/commonCode/is_login_model.dart';
import 'package:medsalesportal/model/rfc/et_kunnr_response_model.dart';
import 'package:medsalesportal/model/rfc/et_customer_response_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_response_model.dart';

class BasePopupSearchProvider extends ChangeNotifier {
  bool isLoadData = false;
  bool isFirestRun = true;
  bool isSingleData = false;
  bool? isShhowNotResultText;
  String? personInputText;
  String? keymanInputText;
  String? customerInputTextForAddActivityPage;
  String? suggetionItemNameInputText;
  String? suggetionItemGroupInputText;
  String? customerInputText;
  String? endCustomerInputText;
  String? selectedProductCategory;
  String? selectedProductFamily;
  String? selectedSalesGroup;
  String? seletedMaterialSearchKey;
  String? seletedMateriaFamily;

  List<String>? productCategoryDataList;
  List<String>? productBusinessDataList;
  List<String>? productFamilyDataList;
  List<String>? materalItemDataList;
  IsLoginModel? isLoginModel;
  EtStaffListModel? selectedSalesPerson;
  EtStaffListResponseModel? staList;
  EtKunnrResponseModel? etKunnrResponseModel;
  EtCustomerResponseModel? etCustomerResponseModel;
  EtCustListResponseModel? etEndCustomerOrSupplierResponseModel;
  AddActivityKeyManResponseModel? keyManResponseModel;
  AddActivitySuggetionResponseModel? suggetionResponseModel;
  OrderManagerMetarialResponseModel? metarialResponseModel;
  OneCellType? type;
  Map<String, dynamic>? bodyMap;

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
    etEndCustomerOrSupplierResponseModel = null;
    keyManResponseModel = null;
    suggetionResponseModel = null;
    metarialResponseModel = null;
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
    // data(String) 를 map으로 받아와 조건에 맞는 model로 초기화 해준다.
    // 제품군 / 영업사원
    if (isFirestRun && bodyMap != null) {
      staffName = bodyMap?['staff'];
      selectedProductFamily = bodyMap?['product_family'];
      await getProductFamily();
      await getSalesGroup(isFirstRun: isFirestRun);
      searchPerson(true, isFromSearchSaller: true);
    }
  }

  void setPersonInputText(String? value) {
    personInputText = value;
    if (value == null || (value.length == 1) || value == '') {
      if (value == '*') {
        personInputText = ' ';
      }
      notifyListeners();
    }
  }

  void setSuggetionItemNameInputText(String? value) {
    suggetionItemNameInputText = value;
    if (value == null || (value.length == 1) || value == '') {
      if (value == '*') {
        suggetionItemNameInputText = ' ';
      }
      notifyListeners();
    }
  }

  void setMeatrialSearchKeyInputText(String? value) {
    seletedMaterialSearchKey = value;
    if (value == null || (value.length == 1) || value == '') {
      if (value == '*') {
        seletedMaterialSearchKey = ' ';
      }
      pr(value);
      notifyListeners();
    }
  }

  void setMeatrialItemType(String? value) {
    seletedMateriaFamily = value;
    notifyListeners();
  }

  void setSuggetionItemGroupInputText(String? value) {
    suggetionItemGroupInputText = value;
    if (value == null || (value.length == 1) || value == '') {
      if (value == '*') {
        suggetionItemGroupInputText = ' ';
      }
      notifyListeners();
    }
  }

  void setKeymanInputText(String? value) {
    keymanInputText = value;
    if (value == null || (value.length == 1)) {
      if (value == '*') {
        keymanInputText = ' ';
      }
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

  void setSalesGroup(String? value) {
    selectedSalesGroup = value;

    notifyListeners();
  }

  void setCustomerInputText(String? value) {
    customerInputText = value;
    if (value == null || (value.length == 1)) {
      if (value == '*') {
        customerInputText = ' ';
      }
      notifyListeners();
    }
  }

  void setEndCustomerInputText(String? value) {
    endCustomerInputText = value;
    if (value == null || (value.length == 1)) {
      if (value == '*') {
        endCustomerInputText = ' ';
      }
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

  Future<List<String>?> getSalesGroup({bool? isFirstRun}) async {
    // isSuperAccount.
    productBusinessDataList = await HiveService.getSalesGroup();
    if (isFirestRun) {
      var dptnm = bodyMap?['dptnm'];
      //------ default data ------
      final esLogin = CacheService.getEsLogin();
      var temp = productBusinessDataList
          ?.where((str) => dptnm != null
              ? str.contains(dptnm)
              : str.contains(esLogin!.dptnm!))
          .toList();
      if (temp != null && temp.isNotEmpty) {
        pr(temp.first);
        selectedSalesGroup = staffName != tr('all')
            ? temp.first.substring(0, temp.first.indexOf('-'))
            : tr('all');
        notifyListeners();
      } else {
        pr('all');
        selectedSalesGroup = tr('all');
        notifyListeners();
      }
      //------ default data ------
    }
    var dataStr = <String>[];
    productBusinessDataList!.forEach((data) {
      dataStr.add(data.substring(0, data.indexOf('-')));
    });
    return dataStr;
  }

  Future<List<String>?> getMateralItemType() async {
    materalItemDataList = await HiveService.getProductType();
    var dataStr = <String>[];
    materalItemDataList!.forEach((data) {
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

  String getSalseGroupCode() {
    var temp = productBusinessDataList
        ?.where((str) => str.contains(selectedSalesGroup!))
        .toList();
    return temp != null && temp.isNotEmpty
        ? temp.first.substring(temp.first.indexOf('-') + 1)
        : '';
  }

  Future<BasePoupSearchResult> searchPerson(bool isMounted,
      {bool? isFromSearchSaller}) async {
    if (isFirestRun) {
      isFirestRun = false;
      return BasePoupSearchResult(true);
    }
    if (isFromSearchSaller == null) {
      isLoadData = true;
      if (isMounted) {
        notifyListeners();
      }
    }

    var _api = ApiService();
    final isLogin = CacheService.getIsLogin();
    final esLogin = CacheService.getEsLogin();
    Map<String, dynamic>? body;
    var dptnm = bodyMap?['dptnm'];
    var isNotDptnm = bodyMap?['not_dptnm'] != null;
    pr('person dptnm:::$dptnm');
    body = {
      "methodName": RequestType.SEARCH_STAFF.serverMethod,
      "methodParamMap": {
        "IV_SALESM": "",
        "IV_SNAME": personInputText != null
            ? RegExpUtil.removeSpace(personInputText!)
            : '',
        "IV_DPTNM": isNotDptnm
            ? ''
            : CheckSuperAccount.isLeaderAccount()
                ? esLogin!.dptnm
                : CheckSuperAccount.isMultiAccountOrLeaderAccount()
                    ? dptnm != null
                        ? dptnm
                        : ''
                    : esLogin!.dptnm,
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.SEARCH_STAFF.resultTable,
        "functionName": RequestType.SEARCH_STAFF.serverMethod,
      }
    };
    if (isFromSearchSaller == null) {
      body.addAll({
        "pos": "$pos",
        "partial": "$partial",
      });
    } else {
      body.addAll({
        "pos": "-1",
      });
    }
    _api.init(RequestType.SEARCH_STAFF);
    final result = await _api.request(body: body);
    if (result == null || result.statusCode != 200) {
      if (isFromSearchSaller == null) {
        isLoadData = false;
        staList = null;
        notifyListeners();
      }
      return BasePoupSearchResult(false);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      pr(result.body);
      if (isFromSearchSaller == null) {
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
      } else {
        var temp = EtStaffListResponseModel.fromJson(result.body['data']);
        var staffList =
            temp.staffList!.where((model) => model.sname == staffName).toList();
        selectedSalesPerson = staffList.isNotEmpty ? staffList.first : null;
      }
      isShhowNotResultText = staList != null && staList!.staffList!.isEmpty;
      pr(isShhowNotResultText);
      return BasePoupSearchResult(true);
    }
    isLoadData = false;

    notifyListeners();
    return BasePoupSearchResult(false);
  }

  Future<BasePoupSearchResult> searchKeyMan(bool isMounted) async {
    isLoadData = true;
    if (isMounted) {
      // notifyListeners();
    }
    var _api = ApiService();
    final isLogin = CacheService.getIsLogin();
    pr(bodyMap?['zskunnr']);
    Map<String, dynamic>? body;
    body = {
      "methodName": RequestType.SEARCH_KEY_MAN.serverMethod,
      "methodParamMap": {
        "IV_NAME": "",
        "IV_XREPKM": "",
        "IV_ZSKUNNR": bodyMap?['zskunnr'] ?? '',
        "IV_ZTRAITMENT": "",
        "pos": pos,
        "partial": partial,
        "IS_LOGIN": isLogin,
        "IV_ZKMNAME": keymanInputText != null
            ? RegExpUtil.removeSpace(keymanInputText!)
            : '',
        "resultTables": RequestType.SEARCH_KEY_MAN.resultTable,
        "functionName": RequestType.SEARCH_KEY_MAN.serverMethod,
      }
    };
    _api.init(RequestType.SEARCH_KEY_MAN);
    final result = await _api.request(body: body);
    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return BasePoupSearchResult(false);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      var temp = AddActivityKeyManResponseModel.fromJson(result.body['data']);
      if (temp.etList!.length != partial) {
        hasMore = false;
      }
      if (keyManResponseModel == null) {
        keyManResponseModel = temp;
      } else {
        keyManResponseModel!.etList!.addAll(temp.etList!);
      }
      if (keyManResponseModel != null && keyManResponseModel!.etList == null) {
        keyManResponseModel = null;
      }
      pr(temp.toJson());
      isLoadData = false;
      isShhowNotResultText =
          keyManResponseModel != null && keyManResponseModel!.etList!.isEmpty;

      notifyListeners();
      return BasePoupSearchResult(true);
    }
    isLoadData = false;
    isShhowNotResultText = true;
    try {
      notifyListeners();
    } catch (e) {}
    return BasePoupSearchResult(false);
  }

  Future<BasePoupSearchResult> searchMaterial(bool isMounted) async {
    // assert(seletedMateriaFamily != null);
    pr(1);
    if (isFirestRun) {
      isFirestRun = false;
      return BasePoupSearchResult(true);
    }
    pr(2);

    isLoadData = true;
    if (isMounted) {
      notifyListeners();
    }
    pr(3);

    var _api = ApiService();
    final isLogin = CacheService.getIsLogin();
    var spart = '';
    await getMateralItemType();
    if (seletedMateriaFamily != tr('all')) {
      var temp = materalItemDataList!
          .where((data) => data.contains(seletedMateriaFamily!))
          .toList();
      if (temp.isNotEmpty) {
        spart = temp.first.substring(temp.first.indexOf('-') + 1);
      }
    }
    Map<String, dynamic> _body = {
      "methodName": RequestType.SEARCH_MATERIAL.serverMethod,
      "methodParamMap": {
        "IV_MATNR": "",
        "IV_MATKL": "",
        "IV_WGBEZ": "",
        "IV_PTYPE": "R",
        "IV_MAKTX": seletedMaterialSearchKey != null
            ? RegExpUtil.removeSpace(seletedMaterialSearchKey!)
            : '',
        "IV_SPART": spart,
        "pos": pos,
        "partial": partial,
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.SEARCH_MATERIAL.resultTable,
        "functionName": RequestType.SEARCH_MATERIAL.serverMethod,
      }
    };
    _api.init(RequestType.SEARCH_MATERIAL);
    final result = await _api.request(body: _body);
    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return BasePoupSearchResult(false);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      var temp =
          OrderManagerMetarialResponseModel.fromJson(result.body['data']);
      if (temp.etOutput!.length != partial) {
        hasMore = false;
      }
      if (metarialResponseModel == null) {
        metarialResponseModel = temp;
      } else {
        metarialResponseModel!.etOutput!.addAll(temp.etOutput!);
      }
      if (metarialResponseModel != null &&
          metarialResponseModel!.etOutput!.isEmpty) {
        metarialResponseModel = null;
      }
      pr(temp.toJson());
      isLoadData = false;
      isFirestRun = false;
      isShhowNotResultText = metarialResponseModel != null &&
          metarialResponseModel!.etOutput!.isNotEmpty;
      notifyListeners();
      return BasePoupSearchResult(true);
    }
    isLoadData = false;
    isShhowNotResultText = true;
    try {
      notifyListeners();
    } catch (e) {}
    return BasePoupSearchResult(false);
  }

  Future<BasePoupSearchResult> searchCustomer(bool isMounted,
      {bool? isAddActivityPage}) async {
    if (isFirestRun || !isMounted) {
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
      zbiz =
          temp.isEmpty ? '' : temp.first.substring(temp.first.indexOf('-') + 1);
    }
    if (selectedProductFamily != null) {
      var temp = productFamilyDataList!
          .where((data) => data.contains(selectedProductFamily!))
          .toList();
      spart =
          temp.isEmpty ? '' : temp.first.substring(temp.first.indexOf('-') + 1);
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
        "IV_NAME": customerInputText != null
            ? RegExpUtil.removeSpace(customerInputText!)
            : '',
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
      isShhowNotResultText = etKunnrResponseModel != null &&
          etKunnrResponseModel!.etKunnr!.isEmpty;
      notifyListeners();
      return BasePoupSearchResult(true);
    }
    isLoadData = false;
    isShhowNotResultText = true;
    try {
      notifyListeners();
    } catch (e) {}
    return BasePoupSearchResult(false);
  }

  Future<BasePoupSearchResult> searchSallerCustomer(bool isMounted,
      {bool? isBulkOrder}) async {
    // 검색 하기 전에 popup body 에는  '조회결관가 없습니다.' 문구만 보여주기 위해.
    // 첫 진입시 data 초기화 작업만 해주고 BasePoupSearchResult(false) 로 return 한다;
    if (isFirestRun || !isMounted) {
      await initData();
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
        ?.where((str) => str.contains(selectedSalesGroup!))
        .toList();

    _body = {
      "methodName": isBulkOrder != null && isBulkOrder
          ? RequestType.SEARCH_SALLER_FOR_BULK_ORDER.serverMethod
          : RequestType.SEARCH_SALLER.serverMethod,
      "methodParamMap": {
        "IV_VTWEG": bodyMap?['vtweg'] ?? "10",
        "IV_VKORG": esLogin!.vkorg,
        "IV_SPART": spart != null && spart.isNotEmpty
            ? spart.first.substring(spart.first.indexOf('-') + 1)
            : '',
        "IV_VKGRP": vkgrp != null && vkgrp.isNotEmpty
            ? vkgrp.first.substring(vkgrp.first.indexOf('-') + 1)
            : '',
        "IV_PERNR": staffName == tr('all')
            ? ''
            : selectedSalesPerson != null
                ? selectedSalesPerson!.pernr
                : '',
        "pos": pos,
        "partial": partial,
        "IV_KUNNR": "",
        "IV_KEYWORD": customerInputText != null
            ? RegExpUtil.removeSpace(customerInputText!)
            : '',
        "IS_LOGIN": isLogin,
        "functionName": isBulkOrder != null && isBulkOrder
            ? RequestType.SEARCH_SALLER_FOR_BULK_ORDER.serverMethod
            : RequestType.SEARCH_SALLER.serverMethod,
        "resultTables": isBulkOrder != null && isBulkOrder
            ? RequestType.SEARCH_SALLER_FOR_BULK_ORDER.resultTable
            : RequestType.SEARCH_SALLER.resultTable
      }
    };
    _api.init(isBulkOrder != null && isBulkOrder
        ? RequestType.SEARCH_SALLER_FOR_BULK_ORDER
        : RequestType.SEARCH_SALLER);
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      isLoadData = false;
      staList = null;
      notifyListeners();
      return BasePoupSearchResult(false);
    }
    if (result != null && result.statusCode == 200) {
      var temp = EtCustomerResponseModel.fromJson(result.body['data']);

      if (temp.esReturn!.mtype == 'S') {
        pr(result.body);
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
        isShhowNotResultText = etCustomerResponseModel != null &&
            etCustomerResponseModel!.etCustomer!.isEmpty;
        notifyListeners();
        return BasePoupSearchResult(true);
      }
    }
    isLoadData = false;
    isShhowNotResultText = true;
    try {
      notifyListeners();
    } catch (e) {}
    return BasePoupSearchResult(false);
  }

  Future<BasePoupSearchResult> searchEndOrDeliveryCustomer(
      bool isMounted, bool isSupplier,
      {bool? isDeliveryCustomer}) async {
    isLoadData = true;
    if (isMounted) {
      notifyListeners();
    }
    var _api = ApiService();
    final isLogin = CacheService.getIsLogin();
    final isloginModel = EncodingUtils.decodeBase64ForIsLogin(isLogin!);
    isloginModel.kunag = '${bodyMap!['kunnr']}';

    var newIslogin = await EncodingUtils.base64Convert(isloginModel.toJson());
    Map<String, dynamic>? _body;
    _body = {
      // Z_LTS_IFS6002
      "methodName": RequestType.SEARCH_END_OR_DELIVERY_CUSTOMER.serverMethod,
      "methodParamMap": {
        "IV_VTWEG": "10",
        "IV_KEYWORD": "",
        "IS_LOGIN": newIslogin,
        "pos": "0",
        "IV_PARVW": isSupplier ? "WE" : "Z1",
        "IV_KFM2": "",
        "groupid": "",
        "functionName":
            RequestType.SEARCH_END_OR_DELIVERY_CUSTOMER.serverMethod,
        "resultTables": RequestType.SEARCH_END_OR_DELIVERY_CUSTOMER.resultTable,
      }
    };
    _api.init(RequestType.SEARCH_END_OR_DELIVERY_CUSTOMER);
    final result = await _api.request(body: _body);
    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      etEndCustomerOrSupplierResponseModel = null;
      notifyListeners();
      return BasePoupSearchResult(false);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      var temp = EtCustListResponseModel.fromJson(result.body['data']);
      pr(temp.toJson());
      if (temp.etCustList!.length != partial) {
        hasMore = false;
      }
      if (etEndCustomerOrSupplierResponseModel == null) {
        etEndCustomerOrSupplierResponseModel = temp;
        if (etEndCustomerOrSupplierResponseModel!.etCustList!.length == 1) {
          isSingleData = true;
        }
      } else {
        etEndCustomerOrSupplierResponseModel!.etCustList!
            .addAll(temp.etCustList!);
      }
      if (etEndCustomerOrSupplierResponseModel != null &&
          etEndCustomerOrSupplierResponseModel!.etCustList == null) {
        etEndCustomerOrSupplierResponseModel = null;
      }

      isLoadData = false;
      isShhowNotResultText = etEndCustomerOrSupplierResponseModel != null &&
          etEndCustomerOrSupplierResponseModel!.etCustList!.isEmpty;
      notifyListeners();
      return BasePoupSearchResult(true);
    }

    isLoadData = false;
    isShhowNotResultText = true;
    try {
      notifyListeners();
    } catch (e) {}
    return BasePoupSearchResult(false);
  }

  Future<BasePoupSearchResult> searchSuggetionItem(bool isMounted,
      {bool? isDeliveryCustomer}) async {
    isLoadData = true;
    if (isMounted) {
      notifyListeners();
    }
    var _api = ApiService();
    _api.init(RequestType.SEARCH_SUGGETION_ITEM);
    Map<String, dynamic>? _body;
    _body = {
      "methodName": RequestType.SEARCH_SUGGETION_ITEM.serverMethod,
      "methodParamMap": {
        "IV_PTYPE": "R",
        "IV_MATNR": "",
        "IV_MAKTX": suggetionItemNameInputText != null
            ? RegExpUtil.removeSpace(suggetionItemNameInputText!)
            : '', // input
        "IV_MATKL": suggetionItemGroupInputText != null
            ? RegExpUtil.removeSpace(suggetionItemGroupInputText!)
            : '', // input
        "IV_WGBEZ": "",
        "IV_MTART": "",
        "pos": pos,
        "partial": partial,
        "IS_LOGIN": CacheService.getIsLogin(),
        "resultTables": RequestType.SEARCH_SUGGETION_ITEM.resultTable,
        "functionName": RequestType.SEARCH_SUGGETION_ITEM.serverMethod
      }
    };
    _api.init(RequestType.SEARCH_END_OR_DELIVERY_CUSTOMER);
    final result = await _api.request(body: _body);
    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      suggetionResponseModel = null;
      notifyListeners();
      return BasePoupSearchResult(false);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      var temp =
          AddActivitySuggetionResponseModel.fromJson(result.body['data']);
      pr(temp.toJson());
      if (temp.etOutput!.length != partial) {
        hasMore = false;
      }
      if (suggetionResponseModel == null) {
        suggetionResponseModel = temp;
      } else {
        suggetionResponseModel!.etOutput!.addAll(temp.etOutput!);
      }
      if (suggetionResponseModel != null &&
          suggetionResponseModel!.etOutput == null) {
        suggetionResponseModel = null;
      }
      isLoadData = false;
      isShhowNotResultText = suggetionResponseModel != null &&
          suggetionResponseModel!.etOutput!.isEmpty;

      notifyListeners();
      return BasePoupSearchResult(true);
    }
    isLoadData = false;
    isShhowNotResultText = true;
    try {
      notifyListeners();
    } catch (e) {}
    return BasePoupSearchResult(false);
  }

  void setIsLoginModel() async {
    var isLogin = CacheService.getIsLogin();
    isLoginModel = EncodingUtils.decodeBase64ForIsLogin(isLogin!);
  }

  Future<BasePoupSearchResult> onSearch(OneCellType type, bool isMounted,
      {Map<String, dynamic>? bodyMaps}) async {
    if (bodyMaps != null && bodyMaps != bodyMap) {
      this.bodyMap = bodyMaps;
      if (bodyMaps['productFamily'] != null) {
        seletedMateriaFamily = bodyMaps['productFamily'];
      }
    }
    this.type = type;
    setIsLoginModel();
    switch (type) {
      case OneCellType.SEARCH_SALSE_PERSON:
        return await searchPerson(isMounted);
      case OneCellType.SEARCH_SUGGETION_ITEM:
        return await searchSuggetionItem(isMounted);
      case OneCellType.SEARCH_KEY_MAN:
        return await searchKeyMan(isMounted);
      case OneCellType.SEARCH_CUSTOMER_FOR_ADD_ACTIVITY_PAGE:
        return await searchCustomer(isMounted);
      case OneCellType.SEARCH_CUSTOMER:
        return await searchCustomer(isMounted);
      case OneCellType.SEARCH_SALLER:
        return await searchSallerCustomer(isMounted);
      case OneCellType.SEARCH_SALLER_FOR_BULK_ORDER:
        return await searchSallerCustomer(isMounted, isBulkOrder: true);
      case OneCellType.SEARCH_END_CUSTOMER:
        return await searchEndOrDeliveryCustomer(isMounted, false);
      case OneCellType.SEARCH_SUPPLIER:
        return await searchEndOrDeliveryCustomer(isMounted, true);
      case OneCellType.SEARCH_MATERIAL:
        return await searchMaterial(isMounted);
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
