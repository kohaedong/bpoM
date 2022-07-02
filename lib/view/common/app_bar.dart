/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/app_bar.dart
 * Created Date: 2021-08-29 19:57:10
 * Last Modified: 2022-07-02 14:09:00
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
import 'package:medsalesportal/styles/app_colors.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/styles/app_style.dart';
import 'package:medsalesportal/view/common/app_dialog.dart';
import 'package:medsalesportal/view/common/dialog_contents.dart';
import 'package:medsalesportal/view/common/provider/app_theme_provider.dart';
import 'package:provider/provider.dart';

typedef IsEditPageCallBack = Function();

class MainAppBar extends AppBar {
  final Widget? titleText;
  final Widget? action;
  final Function? callback;
  final Widget? icon;
  final Function? actionCallback;
  final IsEditPageCallBack? cachePageTypeCallBack;
  MainAppBar(
    BuildContext context, {
    this.titleText,
    this.action,
    this.callback,
    this.icon,
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
                            child: buildDialogContents(
                              context,
                              Padding(
                                padding: EdgeInsets.only(
                                    top: AppSize.appBarHeight * .6),
                                child: Center(
                                  child: AppStyles.text(
                                      '${tr('is_exit_current_page')}',
                                      context
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
                      Navigator.pop(context);
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
                    InkWell(
                      onTap: () => actionCallback!.call(),
                      child: action,
                    )
                  ]
                : null);
}
