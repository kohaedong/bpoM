/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/globalProvider/update_and_notice_state_provider.dart
 * Created Date: 2022-09-24 16:16:24
 * Last Modified: 2022-09-24 16:47:29
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';

class UpdateAndNoticeStateProvider extends ChangeNotifier {
  bool? isNoticeShowDone;
  void setIsShowNotice(bool val) {
    isNoticeShowDone = val;
    notifyListeners();
  }
}
