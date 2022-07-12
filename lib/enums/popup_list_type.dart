/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums/list_group_type.dart
 * Created Date: 2021-09-10 09:52:32
 * Last Modified: 2022-07-12 17:37:47
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/order_type.dart';
import 'package:medsalesportal/styles/app_size.dart';

// 팝업창이 단순 list 형태 일 경우 팝업 title / 내용 / 버튼 / 등 구분 해주는 enum.
typedef CommononeCellDataCallback = Future<List<String>?> Function();

enum OneCellType {
  // medSalesPortal
  MANAGER,
  SEARCH_CUSTOMER,
  SEARCH_PRODUCTS_CATEGORY,
  SEARCH_PROCESS_STATUS,
  SEARCH_SALLER,
  // -------------
  SEARCH_CUSTOMER_CONDITION,
  SEARCH_CUSOMER_TYPE,
  SEARCH_SALSE_PERSON,
  SEARCH_MATERIALS,
  SEARCH_CIRCULATION_CHANNEL,
  SEARCH_SALES_AREA,
  SEARCH_ORG,
  SEARCH_PRODUCT_FAMILY,
  SEARCH_BUSINESS_PLACE,
  SEARCH_BUSINESS_GROUP,
  SEARCH_CITY,
  SEARCH_CITY_AREA,
  SELECT_GENDER,
  SELECT_KEY_MAN,
  SELECT_FINANCIA,
  SEARCH_TARIFF,
  SEARCH_SHIPPING,
  DATE_PICKER,
  REPORT_TYPE,
  CUSTOMER_IMPORTANTS,
  CUSTOMER_RELATION,
  CONSULTATION_REPORT_METHOD,
  CONSULTATION_REPORT_IMPOTANCE,
  CONSULTATION_REPORT_TYPE,
  DISCOUNT_SURCHARGE,
  DO_SAVE_TO,
  INVENTORY_SAVE_TO,
  DO_CREATE,
  CUSTOMER_APPROVAL_REFUSE,
  CUSTOMER_APPROVAL_RESERVE,
  CUSTOMER_APPROVAL_APPROVAL,
  AGENCY_APPROVAL_REFUSE,
  AGENCY_APPROVAL_RESERVE,
  AGENCY_APPROVAL_APPROVAL,
  SALES_ORDER_PAGE_ORDER_TYPE,
  SALES_ORDER_SALES_ORG,
  SALES_ORDER_PAGE_CIRCULATION_CHANNEL,
  SALES_ORDER_PAGE_PRODUCT_FAMILY,
  SALES_ORDER_PAGE_BUSINESS_PLACE,
  SALES_ORDER_PAGE_BUSINESS_GROUP,
  SALES_ORDER_PAGE_SALES_OFFICE,
  SALES_ORDER_PAGE_SUPPLIER,
  SALES_ORDER_PAGE_END_CUSTOMER,
  SALES_ORDER_PAGE_SPECIAL_PARTNER,
  SALES_ORDER_PAGE_DELIVERY_CONDITION,
  SALES_ORDER_PAGE_SUPPLY_CONDITION,
  SALES_ORDER_PAGE_CURRENCY_UNIT,
  SALES_ORDER_PAGE_ITEM,
  SEARCH_ORDER_MONITORING_BUSINISS_GROUP,
  SEARCH_PLANT_CONDITION,
  SEARCH_PLANT_RESULT,
  FABRIC_STOCK_PLANT,
  SALESE_ORDER_ITEM_QUANTITY_UNIT,
  ADDRESS_CITY,
  ADDRESS_CITY_AREA,
  CUSTOMER_APPROVAL_STATE,
  ORDER_MONITORING_STATE,
  AGENCY_OPINION,
  SPECIAL_DELIVERY_CONDITION,
  NULL_CHECK,
  DO_NOTHING,
}

