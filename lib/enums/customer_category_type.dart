/*
 * Filename: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums/customer_
 * Path: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums
 * Created Date: Wednesday, September 29th 2021, 1:34:48 am
 * Author: bakbeom
 * 
 * Copyright (c) 2021 KOLON GROUP.
 */

import 'package:bpom/enums/hive_box_type.dart';
import 'package:bpom/enums/popup_cell_type.dart';

//* 잠재고객등록 -> 부가정보2 -> 고객대분류 / 중분류 /수요사업군/ 설비 / 고객용도1,2 / 실적 구분자
enum CustomerCategoryType {
  MAIN,
  MEDIUM,
  DEMAND,
  EQUIPMENT,
  USE_1,
  USE_2,
  ANALYSIS_AREA
}

extension CustomerCategoryTypeExtension on CustomerCategoryType {
  get condition {
    switch (this) {
      case CustomerCategoryType.MAIN:
        return 'ZDOTCLTS01';
      case CustomerCategoryType.MEDIUM:
        return 'ZDOTCLTS02';
      case CustomerCategoryType.DEMAND:
        return 'ZDOTCLTS03';
      case CustomerCategoryType.EQUIPMENT:
        return 'ZDOTCLTS07';
      case CustomerCategoryType.USE_1:
        return 'ZDOTCLTS04';
      case CustomerCategoryType.USE_2:
        return 'ZDOTCLTS05';
      case CustomerCategoryType.ANALYSIS_AREA:
        return 'ZDOTCLTS06';
      default:
    }
  }

  HiveBoxType get hiveType {
    switch (this) {
      default:
        return HiveBoxType.ET_CUSTOMER_CATEGORY;
    }
  }

  ThreeCellType get threeSellType {
    switch (this) {
      case CustomerCategoryType.MAIN:
        return ThreeCellType.GET_CUSTOMER_CATEGORY_MAIN;
      case CustomerCategoryType.MEDIUM:
        return ThreeCellType.GET_CUSTOMER_CATEGORY_MEDIUM;
      case CustomerCategoryType.DEMAND:
        return ThreeCellType.GET_CUSTOMER_CATEGORY_DEMAND;
      case CustomerCategoryType.EQUIPMENT:
        return ThreeCellType.GET_CUSTOMER_CATEGORY_EQUIPMENT;
      case CustomerCategoryType.USE_1:
        return ThreeCellType.GET_CUSTOMER_CATEGORY_USE_1;
      case CustomerCategoryType.USE_2:
        return ThreeCellType.GET_CUSTOMER_CATEGORY_USE_2;
      case CustomerCategoryType.ANALYSIS_AREA:
        return ThreeCellType.GET_CUSTOMER_CATEGORY_ANALYSIS_AREA;
    }
  }
}
