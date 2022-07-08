import 'package:medsalesportal/service/key_service.dart';

import 'app_colors.dart';
import 'app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/styles/app_text.dart';

class AppStyles {
  // input Border style.
  static OutlineInputBorder get textfieldBorder => OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary, width: 1),
      borderRadius: BorderRadius.circular(AppSize.radius5));

  ///  일반 테스트 style 사전 정의.
  /// [TextStyle]은 [AppTextStyle]에 저의 된 style 적용.

  /// [TextButton] 사용시 style 사전 정의.
  static ButtonStyle getButtonStyle(Color backgroundColor, Color forgroundColor,
      TextStyle textStyle, double radius,
      {MaterialStateProperty<EdgeInsetsGeometry?>? padding}) {
    return ButtonStyle(
      padding: padding,
      backgroundColor: MaterialStateProperty.all(backgroundColor),
      foregroundColor: MaterialStateProperty.all(forgroundColor),
      textStyle: MaterialStateProperty.all(textStyle),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius))),
    );
  }

  // 검색버튼 사전 정의.
  static Widget buildSearchButton(
      BuildContext context, String buttonText, Function callback,
      {bool? doNotWithPadding}) {
    return Padding(
        padding: doNotWithPadding != null
            ? EdgeInsets.all(AppSize.zero)
            : AppSize.customerManagerPageSearchButtonPadding,
        child: AppStyles.buildButton(
            context,
            '$buttonText',
            AppSize.realWidth * .55,
            AppColors.lightBlueColor,
            AppTextStyle.color_16(AppColors.blueTextColor),
            AppSize.radius5,
            () => callback.call(),
            isWithBorder: true,
            borderColor: AppColors.blueBorderColor,
            selfHeight: AppSize.secondButtonHeight));
  }

  /// [Container]로 일반 버튼 paint 할때 기본 양식 사전 정의.
  static Widget buildButton(BuildContext context, String text, double width,
      Color bgColor, TextStyle style, double radius, VoidCallback callback,
      {bool? isLeft,
      bool? isWithBottomRadius,
      double? selfHeight,
      bool? isWithBorder,
      Color? borderColor,
      bool? isOnlyTopBorder}) {
    return InkWell(
      onTap: callback.call,
      child: Container(
          alignment: Alignment.center,
          height: selfHeight ?? AppSize.buttonHeight,
          width: width,
          decoration: BoxDecoration(
              color: bgColor,
              border: isWithBorder != null
                  ? Border.all(
                      color: borderColor!, width: AppSize.defaultBorderWidth)
                  : isOnlyTopBorder != null
                      ? Border(top: BorderSide(color: AppColors.textGrey))
                      : null,
              borderRadius: isLeft != null
                  ? isLeft
                      ? BorderRadius.only(bottomLeft: Radius.circular(radius))
                      : BorderRadius.only(bottomRight: Radius.circular(radius))
                  : isWithBottomRadius != null
                      ? isWithBottomRadius
                          ? BorderRadius.only(
                              bottomLeft: Radius.circular(radius),
                              bottomRight: Radius.circular(radius))
                          : null
                      : BorderRadius.all(Radius.circular(radius))),
          child: AppText.text('$text', style: style)),
    );
  }

// Pipe 공통 style.
  static Widget buildPipe({double? height}) {
    return Padding(
      padding: EdgeInsets.only(
          left: AppSize.defaultListItemSpacing,
          right: AppSize.defaultListItemSpacing),
      child: Container(
          height: height ?? AppTextStyle.h4.fontSize! - 2,
          decoration: BoxDecoration(
              border: Border(right: BorderSide(color: AppColors.textGrey)))),
    );
  }
}
