/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/view/common/widget_of_default_spacing.dart
 * Created Date: 2022-07-03 14:18:03
 * Last Modified: 2022-08-21 11:50:05
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:bpom/styles/app_size.dart';

Widget defaultSpacing({double? height, int? times, bool? isHalf}) => Padding(
    padding: EdgeInsets.only(
        top: height != null
            ? height
            : times != null
                ? AppSize.defaultListItemSpacing * times
                : isHalf != null && isHalf
                    ? AppSize.defaultListItemSpacing / 2
                    : AppSize.defaultListItemSpacing));
