/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/splash/splash_page_contents.dart
 * Created Date: 2021-08-20 14:37:40
 * Last Modified: 2022-07-02 14:33:34
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/styles/app_image.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: true,
        isResizeToAvoidBottomInset: false,
        appBar: null,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 168.h),
                      child: SizedBox(
                          height: AppSize.splashIconHeight,
                          width: AppSize.splashIconWidth,
                          child: AppImage.getImage(ImageType.SPLASH_ICON))),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: AppSize.splashIconBottomSpacing),
                      child: SizedBox(
                          width: AppSize.splashLogoWidth,
                          height: AppSize.splashLogoHeight,
                          child: AppImage.getImage(ImageType.TEXT_LOGO)))
                ],
              ),
            ),
          ],
        ));
  }
}
