/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums/request_type.dart
 * Created Date: 2021-08-27 10:22:15
 * Last Modified: 2022-08-16 17:02:16
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:medsalesportal/buildConfig/kolon_build_config.dart';
import 'package:medsalesportal/service/deviceInfo_service.dart';

//*  api url / functionName/ resultTable 사전 정의.
enum RequestType {
  RFC_COMMON_CODE,
  CHECK_NOTICE,
  CHECK_UPDATE,
  SAP_SIGNIN_INFO,
  SIGNIN,
  REQEUST_TOKEN,
  REFRESHE_TOKEN,
  SAVE_ENV,
  GET_ENV,
  SAVE_DEVICE_INFO,
  SEND_SUGGETION,
  HOME_NOTICE,
  HOME_NOTICE_DETAIL,
  NOTICE_DONT_SHOW_AGAIN,
  SEND_IMAGE_TO_SERVER,
  GET_OFFICE_ADDRESS,
  GET_LAT_AND_LON,
  SEARCH_KEY_MAN,
  // --------------
  SEARCH_STAFF,
  SEARCH_CUSTOMER,
  SEARCH_SALSE_ACTIVITY,
  SALSE_ACTIVITY_DETAIL,
  SEARCH_SALLER,
  SEARCH_SALLER_FOR_BULK_ORDER,
  SEARCH_END_OR_DELIVERY_CUSTOMER,
  SEARCH_ORDER,
  ORDER_CANCEL,
  SEARCH_TRANSACTION_LEDGER,
  SEARCH_BULK_ORDER,
  GET_BULK_DETAIL,
  AMOUNT_AVAILABLE_FOR_ORDER_ENTRY,
  CHECK_META_PRICE_AND_STOCK,
  ORDER_CANCEL_AND_SAVE,
  SEARCH_DETAIL_BOOK,
  DETAIL_BOOK_SEARCH_FILE,
  SALESE_ACTIVITY_MONTH_DATA,
  SALESE_ACTIVITY_DAY_DATA,
  SEARCH_PARTMENT_KEY_ZIBI,
  CHECK_HOLIDAY,
  GET_DISTANCE,
}

// [KolonBuildConfig] 빌드 옵션에 따라 url가 변한다.
extension RequestTypeExtension on RequestType {
  String get baseURL => KolonBuildConfig.KOLON_APP_BASE_URL;
  String get v2URL => '$baseURL/common/v2/api';
  String get signURL => '$baseURL/common/v2/api/basiclogin/auth';
  String get rfcURL => '$baseURL/sales-group/rfc';
  String get medical => '$baseURL/sales-group/med';
  // api 에 header 추가 필요시 사전 등록.
  Future<Map<String, String>> get anotherHeader async {
    final deviceInfo = await DeviceInfoService.getDeviceInfo();
    final Map<String, String> tempHeader = {
      "devicePlatformNm": Platform.isIOS ? "iOS Phone" : "Android Phone",
      "hckMngYn": "n",
      "osVerNm": '${deviceInfo.deviceVersion}'
    };
    switch (this) {
      case RequestType.REQEUST_TOKEN:
        return tempHeader;
      case RequestType.SIGNIN:
        return tempHeader;
      case RequestType.SAVE_ENV:
        return tempHeader;
      case RequestType.GET_ENV:
        return tempHeader;
      case RequestType.SAVE_DEVICE_INFO:
        return tempHeader;
      case RequestType.SEND_SUGGETION:
        return tempHeader;
      case RequestType.NOTICE_DONT_SHOW_AGAIN:
        return tempHeader;
      default:
        return {'Timestamp': DateTime.now().toIso8601String()};
    }
  }
//*  url은 api 추가 할때 마다 지정 해줘야 함.
//*  default 값이 없다.

