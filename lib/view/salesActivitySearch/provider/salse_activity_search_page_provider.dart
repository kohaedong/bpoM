/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activitySearch/provider/activity_search_page_provider.dart
 * Created Date: 2022-07-05 09:51:16
 * Last Modified: 2022-07-06 17:01:24
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/commonCode/is_login_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/util/encoding_util.dart';

class SalseSalseActivitySearchPageProvider extends ChangeNotifier {
  bool isLoadData = false;
  bool isFirstIn = true;
  bool isTeamLeader = false;
  String? selectedCompanyDistribution;
  String? managerName;
  String? selectedBusinessGroup;
  String? selectedStartDate;
  String? selectedEndDate;
  String? selectedOrderNumber;
  String? selectedDeliveryNumber;

  String? selectedOrgCode;
  String? selectedBusinessGroupCode;
  EtStaffListModel? selectedSalesPerson;
  IsLoginModel? isLoginModel;
  int pos = 0;
  int partial = 30;
  bool hasMore = false;

  Future<void> refresh() async {
    pos = 0;
    hasMore = true;
    // model = null;
    onSearch(true);
  }

  bool get isValidate =>
      selectedCompanyDistribution != null &&
      managerName != null &&
      selectedBusinessGroup != null &&
      selectedStartDate != null &&
      selectedEndDate != null;
  Future<ResultModel?> nextPage() async {
    if (hasMore) {
      pos = partial + pos;
      return onSearch(false);
    }
    return null;
  }

  Future<void> initPageData() async {
    var esLogin = CacheService.getEsLogin();
    setIsLoginModel();
    selectedCompanyDistribution = esLogin!.bukrs;
    selectedStartDate = DateUtil.prevWeek();
    selectedEndDate = DateUtil.now();
  }

  void setIsLoginModel() async {
    var isLogin = CacheService.getIsLogin();
    isLoginModel = EncodingUtils.decodeBase64ForIsLogin(isLogin!);
    isTeamLeader = isLoginModel!.xtm == 'X';
    managerName = isLoginModel!.ename;
  }

  void setStartDate(BuildContext context, String? str) {
    DateUtil.checkDateIsBefore(context, str, selectedEndDate).then((before) {
      if (before) {
        this.selectedStartDate = str;
        notifyListeners();
      }
    });
  }

  void setSalesPerson(dynamic str) {
    str as EtStaffListModel;
    selectedSalesPerson = str;
    managerName = selectedSalesPerson!.sname;
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

  Future<ResultModel> onSearch(bool isMouted) async {
    return ResultModel(false);
  }
}
