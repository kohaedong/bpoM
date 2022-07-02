/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums/request_type.dart
 * Created Date: 2021-08-27 10:22:15
 * Last Modified: 2022-07-02 15:30:28
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
  SIGNIN,
  REQEUST_TOKEN,
  REFRESHE_TOKEN,
  SAVE_ENV,
  GET_ENV,
  SAVE_DEVICE_INFO,
  SEND_SUGGETION,
  REQUEST_ES_LOGIN,
  NOTICE_ALARM,
  NOTICE_ALARM_COUNT,
  NOTICE_ALARM_CONFIRM,
  NOTICE_DONT_SHOW_AGAIN,
  UN_CONFIRM_ALARM,
  CUSTOMER_INFO,
  CUSTOMER_INFO_BY_SEARCH_COMPANY_TYPE,
  CUSTOMER_GENERAL_INFO,
  CUSTOMER_SALESOPP,
  CUSTOMER_SALESOPP_DETAIL,
  CUSTOMER_RECENT_ORDER,
  CUSTOMER_MANAGER,
  CUSTOMER_MANAGER_DETAIL,
  CUSTOMER_REPORT_SEARCH,
  CUSTOMER_REPORT_SEARCH_DETAIL,
  CUSTOER_REPORT_COMMENT,
  SEARCH_STAFF,
  GET_COUNTRY,
  GET_COUNTRY_AREA,
  GET_CUSTOMER_CATEGORY,
  GET_CUSTOMER_CUSTOMS_INFO,
  ORDER_DETAIL,
  SEARCH_CUSTOMER_REPORT,
  SEARCH_ORDER_MONITORING,
  SEARCH_MATERIAL,
  MATERIAL_IN_STORE,
  DISCOUNT_SURCHARGE,
  ON_SUBMMIT_BY_POTENTIAL_CUSTOMERS,
  ON_SUBMMIT_BY_CONSULTATION_REPORT,
  ON_SUBMMIT_BY_CUSTOMER_MANAGER,
  ON_SUBMMIT_BY_SALES_ORDER,
  SEARCH_DELIVERY_ORDER,
  ORDRE_INFO_DELIVERY_DETAIL,
  ORDER_INFO_DELIVERY_ITEM,
  ORDER_INFO_BILING_DETAIL,
  ORDER_INFO_BILING_ITEM,
  APPROVAL_CUSTOMER_SALES_PRICE_LIST,
  APPROVAL_CUSTOMER_SALES_PRICE_CONFIRM,
  SEARCH_APPROVAL_CUSTOMER,
  APPROVAL_CUSTOMER_DETAIL,
  APPROVAL_CUSTOMER_CONFIRM,
  SEARCH_INVENTORY_FABRIC_STOCK,
  SEARCH_INVENTORY_FILM_STOCK,
  SEARCH_INVENTORY_GENERAL_STOCK,
  SEARCH_AGENCY_ORDER,
  AGENCY_ORDER_DETAIL,
  AGENCY_ORDER_CONFIRM,
  ADDRESS_CITY_AND_AREA,
  ADDRESS_BY_GIBUN_NUMBER,
  ADDRESS_BY_ROAD_NAME,
  CHEAK_STANDARD_PRICE,
  DEFAULT_VALUE_FOR_SUPPLAY_DILIVERY_UNIT,
  DEFAULT_VALUE_FOR_PERSON,
  PRICE_SUM,
  SAVE_TO,
  DO_CREATE,
  SEND_IMAGE_TO_SERVER
}

