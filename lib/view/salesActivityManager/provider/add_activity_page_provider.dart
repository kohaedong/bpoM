/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/add_activity_page_provider.dart
 * Created Date: 2022-08-11 11:12:00
 * Last Modified: 2022-08-15 13:31:07
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/model/rfc/add_activity_key_man_model.dart';
import 'package:medsalesportal/model/rfc/add_activity_key_man_response_model.dart';
import 'package:medsalesportal/model/rfc/et_kunnr_model.dart';
import 'package:medsalesportal/model/rfc/et_kunnr_response_model.dart';

class AddActivityPageProvider extends ChangeNotifier {
  EtKunnrResponseModel? etKunnrResponseModel;
  AddActivityKeyManResponseModel? keyManResponseModel;
  bool isVisit = false;
  EtKunnrModel? selectedKunnr;
  AddActivityKeyManModel? selectedKeyMan;

  void setIsVisit(bool val) {
    isVisit = val;
    notifyListeners();
  }

  void setCustomerModel(EtKunnrModel? model) {
    selectedKunnr = model;
    notifyListeners();
  }

  void setKeymanModel(AddActivityKeyManModel? model) {
    selectedKeyMan = model;
    notifyListeners();
  }
}
