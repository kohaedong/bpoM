/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/service/background_task_service.dart
 * Created Date: 2022-10-24 03:38:32
 * Last Modified: 2022-10-24 13:24:46
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'dart:io';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundTaskService {
  factory BackgroundTaskService() => _sharedInstance();
  static BackgroundTaskService? _instance;
  static BackgroundTaskService? sharedPreferences;
  BackgroundTaskService._();
  static BackgroundTaskService _sharedInstance() {
    if (_instance == null) {
      _instance = BackgroundTaskService._();
    }
    return _instance!;
  }

  static const simplePeriodicTask =
      "be.tramckrijte.workmanagerExample.simplePeriodicTask";
  static const simplePeriodic1HourTask =
      "be.tramckrijte.workmanagerExample.simplePeriodic1HourTask";
  static const iosTaskKey = 'com.kolon.medsalesportaldev.taskId';
  @pragma(
      'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      switch (task) {
        case simplePeriodicTask:
          pr('$simplePeriodicTask was executed');
          break;
        case simplePeriodic1HourTask:
          pr("$simplePeriodic1HourTask was executed");
          break;
        case Workmanager.iOSBackgroundTask:
          pr('IOS task Start! $iosTaskKey');
      }
      return Future.value(true);
    });
  }

  static Future<void> startBackgroundTask() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  }

  static void addOneOffTask() {
    if (Platform.isAndroid) {
      Workmanager().registerPeriodicTask(
        simplePeriodicTask,
        simplePeriodic1HourTask,
        frequency: Duration(seconds: 60),
      );
    }
  }

  static Future<void> cancelAllTask() async {
    try {
      await Workmanager().cancelAll();
    } catch (e) {
      pr(e);
    }
  }
}
