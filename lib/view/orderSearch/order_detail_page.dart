/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderSearch/order_detail_page.dart
 * Created Date: 2022-07-12 15:20:28
 * Last Modified: 2022-07-12 15:24:09
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:medsalesportal/model/rfc/t_list_search_order_model.dart';
import 'package:medsalesportal/styles/app_text.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({Key? key}) : super(key: key);
  static const String routeName = '/orderDetailPage';
  @override
  Widget build(BuildContext context) {
    final model =
        ModalRoute.of(context)?.settings.arguments as TlistSearchOrderModel;
    pr(model.toJson());
    return BaseLayout(
      hasForm: false,
      appBar: MainAppBar(
        context,
        titleText: AppText.text('ddd'),
      ),
      child: Container(),
    );
  }
}
