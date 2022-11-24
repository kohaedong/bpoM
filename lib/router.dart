/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/route.dart
 * Created Date: 2022-07-02 14:47:58
 * Last Modified: 2022-11-15 11:05:42
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:bpom/view/attach/attach_page.dart';
import 'package:bpom/view/commonLogin/common_login_page.dart';
import 'package:bpom/view/home/home_page.dart';
import 'package:bpom/view/settings/font_setting_page.dart';
import 'package:bpom/view/settings/notice_setting_page.dart';
import 'package:bpom/view/settings/send_suggestions_page.dart';
import 'package:bpom/view/settings/settings_page.dart';
import 'package:bpom/view/signin/signin_page.dart';
import 'package:flutter/widgets.dart';

Map<String, WidgetBuilder> routes = {
  SettingsPage.routeName: (context) => const SettingsPage(),
  SigninPage.routeName: (context) => const SigninPage(),
  HomePage.routeName: (context) => const HomePage(),
  AttachPage.routeName: (context) => const AttachPage(),
  NoticeSettingPage.routeName: (context) => const NoticeSettingPage(),
  FontSettingsPage.routeName: (context) => const FontSettingsPage(),
  SendSuggestionPage.routeName: (context) => const SendSuggestionPage(),
  CommonLoginPage.routeName: (context) => const CommonLoginPage(),
};
