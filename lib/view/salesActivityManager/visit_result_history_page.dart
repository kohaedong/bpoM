/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/visit_result_history_page.dart
 * Created Date: 2022-08-17 23:31:14
 * Last Modified: 2022-08-17 23:49:58
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

class VisitResultHistoryPage extends StatelessWidget {
  const VisitResultHistoryPage({Key? key}) : super(key: key);
  static const String routeName = '/visitResultHistoryPage';
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: false,
        appBar: MainAppBar(
          context,
          titleText: AppText.text(tr('visit_result_history'),
              style: AppTextStyle.w500_22),
        ),
        child: Container());
  }
}