// [KolonBuildConfig] 빌드 옵션에 따라 url가 변한다.
extension RequestTypeExtension on RequestType {
  bool get isDev => KolonBuildConfig.KOLON_APP_BUILD_TYPE == 'dev';
  String get baseURL => KolonBuildConfig.KOLON_APP_BASE_URL;
  String get prodSalesURL => 'https://apps2.kolon.com';
  String get v2URL => '$baseURL/common/v2/api';
  String get signURL => '$baseURL/common/v2/api/basiclogin/auth';
  String get rfcURL =>
      isDev ? '$baseURL/sales-group/rfc' : '$prodSalesURL/sales-group/rfc';
  String get salesportal => isDev
      ? '$baseURL/sales-group/salesportal'
      : '$prodSalesURL/sales-group/salesportal';

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
      case RequestType.REQEUST_TOKEN:
        return '$baseURL/common/oauth/token';
      case RequestType.REFRESHE_TOKEN:
        return '$baseURL/common//oauth/token';
      case RequestType.SIGNIN:
        return '$signURL';
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
        return '$salesportal/commoncode';
      case RequestType.CUSTOMER_GENERAL_INFO:
        return '$salesportal/customerprofile';
      case RequestType.CUSTOMER_REPORT_SEARCH_DETAIL:
        return '$salesportal/counselingdetail';
      case RequestType.ADDRESS_CITY_AND_AREA:
        return '$salesportal/sidoguncode';
      case RequestType.ADDRESS_BY_ROAD_NAME:
        return '$salesportal/dolomyoungcode';
      case RequestType.ADDRESS_BY_GIBUN_NUMBER:
        return '$salesportal/gibuncode';
      case RequestType.REQUEST_ES_LOGIN:
        return '$rfcURL/login';
      case RequestType.NOTICE_ALARM:
        return '$salesportal/alarmlist';
      case RequestType.NOTICE_ALARM_COUNT:
        return '$rfcURL/common';
      case RequestType.NOTICE_ALARM_CONFIRM:
        return '$rfcURL/common';
      case RequestType.CUSTOMER_INFO:
        return '$rfcURL/common';
      case RequestType.CUSTOMER_INFO_BY_SEARCH_COMPANY_TYPE:
        return '$rfcURL/common';
      case RequestType.CUSTOMER_SALESOPP:
        return '$rfcURL/common';
      case RequestType.CUSTOMER_RECENT_ORDER:
        return '$rfcURL/common';
      case RequestType.CUSTOMER_MANAGER:
        return '$rfcURL/common';
      case RequestType.CUSTOMER_REPORT_SEARCH:
        return '$rfcURL/common';
      case RequestType.CUSTOMER_MANAGER_DETAIL:
        return '$rfcURL/common';
      case RequestType.SEARCH_STAFF:
        return '$rfcURL/common';
      case RequestType.GET_COUNTRY:
        return '$rfcURL/common';
      case RequestType.GET_COUNTRY_AREA:
        return '$rfcURL/common';
      case RequestType.GET_CUSTOMER_CATEGORY:
        return '$rfcURL/common';
      case RequestType.GET_CUSTOMER_CUSTOMS_INFO:
        return '$rfcURL/common';
      case RequestType.SEARCH_CUSTOMER_REPORT:
        return '$rfcURL/common';
      case RequestType.CUSTOMER_SALESOPP_DETAIL:
        return '$rfcURL/common';
      case RequestType.ORDER_DETAIL:
        return '$rfcURL/common';
      case RequestType.ON_SUBMMIT_BY_POTENTIAL_CUSTOMERS:
        return '$rfcURL/common';
      case RequestType.SEARCH_ORDER_MONITORING:
        return '$rfcURL/common';
      case RequestType.SEARCH_MATERIAL:
        return '$rfcURL/common';
      case RequestType.MATERIAL_IN_STORE:
        return '$rfcURL/common';
      case RequestType.DISCOUNT_SURCHARGE:
        return '$rfcURL/common';
      case RequestType.ON_SUBMMIT_BY_CONSULTATION_REPORT:
        return '$rfcURL/common';
      case RequestType.ON_SUBMMIT_BY_CUSTOMER_MANAGER:
        return '$rfcURL/common';
      case RequestType.ON_SUBMMIT_BY_SALES_ORDER:
        return '$rfcURL/common';
      case RequestType.SEARCH_DELIVERY_ORDER:
        return '$rfcURL/common';
      case RequestType.ORDER_INFO_BILING_DETAIL:
        return '$rfcURL/common';
      case RequestType.ORDER_INFO_BILING_ITEM:
        return '$rfcURL/common';
      case RequestType.ORDER_INFO_DELIVERY_ITEM:
        return '$rfcURL/common';
      case RequestType.ORDER_INFO_BILING_DETAIL:
        return '$rfcURL/common';
      case RequestType.APPROVAL_CUSTOMER_SALES_PRICE_LIST:
        return '$rfcURL/common';
      case RequestType.APPROVAL_CUSTOMER_SALES_PRICE_CONFIRM:
        return '$rfcURL/common';
      case RequestType.SEARCH_APPROVAL_CUSTOMER:
        return '$rfcURL/common';
      case RequestType.APPROVAL_CUSTOMER_DETAIL:
        return '$rfcURL/common';
      case RequestType.APPROVAL_CUSTOMER_CONFIRM:
        return '$rfcURL/common';
      case RequestType.SEARCH_INVENTORY_FABRIC_STOCK:
        return '$rfcURL/common';
      case RequestType.SEARCH_INVENTORY_FILM_STOCK:
        return '$rfcURL/common';
      case RequestType.SEARCH_INVENTORY_GENERAL_STOCK:
        return '$rfcURL/common';
      case RequestType.SEARCH_AGENCY_ORDER:
        return '$rfcURL/common';
      case RequestType.AGENCY_ORDER_DETAIL:
        return '$rfcURL/common';
      case RequestType.AGENCY_ORDER_CONFIRM:
        return '$rfcURL/common';
      case RequestType.CHEAK_STANDARD_PRICE:
        return '$rfcURL/common';
      case RequestType.DO_CREATE:
        return '$rfcURL/common';
      case RequestType.CUSTOER_REPORT_COMMENT:
        return '$rfcURL/common';
      case RequestType.DEFAULT_VALUE_FOR_SUPPLAY_DILIVERY_UNIT:
        return '$rfcURL/common';
      case RequestType.DEFAULT_VALUE_FOR_PERSON:
        return '$rfcURL/common';
      case RequestType.PRICE_SUM:
        return '$rfcURL/common';
      case RequestType.ORDRE_INFO_DELIVERY_DETAIL:
        return '$rfcURL/common';
      case RequestType.SAVE_TO:
        return '$rfcURL/common';
      case RequestType.UN_CONFIRM_ALARM:
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
      case RequestType.REQUEST_ES_LOGIN:
        return 'ES_RETURN,ES_LOGIN,T_CODE';
      case RequestType.NOTICE_ALARM:
        return 'ES_RETURN,T_ALARM';
      case RequestType.NOTICE_ALARM_CONFIRM:
        return 'ES_RETURN';
      case RequestType.NOTICE_ALARM_COUNT:
        return 'ES_RETURN,ET_BASESUMMARY';
      case RequestType.NOTICE_DONT_SHOW_AGAIN:
        return '';
      case RequestType.RFC_COMMON_CODE:
        return 'H_TVKO,H_TVKOV,H_TVTA,H_TVKBZ,H_TVBVK,H_T171,H_TVSB,H_TINC,SH_LORD_ZTERM,H_TVKT,ZLTS_H_LTS_AKONT,H_TSKD,SH_DWERK_EXTS,H_TVAG';
      case RequestType.CUSTOMER_INFO:
        return 'ES_RETURN,ET_CUSTOMER';
      case RequestType.CUSTOMER_INFO_BY_SEARCH_COMPANY_TYPE:
        return 'ES_RETURN,ET_CUSTLIST';
      case RequestType.CUSTOMER_GENERAL_INFO:
        return 'ES_RETURN,ET_LONLIST,ET_CUSTOMER,ET_SALEINFO_PA_WE,ET_SALEINFO_PA_Z1,ET_SALEINFO_PA_AG';
      case RequestType.CUSTOMER_SALESOPP:
        return 'ES_RETURN,ET_SALESOPP';
      case RequestType.CUSTOMER_RECENT_ORDER:
        return 'ES_RETURN,ET_PAORLIST';
      case RequestType.CUSTOMER_MANAGER:
        return 'ES_RETURN,T_CONTPERSON';
      case RequestType.CUSTOMER_REPORT_SEARCH:
        return 'ES_RETURN,ET_CUSTOMER';
      case RequestType.CUSTOMER_MANAGER_DETAIL:
        return 'ES_RETURN,T_CON_PER';
      case RequestType.SEARCH_STAFF:
        return 'ES_RETURN,ET_STAFFLIST';
      case RequestType.CUSTOMER_REPORT_SEARCH_DETAIL:
        return '';
      case RequestType.GET_COUNTRY:
        return 'ES_RETURN,T_VALUES';
      case RequestType.GET_COUNTRY_AREA:
        return 'ES_RETURN,T_VALUES';
      case RequestType.GET_CUSTOMER_CATEGORY:
        return 'ET_DD07V_TAB';
      case RequestType.GET_CUSTOMER_CUSTOMS_INFO:
        return 'ES_RETURN,T_VALUES';
      case RequestType.CUSTOMER_SALESOPP_DETAIL:
        return 'ES_RETURN,T_SALEOPP,T_SALEOPPSTAGE,T_SALEOPPMATINFO,T_SALESOPPSAMPLE,T_SALEOPPTESTSTATS,T_SALEOPPATTACH,T_SALEOPPACTPLAN,T_SALESINFO';
      case RequestType.ORDER_DETAIL:
        return 'ES_RETURN,ET_SALESHEADER,ET_SALESORDER,ET_TEXT';
      case RequestType.ON_SUBMMIT_BY_POTENTIAL_CUSTOMERS:
        return 'ES_RETURN,T_CUSTOMER';
      case RequestType.SEARCH_ORDER_MONITORING:
        return 'ES_RETURN,ET_ORDERINFO';
      case RequestType.SEARCH_MATERIAL:
        return 'ES_RETURN,ET_MATERIAL';
      case RequestType.MATERIAL_IN_STORE:
        return 'ES_RETURN,ET_STOCK';
      case RequestType.DISCOUNT_SURCHARGE:
        return 'ES_RETURN,ET_CONDITION';
      case RequestType.ON_SUBMMIT_BY_CONSULTATION_REPORT:
        return 'ES_RETURN,T_CUSTREPORT,T_TEXT';
      case RequestType.ON_SUBMMIT_BY_CUSTOMER_MANAGER:
        return 'ES_RETURN,T_CON_PER';
      case RequestType.ON_SUBMMIT_BY_SALES_ORDER:
        return 'ES_RETURN';
      case RequestType.SEARCH_DELIVERY_ORDER:
        return 'ES_RETURN,ET_DATA';
      case RequestType.ORDER_INFO_BILING_DETAIL:
        return 'ES_RETURN,ET_BILLING';
      case RequestType.ORDER_INFO_BILING_ITEM:
        return 'ES_RETURN,ET_BILLING_I';
      case RequestType.ORDER_INFO_DELIVERY_ITEM:
        return 'ES_RETURN,ET_DELIVERY_I';
      case RequestType.ORDRE_INFO_DELIVERY_DETAIL:
        return 'ES_RETURN,ET_DELIVERY';
      case RequestType.APPROVAL_CUSTOMER_SALES_PRICE_LIST:
        return 'ES_RETURN,T_SALEPRICE';
      case RequestType.APPROVAL_CUSTOMER_SALES_PRICE_CONFIRM:
        return 'ES_RETURN';
      case RequestType.SEARCH_APPROVAL_CUSTOMER:
        return 'ES_RETURN,ET_LIST';
      case RequestType.APPROVAL_CUSTOMER_DETAIL:
        return 'ES_RETURN,ES_CUST,ET_DETAIL';
      case RequestType.APPROVAL_CUSTOMER_CONFIRM:
        return '';
      case RequestType.SEARCH_INVENTORY_FABRIC_STOCK:
        return 'ES_RETURN,ET_STOCK';
      case RequestType.SEARCH_INVENTORY_FILM_STOCK:
        return 'ES_RETURN,ET_STOCK';
      case RequestType.SEARCH_INVENTORY_GENERAL_STOCK:
        return 'ES_RETURN,ET_STOCK';
      case RequestType.SEARCH_AGENCY_ORDER:
        return 'ES_RETURN,T_REQINFO_H';
      case RequestType.AGENCY_ORDER_DETAIL:
        return 'ES_RETURN,T_REQINFO_I,T_OPINON_TEXT';
      case RequestType.AGENCY_ORDER_CONFIRM:
        return 'ES_RETURN';
      case RequestType.CHEAK_STANDARD_PRICE:
        return 'ES_RETURN,ET_PRICE';
      case RequestType.DO_CREATE:
        return 'ES_RETURN';
      case RequestType.CUSTOER_REPORT_COMMENT:
        return 'ES_RETURN,T_COMMENT';
      case RequestType.DEFAULT_VALUE_FOR_PERSON:
        return 'ES_RETURN,ET_PERLIST';
      case RequestType.DEFAULT_VALUE_FOR_SUPPLAY_DILIVERY_UNIT:
        return 'ES_RETURN,ET_KNVVLIST';
      case RequestType.PRICE_SUM:
        return 'ES_RETURN,ET_SIMUALATE,ET_CONDITION';
      case RequestType.SAVE_TO:
        return 'ES_RETURN,ET_LGORT';
      case RequestType.UN_CONFIRM_ALARM:
        return 'ES_RETURN,T_ALARM';
      default:
        return '';
    }
  }

  String get serverMethod {
    switch (this) {
      case RequestType.CHECK_NOTICE:
        return "noticeAll";
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
      case RequestType.REQUEST_ES_LOGIN:
        return 'Z_LTS_IFS0001';
      case RequestType.NOTICE_ALARM:
        return 'Z_LTS_IFR0068';
      case RequestType.NOTICE_ALARM_COUNT:
        return 'Z_LTS_IFS0070';
      case RequestType.NOTICE_ALARM_CONFIRM:
        return 'Z_LTS_IFR0068';
      case RequestType.RFC_COMMON_CODE:
        return 'Z_LTS_IFS0002';
      case RequestType.CUSTOMER_INFO:
        return 'Z_LTS_IFS0005';
      case RequestType.CUSTOMER_INFO_BY_SEARCH_COMPANY_TYPE:
        return 'Z_LTS_IFS6002';
      case RequestType.CUSTOMER_GENERAL_INFO:
        return 'Z_LTS_IFS0007,Z_LTS_IFS0067,Z_LTS_IFS0082';
      case RequestType.CUSTOMER_SALESOPP:
        return 'Z_LTS_IFS0033';
      case RequestType.CUSTOMER_RECENT_ORDER:
        return 'Z_LTS_IFS0066';
      case RequestType.CUSTOMER_MANAGER:
        return 'Z_LTS_IFR0014';
      case RequestType.CUSTOMER_REPORT_SEARCH:
        return 'Z_LTS_IFS0018';
      case RequestType.CUSTOMER_MANAGER_DETAIL:
        return 'Z_LTS_IFS0015';
      case RequestType.SEARCH_STAFF:
        return 'Z_LTS_IFS0068';
      case RequestType.CUSTOMER_REPORT_SEARCH_DETAIL:
        return 'Z_LTS_IFR0010,Z_LTS_IFR0062';
      case RequestType.GET_COUNTRY:
        return 'Z_XP_IFS0003';
      case RequestType.GET_COUNTRY_AREA:
        return 'Z_XP_IFS0003';
      case RequestType.GET_CUSTOMER_CATEGORY:
        return 'Z_LTS_IFS0100';
      case RequestType.GET_CUSTOMER_CUSTOMS_INFO:
        return 'Z_XP_IFS0003';
      case RequestType.CUSTOMER_SALESOPP_DETAIL:
        return 'Z_LTS_IFR0028';
      case RequestType.ORDER_DETAIL:
        return 'Z_LTS_IFS0108';
      case RequestType.ON_SUBMMIT_BY_POTENTIAL_CUSTOMERS:
        return 'Z_LTS_IFR0071';
      case RequestType.SEARCH_ORDER_MONITORING:
        return 'Z_LTS_IFS0121';
      case RequestType.SEARCH_MATERIAL:
        return 'Z_LTS_IFS0102';
      case RequestType.MATERIAL_IN_STORE:
        return 'Z_LTS_IFS0127';
      case RequestType.DISCOUNT_SURCHARGE:
        return 'Z_LTS_IFS0123';
      case RequestType.ON_SUBMMIT_BY_CONSULTATION_REPORT:
        return 'Z_LTS_IFR0010';
      case RequestType.ON_SUBMMIT_BY_CUSTOMER_MANAGER:
        return 'Z_LTS_IFS0015';
      case RequestType.ON_SUBMMIT_BY_SALES_ORDER:
        return 'Z_LTS_IFR0122';
      case RequestType.SEARCH_DELIVERY_ORDER:
        return 'Z_LTS_IFS0125';
      case RequestType.ORDER_INFO_BILING_DETAIL:
        return 'Z_LTS_IFS0110';
      case RequestType.ORDER_INFO_BILING_ITEM:
        return 'Z_LTS_IFS0110';
      case RequestType.ORDER_INFO_DELIVERY_ITEM:
        return 'Z_LTS_IFS0109';
      case RequestType.ORDRE_INFO_DELIVERY_DETAIL:
        return 'Z_LTS_IFS0109';
      case RequestType.APPROVAL_CUSTOMER_SALES_PRICE_LIST:
        return 'Z_LTS_IFS0107';
      case RequestType.APPROVAL_CUSTOMER_SALES_PRICE_CONFIRM:
        return 'Z_LTS_IFS0107';
      case RequestType.SEARCH_APPROVAL_CUSTOMER:
        return 'Z_LTS_IFS8601';
      case RequestType.APPROVAL_CUSTOMER_DETAIL:
        return 'Z_LTS_IFS8602';
      case RequestType.APPROVAL_CUSTOMER_CONFIRM:
        return 'Z_LTS_IFS8603';
      case RequestType.SEARCH_INVENTORY_FABRIC_STOCK:
        return 'Z_LTS_IFS0106';
      case RequestType.SEARCH_INVENTORY_FILM_STOCK:
        return 'Z_LTS_IFS0105';
      case RequestType.SEARCH_INVENTORY_GENERAL_STOCK:
        return 'Z_LTS_IFS0104';
      case RequestType.SEARCH_AGENCY_ORDER:
        return 'Z_LTS_IFR0120';
      case RequestType.AGENCY_ORDER_DETAIL:
        return 'Z_LTS_IFR0120';
      case RequestType.AGENCY_ORDER_CONFIRM:
        return 'Z_LTS_IFR0120';
      case RequestType.ADDRESS_CITY_AND_AREA:
        return 'sidoguncode';
      case RequestType.ADDRESS_BY_ROAD_NAME:
        return 'dolomyoungcode';
      case RequestType.ADDRESS_BY_GIBUN_NUMBER:
        return 'gibuncode';
      case RequestType.CHEAK_STANDARD_PRICE:
        return 'Z_LTS_IFS0043';
      case RequestType.DO_CREATE:
        return 'Z_LTS_IFS0129';
      case RequestType.CUSTOER_REPORT_COMMENT:
        return 'Z_LTS_IFR0062';
      case RequestType.DEFAULT_VALUE_FOR_PERSON:
        return 'Z_LTS_IFS0089';
      case RequestType.DEFAULT_VALUE_FOR_SUPPLAY_DILIVERY_UNIT:
        return 'Z_LTS_IFS0065';
      case RequestType.PRICE_SUM:
        return 'Z_LTS_IFS0083';
      case RequestType.SAVE_TO:
        return 'Z_LTS_IFS0101';
      //! api 개발 완료 후 추가.
      case RequestType.UN_CONFIRM_ALARM:
        return 'Z_LTS_IFR0069';
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
