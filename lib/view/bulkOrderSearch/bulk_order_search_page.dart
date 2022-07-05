/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/bulkOrderSearch/bulk_order_search_page.dart
 * Created Date: 2022-07-05 09:53:16
 * Last Modified: 2022-07-05 10:26:26
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

class BulkOrderSearchPage extends StatefulWidget {
  const BulkOrderSearchPage({Key? key}) : super(key: key);
  static const String routeName = '/bulkOrderSearchPage';
  @override
  State<BulkOrderSearchPage> createState() => _BulkOrderSearchPageState();
}

class _BulkOrderSearchPageState extends State<BulkOrderSearchPage> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: true,
        appBar: null,
        child: Center(
          child: AppText.text('/bulkOrderSearchPage'),
        ));
  }
}
