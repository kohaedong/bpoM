/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/app_toast.dart
 * Created Date: 2021-10-01 14:02:55
 * Last Modified: 2022-07-05 16:54:04
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medsalesportal/styles/export_common.dart';

class AppToast {
  final FToast? fToast;
  factory AppToast() => _sharedInstance();
  static AppToast? _instance;
  AppToast._(this.fToast);
  static AppToast _sharedInstance() {
    if (_instance == null) {
      _instance = AppToast._(FToast());
    }
    return _instance!;
  }

  show(BuildContext context, String str) {
    fToast!.init(context);
    Widget toast = Container(
        alignment: Alignment.center,
        width: AppSize.defaultContentsWidth,
        height: AppSize.buttonHeight,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadowColor,
                  offset: Offset(0, 4),
                  blurRadius: 20,
                  spreadRadius: -6)
            ],
            color: AppColors.textFieldUnfoucsColor,
            borderRadius: BorderRadius.all(Radius.circular(AppSize.radius8))),
        child: AppText.text('$str',
            style: AppTextStyle.color14(AppColors.whiteText)));
    fToast!.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
  }
}
