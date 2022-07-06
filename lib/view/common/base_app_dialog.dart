/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/app_dialog.dart
 * Created Date: 2021-08-23 13:52:24
 * Last Modified: 2022-07-06 14:59:28
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/globalProvider/app_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/view/common/dialog_contents.dart';
import 'package:medsalesportal/view/common/base_error_dialog_contents.dart';

class AppDialog {
  static dynamic showPopup(BuildContext context, Widget widget,
      {bool? isWithShapeBorder}) {
    return showDialog(
        useSafeArea: false,
        context: context,
        builder: (ctx) => AlertDialog(
            actionsPadding: EdgeInsets.zero,
            buttonPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content:
                WillPopScope(child: widget, onWillPop: () async => false)));
  }

  static dynamic showNetworkErrorDialog(BuildContext context) {
    return showPopup(
        context,
        buildDialogContents(context, BaseNetworkErrorDialogContents.build(),
            true, AppSize.networkErrorPopupHeight,
            signgleButtonText: '${tr('ok')}'));
  }

  static dynamic showServerErrorDialog(BuildContext context) {
    return showPopup(
        context,
        buildDialogContents(context, BaseServerErrorDialogContents.build(),
            true, AppSize.serverErrorPopupHeight,
            signgleButtonText: '${tr('ok')}'));
  }

  static dynamic showDangermessage(BuildContext context, String str) {
    return showPopup(
        context,
        buildDialogContents(
            context,
            Center(
                child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: AppSize.padding * 2)),
                AppImage.getImage(ImageType.INFO),
                Padding(
                    padding: EdgeInsets.only(top: AppSize.infoBoxSpaccing * 2)),
                AppText.text('$str',
                    style: context
                        .read<AppThemeProvider>()
                        .themeData
                        .textTheme
                        .headline3!,
                    maxLines: 3),
              ],
            )),
            true,
            AppSize.smallPopupHeight,
            signgleButtonText: '${tr('ok')}'));
  }

  static menu(BuildContext context) {
    return AppDialog.showPopup(
        context,
        buildDialogContents(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context, 'edit');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: AppSize.buttonHeight,
                    child: AppText.text('${tr('do_edit')}',
                        style: AppTextStyle.default_18),
                  ),
                ),
                Divider(
                  height: AppSize.dividerHeight,
                  color: AppColors.textGrey,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context, 'delete');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: AppSize.buttonHeight,
                    child: AppText.text('${tr('do_delete')}',
                        style: AppTextStyle.default_18),
                  ),
                )
              ],
            ),
            true,
            AppSize.menuPopupHeight,
            signgleButtonText: '${tr('close')}',
            isNotPadding: true));
  }

  static showSignglePopup(BuildContext context, String contents,
      {double? height}) {
    return showPopup(
        context,
        buildDialogContents(
            context,
            Padding(
                padding: EdgeInsets.only(top: AppSize.appBarHeight * .6),
                child: Container(
                  width: AppSize.defaultContentsWidth,
                  child: Center(
                    child: AppText.text(
                      '$contents',
                      style: context
                          .read<AppThemeProvider>()
                          .themeData
                          .textTheme
                          .headline3!,
                    ),
                  ),
                )),
            true,
            height ?? AppSize.singlePopupHeight,
            signgleButtonText: '${tr('ok')}'));
  }
}
