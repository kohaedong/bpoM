/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/service/background_task_service.dart
 * Created Date: 2022-10-24 03:38:32
 * Last Modified: 2022-10-25 15:33:26
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'dart:io';
import 'package:medsalesportal/globalProvider/login_provider.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:provider/provider.dart';
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

  @pragma('vm:entry-point')
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      switch (task) {
        case simplePeriodicTask:
          pr('$simplePeriodicTask was executed');
          break;
        case simplePeriodic1HourTask:
          final sp =
              KeyService.baseAppKey.currentContext!.read<LoginProvider>();
          await sp.saveUserEnvironment();
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
    );
  }

  static Future<void> addTask() async {
    if (Platform.isAndroid) {
      try {
        await Workmanager().registerPeriodicTask(
          'onlyone',
          simplePeriodic1HourTask,
          frequency: Duration(minutes: 30),
        );
      } catch (e) {
        pr(e);
      }
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
