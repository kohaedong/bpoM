/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/service/permission_type.dart
 * Created Date: 2021-08-13 11:39:15
 * Last Modified: 2022-01-28 10:09:52
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
// 권한 유형.
enum AppPermissionType {
  notification,
  microphones,
  camera,
  photoLibraray,
  location,
  storage
}

extension AppPermissionTypeExtension on AppPermissionType {
  String get key {
    switch (this) {
      case AppPermissionType.notification:
        return "notification";
      case AppPermissionType.microphones:
        return "microphones";
      case AppPermissionType.camera:
        return "camera";
      case AppPermissionType.photoLibraray:
        return "photoLibraray";
      case AppPermissionType.location:
        return "location";
      case AppPermissionType.storage:
        return "storge";
    }
  }
}
