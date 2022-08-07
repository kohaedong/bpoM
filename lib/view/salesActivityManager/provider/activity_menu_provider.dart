/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/menu_provider.dart
 * Created Date: 2022-08-04 23:17:24
 * Last Modified: 2022-08-07 14:38:37
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class ActivityMenuProvider extends ChangeNotifier {
  SalesActivityDayResponseModel? editModel;
  void saveEditModel(SalesActivityDayResponseModel fromParentWindowModel) {
    editModel =
        SalesActivityDayResponseModel.fromJson(fromParentWindowModel.toJson());
    pr(editModel?.toJson());
  }
}
