/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/home/home_icon_map.dart
 * Created Date: 2021-10-27 18:09:39
 * Last Modified: 2022-07-02 14:45:36
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
  ImageType.APP_PROFILE,
  ImageType.APP_OPPORTUNITY,
  ImageType.APP_CUSTOMER_MANAGER,
  ImageType.APP_CONSULTING,
];

final List<ImageType> homeIconsListTwo = [
  ImageType.APP_SALES_OPPORTUNITY,
  ImageType.APP_SALES_ORDER,
  ImageType.APP_ORDER_DO,
  ImageType.APP_MONITORING,
];
final List<ImageType> homeIconsListThree = [
  ImageType.APP_SALES_APPROVAL,
  ImageType.APP_INVENTORY,
  ImageType.APP_AGENCY,
  ImageType.EMPTY
];
final List<String> homeIconsListOneText = [
  tr('customer_profile'),
  tr('opportunity'),
  tr('manager'),
  tr('consulting')
];
final List<String> homeIconsListTwoText = [
  tr('sales_opportunity'),
  tr('sales_order'),
  tr('order_do'),
  tr('monitoring')
];
final List<String> homeIconsListThreeText = [
  tr('price_approval'),
  tr('inventory'),
  tr('agency'),
  'empty'
];
