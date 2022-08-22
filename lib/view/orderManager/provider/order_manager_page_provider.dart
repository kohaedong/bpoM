/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/provider/order_manager_page_provider.dart
 * Created Date: 2022-07-05 09:57:03
 * Last Modified: 2022-08-21 12:46:49
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/hive_box_type.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/util/hive_select_data_util.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

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
  List<String>? groupDataList;
  List<String>? productFamilyDataList;
  EtStaffListModel? selectedSalsePerson;
  void setSalseGroup(String str) {
    selectedSalseGroup = str;
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

  void setSalsePerson(saler) {
    saler as EtStaffListModel?;
    selectedSalsePerson = saler;
    selectedStaffName = selectedSalsePerson!.sname;
    notifyListeners();
  }

  Future<List<String>?> getSalesGroup({bool? isFirstRun}) async {
    // isSuperAccount.
    groupDataList = await HiveService.getSalesGroup();
    var dataStr = <String>[];
    groupDataList!.forEach((data) {
      dataStr.add(data.substring(0, data.indexOf('-')));
    });
    return dataStr;
  }

  Future<List<String>?> getChannelFromDB() async {
    var temp = groupDataList!
        .where((item) => item.contains(selectedSalseGroup!))
        .single;
    pr(temp.substring(temp.indexOf('-') + 1));
    final resultList = await HiveSelectDataUtil.select(HiveBoxType.T_VALUE,
        tvalueConditional: (tValue) {
      return tValue.tname == 'H_TVKOV' && tValue.helpValues!.isNotEmpty;
    }, searchLevel: 2, group1SearchKey: '');

    return resultList.strList;
  }
}
