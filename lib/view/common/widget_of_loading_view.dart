/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_loading_view_on_stack_widget.dart
 * Created Date: 2021-10-20 22:21:27
 * Last Modified: 2022-07-06 10:33:13
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/styles/export_common.dart';

class BaseLoadingViewOnStackWidget {
  static build(BuildContext context, bool isLoadData,
      {double? height, double? width, Color? color}) {
    return isLoadData
        ? Container(
            height: height ?? AppSize.realHeight,
            width: width ?? AppSize.realWidth,
            color: color ?? AppColors.defaultText.withOpacity(.4),
            child: Column(
              mainAxisAlignment: height != null
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                height != null
                    ? Padding(padding: EdgeInsets.only(top: height * .3))
                    : Container(),
                SizedBox(
                  height: AppSize.defaultIconWidth * 1.5,
                  width: AppSize.defaultIconWidth * 1.5,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              ],
            ))
        : Container();
  }
}
