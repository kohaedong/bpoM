/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums/popup_search_type.dart
 * Created Date: 2021-09-10 21:38:04
 * Last Modified: 2022-07-24 14:37:10
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/app_size.dart';

import 'popup_list_type.dart';

// 팝업에 검색기능이 들어있을 경우 그 기능을 공통으로 사용 하기 위해 만든 enum.
enum PopupSearchType {
  SEARCH_SALSE_PERSON, // 영업사원조회 화면
  SEARCH_CUSTOMER,
  SEARCH_SALLER,
  SEARCH_SALLER_FOR_BULK_ORDER,
  SEARCH_END_CUSTOMER,
  SEARCH_PLANT, // 플랜트 조회 화면
}

extension PopupSearchTypeExtension on PopupSearchType {
  // hint문구를 디폴트로 설정해줍니다.
  List<String>? get hintText {
    switch (this) {
      case PopupSearchType.SEARCH_SALSE_PERSON:
        return ['${tr('staff_name')}']; // 사원명
      case PopupSearchType.SEARCH_PLANT:
        return [
          '${tr('plz_select')}', // 선택해주세요
          '${tr('plz_select')}', // 선택해주세요
          '${tr('plant_code_')}' // 플랜트 코드
        ];
      default:
        return [];
    }
  }

// 팝업창 버튼의 문구를 설정해줍니다.
  String get buttonText {
    switch (this) {
      default:
        return '${tr('close')}'; // 디폴트 > 닫기 <
    }
  }

//* 영업사원 검색
//* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//  ---------       ---------
// |  사원명   |     | 입력창...|
//  ---------       ---------

//* 자재 검색
//* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//  ---------       ---------
// |  자재명   |     | 입력창...|
//  ---------       ---------

//* 플랜트 검색
//* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//  -------------------------
// |  인더스트리 본부            |
//  -------------------------
//         index[0]
//  -------------------------
// |  내수                    |
//  -------------------------
//         index[1]
//  ---------       ---------
// | 플랜트코드 |     | 입력창...|
//  ---------       ---------
//   index[2]       index[3]

  List<OneCellType> get popupStrListType {
    switch (this) {
      case PopupSearchType.SEARCH_SALSE_PERSON:
        return [OneCellType.SEARCH_SALSE_PERSON]; // 영업사원
      case PopupSearchType.SEARCH_END_CUSTOMER:
        return [OneCellType.SEARCH_END_CUSTOMER];
      case PopupSearchType.SEARCH_SALLER:
        return [OneCellType.SEARCH_SALLER]; // 영업사원
      case PopupSearchType.SEARCH_SALLER_FOR_BULK_ORDER:
        return [OneCellType.SEARCH_SALLER_FOR_BULK_ORDER]; // 영업사원
      case PopupSearchType.SEARCH_CUSTOMER:
        return [OneCellType.SEARCH_CUSTOMER]; // 영업사원
      case PopupSearchType.SEARCH_PLANT:
        return [
          OneCellType.SEARCH_ORG, // index[0]
          OneCellType.SEARCH_CIRCULATION_CHANNEL, // index[1]
          OneCellType.SEARCH_PLANT_CONDITION, // index[2]
          OneCellType.SEARCH_PLANT_RESULT, // index[3]
        ];
    }
  }

  double get height {
    switch (this) {
      case PopupSearchType.SEARCH_CUSTOMER:
        return AppSize.realHeight * .8;
      case PopupSearchType.SEARCH_SALLER:
        return AppSize.realHeight * .85;
      case PopupSearchType.SEARCH_SALLER_FOR_BULK_ORDER:
        return AppSize.realHeight * .85;
      case PopupSearchType.SEARCH_END_CUSTOMER:
        return AppSize.realHeight * .6;
      default:
        return AppSize.popupHeightWidthOneRowSearchBar;
    }
  }

  double get appBarHeight {
    switch (this) {
      case PopupSearchType.SEARCH_CUSTOMER:
        return AppSize.defaultTextFieldHeight * 3 +
            AppSize.defaultListItemSpacing * 5 +
            AppSize.appBarHeight +
            AppSize.secondButtonHeight; // 영업사원
      case PopupSearchType.SEARCH_SALLER:
        return AppSize.defaultTextFieldHeight * 4 +
            AppSize.defaultListItemSpacing * 6 +
            AppSize.appBarHeight +
            AppSize.secondButtonHeight; // 영업사원
      case PopupSearchType.SEARCH_SALLER_FOR_BULK_ORDER:
        return AppSize.defaultTextFieldHeight * 4 +
            AppSize.defaultListItemSpacing * 6 +
            AppSize.appBarHeight +
            AppSize.secondButtonHeight; // 영업사원
      default:
        return AppSize.popupAppbarHeight + AppSize.secondButtonHeight;
    }
  }
}
