/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/app_bar.dart
 * Created Date: 2021-08-29 19:57:10
 * Last Modified: 2022-10-13 07:41:04
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bpom/styles/export_common.dart';
import 'package:bpom/view/common/base_app_dialog.dart';
import 'package:bpom/view/common/dialog_contents.dart';

typedef IsEditPageCallBack = Function();

class MainAppBar extends AppBar {
  final Widget? titleText;
  final Widget? action;
  final Function? callback;
  final Widget? icon;
  final bool? isDisableUpdate;
  final Function? actionCallback;
  final IsEditPageCallBack? cachePageTypeCallBack;
  MainAppBar(
    BuildContext context, {
    this.titleText,
    this.action,
    this.callback,
    this.icon,
    this.isDisableUpdate,
    this.actionCallback,
    this.cachePageTypeCallBack,
  }) : super(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: AppColors.whiteText,
            iconTheme: IconThemeData(
                color: titleText == null
                    ? AppColors.whiteText
                    : AppColors.appBarIconColor),
            toolbarHeight: AppSize.appBarHeight,
            leading: IconButton(
                onPressed: () async {
                  if (cachePageTypeCallBack != null &&
                      cachePageTypeCallBack.call()) {
                    final result = await AppDialog.showPopup(
                        context,
                        WillPopScope(
                            child: buildTowButtonTextContents(
                              context,
                              '${tr('is_exit_current_page')}',
                            ),
                            onWillPop: () async => false));
                    result as bool;
                    if (result) {
                      Navigator.pop(context, isDisableUpdate ?? true);
                    }
                  } else {
                    if (callback != null) {
                      callback.call();
                    } else {
                      Navigator.pop(context);
                    }
                  }
                },
                icon: icon ?? Icon(Icons.arrow_back_ios_new)),
            title: titleText,
            elevation: 0,
            titleSpacing: 0,
            centerTitle: true,
            actions: action != null
                ? [
                    GestureDetector(
                      onTap: () => actionCallback!.call(),
                      child: action,
                    )
                  ]
                : null);
}
