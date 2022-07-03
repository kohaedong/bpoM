/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/styles/app_text.dart
 * Created Date: 2022-07-03 14:42:12
 * Last Modified: 2022-07-03 14:42:43
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:medsalesportal/styles/app_text_style.dart';

class AppText {
  static text(
    String data, {
    TextStyle? style,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
  }) =>
      Text(data,
          style: style ?? AppTextStyle.default_14,
          textAlign: textAlign ?? TextAlign.center,
          maxLines: maxLines,
          overflow: overflow ?? TextOverflow.ellipsis);
}
