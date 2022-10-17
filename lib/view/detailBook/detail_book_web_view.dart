/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/detailBook/detail_book_web_view.dart
 * Created Date: 2022-07-29 15:17:27
 * Last Modified: 2022-10-18 04:20:20
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class DetailBookWebView extends StatefulWidget {
  const DetailBookWebView({Key? key}) : super(key: key);
  static const String routeName = '/DetailBookWebView';
  @override
  State<DetailBookWebView> createState() => _DetailBookWebViewState();
}

class _DetailBookWebViewState extends State<DetailBookWebView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var url = ModalRoute.of(context)!.settings.arguments as String;

    pr(url);
    return BaseLayout(
        hasForm: false,
        appBar: MainAppBar(
          context,
          titleText:
              AppText.text('${tr('detail_book')}', style: AppTextStyle.w500_22),
          callback: () {
            Navigator.pop(context, true);
          },
        ),
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, true);
            return false;
          },
          child: SizedBox(
              height: AppSize.realHeight - AppSize.appBarHeight,
              width: AppSize.realWidth,
              child: OrientationBuilder(builder: (context, orientation) {
                return InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse('$url')),
                );
              })),
        ));
  }
}
