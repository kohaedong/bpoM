/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salseReport/provider/salse_report_page_provider.dart
 * Created Date: 2022-07-05 09:59:52
 * Last Modified: 2022-10-22 13:41:32
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/model/rfc/et_cust_list_model.dart';
import 'package:medsalesportal/model/rfc/et_cust_list_response_model.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/et_customer_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/model/commonCode/is_login_model.dart';
import 'package:medsalesportal/model/rfc/trans_ledger_response_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_response_model.dart';

class TransactionLedgerPageProvider extends ChangeNotifier {
  bool isLoadData = false;
  bool isFirstRun = true;
  bool firstIn = true;
  bool? hasResultData;
  bool isAnimationNotReady = true;
  bool isOpenBottomSheet = true;
  bool isOpenBottomSheetForLandSpace = true;
  bool isShowShadow = true;
  bool isShowAppBar = true;
  bool hasData = false;
  String? selectedStartDate;
  String? selectedEndDate;
  String? selectedProductsFamily;
  String? customerName;
  List<EtCustListModel> endCustomerList = [];
  EtStaffListModel? selectedSalesPerson;
  EtCustListModel? selectedEndCustomerModel;
  EtCustomerModel? selectedCustomerModel;
  TransLedgerResponseModel? transLedgerResponseModel;

  List<String>? processingStatusListWithCode;
  List<String>? productsFamilyListWithCode;
  IsLoginModel? isLoginModel;

  int pos = 0;
  int partial = 100;
  bool hasMore = false;
  final _api = ApiService();
  Future<ResultModel> refresh() async {
    pos = 0;
    hasMore = true;
    transLedgerResponseModel = null;
    return onSearch(true);
  }

  String get dptnm => CacheService.getEsLogin()!.dptnm!;
  bool get isValidate =>
      selectedStartDate != null &&
      selectedEndDate != null &&
      selectedCustomerModel != null &&
      customerName != null;
  Future<ResultModel?> nextPage() async {
    if (hasMore) {
      pos = partial + pos;
      return onSearch(false);
    }
    return null;
  }

  void setIsOpenBottomSheet() {
    isOpenBottomSheet = !isOpenBottomSheet;
    Future.delayed(Duration(milliseconds: isOpenBottomSheet ? 274 : 0), () {
      setShhowShadow();
    });
    notifyListeners();
  }

  void setIsOpenBottomSheetForLandSpace() {
    isOpenBottomSheetForLandSpace = !isOpenBottomSheetForLandSpace;
    notifyListeners();
  }

  void setShhowShadow() {
    isShowShadow = !isShowShadow;
    notifyListeners();
  }

  void setIsReadyForAnimation() {
    isAnimationNotReady = !isAnimationNotReady;
    notifyListeners();
  }

  void setIsShowAppBar() {
    isShowAppBar = !isShowAppBar;
    notifyListeners();
  }

