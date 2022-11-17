/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/provider/app_theme_provider.dart
 * Created Date: 2021-09-01 20:12:58
 * Last Modified: 2022-10-23 23:03:01
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:bpom/enums/app_theme_type.dart';
import 'package:bpom/styles/app_theme.dart';

class AppThemeProvider with ChangeNotifier {
  AppThemeType themeType = AppThemeType.TEXT_MEDIUM;
  ThemeData themeData = Apptheme().appTheme;

  void setThemeType(AppThemeType type) {
    this.themeType = type;
    themeData = themeType.theme;
    notifyListeners();
  }
}
