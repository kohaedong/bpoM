import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medsalesportal/styles/app_colors.dart';
import 'package:medsalesportal/view/commonLogin/splash_page.dart';
import 'package:medsalesportal/enums/update_and_notice_check_type.dart';
import 'package:medsalesportal/view/commonLogin/update_and_notice_dialog.dart';
import 'package:medsalesportal/view/common/base_loading_view_on_stack_widget.dart';

class CommonLoginPage extends StatefulWidget {
  CommonLoginPage({Key? key}) : super(key: key);
  static const String routeName = '/commonLoginPage';

  @override
  State<CommonLoginPage> createState() => _CommonLoginPageState();
}

class _CommonLoginPageState extends State<CommonLoginPage> {
  ValueNotifier<bool> loadingSwich = ValueNotifier(true);
  Timer? timer;
  @override
  void initState() {
    timer = Timer(Duration(seconds: 60), () {
      loadingSwich.value = false;
    });
    loadingSwich = ValueNotifier(true);
    Future.delayed(Duration.zero, () {
      CheckUpdateAndNoticeService.check(
          context, CheckType.UPDATE_AND_NOTICE, false);
    });
    super.initState();
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
    return Stack(
      children: [
        SplashPage(),
        ValueListenableBuilder<bool>(
          valueListenable: loadingSwich,
          builder: (context, isLoding, _) {
            return loadingSwich.value
                ? Positioned(
                    child: Center(
                    child: BaseLoadingViewOnStackWidget.build(context, isLoding,
                        color: AppColors.whiteText, height: 100, width: 100),
                  ))
                : Container();
          },
        ),
      ],
    );
  }
}
