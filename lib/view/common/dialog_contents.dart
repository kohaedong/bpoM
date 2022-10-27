/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/dialog_contents.dart
 * Created Date: 2021-08-29 18:05:23
 * Last Modified: 2022-10-27 15:48:19
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/util/format_util.dart';

typedef SuccessCallback = String Function();
typedef PopContextDataCallback = Future<dynamic> Function();
typedef CanPopCallBack = Future<bool> Function();
Widget withTitleContents(String title) {
  return Column(
    children: [
      Container(
          height: AppSize.buttonHeight,
          width: AppSize.updatePopupWidth,
          child: Padding(
              padding: EdgeInsets.only(left: AppSize.padding),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppText.text('$title', style: AppTextStyle.w500_18),
              ))),
      Divider(
        height: AppSize.dividerHeight,
        color: AppColors.textGrey,
      ),
    ],
  );
}

Widget popUpTwoButton(
  BuildContext context,
  String rightText,
  String leftText, {
  double? radius,
  PopContextDataCallback? callback,
  CanPopCallBack? canPopCallBackk,
}) {
  return Row(
    children: [
      Expanded(
          flex: 1,
          child: popUpSignleButton(context, '$leftText', isLeftButton: true)),
      Expanded(
        flex: 1,
        child: popUpSignleButton(context, '$rightText',
            isLeftButton: false,
            callback: callback,
            canPopCallBackk: canPopCallBackk),
      ),
    ],
  );
}

Widget buildDialogContents(BuildContext context, Widget widget,
    bool isSigngleButton, double popupHeight,
    {String? leftButtonText,
    String? rightButtonText,
    String? signgleButtonText,
    bool? iswithTitle,
    String? titleText,
    bool? isNotPadding,
    double? radius,
    CanPopCallBack? canPopCallBackk,
    PopContextDataCallback? dataCallback}) {
  return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      height: popupHeight,
      width: AppSize.updatePopupWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          iswithTitle != null ? withTitleContents(titleText!) : Container(),
          Expanded(
              child: isNotPadding != null
                  ? widget
                  : SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: Padding(
                        padding: AppSize.defaultSidePadding,
                        child: widget,
                      ),
                    )),
          Divider(
            height: AppSize.dividerHeight,
            color: AppColors.textGrey,
          ),
          isSigngleButton
              ? popUpSignleButton(context, '$signgleButtonText',
                  isWithBottomRadius: true)
              : popUpTwoButton(context, rightButtonText ?? tr('ok'),
                  leftButtonText ?? tr('cancel'),
                  radius: radius,
                  callback: dataCallback,
                  canPopCallBackk: canPopCallBackk)
        ],
      ));
}

Widget buildTowButtonTextContents(BuildContext context, String text,
    {String? faildButtonText,
    String? successButtonText,
    Function? successCallback}) {
  var enterLength = FormatUtil.howManyLengthForString(text) + 1;
  var height =
      AppSize.buttonHeight * 2 + AppSize.padding * 2 + enterLength * 14;
  return Container(
      height: height,
      width: AppSize.defaultContentsWidth,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: AppSize.defaultSidePadding,
            width: AppSize.defaultContentsWidth,
            height: height - AppSize.buttonHeight,
            child: AppText.text(text, textAlign: TextAlign.left, maxLines: 20),
          ),
          Positioned(
              left: 0,
              bottom: 0,
              child: Row(
                children: [
                  Container(
                    width: AppSize.defaultContentsWidth / 2,
                    height: AppSize.buttonHeight,
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                width: .5, color: AppColors.textGrey),
                            top: BorderSide(
                                width: .5, color: AppColors.textGrey))),
                    child: TextButton(
                        style: AppStyles.getButtonStyle(
                            AppColors.whiteText,
                            AppColors.defaultText,
                            AppTextStyle.hint_16,
                            AppSize.radius15),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text('${faildButtonText ?? tr('cancel')}')),
                  ),
                  Container(
                    width: AppSize.defaultContentsWidth / 2,
                    height: AppSize.buttonHeight,
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: .5, color: AppColors.textGrey))),
                    child: TextButton(
                        style: AppStyles.getButtonStyle(
                            AppColors.whiteText,
                            AppColors.primary,
                            AppTextStyle.hint_16,
                            AppSize.radius15),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text('${successButtonText ?? tr('ok')}')),
                  )
                ],
              ))
        ],
      ));
}

