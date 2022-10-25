/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/globalProvider/connect_status_provider.dart
 * Created Date: 2022-10-26 07:14:36
 * Last Modified: 2022-10-26 07:39:57
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

class ConnectStatusProvider extends ChangeNotifier {
  final streamController = StreamController<ConnectivityResult>();
  late StreamSink<ConnectivityResult>? streamdSink;
  late Stream<ConnectivityResult>? stream;
  Future<ConnectivityResult?> get currenStream async =>
      await stream != null ? stream!.last : null;

  void addSink(ConnectivityResult result) {
    streamdSink ??= streamController.sink;
    stream ??= streamController.stream;
    streamdSink!.add(result);
  }

  @override
  void dispose() {
    streamdSink?.close();
    streamController.close();
    super.dispose();
  }
}
