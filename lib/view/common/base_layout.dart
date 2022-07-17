/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_widget.dart
 * Created Date: 2021-08-19 11:37:50
 * Last Modified: 2022-07-17 11:20:22
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

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
                  bottom: isWithBottomSafeArea ?? false,
                  child: GestureDetector(
                      onTap: () {
                        hasForm ? hideKeyboard(context) : DoNothingAction();
                      },
                      child: child)),
              onWillPop: () async => false)
          : SafeArea(
              bottom: isWithBottomSafeArea ?? false,
              child: GestureDetector(
                  onTap: () {
                    hasForm ? hideKeyboard(context) : DoNothingAction();
                  },
                  child: child)),
    );
  }
}
