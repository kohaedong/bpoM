/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/route.dart
 * Created Date: 2022-07-02 14:47:58
 * Last Modified: 2022-10-11 04:31:00
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:medsalesportal/view/bulkOrderSearch/bulk_order_detail_page.dart';
import 'package:medsalesportal/view/detailBook/detail_book_web_view.dart';
import 'package:medsalesportal/view/home/home_page.dart';
import 'package:medsalesportal/view/orderSearch/order_detail_page.dart';
import 'package:medsalesportal/view/salesActivityManager/activity_finish_page.dart';
import 'package:medsalesportal/view/salesActivityManager/add_activity_page.dart';
import 'package:medsalesportal/view/salesActivityManager/current_month_scenario_page.dart';
import 'package:medsalesportal/view/salesActivityManager/visit_result_history_page.dart';
import 'package:medsalesportal/view/signin/signin_page.dart';
import 'package:medsalesportal/view/home/notice_all_page.dart';
import 'package:medsalesportal/view/home/notice_detail_page.dart';
import 'package:medsalesportal/view/settings/settings_page.dart';
import 'package:medsalesportal/view/settings/font_setting_page.dart';
import 'package:medsalesportal/view/detailBook/detail_book_page.dart';
import 'package:medsalesportal/view/settings/notice_setting_page.dart';
import 'package:medsalesportal/view/orderSearch/order_search_page.dart';
import 'package:medsalesportal/view/commonLogin/common_login_page.dart';
import 'package:medsalesportal/view/settings/send_suggestions_page.dart';
import 'package:medsalesportal/view/orderManager/order_manager_page.dart';
import 'package:medsalesportal/view/bulkOrderSearch/bulk_order_search_page.dart';
import 'package:medsalesportal/view/salesActivitySearch/salse_activity_detail_page.dart';
import 'package:medsalesportal/view/salesActivitySearch/salse_activity_search_page.dart';
import 'package:medsalesportal/view/salesActivityManager/sales_activity_manager_page.dart';
import 'package:medsalesportal/view/transactionLedger/transaction_ledger_page.dart';

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
  TransactionLedgerPage.routeName: (context) => const TransactionLedgerPage(),
  NoticeAllPage.routeName: (context) => const NoticeAllPage(),
  NoticeDetailPage.routeName: (context) => const NoticeDetailPage(),
  SalseActivityDetailPage.routeName: (context) =>
      const SalseActivityDetailPage(),
  OrderDetailPage.routeName: (context) => const OrderDetailPage(),
  BulkOrderDetailPage.routeName: (context) => const BulkOrderDetailPage(),
  DetailBookWebView.routeName: (context) => const DetailBookWebView(),
  AddActivityPage.routeName: (context) => const AddActivityPage(),
  CurruntMonthScenarioPage.routeName: (context) =>
      const CurruntMonthScenarioPage(),
  VisitResultHistoryPage.routeName: (context) => const VisitResultHistoryPage(),
  SalseActivityFinishPage.routeName: (context) =>
      const SalseActivityFinishPage()
};
