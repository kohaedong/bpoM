/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/globalProvider/app_auth_provider.dart
 * Created Date: 2022-09-22 20:26:29
 * Last Modified: 2022-09-24 20:33:40
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/model/rfc/et_orghk_model.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class AppAuthProvider extends ChangeNotifier {
  List<EtOrghkModel?> salseGroupList = [];
  void setSsalseGroupList(List<EtOrghkModel> list) {
    salseGroupList.clear();
    salseGroupList = list;
    notifyListeners();
  }

  bool get isPermidedSalseGroup {
    var esLogin = CacheService.getEsLogin();
    pr(esLogin!.toJson());
    if (salseGroupList.isEmpty) {
      return false;
    } else {
      return salseGroupList
          .where((group) => group!.orghk == esLogin.orghk)
          .toList()
          .isNotEmpty;
    }
  }
}
