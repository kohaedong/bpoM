/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/app_bar.dart
 * Created Date: 2021-08-29 19:57:10
 * Last Modified: 2022-10-02 17:44:00
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
import 'package:medsalesportal/globalProvider/app_theme_provider.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/dialog_contents.dart';
import 'package:provider/provider.dart';

typedef IsEditPageCallBack = Function();

class MainAppBar extends AppBar {
  final Widget? titleText;
  final Widget? action;
  final Function? callback;
  final Widget? icon;
  final bool? popArguments;
  final Function? actionCallback;
  final IsEditPageCallBack? cachePageTypeCallBack;
  MainAppBar(
    BuildContext context, {
    this.titleText,
    this.action,
    this.callback,
    this.icon,
    this.actionCallback,
    this.popArguments,
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
                      Navigator.pop(context, popArguments);
                    }
                  } else {
                    if (callback != null) {
                      callback.call();
                    } else {
                      Navigator.pop(context, popArguments);
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
