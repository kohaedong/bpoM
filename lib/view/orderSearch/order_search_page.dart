/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderSearch/order_search_page.dart
 * Created Date: 2022-07-05 09:58:56
 * Last Modified: 2022-07-05 10:27:21
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_layout.dart';

class OrderSearchPage extends StatefulWidget {
  const OrderSearchPage({Key? key}) : super(key: key);
  static const String routeName = '/orderSearchPage';
  @override
  State<OrderSearchPage> createState() => _OrderSearchPageState();
}

class _OrderSearchPageState extends State<OrderSearchPage> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: true,
        appBar: null,
        child: Center(
          child: AppText.text('/orderSearchPage'),
        ));
  }
}
