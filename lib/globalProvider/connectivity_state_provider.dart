/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/globalProvider/connectivity_state_provider.dart
 * Created Date: 2022-10-13 04:56:29
 * Last Modified: 2022-10-13 05:49:57
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class ConnectivityStatusProvider extends ChangeNotifier {
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    connectivityResult = result;
    pr(result);
    notifyListeners();
  }

  init() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }
}