  String url({String? params}) {
    switch (this) {
      case RequestType.SEARCH_STAFF:
        return '$rfcURL/common';
      case RequestType.SEARCH_KEY_MAN:
        return '$rfcURL/common';
      case RequestType.GET_OFFICE_ADDRESS:
        return '$rfcURL/common';
      case RequestType.SALESE_ACTIVITY_DAY_DATA:
        return '$rfcURL/common';
      case RequestType.SEARCH_PARTMENT_KEY_ZIBI:
        return '$rfcURL/common';
      case RequestType.SALESE_ACTIVITY_MONTH_DATA:
        return '$rfcURL/common';
      case RequestType.DETAIL_BOOK_SEARCH_FILE:
        return '$rfcURL/file';
      case RequestType.SEARCH_DETAIL_BOOK:
        return '$rfcURL/common';
      case RequestType.ORDER_CANCEL_AND_SAVE:
        return '$rfcURL/common';
      case RequestType.CHECK_META_PRICE_AND_STOCK:
        return '$rfcURL/common';
      case RequestType.AMOUNT_AVAILABLE_FOR_ORDER_ENTRY:
        return '$rfcURL/common';
      case RequestType.GET_BULK_DETAIL:
        return '$rfcURL/common';
      case RequestType.SEARCH_BULK_ORDER:
        return '$rfcURL/common';
      case RequestType.SEARCH_END_OR_DELIVERY_CUSTOMER:
        return '$rfcURL/common';
      case RequestType.SEARCH_TRANSACTION_LEDGER:
        return '$rfcURL/common';
      case RequestType.ORDER_CANCEL:
        return '$rfcURL/common';
      case RequestType.SEARCH_ORDER:
        return '$rfcURL/common';
      case RequestType.SEARCH_SALLER:
        return '$rfcURL/common';
      case RequestType.SEARCH_SALLER_FOR_BULK_ORDER:
        return '$rfcURL/common';
      case RequestType.SEARCH_CUSTOMER:
        return '$rfcURL/common';
      case RequestType.SEARCH_SALSE_ACTIVITY:
        return '$rfcURL/common';
      case RequestType.SALSE_ACTIVITY_DETAIL:
        return '$rfcURL/common';
      case RequestType.REQEUST_TOKEN:
        return '$baseURL/common/oauth/token';
      case RequestType.REFRESHE_TOKEN:
        return '$baseURL/common//oauth/token';
      case RequestType.SIGNIN:
        return '$signURL';
      case RequestType.SAP_SIGNIN_INFO:
        return '$rfcURL/login';
      case RequestType.CHECK_HOLIDAY:
        return '$v2URL/opendata/holiday';
      case RequestType.GET_LAT_AND_LON:
        return '$medical/getcoordinate';
      case RequestType.GET_DISTANCE:
        return '$medical/getdistancenew';
      case RequestType.CHECK_NOTICE:
        return '$v2URL/rest';
      case RequestType.NOTICE_DONT_SHOW_AGAIN:
        return '$v2URL/rest';
      case RequestType.SEND_IMAGE_TO_SERVER:
        return '$v2URL/rest';
      case RequestType.CHECK_UPDATE:
        return '$v2URL/rest';
      case RequestType.SAVE_ENV:
        return '$v2URL/rest';
      case RequestType.GET_ENV:
        return '$v2URL/rest';
      case RequestType.SAVE_DEVICE_INFO:
        return '$v2URL/rest';
      case RequestType.SEND_SUGGETION:
        return '$v2URL/rest';
      case RequestType.RFC_COMMON_CODE:
        return '$medical/commoncode';
      case RequestType.HOME_NOTICE:
        return '$rfcURL/common';
      case RequestType.HOME_NOTICE_DETAIL:
        return '$rfcURL/common';
    }
  }

// 메소드 사전 등록.
  String get httpMethod {
    switch (this) {
      default:
        return 'POST';
    }
  }

//resultTable 사전 등록.
  String get resultTable {
    switch (this) {
      case RequestType.SEARCH_STAFF:
        return 'ES_RETURN,ET_STAFFLIST';
      case RequestType.SEARCH_KEY_MAN:
        return 'ES_RETURN,ET_LIST';
      case RequestType.GET_OFFICE_ADDRESS:
        return 'ES_RETURN,T_LIST';
      case RequestType.SALESE_ACTIVITY_DAY_DATA:
        return 'ES_RETURN,T_ZLTSP0250S,T_ZLTSP0260S,T_ZLTSP0270S,T_ZLTSP0280S,T_ZLTSP0290S,T_ZLTSP0291S,T_ZLTSP0300S,T_ZLTSP0301S,T_ZLTSP0310S,T_ZLTSP0320S,T_ZLTSP0321S,T_ZLTSP0330S,T_ZLTSP0340S,T_ZLTSP0350S,T_ZLTSP0430S, T_ZLTSP0361S';
      case RequestType.SEARCH_PARTMENT_KEY_ZIBI:
        return 'ES_RETURN,T_LIST,T_LIST2';
      case RequestType.SALESE_ACTIVITY_MONTH_DATA:
        return 'ES_RETURN,T_LIST';
      case RequestType.DETAIL_BOOK_SEARCH_FILE:
        return 'ES_RETURN,ES_FILEINFO,ET_DRAO,ET_URL,ATTACH_INFO';
      case RequestType.SEARCH_DETAIL_BOOK:
        return 'ES_RETURN,T_LIST';
      case RequestType.ORDER_CANCEL_AND_SAVE:
        return 'ES_RETURN,T_HEAD,T_ITEM';
      case RequestType.CHECK_META_PRICE_AND_STOCK:
        return 'ES_RETURN,T_LIST';
      case RequestType.AMOUNT_AVAILABLE_FOR_ORDER_ENTRY:
        return 'ES_RETURN,T_CREDIT_LIMIT';
      case RequestType.GET_BULK_DETAIL:
        return 'ES_RETURN,T_HEAD,T_ITEM';
      case RequestType.SEARCH_BULK_ORDER:
        return 'ES_RETURN,T_LIST';
      case RequestType.SEARCH_END_OR_DELIVERY_CUSTOMER:
        return 'ES_RETURN,ET_CUSTLIST';
      case RequestType.SEARCH_TRANSACTION_LEDGER:
        return 'ES_RETURN,ES_HEAD,T_LIST,T_REPORT';
      case RequestType.ORDER_CANCEL:
        return 'ES_RETURN';
      case RequestType.SEARCH_ORDER:
        return 'ES_RETURN,T_LIST';
      case RequestType.SEARCH_SALLER:
        return 'ES_RETURN,ET_CUSTOMER,IT_KTOKD';
      case RequestType.SEARCH_SALLER_FOR_BULK_ORDER:
        return 'ES_RETURN,ET_CUSTOMER,IT_KTOKD';
      case RequestType.SEARCH_CUSTOMER:
        return 'ES_RETURN,ET_KUNNR';
      case RequestType.SEARCH_SALSE_ACTIVITY:
        return 'ES_RETURN,T_LIST';
      case RequestType.SAP_SIGNIN_INFO:
        return 'ES_RETURN,ET_ORGHK,T_CODE,ET_VKGRP,IS_LOGIN,ES_LOGIN';
      case RequestType.HOME_NOTICE:
        return 'ES_RETURN,T_ZLTSP0710';
      case RequestType.HOME_NOTICE_DETAIL:
        return 'ES_RETURN,T_ZLTSP0700,T_TEXT,T_VKGRP';
      case RequestType.NOTICE_DONT_SHOW_AGAIN:
        return '';
      case RequestType.RFC_COMMON_CODE:
        return 'H_TVKO,H_TVKOV,H_TVTA,H_TVKBZ,H_TVBVK,H_T171,H_TVSB,H_TINC,SH_LORD_ZTERM,H_TVKT,ZLTS_H_LTS_AKONT,H_TSKD,SH_DWERK_EXTS,H_TVAG';

      default:
        return '';
    }
  }

