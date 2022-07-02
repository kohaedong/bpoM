/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/service/permission_service.dart
 * Created Date: 2021-08-13 11:38:37
 * Last Modified: 2022-07-02 13:49:49
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:medsalesportal/enums/permission_type.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:permission_handler/permission_handler.dart';

//*  앱 권한 요청.
class PermissionService {
  static Future<PermissionStatus> request(AppPermissionType type) async {
    switch (type) {
      case AppPermissionType.camera: // 카메라
        return await handler.Permission.camera.request();
      case AppPermissionType.location: // 위치정보
        return await handler.Permission.location.request();
      case AppPermissionType.microphones: // 마이크로폰
        return await handler.Permission.microphone.request();
      case AppPermissionType.notification: // 알림
        return await handler.Permission.notification.request();
      case AppPermissionType.photoLibraray: // 갤러리
        return await handler.Permission.photos.request();
      case AppPermissionType.storage: // 파일저장소
        return await handler.Permission.storage.request();
    }
  }

// 권한 부여 여부
  static Future<bool> isGranted(handler.Permission permission) async =>
      await permission.isGranted;
}
