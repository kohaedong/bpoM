/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activityManeger/activity_manager_page.dart
 * Created Date: 2022-07-05 09:46:17
 * Last Modified: 2022-07-05 10:25:43
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:medsalesportal/styles/app_text.dart';
import 'package:medsalesportal/view/common/base_layout.dart';

class ActivityManagerPage extends StatefulWidget {
  const ActivityManagerPage({Key? key}) : super(key: key);
  static const String routeName = '/activityManegerPage';
  @override
  State<ActivityManagerPage> createState() => _ActivityManagerPageState();
}

class _ActivityManagerPageState extends State<ActivityManagerPage> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: true,
        appBar: null,
        child: Center(
          child: AppText.text('/activityManegerPage'),
        ));
  }
}
