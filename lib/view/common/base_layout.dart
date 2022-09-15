/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_widget.dart
 * Created Date: 2021-08-19 11:37:50
 * Last Modified: 2022-09-15 09:58:02
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medsalesportal/styles/app_colors.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';

typedef IsShowAppBarCallBack = bool Function();

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
      this.unFoucsCallback,
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
  final Function? unFoucsCallback;

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
                                unFoucsCallback?.call();
                              }()
                            : DoNothingAction();
                      },
                      child: child)),
              onWillPop: () async => false)
          : SafeArea(
              bottom: Platform.isIOS
                  ? isWithBottomSafeArea ?? false
                  : isWithBottomSafeArea ?? true,
              child: GestureDetector(
                  onTap: () {
                    hasForm
                        ? () {
                            hideKeyboard(context);
                            unFoucsCallback?.call();
                          }()
                        : DoNothingAction();
                  },
                  child: child)),
    );
  }
}
