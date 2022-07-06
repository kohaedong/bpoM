/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activitySearch/activity_search_page.dart
 * Created Date: 2022-07-05 09:51:03
 * Last Modified: 2022-07-05 21:23:02
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

class SalseActivitySearchPage extends StatefulWidget {
  const SalseActivitySearchPage({Key? key}) : super(key: key);
  static const String routeName = '/activitySearchPage';
  @override
  State<SalseActivitySearchPage> createState() =>
      _SalseActivitySearchPageState();
}

class _SalseActivitySearchPageState extends State<SalseActivitySearchPage> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: true,
        appBar: null,
        child: Center(
          child: AppText.text('/activitySearchPage'),
        ));
  }
}
