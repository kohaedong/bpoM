/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums/common_code_group_type.dart
 * Created Date: 2021-08-17 12:51:30
 * Last Modified: 2022-07-02 13:50:47
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:bpom/model/commonCode/cell_model.dart';
import 'package:bpom/styles/app_size.dart';

typedef CommonThreeCellDataCallback = Future<List<CellModel>> Function();

// table cell형태 데이터의 구분자.
// 주로 팝업창의 title / table cell의 title 사정 저의로 사용.
enum ThreeCellType {
  GET_COUNTRY,
  GET_COUNTRY_KR,
  GET_COUNTRY_AREA,
  GET_COUNTRY_AREA_KR,
  GET_COUNTRY_,
  GET_CUSTOMER_CATEGORY_MAIN,
  GET_CUSTOMER_CATEGORY_MEDIUM,
  GET_CUSTOMER_CATEGORY_DEMAND,
  GET_CUSTOMER_CATEGORY_EQUIPMENT,
  GET_CUSTOMER_CATEGORY_USE_1,
  GET_CUSTOMER_CATEGORY_USE_2,
  GET_CUSTOMER_CATEGORY_ANALYSIS_AREA,
  SEARCH_CUSTOMER_DELEV_AREA,
  DISCOUNT_SURCHARGE,
  DO_NOTHING,
}

extension ThreeCellTypeExtension on ThreeCellType {
  String get groupKey {
    switch (this) {
      default:
        return '${this.runtimeType}';
    }
  }

  String get buttonText {
    switch (this) {
      default:
        return '${tr('close')}';
    }
  }

  double get height {
    switch (this) {
      default:
        return AppSize.secondPopupHeight;
    }
  }

  Future<String> get title async {
    switch (this) {
      case ThreeCellType.GET_COUNTRY:
        return '${tr('country')}';
      case ThreeCellType.GET_COUNTRY_KR:
        return '${tr('country')}';
      case ThreeCellType.GET_COUNTRY_AREA:
        return '${tr('area')}';
      case ThreeCellType.SEARCH_CUSTOMER_DELEV_AREA:
        return '${tr('delivery_area')}';
      case ThreeCellType.GET_CUSTOMER_CATEGORY_MAIN:
        return '${tr('customer_category_main')}';
      case ThreeCellType.GET_CUSTOMER_CATEGORY_MEDIUM:
        return '${tr('customer_category_medium')}';
      case ThreeCellType.GET_CUSTOMER_CATEGORY_DEMAND:
        return '${tr('demand_products')}';
      case ThreeCellType.GET_CUSTOMER_CATEGORY_ANALYSIS_AREA:
        return '${tr('performance_analysis_area')}';
      case ThreeCellType.GET_CUSTOMER_CATEGORY_EQUIPMENT:
        return '${tr('equipment')}';
      case ThreeCellType.GET_CUSTOMER_CATEGORY_USE_1:
        return '${tr('customer_use_1')}';
      case ThreeCellType.GET_CUSTOMER_CATEGORY_USE_2:
        return '${tr('customer_use_2')}';
      case ThreeCellType.DISCOUNT_SURCHARGE:
        return '${tr('discount_surcharge_')}';
      default:
        return '${tr('category_name')}';
    }
  }

  List<String> get cellTitle {
    switch (this) {
      case ThreeCellType.GET_COUNTRY:
        return ['${tr('country')}', '${tr('name')}', '${tr('citizenship')}'];
      case ThreeCellType.GET_COUNTRY_KR:
        return ['${tr('country')}', '${tr('name')}', '${tr('citizenship')}'];
      case ThreeCellType.GET_COUNTRY_AREA:
        return ['${tr('country')}', '${tr('area')}', '${tr('contents')}'];
      case ThreeCellType.GET_COUNTRY_AREA_KR:
        return ['${tr('country')}', '${tr('area')}', '${tr('contents')}'];
      case ThreeCellType.DISCOUNT_SURCHARGE:
        return ['${tr('condition_type')}', '${tr('+')}', '${tr('name')}'];
      case ThreeCellType.SEARCH_CUSTOMER_DELEV_AREA:
        return [
          '${tr('country')}',
          '${tr('delivery_area_1')}',
          '${tr('contents')}'
        ];
      default:
        return ['No', 'Code', 'Text'];
    }
  }

  Future<List<CellModel>> get cellContents async {
    switch (this) {
      default:
        return [];
    }
  }
}
