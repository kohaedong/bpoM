/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/detailBook/detail_book_web_view.dart
 * Created Date: 2022-07-29 15:17:27
 * Last Modified: 2022-08-01 09:53:43
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class DetailBookWebView extends StatefulWidget {
  const DetailBookWebView({Key? key}) : super(key: key);
  static const String routeName = '/DetailBookWebView';
  @override
  State<DetailBookWebView> createState() => _DetailBookWebViewState();
}

class _DetailBookWebViewState extends State<DetailBookWebView> {
  @override
  Widget build(BuildContext context) {
    var url = ModalRoute.of(context)!.settings.arguments as String;

    pr(url);
    return BaseLayout(
        hasForm: false,
        appBar: MainAppBar(context,
            titleText: AppText.text('${tr('detail_book')}',
                style: AppTextStyle.w500_22)),
        child: SizedBox(
          height: AppSize.realHeight - AppSize.appBarHeight,
          width: AppSize.realWidth,
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse('$url')),
          ),
        ));
  }
}
