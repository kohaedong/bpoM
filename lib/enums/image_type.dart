/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums/image_type.dart
 * Created Date: 2021-08-20 14:37:40
 * Last Modified: 2022-07-05 10:06:59
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

//* 이미지 url 사전 등록후 사용.
import 'package:medsalesportal/view/activityManager/activity_manager_page.dart';
import 'package:medsalesportal/view/activitySearch/activity_search_page.dart';
import 'package:medsalesportal/view/bulkOrderSearch/bulk_order_search_page.dart';
import 'package:medsalesportal/view/detailBook/detail_book_page.dart';
import 'package:medsalesportal/view/orderManager/order_manager_page.dart';
import 'package:medsalesportal/view/orderSearch/order_search_page.dart';
import 'package:medsalesportal/view/salseReport/salse_report_page.dart';

enum ImageType {
  SPLASH_ICON,
  TEXT_LOGO,
  APP_ACTIVITY_MANEGER,
  APP_ACTIVITY_SEARCH,
  APP_ORDER_MANEGER,
  APP_ORDER_SEARCH,
  APP_SALSE_REPORT,
  APP_BULK_ORDER_SEARCH,
  APP_DETAIL_BOOK,
  SETTINGS_ICON,
  EMPTY,
  SEARCH,
  SELECT,
  DELETE,
  DATA_PICKER,
  PLUS,
  MENU,
  PLUS_SMALL,
  INFO
}

extension RequestTypeExtension on ImageType {
  String get path {
    switch (this) {
      case ImageType.SPLASH_ICON:
        return 'assets/images/icon_app_material.svg';
      case ImageType.TEXT_LOGO:
        return 'assets/images/kolon_logo.svg';
      case ImageType.APP_ACTIVITY_MANEGER:
        return 'assets/images/icon_app_sales_activity_manager.svg';
      case ImageType.APP_ACTIVITY_SEARCH:
        return 'assets/images/icon_app_sales_activity_search.svg';
      case ImageType.APP_BULK_ORDER_SEARCH:
        return 'assets/images/icon_app_bulk_order_search.svg';
      case ImageType.APP_DETAIL_BOOK:
        return 'assets/images/icon_app_sales_detailbook.svg';
      case ImageType.APP_ORDER_MANEGER:
        return 'assets/images/icon_app_sales_order_manager.svg';
      case ImageType.APP_ORDER_SEARCH:
        return 'assets/images/icon_app_sales_order_search.svg';
      case ImageType.APP_SALSE_REPORT:
        return 'assets/images/icon_app_sales_report.svg';
      case ImageType.EMPTY:
        return 'assets/images/empty.svg';
      case ImageType.SETTINGS_ICON:
        return 'assets/images/icon_outlined_24_lg_1_settings.svg';
      case ImageType.SEARCH:
        return 'assets/images/icon_outlined_18_lg_3_search.svg';
      case ImageType.SELECT:
        return 'assets/images/icon_outlined_18_lg_3_down.svg';
      case ImageType.DELETE:
        return 'assets/images/icon_filled_18_lg_3_misuse.svg';
      case ImageType.DATA_PICKER:
        return 'assets/images/icon_outlined_18_lg_3_calendar.svg';
      case ImageType.PLUS:
        return 'assets/images/icon_outlined_24_lbp_3_add.svg';
      case ImageType.MENU:
        return 'assets/images/icon_outlined_24_lg_3_menu.svg';
      case ImageType.PLUS_SMALL:
        return 'assets/images/icon_outlined_18_lg_3_add.svg';
      case ImageType.INFO:
        return 'assets/images/icon_outlined_24_lg_3_warning.svg';

      default:
        return '';
    }
  }

// 홈화면에 icon을 텝 했을 때 route 하는 경로 사전 등록.
  String get routeName {
    switch (this) {
      case ImageType.APP_ACTIVITY_MANEGER:
        return ActivityManagerPage.routeName;
      case ImageType.APP_ACTIVITY_SEARCH:
        return ActivitySearchPage.routeName;
      case ImageType.APP_ORDER_MANEGER:
        return OrderManagerPage.routeName;
      case ImageType.APP_ORDER_SEARCH:
        return OrderSearchPage.routeName;
      case ImageType.APP_BULK_ORDER_SEARCH:
        return BulkOrderSearchPage.routeName;
      case ImageType.APP_SALSE_REPORT:
        return SalseReportPage.routeName;
      case ImageType.APP_DETAIL_BOOK:
        return DetailBookPage.routeName;
      default:
        return '';
    }
  }
}
