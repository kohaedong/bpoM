/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums/update_type.dart
 * Created Date: 2021-08-12 14:35:41
 * Last Modified: 2022-01-28 11:11:01
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

// * 업데이트 결과 유형
enum UpdateType {
  NOT_WEB_ENFORCE, // 문구가 html/xml/url 아니고, 취소 누르면 앱이 강제종료 됨.
  WEB_ENFORCE, // 문구가 webView로 보여줘야 하고, 취소 누르면 앱이 강제종료 됨.
  LOCAL_CHOOSE, //문구가 html/xml/url 아니고, 취소 누르면 팝업 닫힘.
  WEB_CHOOSE, // 문구가 webView로 보여줘야 하고, 취소 누르면 팝업 닫힘.
}