Widget popUpSignleButton(BuildContext context, String buttonText,
    {bool? isLeftButton,
    bool? isWithBottomRadius,
    double? radius,
    PopContextDataCallback? callback,
    CanPopCallBack? canPopCallBackk}) {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border: isLeftButton != null
          ? isLeftButton
              ? Border(right: BorderSide(width: .5, color: AppColors.textGrey))
              : null
          : null,
    ),
    child: AppStyles.buildButton(
        context,
        '$buttonText',
        AppSize.buildWidth(context, 1),
        AppColors.whiteText,
        AppTextStyle.menu_18(isLeftButton != null
            ? isLeftButton
                ? AppColors.defaultText
                : AppColors.primary
            : AppColors.primary),
        radius ?? 25, () async {
      if (canPopCallBackk == null) {
        Navigator.pop(
            context,
            callback == null
                ? isLeftButton != null
                    ? isLeftButton
                        ? false
                        : true
                    : true
                : callback.call());
      } else {
        var isCanPop = await canPopCallBackk.call();
        if (isCanPop) {
          Navigator.pop(
              context,
              callback == null
                  ? isLeftButton != null
                      ? isLeftButton
                          ? false
                          : true
                      : true
                  : await callback.call());
        }
      }
    }, isLeft: isLeftButton, isWithBottomRadius: isWithBottomRadius),
  );
}

Widget buildTowButtonDialogContents(
  BuildContext context,
  double height,
  Widget contents, {
  double? width,
  bool? iswithScrollbale,
  bool? isWithTitle,
  SuccessCallback? callback,
  String? successButtonText,
  String? faildButtonText,
  String? title,
  Color? successTextColor,
  Color? successBackgraoundColor,
  Color? faildBackgraoundColor,
  Color? faildTextColor,
}) {
  return Container(
    height: height,
    width: width ?? AppSize.defaultContentsWidth,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(AppSize.radius8)),
    child: Stack(
      children: [
        iswithScrollbale != null
            ? SizedBox(
                height: height - AppSize.buttonHeight,
                child: ListView(
                  children: [
                    isWithTitle != null
                        ? withTitleContents(title!)
                        : Container(),
                    contents
                  ],
                ),
              )
            : SizedBox(
                height: height - AppSize.buttonHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isWithTitle != null
                        ? withTitleContents(title!)
                        : Container(),
                    contents
                  ],
                ),
              ),
        Positioned(
            left: 0,
            bottom: 0,
            child: Row(
              children: [
                Container(
                  width: AppSize.defaultContentsWidth / 2,
                  height: AppSize.buttonHeight,
                  decoration: BoxDecoration(
                      border: Border(
                          right:
                              BorderSide(width: .5, color: AppColors.textGrey),
                          top: BorderSide(
                              width: .5, color: AppColors.textGrey))),
                  child: TextButton(
                      style: AppStyles.getButtonStyle(
                          successBackgraoundColor ?? AppColors.whiteText,
                          faildTextColor ?? AppColors.defaultText,
                          AppTextStyle.hint_16,
                          AppSize.radius15),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('${faildButtonText ?? '${tr('cancel')}'}')),
                ),
                Container(
                  width: AppSize.defaultContentsWidth / 2,
                  height: AppSize.buttonHeight,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: .5, color: AppColors.textGrey))),
                  child: TextButton(
                      style: AppStyles.getButtonStyle(
                          successBackgraoundColor ?? AppColors.whiteText,
                          successTextColor ?? AppColors.primary,
                          AppTextStyle.hint_16,
                          AppSize.radius15),
                      onPressed: () {
                        Navigator.pop(
                            context,
                            callback != null
                                ? callback.call()
                                : DoNothingAction());
                      },
                      child: Text('${successButtonText ?? '${tr('ok')}'}')),
                )
              ],
            ))
      ],
    ),
  );
}
