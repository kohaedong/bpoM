/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/home/notice_detail_page.dart
 * Created Date: 2022-07-05 13:17:36
 * Last Modified: 2022-07-13 11:15:07
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_shimmer.dart';
import 'package:medsalesportal/view/home/provider/notice_provider.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';

class NoticeDetailPage extends StatelessWidget {
  const NoticeDetailPage({Key? key}) : super(key: key);
  static const String routeName = '/noticeDetailPage';
  Widget _buildNoticeTitle(BuildContext context) {
    return Consumer<NoticeProvider>(builder: (context, provider, _) {
      final textModel = provider.homeNoticeDetailResponseModel!.tText!.first;
      final noticeModel =
          provider.homeNoticeDetailResponseModel!.tZLTSP0700!.single;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.text(textModel.ztext!, style: AppTextStyle.bold_18),
          defaultSpacing(),
          Row(
            children: [
              AppText.text('${noticeModel.sanumNm}',
                  style: AppTextStyle.default_14
                      .copyWith(color: AppColors.subText)),
              AppStyles.buildPipe(height: AppTextStyle.default_14.fontSize!),
              AppText.text(
                  '${FormatUtil.addDashForDateStr('${noticeModel.aedat}')} ${FormatUtil.addColonForTime('${noticeModel.aezet}')}',
                  style: AppTextStyle.default_14
                      .copyWith(color: AppColors.subText))
            ],
          ),
          defaultSpacing()
        ],
      );
    });
  }

  Widget _buildNoticeBody(context) {
    return Consumer<NoticeProvider>(builder: (context, provider, _) {
      return Column(
        children: [
          defaultSpacing(),
          AppText.text(
              provider.homeNoticeDetailResponseModel!.tText!.last.ztext!,
              maxLines: 100,
              style: AppTextStyle.default_16,
              textAlign: TextAlign.start)
        ],
      );
    });
  }

  Widget _buildNoticeDetailPageShimmer(BuildContext context) {
    return BaseShimmer(
      child: Container(),
    );
  }

  Widget _buildDividerLine() {
    return Divider();
  }

  @override
  Widget build(BuildContext context) {
    final noticeNumber = ModalRoute.of(context)!.settings.arguments as String;
    return BaseLayout(
        hasForm: false,
        appBar: MainAppBar(
          context,
          titleText: AppText.text('${tr('notice_detail')}',
              style: AppTextStyle.w500_22),
          callback: () {
            Navigator.pop(context);
          },
        ),
        child: ChangeNotifierProvider(
          create: (context) => NoticeProvider(),
          builder: (context, _) {
            return FutureBuilder(
                future: context
                    .read<NoticeProvider>()
                    .getNoticeDetail(noticeNumber: noticeNumber),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Padding(
                      padding: AppSize.defaultSidePadding,
                      child: ListView(
                        children: [
                          _buildNoticeTitle(context),
                          _buildDividerLine(),
                          _buildNoticeBody(context),
                        ],
                      ),
                    );
                  }
                  return _buildNoticeDetailPageShimmer(context);
                });
          },
        ));
  }
}
