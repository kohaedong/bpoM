/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/home/home_icon_map.dart
 * Created Date: 2021-10-27 18:09:39
 * Last Modified: 2022-07-05 10:28:31
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/image_type.dart';

final List<ImageType> homeIconsListOne = [
  ImageType.APP_ACTIVITY_MANEGER,
  ImageType.APP_ACTIVITY_SEARCH,
  ImageType.APP_ORDER_MANEGER,
  ImageType.APP_ORDER_SEARCH,
];

final List<ImageType> homeIconsListTow = [
  ImageType.APP_SALSE_REPORT,
  ImageType.APP_BULK_ORDER_SEARCH,
  ImageType.APP_DETAIL_BOOK,
  ImageType.EMPTY
];
final List<String> homeIconsListOneText = [
  tr('app_activity_manager'),
  tr('app_activity_search'),
  tr('app_order_manager'),
  tr('app_order_search')
];

final List<String> homeIconsListTowText = [
  tr('app_salse_report'),
  tr('app_buld_order_search'),
  tr('app_detail_book'),
  'empty'
];
