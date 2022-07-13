/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salseReport/salse_search_page.dart
 * Created Date: 2022-07-05 10:00:17
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

class TransactionLedgerPage extends StatefulWidget {
  const TransactionLedgerPage({Key? key}) : super(key: key);
  static const String routeName = '/salseReportPage';
  @override
  State<TransactionLedgerPage> createState() => _TransactionLedgerPageState();
}

class _TransactionLedgerPageState extends State<TransactionLedgerPage> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: true,
        appBar: MainAppBar(context,
            titleText: AppText.text('${tr('transaction_ledger')}',
                style: AppTextStyle.w500_22)),
        child: Center(
          child: AppText.text('/salseReportPage'),
        ));
  }
}
