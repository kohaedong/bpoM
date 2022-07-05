/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/route.dart
 * Created Date: 2022-07-02 14:47:58
 * Last Modified: 2022-07-05 10:04:43
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:medsalesportal/view/activityManager/activity_manager_page.dart';
import 'package:medsalesportal/view/activitySearch/activity_search_page.dart';
import 'package:medsalesportal/view/bulkOrderSearch/bulk_order_search_page.dart';
import 'package:medsalesportal/view/commonLogin/common_login_page.dart';
import 'package:medsalesportal/view/detailBook/detail_book_page.dart';
import 'package:medsalesportal/view/home/home_page.dart';
import 'package:medsalesportal/view/orderManager/order_manager_page.dart';
import 'package:medsalesportal/view/orderSearch/order_search_page.dart';
import 'package:medsalesportal/view/salseReport/salse_report_page.dart';
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
  CommonLoginPage.routeName: (context) => const CommonLoginPage(),
  ActivityManagerPage.routeName: (context) => const ActivityManagerPage(),
  ActivitySearchPage.routeName: (context) => const ActivitySearchPage(),
  BulkOrderSearchPage.routeName: (context) => const BulkOrderSearchPage(),
  DetailBookPage.routeName: (context) => const DetailBookPage(),
  OrderManagerPage.routeName: (context) => const OrderManagerPage(),
  OrderSearchPage.routeName: (context) => const OrderSearchPage(),
  SalseReportPage.routeName: (context) => const SalseReportPage()
};
