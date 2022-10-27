/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/service/deviceInfo_service.dart
 * Created Date: 2021-08-16 21:01:02
 * Last Modified: 2022-10-27 14:12:37
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:medsalesportal/model/user/user_device_info.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:platform_device_id/platform_device_id.dart';

class DeviceInfoService {
  factory DeviceInfoService() => _sharedInstance();
  static DeviceInfoService? _instance;
  DeviceInfoService._();
  static DeviceInfoService _sharedInstance() {
    _instance ??= DeviceInfoService._();
    return _instance!;
  }

  static Future<UserDeviceInfo> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    AndroidDeviceInfo androidInfo;
    IosDeviceInfo iosDeviceInfo;
    UserDeviceInfo? userDeviceInfo;
    if (Platform.isIOS) {
      iosDeviceInfo = await deviceInfo.iosInfo;
      userDeviceInfo = UserDeviceInfo(
          '${iosDeviceInfo.identifierForVendor}',
          'apple',
          '${iosDeviceInfo.utsname.nodename}',
          '${iosDeviceInfo.utsname.machine}',
          '${iosDeviceInfo.systemVersion}');
    }
    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
      String? deviceId = await PlatformDeviceId.getDeviceId;
      userDeviceInfo = UserDeviceInfo(
          '${deviceId}',
          '${androidInfo.brand}',
          '${androidInfo.device}',
          '${androidInfo.model}',
          '${androidInfo.version.sdkInt}');
    }

    return userDeviceInfo!;
  }
}
