/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums/customer_report_type.dart
 * Created Date: 2021-10-17 19:01:13
 * Last Modified: 2022-08-04 13:55:02
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bpom/styles/app_colors.dart';
import 'package:bpom/styles/app_size.dart';
import 'package:bpom/styles/app_text.dart';
import 'package:bpom/styles/app_text_style.dart';

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
          height: AppSize.appBarHeight,
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: AppSize.padding),
          child: AppText.text(tr('confirm'),
              style:
                  AppTextStyle.default_16.copyWith(color: AppColors.primary)),
        );
      case PageType.SALES_ACTIVITY_MANAGER_DAY_DISIBLE:
        return Container(
            child: Container(
          height: AppSize.appBarHeight,
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: AppSize.padding),
          child: AppText.text(
            tr('confirm'),
            style: AppTextStyle.default_16.copyWith(color: AppColors.subText),
          ),
        ));
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
