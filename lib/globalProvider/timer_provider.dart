/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/globalProvider/timer_provider.dart
 * Created Date: 2022-07-08 14:36:43
 * Last Modified: 2022-07-08 14:37:40
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class TimerProvider extends ChangeNotifier {
  String? lastToastText;
  Timer? _timer;
  Timer? _exitAppTimer;
  Timer? _toastTimer;
  Timer? get getTimer => _timer;
  bool? get isRunning => _timer?.isActive;
  bool get isToastRunnint =>
      _toastTimer == null ? false : _toastTimer!.isActive;
  void stopToastTimer() {
    _toastTimer?.cancel();
    notifyListeners();
  }

  void setLastToastText(String str) {
    lastToastText = str;
  }

  Future<void> doExit(Future<void> future) async {
    if (_exitAppTimer == null) {
      _exitAppTimer = Timer(Duration(seconds: 3), () {});
      future.then((_) => null);
    } else {
      if (_exitAppTimer!.isActive) {
        exit(0);
      } else {
        _exitAppTimer = Timer(Duration(seconds: 3), () {});
        future.then((_) => null);
      }
    }
  }

  Future<void> toastprocess(Function process, {Duration? duration}) async {
    process.call();
    _toastTimer = Timer.periodic(duration ?? const Duration(seconds: 3), (t) {
      t.cancel();
      _toastTimer = null;
    });
  }

  Future<void> perdict(Future<void> future, {Duration? duration}) async {
    if (_timer == null) {
      _timer = Timer.periodic(duration ?? const Duration(milliseconds: 1600),
          (t) async {
        future.whenComplete(() {
          t.cancel();
          _timer?.cancel();
          pr('canceld');
        });
      });
      notifyListeners();
    } else {
      _timer =
          Timer.periodic(duration ?? const Duration(milliseconds: 1600), (t) {
        t.cancel();
        _timer?.cancel();
        pr('canceld');
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _exitAppTimer?.cancel();
    _toastTimer?.cancel();
    super.dispose();
  }
}
