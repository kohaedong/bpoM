/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/provider/order_manager_page_provider.dart
 * Created Date: 2022-07-05 09:57:03
 * Last Modified: 2022-08-21 11:40:26
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/service/hive_service.dart';

class OrderManagerPageProvider extends ChangeNotifier {
  String? selectedSalseGroup;
  String? selectedStaffName;
  String? selectedSalseChannel;
  String? selectedProductFamily;
  String? selectedSalseOffice;
  String? selectedSupplier;
  String? selectedEndCustomer;
  String? deliveryConditionInputText;
  String? orderDescriptionDetailInputText;
  List<String>? productBusinessDataList;
  List<String>? productFamilyDataList;
  void setSalseGroup(String str) {
    selectedSalseGroup = str;
    notifyListeners();
  }

  void setStaffName(String str) {
    selectedStaffName = str;
    notifyListeners();
  }

  void setSalseChannel(String str) {
    selectedSalseChannel = str;
    notifyListeners();
  }

  void setProductFamily(String str) {
    selectedSalseGroup = str;
    notifyListeners();
  }

  void setSalseOffice(String str) {
    selectedSalseOffice = str;
    notifyListeners();
  }

  void setSupplier(String str) {
    selectedSupplier = str;
    notifyListeners();
  }

  void setEndCustomer(String str) {
    selectedEndCustomer = str;
    notifyListeners();
  }

  void setDeliveryCondition(String str) {
    deliveryConditionInputText = str;
  }

  void setOrderDescriptionDetai(String str) {
    orderDescriptionDetailInputText = str;
  }

  Future<List<String>?> getSalesGroup({bool? isFirstRun}) async {
    // isSuperAccount.
    productBusinessDataList = await HiveService.getSalesGroup();
    var dataStr = <String>[];
    productBusinessDataList!.forEach((data) {
      dataStr.add(data.substring(0, data.indexOf('-')));
    });
    return dataStr;
  }
}
