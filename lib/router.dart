/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/route.dart
 * Created Date: 2022-07-02 14:47:58
 * Last Modified: 2022-07-02 14:51:04
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:medsalesportal/view/home/home_page.dart';
import 'package:medsalesportal/view/settings/font_setting_page.dart';
import 'package:medsalesportal/view/settings/notice_setting_page.dart';
import 'package:medsalesportal/view/settings/send_suggestions_page.dart';
import 'package:medsalesportal/view/settings/settings_page.dart';
import 'package:medsalesportal/view/signin/signin_page.dart';

Map<String, WidgetBuilder> routes = {
  SettingsPage.routeName: (context) => const SettingsPage(),
  SigninPage.routeName: (context) => const SigninPage(),
  HomePage.routeName: (context) => const HomePage(),
  NoticeSettingPage.routeName: (context) => const NoticeSettingPage(),
  FontSettingsPage.routeName: (context) => const FontSettingsPage(),
  SendSuggestionPage.routeName: (context) => const SendSuggestionPage(),
};
