/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/currunt_month_scenario_page.dart
 * Created Date: 2022-08-17 23:33:31
 * Last Modified: 2022-08-17 23:50:12
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_layout.dart';

class CurruntMonthScenarioPage extends StatelessWidget {
  const CurruntMonthScenarioPage({Key? key}) : super(key: key);
  static const String routeName = '/curruntMonthScenarioPage';
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: false,
        appBar: MainAppBar(
          context,
          titleText: AppText.text(tr('curren_month_scenario'),
              style: AppTextStyle.w500_22),
        ),
        child: Container());
  }
}
