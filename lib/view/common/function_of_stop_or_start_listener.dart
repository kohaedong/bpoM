/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/function_of_stop_or_start_listener.dart
 * Created Date: 2022-10-26 08:36:49
 * Last Modified: 2022-10-27 13:01:59
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:bpom/service/connect_service.dart';
import 'package:bpom/service/screen_capture_service.dart';

Future<void> stopAllListener() async {
  ScreenCaptrueService.stopListener();
  ConnectService.stopListener();
}

void startAllListener() {
  ScreenCaptrueService.startListener();
  ConnectService.startListener();
}
