/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums/app_theme.dart
 * Created Date: 2021-09-01 20:12:58
 * Last Modified: 2022-10-13 00:55:51
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/styles/app_text_style.dart';
import 'package:medsalesportal/styles/app_theme.dart';

enum AppThemeType {
  DARK,
  LIGHT,
  TEXT_SMALL,
  TEXT_MEDIUM,
  TEXT_BIG,
  TEXT_BIGGEST
}

extension ThemeTypeExtension on AppThemeType {
  ThemeData get theme {
    switch (this) {
      case AppThemeType.TEXT_SMALL:
        return Apptheme().appTheme.copyWith(
                textTheme: TextTheme(
              headline1: AppTextStyle.blod_16,
              headline2: AppTextStyle.w500_14,
              headline3: AppTextStyle.default_14,
              headline4: AppTextStyle.default_12,
              headline5: AppTextStyle.sub_12,
              headline6: AppTextStyle.sub_12,
            ));
      case AppThemeType.TEXT_MEDIUM:
        return Apptheme().appTheme.copyWith(
                textTheme: TextTheme(
              headline1: AppTextStyle.bold_18,
              headline2: AppTextStyle.w500_16,
              headline3: AppTextStyle.default_16,
              headline4: AppTextStyle.default_14,
              headline5: AppTextStyle.sub_12,
              headline6: AppTextStyle.sub_14,
            ));
      case AppThemeType.TEXT_BIG:
        return Apptheme().appTheme.copyWith(
                textTheme: TextTheme(
              headline1: AppTextStyle.bold_20,
              headline2: AppTextStyle.w500_18,
              headline3: AppTextStyle.default_18,
              headline4: AppTextStyle.default_16,
              headline5: AppTextStyle.sub_14,
              headline6: AppTextStyle.hint_16,
            ));
      case AppThemeType.TEXT_BIGGEST:
        return Apptheme().appTheme.copyWith(
                textTheme: TextTheme(
              headline1: AppTextStyle.bold_22,
              headline2: AppTextStyle.w500_22,
              headline3: AppTextStyle.default_20,
              headline4: AppTextStyle.default_18,
              headline5: AppTextStyle.hint_16,
              headline6: AppTextStyle.hint_18,
            ));
      case AppThemeType.DARK:
        return Apptheme().appTheme.copyWith(brightness: Brightness.dark);
      case AppThemeType.LIGHT:
        return Apptheme().appTheme.copyWith(brightness: Brightness.light);
    }
  }

  String get textScale {
    switch (this) {
      case AppThemeType.TEXT_SMALL:
        return 'small';
      case AppThemeType.TEXT_MEDIUM:
        return 'medium';
      case AppThemeType.TEXT_BIG:
        return 'big';
      case AppThemeType.TEXT_BIGGEST:
        return 'biggest';
      default:
        return '';
    }
  }
}

AppThemeType getThemeType(String scale) {
  if (AppThemeType.TEXT_SMALL.textScale == scale) {
    return AppThemeType.TEXT_SMALL;
  } else if (AppThemeType.TEXT_MEDIUM.textScale == scale) {
    return AppThemeType.TEXT_MEDIUM;
  } else if (AppThemeType.TEXT_BIG.textScale == scale) {
    return AppThemeType.TEXT_BIG;
  } else {
    return AppThemeType.TEXT_BIGGEST;
  }
}
