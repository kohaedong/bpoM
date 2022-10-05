/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/view/commonLogin/provider/special_notice_provider.dart
 * Created Date: 2022-08-26 14:15:20
 * Last Modified: 2022-08-26 14:17:11
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';

/// bakboem 2022.08.25
/// 공지 추석특별추가.
class SpecialNoticeProvider extends ChangeNotifier {
  bool isShowSpecialNotice = true;
  void setIsShowSpecialNotice(bool val) {
    isShowSpecialNotice = false;
    notifyListeners();
  }
}
