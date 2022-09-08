/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/provider/add_order_popup_provider.dart
 * Created Date: 2022-09-04 17:56:07
 * Last Modified: 2022-09-08 12:47:10
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/model/rfc/order_manager_material_model.dart';
import 'package:medsalesportal/styles/app_size.dart';

class AddOrderPopupProvider extends ChangeNotifier {
  double height = AppSize.realHeight * .5;
  OrderManagerMaterialModel? selectedMateria;
  String? quantity;
  String? surcharge;
  void setHeight(double val) {
    height = val;
    notifyListeners();
  }

  void setMaterial(OrderManagerMaterialModel? mat) {
    selectedMateria = mat;
    notifyListeners();
  }

  void setQuantity(String? str) {
    quantity = str;
    notifyListeners();
  }

  void setSurcharge(String? str) {
    surcharge = str;
    notifyListeners();
  }
}
