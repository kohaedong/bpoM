/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/function_of_stop_or_start_listener.dart
 * Created Date: 2022-10-26 08:36:49
 * Last Modified: 2022-10-26 08:52:31
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:medsalesportal/service/connect_service.dart';
import 'package:medsalesportal/service/firebase_service.dart';
import 'package:medsalesportal/service/screen_capture_service.dart';

Future<void> stopAllListener() async {
  ScreenCaptrueService.stopListener();
  FirebaseService.stopListener();
  ConnectService.stopListener();
}

void startAllListener() {
  ScreenCaptrueService.startListener();
  FirebaseService.startListenner();
  ConnectService.startListener();
}
