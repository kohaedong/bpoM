/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/bulkOrderSearch/provider/bulk_order_search_page_provider.dart
 * Created Date: 2022-07-05 09:54:29
 * Last Modified: 2022-10-18 19:48:39
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/enums/account_type.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/util/is_super_account.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/et_customer_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/model/commonCode/is_login_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_response_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_et_t_list_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_response_model.dart';

class BulkOrderSearchPageProvider extends ChangeNotifier {
  bool isLoadData = false;
  bool isFirstRun = true;
  bool? hasResultData;
  String? staffName;
  String? selectedStartDate;
  String? selectedEndDate;
  String? selectedOrderStatus;
  String? selectedProductsFamily;
  String? customerName;
  EtStaffListModel? selectedSalesPerson;
  EtCustomerModel? selectedCustomerModel;
  BulkOrderResponseModel? bulkOrderResponseModel;
  List<String>? orderStatusListWithCode;
  List<String>? productsFamilyListWithCode;
  IsLoginModel? isLoginModel;
  Map<String, List<BulkOrderEtTListModel>> orderSetRef = {};

  int pos = 0;
  int partial = 100;
  bool hasMore = false;
  final _api = ApiService();
  Future<ResultModel> refresh() async {
    pos = 0;
    hasMore = true;
    bulkOrderResponseModel = null;
    orderSetRef = {};
    return onSearch(true);
  }

  bool get isValidate =>
      staffName != null && selectedStartDate != null && selectedEndDate != null;
  Future<ResultModel?> nextPage() async {
    if (hasMore) {
      pos = partial + pos;
      return onSearch(false);
    }
    return null;
  }

