/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/globalProvider/connect_status_provider.dart
 * Created Date: 2022-10-26 07:14:36
 * Last Modified: 2022-10-27 15:08:22
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
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:bpom/view/common/function_of_print.dart';

class ConnectStatusProvider extends ChangeNotifier {
  final streamController = StreamController<ConnectivityResult>();
  late StreamSink<ConnectivityResult>? streamdSink;
  Stream<ConnectivityResult>? stream;
  Future<ConnectivityResult?> get currenStream async =>
      await stream != null ? stream!.last : null;
  Future<bool> get checkFirstStatus async =>
      await InternetConnectionChecker().hasConnection;
  void addSink(ConnectivityResult result) async {
    stream ??= streamController.stream;
    streamdSink ??= streamController.sink;

    streamdSink!.add(result);
    if (await stream!.length > 2) {
      stream!.skip(2);
      pr('stream?.length  ${stream?.length}');
    }
  }

  Future<void> stopListener() async {
    streamController.close();
  }

  @override
  void dispose() {
    streamdSink?.close();
    streamController.close();
    super.dispose();
  }
}
