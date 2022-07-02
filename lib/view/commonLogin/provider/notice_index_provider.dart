/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/view/commonLogin/provider/notice_index_provider.dart
 * Created Date: 2022-01-13 06:03:39
 * Last Modified: 2022-01-13 19:05:11
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';

class NoticeIndexProvider extends ChangeNotifier {
  int categoryIndex = 0;
  int noticeIndex = 0;
  void categoryIncrement() {
    print('do increments');
    categoryIndex++;
    notifyListeners();
  }

  void noticeIncrement() {
    noticeIndex++;
    notifyListeners();
  }

  void resetAll() {
    categoryIndex = 0;
    noticeIndex = 0;
    notifyListeners();
  }

  void resetNoticeIndex() {
    noticeIndex = 0;
    notifyListeners();
  }
}
