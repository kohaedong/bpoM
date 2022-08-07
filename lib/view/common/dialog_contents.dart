/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/dialog_contents.dart
 * Created Date: 2021-08-29 18:05:23
 * Last Modified: 2022-08-07 21:52:05
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

typedef SuccessCallback = String Function();
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

Widget popUpTwoButton(BuildContext context, String rightText, String leftText,
    {double? radius}) {
  return Row(
    children: [
      Expanded(
          flex: 1,
          child: popUpSignleButton(context, '$leftText', isLeftButton: true)),
      Expanded(
        flex: 1,
        child: popUpSignleButton(context, '$rightText', isLeftButton: false),
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
    double? radius}) {
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
                  radius: radius)
        ],
      ));
}

Widget popUpSignleButton(BuildContext context, String buttonText,
    {bool? isLeftButton, bool? isWithBottomRadius, double? radius}) {
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
        radius ?? 25, () {
      Navigator.pop(
          context,
          isLeftButton != null
              ? isLeftButton
                  ? false
                  : true
              : true);
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
            ? ListView(
                children: [
                  isWithTitle != null ? withTitleContents(title!) : Container(),
                  contents
                ],
              )
            : Column(
                children: [
                  isWithTitle != null ? withTitleContents(title!) : Container(),
                  contents
                ],
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
                          AppSize.radius8),
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
                          AppSize.radius8),
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
