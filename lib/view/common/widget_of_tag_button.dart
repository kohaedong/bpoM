/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_tag_button.dart
 * Created Date: 2021-09-18 16:52:24
 * Last Modified: 2022-07-07 13:39:49
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/styles/export_common.dart';

class BaseTagButton {
  static Widget build(String text) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.whiteText,
            borderRadius: BorderRadius.all(Radius.circular(13)),
            border: Border.all(color: AppColors.secondGreyColor, width: 1)),
        child: Padding(
          padding: AppSize.homeNoticeTageSidePadding,
          child: AppText.text('$text', style: AppTextStyle.sub_12),
        ));
  }
}
