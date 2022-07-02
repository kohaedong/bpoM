/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums/popup_search_type.dart
 * Created Date: 2021-09-10 21:38:04
 * Last Modified: 2022-01-28 10:42:19
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';

import 'popup_list_type.dart';

// 팝업에 검색기능이 들어있을 경우 그 기능을 공통으로 사용 하기 위해 만든 enum.
enum PopupSearchType {
  SEARCH_SALSE_PERSON, // 영업사원조회 화면
  SEARCH_MATERIALS, // 자재조회 화면
  SEARCH_PLANT, // 플랜트 조회 화면
}

extension PopupSearchTypeExtension on PopupSearchType {
  // hint문구를 디폴트로 설정해줍니다.
  List<String>? get hintText {
    switch (this) {
      case PopupSearchType.SEARCH_SALSE_PERSON:
        return ['${tr('staff_name')}']; // 사원명
      case PopupSearchType.SEARCH_MATERIALS:
        return ['${tr('materials_name')}']; // 자재명
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
      case PopupSearchType.SEARCH_MATERIALS:
        return [OneCellType.SEARCH_MATERIALS]; // 자재조회
      case PopupSearchType.SEARCH_PLANT:
        return [
          OneCellType.SEARCH_ORG, // index[0]
          OneCellType.SEARCH_CIRCULATION_CHANNEL, // index[1]
          OneCellType.SEARCH_PLANT_CONDITION, // index[2]
          OneCellType.SEARCH_PLANT_RESULT, // index[3]
        ];
    }
  }
}
