/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_widget.dart
 * Created Date: 2021-08-19 11:37:50
 * Last Modified: 2022-10-02 16:52:24
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
      this.unFoucsCallback,
      this.onwillpopCallback,
      this.onWillPopResult,
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
  final OnwillpopCallback? onwillpopCallback;
  final bool? onWillPopResult;

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
              onWillPop: () async {
                if (onwillpopCallback != null && onwillpopCallback!.call()) {
                  final result = await AppDialog.showPopup(
                      context,
                      WillPopScope(
                          child: buildDialogContents(
                            context,
                            SizedBox(
                              height: AppSize.singlePopupHeight -
                                  AppSize.buttonHeight,
                              child: Center(
                                child: AppText.listViewText(
                                    '${tr('is_exit_current_page')}',
                                    style: context
                                        .read<AppThemeProvider>()
                                        .themeData
                                        .textTheme
                                        .headline3!),
                              ),
                            ),
                            false,
                            AppSize.singlePopupHeight,
                            leftButtonText: '${tr('cancel')}',
                            rightButtonText: '${tr('ok')}',
                          ),
                          onWillPop: () async => false));
                  result as bool;
                  if (result) {
                    Navigator.pop(context, onWillPopResult);
                  }
                }
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
                            unFoucsCallback?.call();
                          }()
                        : DoNothingAction();
                  },
                  child: child)),
    );
  }
}
