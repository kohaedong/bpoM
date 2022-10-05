/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/app_dialog.dart
 * Created Date: 2021-08-23 13:52:24
 * Last Modified: 2022-10-06 05:28:00
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/view/common/dialog_contents.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/globalProvider/app_theme_provider.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/base_error_dialog_contents.dart';

typedef DiaLogCallBack = Function(bool);

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
            shape: isWithShapeBorder == null || isWithShapeBorder
                ? RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(AppSize.radius15)))
                : null,
            content:
                WillPopScope(child: widget, onWillPop: () async => false)));
  }

  static Future<void> showSimpleDialog(
      BuildContext context, String? title, String text,
      {String? cancelButtonText,
      String? successButtonText,
      bool? isSingleButton,
      DiaLogCallBack? callBack}) async {
    var default16 =
        AppTextStyle.default_16.copyWith(color: AppColors.defaultText);
    var primray16 = AppTextStyle.default_16.copyWith(color: AppColors.primary);
    var actionWidget = isSingleButton != null && isSingleButton
        ? <Widget>[
            CupertinoDialogAction(
                textStyle: primray16,
                child: Text(successButtonText ?? tr('ok')),
                onPressed: () => callBack != null
                    ? callBack.call(true)
                    : Navigator.pop(context)),
          ]
        : <Widget>[
            CupertinoDialogAction(
              textStyle: default16,
              child: Text(cancelButtonText ?? tr('cancel')),
              onPressed: () => callBack != null
                  ? callBack.call(false)
                  : Navigator.pop(context),
            ),
            CupertinoDialogAction(
              textStyle: primray16,
              child: Text(successButtonText ?? tr('ok')),
              onPressed: () => callBack != null
                  ? callBack.call(true)
                  : Navigator.pop(context),
            ),
          ];

    showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
              title: title != null ? Text(title) : Container(),
              content: Text(
                text,
                style: AppTextStyle.default_14,
                textAlign: TextAlign.center,
              ),
              actions: actionWidget);
        });
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
    // str = str + "fdsaffsafdsafdsafklasfjdskal;jf\n\nd\n,\n,\n" * 15;
    var enterLength = FormatUtil.howManyLengthForString(str) + 1;
    var height =
        AppSize.buttonHeight * 3 + AppSize.padding * 2 + enterLength * 14;
    pr('enterLength $enterLength');
    return showPopup(
        context,
        buildDialogContents(
            context,
            Container(
              padding: EdgeInsets.symmetric(vertical: AppSize.padding),
              alignment: Alignment.center,
              height: height > AppSize.realHeight * .6
                  ? AppSize.realHeight * .6 - AppSize.buttonHeight
                  : height - AppSize.buttonHeight,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage.getImage(ImageType.INFO),
                    defaultSpacing(),
                    SingleChildScrollView(
                      child: AppText.text('$str',
                          style: context
                              .read<AppThemeProvider>()
                              .themeData
                              .textTheme
                              .headline3!,
                          maxLines: 50,
                          textAlign: TextAlign.center),
                    )
                  ],
                ),
              ),
            ),
            true,
            height > AppSize.realHeight * .6 ? AppSize.realHeight * .6 : height,
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
                    child: AppText.text('$contents',
                        style: context
                            .read<AppThemeProvider>()
                            .themeData
                            .textTheme
                            .headline3!,
                        maxLines: 3),
                  ),
                )),
            true,
            height ?? AppSize.singlePopupHeight,
            signgleButtonText: '${tr('ok')}'));
  }
}
