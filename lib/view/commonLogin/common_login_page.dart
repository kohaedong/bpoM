import 'dart:async';

import 'package:bpom/enums/image_type.dart';
import 'package:bpom/enums/update_and_notice_check_type.dart';
import 'package:bpom/service/cache_service.dart';
import 'package:bpom/styles/export_common.dart';
import 'package:bpom/view/common/base_layout.dart';
import 'package:bpom/view/common/widget_of_loading_view.dart';
import 'package:bpom/view/commonLogin/update_and_notice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommonLoginPage extends StatefulWidget {
  const CommonLoginPage({Key? key}) : super(key: key);
  static const String routeName = '/commonLoginPage';

  @override
  State<CommonLoginPage> createState() => _CommonLoginPageState();
}

class _CommonLoginPageState extends State<CommonLoginPage> {
  ValueNotifier<bool> loadingSwich = ValueNotifier(true);
  Timer? timer;
  @override
  void initState() {
    super.initState();
    CacheService.deleteALL();
    timer = Timer(Duration(seconds: 60), () {
      loadingSwich.value = false;
    });
    loadingSwich = ValueNotifier(true);
  }

  @override
  void dispose() {
    loadingSwich.dispose();
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('commligin page build done');
    Future.delayed(Duration.zero, () async {
      CheckUpdateAndNoticeService.check(
          context, CheckType.NOTICE_AND_UPDATE, false);
    });
    return BaseLayout(
        hasForm: false,
        appBar: null,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: AppSize.signinLogoPadding,
                      child: Center(
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
            ValueListenableBuilder<bool>(
              valueListenable: loadingSwich,
              builder: (context, isLoding, _) {
                return loadingSwich.value
                    ? Positioned(
                        child: Center(
                        child: BaseLoadingViewOnStackWidget.build(
                            context, isLoding,
                            color: AppColors.whiteText,
                            height: 100,
                            width: 100),
                      ))
                    : Container();
              },
            ),
          ],
        ));
  }
}