  String get resultColums {
    switch (this) {
      case RequestType.HOME_NOTICE:
        return 'ERRCODE,ERRMSG';
      case RequestType.HOME_NOTICE_DETAIL:
        return 'ERRCODE,ERRMSG';
      default:
        return '';
    }
  }

  String get serverMethod {
    switch (this) {
      case RequestType.CHECK_NOTICE:
        return "noticeAll";
      case RequestType.GET_OFFICE_ADDRESS:
        return "Z_LTSP_IF0133";
      case RequestType.SALESE_ACTIVITY_DAY_DATA:
        return "Z_LTSP_IF0130";
      case RequestType.SEARCH_PARTMENT_KEY_ZIBI:
        return "Z_LTSP_IF0331";
      case RequestType.SALESE_ACTIVITY_MONTH_DATA:
        return "Z_LTSP_IF0332";
      case RequestType.DETAIL_BOOK_SEARCH_FILE:
        return "Z_LTSP_IF0893";
      case RequestType.SEND_IMAGE_TO_SERVER:
        return 'screenCapture';
      case RequestType.NOTICE_DONT_SHOW_AGAIN:
        return "saveNoticeTodayHide";
      case RequestType.CHECK_UPDATE:
        return "updateCheck";
      case RequestType.SAVE_ENV:
        return 'saveOfAppUserEnv';
      case RequestType.GET_ENV:
        return 'getOfAppUserEnv';
      case RequestType.SAVE_DEVICE_INFO:
        return 'saveDeviceInfoByAnonymous';
      case RequestType.SEND_SUGGETION:
        return 'saveOfAppOpinionByAnonymous';
      case RequestType.SAP_SIGNIN_INFO:
        return "Z_LTS_IFS0001";
      case RequestType.HOME_NOTICE:
        return 'Z_LTSP_IF0710';
      case RequestType.HOME_NOTICE_DETAIL:
        return 'Z_LTSP_IF0700';
      case RequestType.RFC_COMMON_CODE:
        return 'Z_LTS_IFS0002';
      // --------------------
      case RequestType.SEARCH_STAFF:
        return 'Z_LTS_IFS0068';
      case RequestType.SEARCH_END_OR_DELIVERY_CUSTOMER:
        return 'Z_LTS_IFS6002';
      case RequestType.SEARCH_CUSTOMER:
        return 'Z_LTSP_IF0030';
      case RequestType.SEARCH_SALSE_ACTIVITY:
        return 'Z_LTSP_IF0160';
      case RequestType.SEARCH_SALLER:
        return 'Z_LTSP_IF0022';
      case RequestType.SEARCH_SALLER_FOR_BULK_ORDER:
        return 'Z_LTS_IFS0005';
      case RequestType.SEARCH_ORDER:
        return 'Z_LTSP_IF0081';
      case RequestType.ORDER_CANCEL:
        return 'Z_LTSP_IF0088';
      case RequestType.SEARCH_TRANSACTION_LEDGER:
        return 'Z_LTSP_IF0350';
      case RequestType.SEARCH_BULK_ORDER:
        return 'Z_LTSP_IF0914';
      case RequestType.GET_BULK_DETAIL:
        return 'Z_LTSP_IF0913';
      case RequestType.AMOUNT_AVAILABLE_FOR_ORDER_ENTRY:
        return 'Z_LTSP_IF0086';
      case RequestType.CHECK_META_PRICE_AND_STOCK:
        return 'Z_LTSP_IF0082';
      case RequestType.ORDER_CANCEL_AND_SAVE:
        return 'Z_LTSP_IF0913';
      case RequestType.SEARCH_DETAIL_BOOK:
        return "Z_LTSP_IF0891";
      case RequestType.SEARCH_KEY_MAN:
        return "Z_LTSP_IF0054";
      default:
        throw NullThrownError();
    }
  }

// Dio에서 api cancel시 사용 된는 구분자.
  String get tag {
    switch (this) {
      default:
        return "tag_${this.runtimeType}";
    }
  }

// 토큰을 사용하는 api 지정
// 토큰 사용 하는 api는 ApiService RequestWarper에서 Token을 자동 추가해준다.
  bool get isWithAccessToken {
    switch (this) {
      case RequestType.REQEUST_TOKEN:
        return false;
      case RequestType.REFRESHE_TOKEN:
        return false;
      default:
        return true;
    }
  }
}
