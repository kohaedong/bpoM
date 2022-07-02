/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/view/common/last_page_text.dart
 * Created Date: 2022-01-24 23:57:34
 * Last Modified: 2022-07-02 14:09:00
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/styles/app_style.dart';
import 'package:medsalesportal/styles/app_text_style.dart';

Widget lastPageText() {
  return Padding(
    padding: EdgeInsets.only(top: AppSize.defaultListItemSpacing),
    child: Center(
      child: AppStyles.text('${tr('is_last_item')}', AppTextStyle.default_12),
    ),
  );
}
