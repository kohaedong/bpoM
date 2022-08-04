/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums/customer_report_type.dart
 * Created Date: 2021-10-17 19:01:13
 * Last Modified: 2022-08-04 12:21:52
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/styles/app_text.dart';

//* appBar에 state가 있는 페이지의 구분자.
//* title / icon / action 등 사전에 정의 후 사용.

enum PageType {
  SALES_ACTIVITY_MANAGER_DAY,
  SALES_ACTIVITY_MANAGER_DAY_DISIBLE,
  DEFAULT,
}

extension ConsultationReportExtension on PageType {
  Widget get actionWidget {
    switch (this) {
      case PageType.SALES_ACTIVITY_MANAGER_DAY:
        return Container(
          child: AppText.text('manager'),
        );
      case PageType.SALES_ACTIVITY_MANAGER_DAY_DISIBLE:
        return Container(
          child: AppText.text('disible'),
        );
      default:
        return Container();
    }
  }

  Icon get leadingIcon {
    switch (this) {
      default:
        return Icon(Icons.close);
    }
  }

  String get appBarTitle {
    switch (this) {
      default:
        return '';
    }
  }
}
