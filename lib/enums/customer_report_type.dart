/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums/customer_report_type.dart
 * Created Date: 2021-10-17 19:01:13
 * Last Modified: 2022-01-28 09:12:17
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

//* appBar에 state가 있는 페이지의 구분자.
//* title / icon / action 등 사전에 정의 후 사용.

enum PageType {
  CONSULTATION_REPORT_EDIT,
  CONSULTATION_REPORT_DEFAULT,
  CONSULTATION_REPORT_REGISTER,
  CUSTOMER_MANAGER_REGISTER,
  CUSTOMER_MANAGER_EDIT,
  POTENTIAL_CUSTOMERS_REGISTER,
  POTENTIAL_CUSTOMERS_EDIT,
  SALES_ORDER_CREATE,
  SALES_ORDER_EDIT,
  SALES_ORDER_ITEM_EDIT,
  SALES_ORDER_ITEM_ADD,
  SALES_ORDER_ITEM,
}

extension ConsultationReportExtension on PageType {
  Widget get actionWidget {
    switch (this) {
      case PageType.CONSULTATION_REPORT_DEFAULT:
        return Container();
      default:
        return Container();
    }
  }

  Icon get leadingIcon {
    switch (this) {
      case PageType.CONSULTATION_REPORT_DEFAULT:
        return Icon(Icons.arrow_back_ios_new_sharp);
      default:
        return Icon(Icons.close);
    }
  }

  String get appBarTitle {
    switch (this) {
      case PageType.CONSULTATION_REPORT_DEFAULT:
        return '${tr('search_recent_consultation_report_info')}';
      case PageType.CONSULTATION_REPORT_EDIT:
        return '${tr('edit_recent_consultation_report')}';
      case PageType.CONSULTATION_REPORT_REGISTER:
        return '${tr('consultation_report_register')}';
      case PageType.CUSTOMER_MANAGER_EDIT:
        return '${tr('appbar_manager_edit')}';
      case PageType.CUSTOMER_MANAGER_REGISTER:
        return '${tr('customer_manager_register')}';
      case PageType.POTENTIAL_CUSTOMERS_EDIT:
        return '${tr('appbar_opportunity_edit')}';
      case PageType.POTENTIAL_CUSTOMERS_REGISTER:
        return '${tr('appbar_opportunity')}';
      case PageType.SALES_ORDER_CREATE:
        return '${tr('sales_order_detail')}';
      case PageType.SALES_ORDER_EDIT:
        return '${tr('sales_order_edit')}';
      default:
        return '';
    }
  }
}
