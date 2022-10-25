/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/app_dialog.dart
 * Created Date: 2021-08-23 13:52:24
 * Last Modified: 2022-10-25 11:52:53
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/view/common/dialog_contents.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';

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
              alignment: Alignment.centerLeft,
              height: height - AppSize.buttonHeight,
              width: AppSize.defaultContentsWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: AppImage.getImage(ImageType.INFO)),
                  defaultSpacing(),
                  AppText.text('$str',
                      textAlign: TextAlign.center, maxLines: 50)
                ],
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
    var enterLength = FormatUtil.howManyLengthForString(contents) + 1;
    var height =
        AppSize.buttonHeight * 2 + AppSize.padding * 2 + enterLength * 14;
    return showPopup(
        context,
        buildDialogContents(
            context,
            Container(
              alignment: Alignment.centerLeft,
              height: height - AppSize.buttonHeight,
              child: AppText.text('$contents',
                  textAlign: TextAlign.start, maxLines: 3),
            ),
            true,
            height,
            signgleButtonText: '${tr('ok')}'));
  }
}
