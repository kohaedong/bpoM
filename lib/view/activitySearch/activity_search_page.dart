/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activitySearch/activity_search_page.dart
 * Created Date: 2022-07-05 09:51:03
 * Last Modified: 2022-07-05 10:26:04
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

class ActivitySearchPage extends StatefulWidget {
  const ActivitySearchPage({Key? key}) : super(key: key);
  static const String routeName = '/activitySearchPage';
  @override
  State<ActivitySearchPage> createState() => _ActivitySearchPageState();
}

class _ActivitySearchPageState extends State<ActivitySearchPage> {
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