  Future<ResultModel> searchPerson() async {
    var _api = ApiService();
    final isLogin = CacheService.getIsLogin();
    final esLogin = CacheService.getEsLogin();
    Map<String, dynamic>? body;
    body = {
      "methodName": RequestType.SEARCH_STAFF.serverMethod,
      "methodParamMap": {
        "IV_SALESM": "",
        "IV_SNAME": '',
        "IV_DPTNM": esLogin!.dptnm,
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
      var staffList =
          temp.staffList!.where((model) => model.sname == staffName).toList();
      selectedSalesPerson = staffList.isNotEmpty ? staffList.first : null;
      // return ResultModel(true);
    }
    return ResultModel(false);
  }

  Future<ResultModel> initPageData() async {
    setIsLoginModel();
    await searchPerson();
    selectedStartDate = DateUtil.prevWeek();
    selectedEndDate = DateUtil.now();
    orderStatusListWithCode = await HiveService.getOrderStatus();
    selectedProductsFamily = tr('all');
    selectedOrderStatus = tr('all');
    isFirstRun = false;
    return onSearch(true);
  }

  void setIsLoginModel() async {
    var isLogin = CacheService.getIsLogin();
    isLoginModel = EncodingUtils.decodeBase64ForIsLogin(isLogin!);

    if (CacheService.getAccountType() == AccountType.MULTI ||
        CacheService.getAccountType() == AccountType.LEADER) {
      staffName = tr('all');
    } else {
      staffName = isLoginModel!.ename;
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
      pr(selectedCustomerModel);
    }
    notifyListeners();
  }

  void setStaffName(String? str) {
    pr(str);
    staffName = str;
    notifyListeners();
  }

  void setSalesPerson(dynamic str) {
    str as EtStaffListModel;
    selectedSalesPerson = str;
    staffName = selectedSalesPerson!.sname;
    pr(staffName);
    notifyListeners();
  }

  void setCustomerModel(dynamic map) {
    map as Map<String, dynamic>;
    var productsFamily = map['product_family'] as String?;
    var staff = map['staff'] as String?;
    selectedProductsFamily = productsFamily;
    staffName = staff;
    searchPerson();
    var model = map['model'] as EtCustomerModel?;
    selectedCustomerModel = model;
    customerName = selectedCustomerModel?.kunnrNm;

    notifyListeners();
  }

  void setOrderStatus(String? str) {
    selectedOrderStatus = str;
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

  Future<List<String>?> getOrderStatus() async {
    return List.generate(
        orderStatusListWithCode!.length,
        (index) => orderStatusListWithCode![index]
            .substring(0, orderStatusListWithCode![index].indexOf('-')));
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
    isLoadData = true;
    if (isMouted) {
      notifyListeners();
    }
    var spart =
        productsFamilyListWithCode != null && selectedProductsFamily != null
            ? productsFamilyListWithCode!
                .where((str) => str.contains(selectedProductsFamily ?? ''))
                .toList()
            : <String>[];
    var status = orderStatusListWithCode != null && selectedOrderStatus != null
        ? orderStatusListWithCode!
            .where((str) => str.contains(selectedOrderStatus!))
            .toList()
        : <String>[];

    var ptype = 'R';
    var vtweg = '10';
    var isLogin = '';
    var vkorg = '';
    var vkgrp = '';
    if (CheckSuperAccount.isMultiAccount()) {
      final isloginModel =
          EncodingUtils.decodeBase64ForIsLogin(CacheService.getIsLogin()!);
      isLogin = await EncodingUtils.getSimpleIsLogin(isloginModel);
    } else {
      var esLogin = CacheService.getEsLogin();
      isLogin = CacheService.getIsLogin()!;
      vkorg = esLogin!.vkorg!;
      vkgrp = esLogin.vkgrp!;
    }
    Map<String, dynamic> _body = {
      "methodName": RequestType.SEARCH_BULK_ORDER.serverMethod,
      "methodParamMap": {
        "IV_ZZKUNNR_END": "",
        "IV_ZREQNOSAP": "",
        "IV_ZREQNO": "",
        "pos": pos,
        "partial": partial,
        "IV_PTYPE": ptype,
        "IV_VKORG": vkorg,
        "IV_VKGRP": vkgrp,
        "IV_VTWEG": vtweg,
        "IS_LOGIN": isLogin,
        "IV_PERNR": staffName == tr('all')
            ? ''
            : selectedSalesPerson != null
                ? selectedSalesPerson!.pernr
                : '',
        "IV_SPART": spart.isNotEmpty
            ? spart.first.substring(spart.first.indexOf('-') + 1)
            : '',
        "IV_ZDMSTATUS": status.isNotEmpty
            ? status.first.substring(status.first.indexOf('-') + 1)
            : '',
        "IV_KUNNR":
            selectedCustomerModel != null ? selectedCustomerModel!.kunnr : '',
        "IV_ZREQ_DATE_FR": FormatUtil.removeDash(selectedStartDate!),
        "IV_ZREQ_DATE_TO": FormatUtil.removeDash(selectedEndDate!),
        "functionName": RequestType.SEARCH_BULK_ORDER.serverMethod,
        "resultTables": RequestType.SEARCH_BULK_ORDER.resultTable,
      }
    };
    _api.init(RequestType.SEARCH_BULK_ORDER);
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      var temp = BulkOrderResponseModel.fromJson(result.body['data']);
      pr(temp.toJson());
      if (temp.tList!.length != partial) {
        hasMore = false;
      }
      if (bulkOrderResponseModel == null) {
        bulkOrderResponseModel = temp;
        bulkOrderResponseModel!.tList =
            await splitModel(BulkOrderResponseModel.fromJson(temp.toJson()));
      } else {
        var tempResult =
            await splitModel(BulkOrderResponseModel.fromJson(temp.toJson()));
        bulkOrderResponseModel!.tList!.addAll(tempResult!);
      }
      if (bulkOrderResponseModel != null &&
          (bulkOrderResponseModel!.tList == null ||
              bulkOrderResponseModel!.tList!.isEmpty)) {
        bulkOrderResponseModel = null;
      }
      isLoadData = false;
      hasResultData = bulkOrderResponseModel != null &&
          bulkOrderResponseModel!.tList!.isNotEmpty;
      notifyListeners();
      return ResultModel(true, data: hasResultData);
    }
    return ResultModel(false);
  }

  Future<List<BulkOrderEtTListModel>?> splitModel(
      BulkOrderResponseModel temp) async {
    var tempList = temp.tList!;
    var indexList = <int>[];
    var orderSet = <String, List<BulkOrderEtTListModel>>{};
    List.generate(temp.tList!.length, (index) {
      if (index < tempList.length - 1) {
        var current = tempList[index];
        var next = tempList[index + 1];
        var currentOrderNumber = current.zreqno!;
        var nextOrderNumber = next.zreqno!;
        if (currentOrderNumber == nextOrderNumber) {
          pr('${current.vbeln} ${next.vbeln}');
          if (orderSet.keys.contains(currentOrderNumber)) {
            orderSet[currentOrderNumber]!.add(next);
          } else {
            orderSet.putIfAbsent(currentOrderNumber, () => [current, next]);
          }
        }
      }
    });
    pr(orderSet.values);
    // 삭제.
    tempList.removeWhere((order) {
      if (orderSet.keys.contains(order.zreqno)) {}
      indexList.add(tempList.indexWhere((element) => element == order));
      return orderSet.keys.contains(order.zreqno);
    });

    BulkOrderEtTListModel? newModel;
    orderSetRef.addAll(orderSet);
    orderSet.forEach((key, value) {
      newModel = BulkOrderEtTListModel.fromJson(value.first.toJson());
      List.generate(value.length, (index) {
        if (index < value.length - 1) {
          // newModel!.maktx = newModel!.maktx! + ',${value[index + 1].maktx}';
          // newModel!.netwr = newModel!.netwr! + value[index + 1].netwr!;
          // newModel!.mwsbp = newModel!.mwsbp! + value[index + 1].mwsbp!;
        }
      });
      tempList.insert(tempList.length - 1, newModel!);
    });
    return tempList;
  }
}
