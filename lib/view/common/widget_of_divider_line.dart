/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/widget_of_divider_line.dart
 * Created Date: 2022-07-02 14:22:53
 * Last Modified: 2022-07-06 10:33:13
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:medsalesportal/styles/app_colors.dart';
import 'package:medsalesportal/styles/app_size.dart';

Widget buildDividingLine() {
  return Container(
    alignment: Alignment.centerLeft,
    height: AppSize.defaultLineHeight,
    width: AppSize.realWidth,
    color: AppColors.homeBgColor,
  );
}
