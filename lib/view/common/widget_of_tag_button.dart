/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_tag_button.dart
 * Created Date: 2021-09-18 16:52:24
 * Last Modified: 2022-07-03 15:00:12
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
            borderRadius: BorderRadius.all(Radius.circular(13)),
            border: Border.all(color: AppColors.secondGreyColor, width: 1)),
        child: Padding(
          padding: AppSize.homeNoticeTageSidePadding,
          child: AppStyles.text('$text', AppTextStyle.sub_12),
        ));
  }
}
