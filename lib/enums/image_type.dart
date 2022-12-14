/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/enums/image_type.dart
 * Created Date: 2021-08-20 14:37:40
 * Last Modified: 2022-11-15 11:35:31
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

//* 이미지 url 사전 등록후 사용.

enum ImageType {
  SPLASH_ICON,
  TEXT_LOGO,
  SETTINGS_ICON,
  EMPTY,
  SEARCH,
  SELECT,
  DELETE,
  DATA_PICKER,
  PLUS,
  MENU,
  PLUS_SMALL,
  INFO,
  SCROLL_TO_TOP,
  SCREEN_ROTATION,
  LAND_SPACE_PAGE_ICON,
  LAND_SPACE_PAGE_APPBAR_ICON,
  L_ICON,
  SELECT_RIGHT,
  DELETE_BOX
}

extension RequestTypeExtension on ImageType {
  String get path {
    switch (this) {
      case ImageType.SCROLL_TO_TOP:
        return 'assets/images/icon_outlined_24_lg_2_go_to_top.svg';
      case ImageType.DELETE_BOX:
        return 'assets/images/button_icon_medium_outline.svg';
      case ImageType.SELECT_RIGHT:
        // return 'assets/images/icon_outlined_18_lg_3_right.svg';
        return 'assets/images/button_icon_small_outline.svg';

      case ImageType.L_ICON:
        return 'assets/images/icon_outlined_18_lg_1_re.svg';
      case ImageType.LAND_SPACE_PAGE_ICON:
        return 'assets/images/button_icon_small_outline.svg';
      case ImageType.LAND_SPACE_PAGE_APPBAR_ICON:
        return 'assets/images/icon_outlined_18_lg_2_left.svg';
      case ImageType.SPLASH_ICON:
        return 'assets/images/icon_app_material.svg';
      case ImageType.TEXT_LOGO:
        return 'assets/images/kolon_logo.svg';
      case ImageType.EMPTY:
        return 'assets/images/empty.svg';
      case ImageType.SETTINGS_ICON:
        return 'assets/images/icon_outlined_24_lg_1_settings.svg';
      case ImageType.SEARCH:
        return 'assets/images/icon_outlined_18_lg_3_search.svg';
      case ImageType.SELECT:
        return 'assets/images/icon_outlined_18_lg_3_down.svg';
      case ImageType.DELETE:
        return 'assets/images/icon_filled_18_lg_3_misuse.svg';
      case ImageType.DATA_PICKER:
        return 'assets/images/icon_outlined_18_lg_3_calendar.svg';
      case ImageType.PLUS:
        return 'assets/images/icon_outlined_24_lbp_3_add.svg';
      case ImageType.MENU:
        return 'assets/images/icon_outlined_24_lg_3_menu.svg';
      case ImageType.PLUS_SMALL:
        return 'assets/images/icon_outlined_18_lg_3_add.svg';
      case ImageType.INFO:
        return 'assets/images/icon_outlined_24_lg_3_warning.svg';
      case ImageType.SCREEN_ROTATION:
        return 'assets/images/icon_outlined_24_lbp_3_landscape.svg';
      default:
        return '';
    }
  }

// 홈화면에 icon을 텝 했을 때 route 하는 경로 사전 등록.
  String get routeName {
    switch (this) {
      default:
        return '';
    }
  }

  bool get isSvg {
    switch (this) {
      default:
        return true;
    }
  }
}
