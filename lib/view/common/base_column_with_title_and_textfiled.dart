/*
 * Filename: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_
 * Path: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common
 * Created Date: Sunday, October 3rd 2021, 3:43:31 pm
 * Author: bakbeom
 * 
 * Copyright (c) 2021 KOLON GROUP.
 */

import 'package:flutter/widgets.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/provider/app_theme_provider.dart';
import 'package:provider/provider.dart';

// title 과 input 묶음으로 보여주는 widget.
// 예:

// 주소 *(필수)
// ------------------------
//|          input         |
// ------------------------
//
class BaseColumWithTitleAndTextFiled {
  static Widget buildRowWithStart(String text,
      {bool? isNotshowStart, bool? isTextSize14}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppStyles.text(
            '$text',
            isTextSize14 != null
                ? KeyService.baseAppKey.currentContext!
                    .read<AppThemeProvider>()
                    .themeData
                    .textTheme
                    .headline6!
                : KeyService.baseAppKey.currentContext!
                    .read<AppThemeProvider>()
                    .themeData
                    .textTheme
                    .headline3!),
        isNotshowStart != null
            ? Container(
                height: AppSize.zero,
              )
            : AppStyles.text(
                ' *', AppTextStyle.color_16(AppColors.dangerColor)),
      ],
    );
  }

  static Widget build(String text, Widget input,
      {bool? isNotShowStar, bool? isTextSize14, Widget? input2}) {
    // isNotShowStar   true : 필수 옵션 * 보여짐,  false: 필수 옵션 * 안보여짐.
    // isTextSize14 true: 폰트 크기 14, false 폰트 크기 16
    // input2 잠재고객페이지에서만 사용. 주소가 2줄일 경우 input 1개 추가.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRowWithStart(text,
            isNotshowStart: isNotShowStar, isTextSize14: isTextSize14),
        Padding(
          padding: EdgeInsets.only(
              top: AppSize.defaultSpacingForTitleAndTextField,
              bottom: AppSize.buttomPaddingForTitleAndTextField),
          child: input2 != null
              ? Column(
                  children: [
                    input,
                    Padding(
                        padding: EdgeInsets.only(
                            top: AppSize.defaultListItemSpacing)),
                    input2
                  ],
                )
              : input,
        )
      ],
    );
  }
}
