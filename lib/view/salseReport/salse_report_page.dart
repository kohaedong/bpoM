/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salseReport/salse_search_page.dart
 * Created Date: 2022-07-05 10:00:17
 * Last Modified: 2022-07-05 10:27:36
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

class SalseReportPage extends StatefulWidget {
  const SalseReportPage({Key? key}) : super(key: key);
  static const String routeName = '/salseReportPage';
  @override
  State<SalseReportPage> createState() => _SalseReportPageState();
}

class _SalseReportPageState extends State<SalseReportPage> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: true,
        appBar: null,
        child: Center(
          child: AppText.text('/salseReportPage'),
        ));
  }
}
