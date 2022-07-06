/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/route.dart
 * Created Date: 2022-07-02 14:47:58
 * Last Modified: 2022-07-05 21:23:18
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:medsalesportal/view/home/home_page.dart';
import 'package:medsalesportal/view/signin/signin_page.dart';
import 'package:medsalesportal/view/home/notice_all_page.dart';
import 'package:medsalesportal/view/home/notice_detail_page.dart';
import 'package:medsalesportal/view/settings/settings_page.dart';
import 'package:medsalesportal/view/settings/font_setting_page.dart';
import 'package:medsalesportal/view/detailBook/detail_book_page.dart';
import 'package:medsalesportal/view/settings/notice_setting_page.dart';
import 'package:medsalesportal/view/orderSearch/order_search_page.dart';
import 'package:medsalesportal/view/salseReport/salse_report_page.dart';
import 'package:medsalesportal/view/commonLogin/common_login_page.dart';
import 'package:medsalesportal/view/settings/send_suggestions_page.dart';
import 'package:medsalesportal/view/orderManager/order_manager_page.dart';
import 'package:medsalesportal/view/bulkOrderSearch/bulk_order_search_page.dart';
import 'package:medsalesportal/view/salesActivitySearch/salse_activity_search_page.dart';
import 'package:medsalesportal/view/salesActivityManager/sales_activity_manager_page.dart';

Map<String, WidgetBuilder> routes = {
  SettingsPage.routeName: (context) => const SettingsPage(),
  SigninPage.routeName: (context) => const SigninPage(),
  HomePage.routeName: (context) => const HomePage(),
  NoticeSettingPage.routeName: (context) => const NoticeSettingPage(),
  FontSettingsPage.routeName: (context) => const FontSettingsPage(),
  SendSuggestionPage.routeName: (context) => const SendSuggestionPage(),
  CommonLoginPage.routeName: (context) => const CommonLoginPage(),
  SalseActivityManagerPage.routeName: (context) =>
      const SalseActivityManagerPage(),
  SalseActivitySearchPage.routeName: (context) =>
      const SalseActivitySearchPage(),
  BulkOrderSearchPage.routeName: (context) => const BulkOrderSearchPage(),
  DetailBookPage.routeName: (context) => const DetailBookPage(),
  OrderManagerPage.routeName: (context) => const OrderManagerPage(),
  OrderSearchPage.routeName: (context) => const OrderSearchPage(),
  SalseReportPage.routeName: (context) => const SalseReportPage(),
  NoticeAllPage.routeName: (context) => const NoticeAllPage(),
  NoticeDetailPage.routeName: (context) => const NoticeDetailPage()
};
