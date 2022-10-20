/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/service/connect_status_service.dart
 * Created Date: 2022-10-19 19:16:52
 * Last Modified: 2022-10-19 19:19:12
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectStatusService {
  factory ConnectStatusService() => _sharedInstance();
  static ConnectStatusService? _instance;
  ConnectStatusService._();
  static ConnectStatusService _sharedInstance() {
    _instance ??= ConnectStatusService._();
    return _instance!;
  }

  static final connect = Connectivity();
  static Future<ConnectivityResult> check() async {
    return await connect.checkConnectivity();
  }
}
