/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/customer_info_top_widget.dart
 * Created Date: 2021-09-16 11:49:56
 * Last Modified: 2022-07-06 10:33:13
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/provider/app_theme_provider.dart';

class CustomerinfoWidget {
  static Widget buildCustomerTopRow(
      BuildContext context, String data, String data2) {
    return Container(
      height: AppSize.searchCustomerTopWidgetHeight,
      child: Padding(
        padding: AppSize.defaultSidePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.text('$data',
                style: context
                    .read<AppThemeProvider>()
                    .themeData
                    .textTheme
                    .headline1!),
            AppText.text('$data2',
                style: context
                    .read<AppThemeProvider>()
                    .themeData
                    .textTheme
                    .headline2!)
          ],
        ),
      ),
    );
  }

  static Widget buildSubTitle(BuildContext context, String text) {
    return Container(
        alignment: Alignment.centerLeft,
        height: AppSize.searchCustomerSubTitleHeight,
        width: AppSize.realWidth,
        color: AppColors.homeBgColor,
        child: Padding(
            padding: AppSize.defaultSidePadding,
            child: AppText.text(text, style: AppTextStyle.w500_14)));
  }

  static Widget buildDividingLine() {
    return Container(
      alignment: Alignment.centerLeft,
      height: AppSize.defaultLineHeight,
      width: AppSize.realWidth,
      color: AppColors.homeBgColor,
    );
  }
}