extension OneCellTypeExtension on OneCellType {
  String get title {
    switch (this) {
      case OneCellType.SEARCH_SALLER:
        return '${tr('sales_office')}';
      case OneCellType.SEARCH_CUSTOMER:
        return '${tr('search_customer')}';
      case OneCellType.SEARCH_SALSE_PERSON:
        return '${tr('sales_person')}';
      case OneCellType.SEARCH_CUSOMER_TYPE:
        return '${tr('customer_type')}';
      case OneCellType.CUSTOMER_RELATION:
        return '${tr('relation_strength')}';
      case OneCellType.CONSULTATION_REPORT_TYPE:
        return '${tr('consulting_type')}';
      case OneCellType.SEARCH_ORG:
        return '${tr('sales_org')}';
      case OneCellType.SEARCH_PLANT_CONDITION:
        return '${tr('search_condition')}';
      case OneCellType.SEARCH_CIRCULATION_CHANNEL:
        return '${tr('circulaton_cannel')}';
      case OneCellType.SEARCH_SALES_AREA:
        return '${tr('sales_area')}';
      case OneCellType.SEARCH_PRODUCT_FAMILY:
        return '${tr('product_family')}';
      case OneCellType.SEARCH_BUSINESS_GROUP:
        return '${tr('salse_group')}';
      case OneCellType.SEARCH_BUSINESS_PLACE:
        return '${tr('business_place')}';
      case OneCellType.SEARCH_TARIFF:
        return '${tr('tariff_type')}';
      case OneCellType.SEARCH_SHIPPING:
        return '${tr('shipping_conditions')}';
      case OneCellType.DO_SAVE_TO:
        return '${tr('save_to')}';
      case OneCellType.SELECT_KEY_MAN:
        return '${tr('is_key_man')}';
      case OneCellType.INVENTORY_SAVE_TO:
        return '${tr('save_to')}';
      case OneCellType.CUSTOMER_IMPORTANTS:
        return '${tr('importants_')}';
      case OneCellType.DO_CREATE:
        return '${tr('do_create')}';
      case OneCellType.DISCOUNT_SURCHARGE:
        return '${tr('discount_surcharge_')}';
      case OneCellType.CUSTOMER_APPROVAL_REFUSE:
        return '${tr('refuse')} ${tr('do_you')}';
      case OneCellType.CUSTOMER_APPROVAL_RESERVE:
        return '${tr('reserve')} ${tr('do_you')}';
      case OneCellType.CUSTOMER_APPROVAL_APPROVAL:
        return '${tr('approval')} ${tr('do_you')}';
      case OneCellType.AGENCY_APPROVAL_REFUSE:
        return '${tr('refuse_')} ${tr('do_you')}';
      case OneCellType.SEARCH_ORDER_MONITORING_BUSINISS_GROUP:
        return '${tr('salse_group')}';
      case OneCellType.SALES_ORDER_PAGE_BUSINESS_GROUP:
        return '${tr('salse_group')}';
      case OneCellType.SALES_ORDER_PAGE_BUSINESS_PLACE:
        return '${tr('business_place')}';
      case OneCellType.SALES_ORDER_PAGE_CIRCULATION_CHANNEL:
        return '${tr('circulaton_cannel')}';
      case OneCellType.SALES_ORDER_PAGE_CURRENCY_UNIT:
        return '${tr('currency_unit')}';
      case OneCellType.SALES_ORDER_PAGE_DELIVERY_CONDITION:
        return '${tr('delivery_condition')}';
      case OneCellType.SALES_ORDER_PAGE_END_CUSTOMER:
        return '${tr('end_customer')}';
      case OneCellType.SALES_ORDER_PAGE_ITEM:
        return '${tr('item')}';
      case OneCellType.SALES_ORDER_PAGE_ORDER_TYPE:
        return '${tr('order_type')}';
      case OneCellType.SALES_ORDER_PAGE_PRODUCT_FAMILY:
        return '${tr('product_family')}';
      case OneCellType.SALES_ORDER_PAGE_SALES_OFFICE:
        return '${tr('sales_office')}';
      case OneCellType.SALES_ORDER_PAGE_ITEM:
        return '${tr('item')}';
      case OneCellType.SALES_ORDER_PAGE_SPECIAL_PARTNER:
        return '${tr('special_partner')}';
      case OneCellType.SALES_ORDER_PAGE_SUPPLIER:
        return '${tr('supplier')}';
      case OneCellType.SALES_ORDER_PAGE_SUPPLY_CONDITION:
        return '${tr('payment_condition')}';
      case OneCellType.SALES_ORDER_SALES_ORG:
        return '${tr('sales_org')}';
      case OneCellType.SALESE_ORDER_ITEM_QUANTITY_UNIT:
        return '${tr('quantity_unit')}';
      case OneCellType.ADDRESS_CITY:
        return '${tr('city')}';
      case OneCellType.ADDRESS_CITY_AREA:
        return '${tr('district')}';
      case OneCellType.SELECT_GENDER:
        return '${tr('gender')}';
      case OneCellType.SELECT_KEY_MAN:
        return '${tr('key_man')}';
      case OneCellType.SELECT_FINANCIA:
        return '${tr('is_financial_manager')}';
      case OneCellType.CUSTOMER_APPROVAL_STATE:
        return '${tr('state')}';
      case OneCellType.ORDER_MONITORING_STATE:
        return '${tr('state')}';
      case OneCellType.FABRIC_STOCK_PLANT:
        return '${tr('plant')}';
      case OneCellType.AGENCY_OPINION:
        return '${tr('opinion')}';
      case OneCellType.SPECIAL_DELIVERY_CONDITION:
        return '${tr('special_delivery_condition')}';
      case OneCellType.CONSULTATION_REPORT_METHOD:
        return '${tr('method_of_consulting')}';
      case OneCellType.CONSULTATION_REPORT_IMPOTANCE:
        return '${tr('importance_')}';

      // medSalsePortal
      case OneCellType.MANAGER:
        return '${tr('manager')}';
      case OneCellType.SEARCH_CUSTOMER:
        return '${tr('search_customer')}';
      case OneCellType.SEARCH_PRODUCTS_CATEGORY:
        return '${tr('products_category')}';
      case OneCellType.SEARCH_PRODUCT_FAMILY:
        return '${tr('product_family')}';
      case OneCellType.SEARCH_PROCESS_STATUS:
        return '${tr('product_process_status')}';
      default:
        return '${tr('search_condition')}';
    }
  }

