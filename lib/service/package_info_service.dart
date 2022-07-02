/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/service/package_info_service.dart
 * Created Date: 2021-08-17 00:11:38
 * Last Modified: 2022-02-10 12:55:33
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:package_info_plus/package_info_plus.dart';

// 앱 Package 정보 호출.
class PackageInfoService {
  factory PackageInfoService() => _sharedInstance();
  static PackageInfoService? _instance;
  PackageInfoService._();
  static PackageInfoService _sharedInstance() {
    if (_instance == null) {
      _instance = PackageInfoService._();
    }
    return _instance!;
  }

  static Future<PackageInfo> getInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}
