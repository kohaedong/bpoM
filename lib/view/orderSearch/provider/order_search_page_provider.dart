/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderSearch/provider/order_search_page_provider.dart
 * Created Date: 2022-07-05 09:58:33
 * Last Modified: 2022-07-11 13:46:38
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
import 'package:medsalesportal/model/commonCode/is_login_model.dart';
import 'package:medsalesportal/model/rfc/et_customer_model.dart';
import 'package:medsalesportal/model/rfc/et_customer_response_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/model/rfc/search_order_response_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class OrderSearchPageProvider extends ChangeNotifier {
  bool isLoadData = false;
  bool isTeamLeader = false;
  String? staffName;
  String? selectedStartDate;
  String? selectedEndDate;
  String? selectedProcessingStatus;
  String? selectedProductsFamily;
  String? customerName;
  EtStaffListModel? selectedSalesPerson;
  EtCustomerModel? selectedCustomerModel;
  EtCustomerResponseModel? searchResponseModel;
  SearchOrderResponseModel? searchOrderResponseModel;
  List<String>? processingStatusListWithCode;
  List<String>? productsFamilyListWithCode;
  IsLoginModel? isLoginModel;
  int pos = 0;
  int partial = 30;
  bool hasMore = false;
  final _api = ApiService();
  Future<void> refresh() async {
    pos = 0;
    hasMore = true;
    searchResponseModel = null;
    onSearch(true);
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

  Future<void> initPageData() async {
    setIsLoginModel();
    selectedStartDate = DateUtil.prevWeek();
    selectedEndDate = DateUtil.now();
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
    notifyListeners();
  }

  void setStaffName(String? str) {
    staffName = str;
    notifyListeners();
  }

  void setSalesPerson(dynamic str) {
    str as EtStaffListModel;
    selectedSalesPerson = str;
    staffName = selectedSalesPerson!.sname;
    notifyListeners();
  }

  void setCustomerModel(dynamic str) {
    str as EtCustomerModel;
    selectedCustomerModel = str;
    customerName = selectedCustomerModel!.kunnrNm;
    notifyListeners();
  }

  void setProcessingStatus(String? str) {
    selectedProcessingStatus = str;
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
    isLoadData = true;
    if (isMouted) {
      notifyListeners();
    }
    final isLogin = CacheService.getIsLogin();
    final esLogin = CacheService.getEsLogin();
    Map<String, dynamic> _body = {
      "methodName": RequestType.SEARCH_SALSE_ACTIVITY.serverMethod,
      "methodParamMap": {
        "IV_SANUM": isTeamLeader
            ? staffName == tr('all')
                ? ''
                : selectedSalesPerson!.logid
            : esLogin!.logid,
        "IV_ORGHK": esLogin!.orghk,
        "IV_ZSKUNNR":
            selectedCustomerModel != null ? selectedCustomerModel!.kunnr : '',
        "IV_FRDAT": FormatUtil.removeDash(selectedStartDate!),
        "IV_TODAT": FormatUtil.removeDash(selectedEndDate!),
        "pos": pos,
        "partial": partial,
        "IS_LOGIN": isLogin,
        "functionName": RequestType.SEARCH_SALSE_ACTIVITY.serverMethod,
        "resultTables": RequestType.SEARCH_SALSE_ACTIVITY.resultTable,
      }
    };
    _api.init(RequestType.SEARCH_SALSE_ACTIVITY);
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      var temp = SearchOrderResponseModel.fromJson(result.body['data']);
      pr(temp.toJson());
      if (temp.tList!.length != partial) {
        hasMore = false;
      }
      if (searchOrderResponseModel == null) {
        searchOrderResponseModel = temp;
      } else {
        searchOrderResponseModel!.tList!.addAll(temp.tList!);
      }
      if (searchOrderResponseModel != null &&
          (searchOrderResponseModel!.tList == null ||
              searchOrderResponseModel!.tList!.isEmpty)) {
        searchOrderResponseModel = null;
      }
      isLoadData = false;
      notifyListeners();
      return ResultModel(true);
    }
    return ResultModel(false);
  }
}