  String get buttonText {
    switch (this) {
      case OneCellType.CUSTOMER_APPROVAL_REFUSE:
        return '${tr('refuse')}';
      case OneCellType.CUSTOMER_APPROVAL_RESERVE:
        return '${tr('reserve')}';
      case OneCellType.CUSTOMER_APPROVAL_APPROVAL:
        return '${tr('approval')}';
      case OneCellType.AGENCY_APPROVAL_REFUSE:
        return '${tr('refuse_')}';
      case OneCellType.AGENCY_APPROVAL_RESERVE:
        return '${tr('reserve_')}';
      case OneCellType.AGENCY_APPROVAL_APPROVAL:
        return '${tr('approval')}';
      case OneCellType.SEARCH_MATERIALS:
        return '${tr('cancel')}';
      default:
        return '${tr('close')}';
    }
  }

  Future<List<String>?> contents() async {
    switch (this) {
      case OneCellType.SEARCH_CUSTOMER_CONDITION:
        return [
          '${tr('customer_name')}',
          '${tr('customer_number')}',
          '${tr('search_by_keywords')}'
        ];
      case OneCellType.SEARCH_SALSE_PERSON:
        return ['${tr('staff_name')}', '${tr('department_name')}'];
      case OneCellType.SEARCH_MATERIALS:
        return ['${tr('materials_name')}', '${tr('materials_code')}'];
      case OneCellType.SELECT_GENDER:
        return ['${tr('man')}', '${tr('women')}'];
      case OneCellType.SELECT_KEY_MAN:
        return ['Y', 'N'];
      case OneCellType.SELECT_FINANCIA:
        return ['Y', 'N'];
      case OneCellType.CONSULTATION_REPORT_IMPOTANCE:
        return [
          '${tr('high')}',
          '${tr('normal')}',
          '${tr('low')}',
        ];
      case OneCellType.SEARCH_PLANT_CONDITION:
        return ['플랜트코드', '플랜트명'];
      case OneCellType.SALES_ORDER_PAGE_ORDER_TYPE:
        return ['표준오더'];
      case OneCellType.CUSTOMER_APPROVAL_STATE:
        return ['Inactive', '진행중', '승인', '반려', '보류', 'Error'];
      case OneCellType.ORDER_MONITORING_STATE:
        return ['전체', 'Order', 'Del', 'G/I', '전표미생성', '매출', 'Clr'];

      // case OneCellType.DO_SAVE_TO:
      //   return [
      //     '전체',
      //     '연직기계반',
      //     '한일 코오드 R/F',
      //     'Latex',
      //     '원부원료',
      //     '포장재',
      //     '원부원료 불용창고'
      //   ];
      case OneCellType.CONSULTATION_REPORT_TYPE:
        return [
          '고객발굴/고객정보',
          '영업기회 발굴',
          '고객니즈 파악',
          '주문 및 납품문의',
          '매출 및 입금협의',
          '샘플(Test)/제안서 제안',
          '시장현황 파악',
          'C&C',
          '가격견적',
          '기타'
        ];
      case OneCellType.NULL_CHECK:
        return ['${tr('enter_in_order')}'];
      case OneCellType.CUSTOMER_APPROVAL_REFUSE:
        return ['${tr('refuse')} ${tr('do_you')}'];
      case OneCellType.CUSTOMER_APPROVAL_RESERVE:
        return ['${tr('reserve')} ${tr('do_you')}'];
      case OneCellType.CUSTOMER_APPROVAL_APPROVAL:
        return ['${tr('approval')} ${tr('do_you')}'];
      case OneCellType.AGENCY_APPROVAL_REFUSE:
        return ['${tr('refuse_')} ${tr('do_you')}'];
      case OneCellType.AGENCY_APPROVAL_RESERVE:
        return ['${tr('reserve_')} ${tr('do_you')}'];
      case OneCellType.AGENCY_APPROVAL_APPROVAL:
        return ['${tr('approval')} ${tr('do_you')}'];
      case OneCellType.NULL_CHECK:
        return ['${tr('enter_in_order')}'];
      default:
        return [];
    }
  }

