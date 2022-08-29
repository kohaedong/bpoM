/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums/input_icon_type.dart
 * Created Date: 2021-09-05 17:34:24
 * Last Modified: 2022-08-29 11:18:36
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/styles/app_image.dart';
import 'package:medsalesportal/styles/app_size.dart';

// input 아이콘 유형.
enum InputIconType {
  SEARCH, // 검색 아이콘
  SELECT, // 드롭메뉴 아이콘
  DELETE_AND_SEARCH, // 삭제 아이콘 + 검색 아이콘 (input내부 값이 있을때 만 사용)
  DATA_PICKER, // 날짜 선텍 아이콘
  DELETE, // 삭제 아이콘
}

// 유형별 이미지 사전 등록.
extension InputIconTypeExtension on InputIconType {
  Widget icon({Function? callback1, Function? callback2, Color? color}) {
    switch (this) {
      case InputIconType.SEARCH:
        return AppImage.getImage(ImageType.SEARCH, color: color);
      case InputIconType.SELECT:
        return AppImage.getImage(ImageType.SELECT, color: color);
      // 아이콘이 2개일 경우
      // 기준 input widget 에서 제공되는 1개의 action widget callback으로는 컨트롤이 어려워
      // action widget 내부에 icon widget 2개를 추가해 각각의 action callback을 구현 하였음.
      case InputIconType.DELETE_AND_SEARCH:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: () => callback2!.call(),
                child: AppImage.getImage(ImageType.DELETE, color: color)),
            SizedBox(width: AppSize.cellPadding),
            InkWell(
              onTap: () => callback1!.call(),
              child: AppImage.getImage(ImageType.SEARCH, color: color),
            ),
          ],
        );
      case InputIconType.DATA_PICKER:
        return AppImage.getImage(ImageType.DATA_PICKER, color: color);
      case InputIconType.DELETE:
        return AppImage.getImage(ImageType.DELETE, color: color);
    }
  }
}
