/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/provider/base_one_cell_popup_provider.dart
 * Created Date: 2021-10-17 23:22:48
 * Last Modified: 2022-07-06 11:00:43
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:bpom/view/common/base_popup_list.dart';

typedef AddressSelectedCity = String Function();

class OneCellPopupProvider extends ChangeNotifier {
  String? agencyTextControllerText;
  bool isLoadData = false;
  // bool ismounted = false;
  String? selectedCity;
  List<bool> checkBoxValueList = [];
  Future<bool> initCheckBoxList(List<String> dataList,
      {CheckBoxDefaultValue? checkBoxDefaultValue}) async {
    if (checkBoxDefaultValue != null) {
      var temp = await checkBoxDefaultValue.call();
      checkBoxValueList = temp;
      print(checkBoxValueList);
      return true;
    } else {
      dataList.forEach((data) {
        checkBoxValueList.add(false);
      });
      return true;
    }
  }

  void setAgencyTextControllerText(String str) {
    this.agencyTextControllerText = str;
    notifyListeners();
  }

  void whenTheCheckBoxValueChanged(int index) {
    checkBoxValueList[index] = !checkBoxValueList[index];
    notifyListeners();
  }
}

class BaseOneCellResult {
  bool isSuccessful;
  BaseOneCellResult(this.isSuccessful);
}
