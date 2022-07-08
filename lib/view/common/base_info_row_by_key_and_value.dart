/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_info_row_by_key_and_value.dart
 * Created Date: 2021-10-03 02:10:59
 * Last Modified: 2022-07-08 17:49:16
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:medsalesportal/enums/string_fomate_type.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/widget_of_text_row_model_by_key_value.dart';

/// [TextRowModelByKeyValue]  참조.
// 한줄의 text가 key 와 value로 구성 되 있을 경우 사용.
// 예:
// 예상수량:  50,000/개

// title :  key값.   '예상수량'
// body : value값.  '50,000/개'
// isWithShimmer : 쉬머 사용 여부. true:사용, false: 사용안함.
/// body,body2,body3,body4 : 수량,수량단위,금액,금액단위 모두 포맷이 필요할때 사용한다. 구분자는 [isWithMoneyAndUnit]이다.
/// [formatType] 포맷유형.
/// [isWithShowAllButton] 전체보기 아이콘 노출여부 , true:  '50,000/개        > '
/// [showAllButtonText] 전체보기 아이콘 외 설명 문구 추가여부. true : '50,000/개       전체보기 > '
/// [icon] 전체보기 아이콘
/// [isWithEndShowAllButton] :  [isWithShowAllButton]이 true일경우에만 혜당. value의 끝부분에서 아이콘추가.
/// 예: isWithEndShowAllButton: true
///  예상수량:  50,000/개       >
/// 예: isWithEndShowAllButton : false
///  예상수량:  50,000/개
///                          >
/// [callback] 전체보기 아이콘 클릭했을때의 callback.
/// [isTitleTowRow] key 값이 2줄일경우.
/// 예: '예상수량/
///      패킹수량'
/// [discription2] value의 값이 2세트로 나눠져 있고,별또의 action있을때 사용.
/// 예 :
/// 운송기사 : 김용만   010-3447-6868 (클릭 action: 다이얼로그 호출)
/// [leadingTextWidth] key widget width (보통key는 전체widget width의 30%, value는70%.  overflow시 생략)
/// [contentsTextWidth] value widget width
/// [exceptionColor] value가 2세트일 경우 마지막세트의 text color.
/// [isWithStar] 필수부호 * 추가여부.
class BaseInfoRowByKeyAndValue {
  static Widget build(String title, String body,
      {bool? isWithShimmer,
      String? body2,
      String? body3,
      String? body4,
      int? shimmerRow,
      StringFormateType? formatType,
      bool? isWithShowAllButton,
      String? showAllButtonText,
      Widget? icon,
      bool? isWithEndShowAllButton,
      Function? callback,
      bool? isTitleTowRow,
      bool? isWithMoneyAndUnit,
      String? discription2,
      double? leadingTextWidth,
      double? contentsTextWidth,
      int? maxLine,
      Color? exceptionColor,
      bool? isWithStar}) {
    return Padding(
      padding: AppSize.textRowModelLinePadding,
      child: TextRowModelByKeyValue(
        '$title',
        formatType != null
            ? isWithMoneyAndUnit != null
                ? formatType.formate('$body',
                    body2: body2, body3: body3, body4: body4)
                : body2 != null
                    ? formatType.formate('$body', body2: body2)
                    : formatType.formate('$body')
            : '$body',
        isWithShowAllButton ?? false,
        isWithEndShowAllButton ?? false,
        isWithShimmer: isWithShimmer,
        shimmerRow: shimmerRow,
        icon: icon,
        maxLine: maxLine,
        callback: callback,
        exceptionColor: exceptionColor != null
            ? exceptionColor
            : title == '${tr('office')}' ||
                    title == '${tr('driver')}' ||
                    title == '${tr('phone_number')}'
                ? AppColors.showAllTextColor
                : null,
        showAllButtonText: showAllButtonText,
        isTitleTwoRow: isTitleTowRow,
        discription2: discription2,
        isWithStar: isWithStar,
        leadingTextWidth: leadingTextWidth,
        contentsTextWidth: contentsTextWidth,
      ),
    );
  }
}
