import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/enums/update_and_notice_check_type.dart';
import 'package:medsalesportal/view/common/widget_of_loading_view.dart';
import 'package:medsalesportal/globalProvider/special_notice_provider.dart';
import 'package:medsalesportal/view/commonLogin/update_and_notice_dialog.dart';

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
      final np = context.read<SpecialNoticeProvider>();
      if (np.isShowSpecialNotice) {
        await CheckUpdateAndNoticeService.showSpecialNotice(context);
      }
      CheckUpdateAndNoticeService.check(
          context, CheckType.UPDATE_AND_NOTICE, false);
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
