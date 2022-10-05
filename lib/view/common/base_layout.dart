/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_widget.dart
 * Created Date: 2021-08-19 11:37:50
 * Last Modified: 2022-10-06 05:07:50
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/globalProvider/app_theme_provider.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/dialog_contents.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';
import 'package:provider/provider.dart';

typedef IsShowAppBarCallBack = bool Function();
typedef OnwillpopCallback = bool Function();

class BaseLayout extends StatelessWidget {
  BaseLayout(
      {required this.hasForm,
      required this.appBar,
      this.isWithWillPopScope,
      this.isWithBottomSafeArea,
      this.isResizeToAvoidBottomInset,
      this.isShowAppBarCallBack,
      this.bgColog,
      required this.child,
      Key? key})
      : super(key: key);
  final Widget child;
  final IsShowAppBarCallBack? isShowAppBarCallBack;
  final bool hasForm;
  final AppBar? appBar;
  final bool? isWithBottomSafeArea;
  final bool? isResizeToAvoidBottomInset;
  final Color? bgColog;
  final bool? isWithWillPopScope;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: isResizeToAvoidBottomInset ?? true,
      backgroundColor: bgColog ?? AppColors.whiteText,
      appBar: isShowAppBarCallBack != null
          ? isShowAppBarCallBack!.call()
              ? appBar
              : null
          : appBar,
      body: isWithWillPopScope != null
          ? WillPopScope(
              child: SafeArea(
                  bottom: Platform.isIOS
                      ? isWithBottomSafeArea ?? false
                      : isWithBottomSafeArea ?? true,
                  child: GestureDetector(
                      onTap: () {
                        hasForm
                            ? () {
                                hideKeyboard(context);
                              }()
                            : DoNothingAction();
                      },
                      child: child)),
              onWillPop: () async {
                return false;
              })
          : SafeArea(
              bottom: Platform.isIOS
                  ? isWithBottomSafeArea ?? false
                  : isWithBottomSafeArea ?? true,
              child: GestureDetector(
                  onTap: () {
                    hasForm
                        ? () {
                            hideKeyboard(context);
                          }()
                        : DoNothingAction();
                  },
                  child: child)),
    );
  }
}