  Future<ResultModel> searchPerson({String? dptnm}) async {
    var _api = ApiService();
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
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      var temp = EtStaffListResponseModel.fromJson(result.body['data']);
      var staffList = temp.staffList!
          .where((model) => model.sname == esLogin!.ename)
          .toList();
      selectedSalesPerson = staffList.isNotEmpty ? staffList.first : null;
      return ResultModel(true);
    }
    return ResultModel(false);
  }

  Future<void> initPageData() async {
    // isLoadData = true;
    if (isFirstRun) {
      await searchPerson();
      selectedStartDate = DateUtil.prevWeek();
      selectedEndDate = DateUtil.now();
      selectedProductsFamily = tr('all');
      isAnimationNotReady = false;
      isFirstRun = false;
    }
  }

  void setStartDate(BuildContext context, String? str) {
    DateUtil.checkDateIsBefore(context, str, selectedEndDate).then((before) {
      if (before) {
        this.selectedStartDate = str;
        notifyListeners();
      }
    });
  }

  void setCustomerName(String? str) {
    customerName = str;
    if (str == null) {
      selectedCustomerModel = null;
    }
    selectedEndCustomerModel = null;
    notifyListeners();
  }

  void setEndCustomerModel(dynamic data) {
    data as String?;
    if (data != null) {
      var tempKunnr = data.substring(data.indexOf('/') + 1);
      pr(tempKunnr);
      selectedEndCustomerModel =
          endCustomerList.where((endCust) => endCust.kunnr == tempKunnr).last;
    } else {
      selectedEndCustomerModel = null;
    }
    notifyListeners();
  }

  void setSalesPerson(dynamic str) {
    str as EtStaffListModel?;
    selectedSalesPerson = str;
    notifyListeners();
  }

  Future<void> setCustomerModel(dynamic map) async {
    map as Map<String, dynamic>;
    selectedProductsFamily = map['product_family'] as String?;
    var staff = map['staff'] as EtStaffListModel?;
    if (staff?.logid == selectedSalesPerson?.logid) {
      selectedSalesPerson = staff;
    } else {
      setSalesPerson(staff);
      return;
    }
    if (map['model'] != null) {
      selectedCustomerModel = map['model'] as EtCustomerModel?;
      customerName = selectedCustomerModel?.kunnrNm;
      selectedEndCustomerModel = null;
      endCustomerList = [];
      if (selectedCustomerModel != null) {
        await searchEndCustomer();
      }
    }

    notifyListeners();
  }

  void setProductsFamily(String? str) {
    selectedProductsFamily = str;
    notifyListeners();
  }

  void setEndDate(BuildContext context, String? str) {
    DateUtil.checkDateIsBefore(context, selectedStartDate, str).then((before) {
      if (before) {
        this.selectedEndDate = str;
        notifyListeners();
      }
    });
  }

  Future<List<String>> getEndCustomerList() async {
    var temp = <String>[];
    endCustomerList.forEach((endCustomer) {
      temp.add('${endCustomer.kunnrNm!}/${endCustomer.kunnr!}');
    });
    return temp;
  }

  Future<ResultModel> searchEndCustomer() async {
    var _api = ApiService();
    final isLogin = CacheService.getIsLogin();
    final isloginModel = EncodingUtils.decodeBase64ForIsLogin(isLogin!);
    isloginModel.kunag = selectedCustomerModel!.kunnr;
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
        "IV_PARVW": "WE",
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
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      var temp = EtCustListResponseModel.fromJson(result.body['data']);
      pr(temp.toJson());
      endCustomerList = [];
      if (temp.etCustList != null && temp.etCustList!.isNotEmpty) {
        endCustomerList.addAll(temp.etCustList!);
      }
      if (endCustomerList.length == 1) {
        selectedEndCustomerModel = endCustomerList.single;
        notifyListeners();
      }
      return ResultModel(true);
    }
    return ResultModel(false);
  }

  Future<List<String>?> getProcessingStatus() async {
    if (processingStatusListWithCode == null) {
      processingStatusListWithCode = await HiveService.getProcessingStatus();
    }
    return List.generate(
        processingStatusListWithCode!.length,
        (index) => processingStatusListWithCode![index]
            .substring(0, processingStatusListWithCode![index].indexOf('-')));
  }

  Future<List<String>?> getProductsFamily() async {
    if (productsFamilyListWithCode == null) {
      productsFamilyListWithCode = await HiveService.getProductFamily();
    }
    return List.generate(
        productsFamilyListWithCode!.length,
        (index) => productsFamilyListWithCode![index]
            .substring(0, productsFamilyListWithCode![index].indexOf('-')));
  }

  Future<ResultModel> onSearch(bool isMouted) async {
    if (selectedCustomerModel == null) {
      return ResultModel(false);
    }
    assert(selectedCustomerModel != null);
    isLoadData = true;
    if (isMouted) {
      notifyListeners();
    }
    final isLogin = CacheService.getIsLogin();
    var spart =
        productsFamilyListWithCode != null && selectedProductsFamily != null
            ? productsFamilyListWithCode!
                .where((str) => str.contains(selectedProductsFamily ?? ''))
                .toList()
            : <String>[];

    var vtweg = '10';
    Map<String, dynamic> _body = {
      "methodName": RequestType.SEARCH_TRANSACTION_LEDGER.serverMethod,
      "methodParamMap": {
        "IV_ENDCU": "",
        "IV_KUNNR":
            selectedCustomerModel != null ? selectedCustomerModel!.kunnr : '',
        "IV_VKGRP": "",
        "IV_VTWEG": vtweg,
        "IV_PERNR":
            selectedSalesPerson != null ? selectedSalesPerson!.pernr : '',
        "IV_SPART": spart.isNotEmpty
            ? spart.first.substring(spart.first.indexOf('-') + 1)
            : '',
        "IV_SPMON_S": FormatUtil.monthStr(selectedStartDate!),
        "IV_SPMON_E": FormatUtil.monthStr(selectedEndDate!),
        "IS_LOGIN": isLogin,
        "functionName": RequestType.SEARCH_TRANSACTION_LEDGER.serverMethod,
        "resultTables": RequestType.SEARCH_TRANSACTION_LEDGER.resultTable,
      }
    };
    _api.init(RequestType.SEARCH_TRANSACTION_LEDGER);
    final result = await _api.request(body: _body);
    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }
    if (result.statusCode == 200) {
      var temp = TransLedgerResponseModel.fromJson(result.body['data']);

      pr(temp.tReport?.length == temp.tList?.length);
      pr(temp.esHead!.toJson());
      if (temp.tList!.length != partial) {
        hasMore = false;
      }
      if (transLedgerResponseModel == null) {
        transLedgerResponseModel = temp;
      } else {
        transLedgerResponseModel!.tList!.addAll(temp.tList!);
      }
      if (transLedgerResponseModel != null &&
          (transLedgerResponseModel!.tList == null ||
              transLedgerResponseModel!.tList!.isEmpty)) {
        transLedgerResponseModel = null;
      }
      isLoadData = false;
      isFirstRun = false;
      firstIn = false;
      hasResultData = transLedgerResponseModel != null &&
          transLedgerResponseModel!.tList!.isNotEmpty;
      notifyListeners();
      return ResultModel(true, data: hasResultData);
    }
    return ResultModel(false);
  }
}
