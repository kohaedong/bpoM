/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/view/common/provider/next_page_loading_provider.dart
 * Created Date: 2022-01-24 23:04:07
 * Last Modified: 2022-01-24 23:54:34
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';

class NextPageLoadingProvider extends ChangeNotifier {
  bool isShowLoading = false;
  void show() {
    isShowLoading = true;
    notifyListeners();
  }

  void stop() {
    isShowLoading = false;
    notifyListeners();
  }
}
