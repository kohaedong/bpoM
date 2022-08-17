/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/widget_of_default_spacing.dart
 * Created Date: 2022-07-03 14:18:03
 * Last Modified: 2022-08-17 15:10:39
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/styles/app_size.dart';

Widget defaultSpacing({double? height, int? times}) => Padding(
    padding: EdgeInsets.only(
        top: height != null
            ? height
            : times != null
                ? AppSize.defaultListItemSpacing * times
                : AppSize.defaultListItemSpacing));
