/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_widget.dart
 * Created Date: 2021-08-19 11:37:50
 * Last Modified: 2022-11-04 18:20:43
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bpom/styles/export_common.dart';
import 'package:bpom/view/common/fountion_of_hidden_key_borad.dart';

typedef IsShowAppBarCallBack = bool Function();
typedef OnwillpopCallback = bool Function();

class BaseLayout extends StatelessWidget {
  BaseLayout(
      {required this.hasForm, this.appBar,
      this.isWithWillPopScope,
      this.isWithBottomSafeArea,
      this.isWithRightSafeArea,
      this.isWithLeftSafeArea,
      this.isWithTopSafeArea,
      this.isResizeToAvoidBottomInset,
      this.isShowAppBarCallBack,
      this.bgColog,
      required this.child,
      this.willpopCallback,
      Key? key})
      : super(key: key);
  final Widget child;
  final IsShowAppBarCallBack? isShowAppBarCallBack;
  final bool hasForm;
  final AppBar? appBar;
  final bool? isWithBottomSafeArea;
  final bool? isWithRightSafeArea;
  final bool? isWithLeftSafeArea;
  final bool? isWithTopSafeArea;

  final bool? isResizeToAvoidBottomInset;
  final Color? bgColog;
  final OnwillpopCallback? willpopCallback;
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
                return willpopCallback != null
                    ? willpopCallback!.call()
                    : false;
              })
          : SafeArea(
              bottom: Platform.isIOS
                  ? isWithBottomSafeArea ?? false
                  : isWithBottomSafeArea ?? true,
              right: isWithRightSafeArea ?? false,
              left: isWithLeftSafeArea ?? false,
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
