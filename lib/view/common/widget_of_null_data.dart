/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_null_data_widget.dart
 * Created Date: 2021-09-18 18:25:35
 * Last Modified: 2022-09-28 19:40:47
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bpom/styles/export_common.dart';

class BaseNullDataWidget {
  static Widget build(BuildContext context,
      {String? message, TextStyle? style, bool? isForSearchResult}) {
    return Container(
        constraints: BoxConstraints(
            maxHeight: AppSize.realHeight -
                AppSize.appBarHeight -
                AppSize.bottomSafeAreaHeight(context) -
                AppSize.topSafeAreaHeight(context) -
                AppSize.buttonHeight * 2),
        child: message != null
            ? Container(
                alignment: Alignment.center,
                child:
                    AppText.text('$message', style: style ?? AppTextStyle.h4),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText.text(
                      isForSearchResult != null && isForSearchResult
                          ? tr('not_search_result')
                          : '${tr('no_data')}',
                      style: style ?? AppTextStyle.h4),
                  // AppStyles.text(
                  //    '${tr('plz_check_condition')}', AppTextStyle.default_14),
                ],
              ));
  }
}
