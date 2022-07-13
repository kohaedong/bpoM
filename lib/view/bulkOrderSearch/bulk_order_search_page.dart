/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/bulkOrderSearch/bulk_order_search_page.dart
 * Created Date: 2022-07-05 09:53:16
 * Last Modified: 2022-07-13 11:15:07
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
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
        appBar: MainAppBar(context,
            titleText: AppText.text('${tr('buld_order_search')}',
                style: AppTextStyle.w500_22)),
        child: Center(
          child: AppText.text('/bulkOrderSearchPage'),
        ));
  }
}
