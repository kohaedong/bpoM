/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_error_dialog_contents.dart
 * Created Date: 2021-10-23 17:18:38
 * Last Modified: 2022-07-03 14:58:35
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';

// 에러 dialog
// 고정 양식
// 호출방법: BaseNetworkErrorDialogContents.build()
class BaseNetworkErrorDialogContents {
  static Widget build() {
    return Column(
      children: [
        AppImage.getImage(ImageType.INFO),
        Padding(padding: EdgeInsets.only(top: AppSize.defaultListItemSpacing)),
        Align(
          alignment: Alignment.center,
          child:
              AppStyles.text('${tr('check_network')}', AppTextStyle.default_16),
        )
      ],
    );
  }
}

class BaseServerErrorDialogContents {
  static Widget build() {
    return Column(
      children: [
        AppImage.getImage(ImageType.INFO),
        Padding(padding: EdgeInsets.only(top: AppSize.defaultListItemSpacing)),
        Align(
          alignment: Alignment.center,
          child:
              AppStyles.text('${tr('server_error')}', AppTextStyle.default_16),
        )
      ],
    );
  }
}
