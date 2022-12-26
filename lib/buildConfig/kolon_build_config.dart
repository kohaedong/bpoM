/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/model/buildConfig/kolon_build_config.dart
 * Created Date: 2022-07-04 13:56:13
 * Last Modified: 2022-11-14 16:38:33
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

class KolonBuildConfig {
  //  개발 환경
  /*
  static const KOLON_APP_VERSION_NAME = "01.00.05";
  static const KOLON_APP_BASE_URL = "https://appdev.kolon.com";
  static const KOLON_APP_BUILD_TYPE = "dev";
  static const ATTACH_BASE_URL = 'https://mkolonviewdev.kolon.com/SynapDocViewServer/job?fileType=URL&';
  static const ATTACH_VIEW_URL = 'https://mkolonviewdev.kolon.com/SynapDocViewServer/viewer/doc.html?key=';
  static const BPO_URL = 'https://test-kbow.kolon.com/web/main.do?hash=';
  static const SERVICE_ID_AOS = "16892";
  static const SERVICE_ID_IOS = "16893";

   */
  // 운영 환경
  static const KOLON_APP_VERSION_NAME = "01.00.10"; // ios
  static const KOLON_APP_BASE_URL = "https://apps.kolon.com";
  static const KOLON_APP_BUILD_TYPE = "prod";
  static const ATTACH_BASE_URL = 'https://mkolonview.kolon.com/SynapDocViewServer/job?fileType=URL&';
  static const ATTACH_VIEW_URL = 'https://mkolonview.kolon.com/SynapDocViewServer/viewer/doc.html?key=';
  static const BPO_URL = 'https://kbow.kolon.com/web/main.do?hash=';
  static const SERVICE_ID_AOS = "3016";
  static const SERVICE_ID_IOS = "3017";
}
