/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/view/common/next_page_loading_widget.dart
 * Created Date: 2022-01-24 23:26:31
 * Last Modified: 2022-07-02 14:09:00
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/styles/app_colors.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/view/common/provider/next_page_loading_provider.dart';
import 'package:provider/provider.dart';

class NextPageLoadingWdiget {
  static Widget build(BuildContext context) {
    return Consumer<NextPageLoadingProvider>(builder: (context, provider, _) {
      return provider.isShowLoading
          ? Padding(
              padding: EdgeInsets.only(top: AppSize.defaultListItemSpacing),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox.fromSize(
                      size: Size(20, 20),
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        color: AppColors.primary,
                      ))))
          : Container();
    });
  }
}
