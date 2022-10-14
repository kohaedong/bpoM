/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/app_toast.dart
 * Created Date: 2021-10-01 14:02:55
 * Last Modified: 2022-10-14 16:12:04
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/globalProvider/timer_provider.dart';

class AppToast {
  final FToast? fToast;
  factory AppToast() => _sharedInstance();
  static AppToast? _instance;
  AppToast._(this.fToast);
  static AppToast _sharedInstance() {
    _instance ??= AppToast._(FToast());
    return _instance!;
  }

  show(BuildContext context, String str, {bool? show}) {
    try {
      fToast!.init(context);
    } catch (e) {
      pr(e);
    }
    Widget toast = Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: AppSize.padding),
        width: AppSize.defaultContentsWidth,
        height:
            str.length > 40 ? AppSize.buttonHeight * 1.4 : AppSize.buttonHeight,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: AppColors.shadowColor,
                  offset: Offset(0, 4),
                  blurRadius: 20,
                  spreadRadius: -6)
            ],
            color: AppColors.textFieldUnfoucsColor,
            borderRadius: BorderRadius.all(Radius.circular(AppSize.radius8))),
        child: AppText.text(
          str,
          style: AppTextStyle.default_14.copyWith(color: AppColors.whiteText),
          maxLines: 3,
        ));
    final tp = context.read<TimerProvider>();
    if (tp.lastToastText == null || tp.lastToastText != str) {
      tp.setLastToastText(str);
      return fToast!.showToast(
        child: toast,
        gravity: ToastGravity.TOP,
        toastDuration: const Duration(seconds: 4),
      );
    } else if (!tp.isToastRunnint) {
      return tp.toastprocess(() {
        fToast!.showToast(
          child: toast,
          gravity: ToastGravity.TOP,
          toastDuration: const Duration(seconds: 4),
        );
      });
    }
  }
}