  List<String> get code {
    switch (this) {
      case OneCellType.SELECT_GENDER:
        return ['M', 'W'];
      case OneCellType.SALES_ORDER_PAGE_ORDER_TYPE:
        return [OrderType.ZOR1.code];
      case OneCellType.CONSULTATION_REPORT_IMPOTANCE:
        return ['C01', 'B01', 'A01'];
      case OneCellType.ORDER_MONITORING_STATE:
        return ['AL', 'SO', 'DO', 'GI', 'BL', 'SA', 'CL'];
      case OneCellType.CUSTOMER_APPROVAL_STATE:
        return ['A', 'B', 'C', 'D', 'E', 'F'];
      default:
        return [];
    }
  }

  String get toastText {
    switch (this) {
      case OneCellType.CUSTOMER_APPROVAL_REFUSE:
        return '${tr('refuse')} ${tr('done')}';
      case OneCellType.CUSTOMER_APPROVAL_RESERVE:
        return '${tr('reserve')} ${tr('done')}';
      case OneCellType.CUSTOMER_APPROVAL_APPROVAL:
        return '${tr('approval')} ${tr('done')}';
      case OneCellType.AGENCY_APPROVAL_REFUSE:
        return '${tr('refuse_')} ${tr('done')}';
      case OneCellType.AGENCY_APPROVAL_RESERVE:
        return '${tr('reserve_')} ${tr('done')}';
      case OneCellType.AGENCY_APPROVAL_APPROVAL:
        return '';
      default:
        return '';
    }
  }

  double get contentsHeight {
    switch (this) {
      case OneCellType.CUSTOMER_APPROVAL_REFUSE:
        return AppSize.approvalPopupHeight;
      case OneCellType.SEARCH_CUSTOMER:
        return AppSize.realHeight * .7;
      case OneCellType.CUSTOMER_APPROVAL_RESERVE:
        return AppSize.approvalPopupHeight;
      case OneCellType.CUSTOMER_APPROVAL_APPROVAL:
        return AppSize.approvalPopupHeight;
      case OneCellType.AGENCY_APPROVAL_REFUSE:
        return AppSize.approvalPopupHeight;
      case OneCellType.AGENCY_APPROVAL_RESERVE:
        return AppSize.singlePopupHeight;
      case OneCellType.AGENCY_APPROVAL_APPROVAL:
        return AppSize.singlePopupHeight;
      case OneCellType.CONSULTATION_REPORT_TYPE:
        return AppSize.consultationTypePopupHeight;
      case OneCellType.SEARCH_ORG:
        return AppSize.consultationTypePopupHeight;
      case OneCellType.SEARCH_CUSOMER_TYPE:
        return AppSize.smallPopupHeight;
      case OneCellType.SEARCH_BUSINESS_GROUP:
        return AppSize.consultationTypePopupHeight;
      case OneCellType.INVENTORY_SAVE_TO:
        return AppSize.consultationTypePopupHeight;
      case OneCellType.NULL_CHECK:
        return AppSize.singlePopupHeight;
      default:
        return AppSize.secondPopupHeight;
    }
  }
}
