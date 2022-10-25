/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/home/notice_detail_page.dart
 * Created Date: 2022-07-05 13:17:36
 * Last Modified: 2022-10-25 13:17:01
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/home/provider/notice_provider.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';

class NoticeDetailPage extends StatefulWidget {
  const NoticeDetailPage({Key? key}) : super(key: key);
  static const String routeName = '/noticeDetailPage';

  @override
  State<NoticeDetailPage> createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  late ValueNotifier<String> _appBarTitle = ValueNotifier<String>('');
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _appBarTitle.dispose();
    super.dispose();
  }

  Widget _buildNoticeTitle(BuildContext context, String title) {
    return Consumer<NoticeProvider>(builder: (context, provider, _) {
      final noticeModel =
          provider.homeNoticeDetailResponseModel!.tZLTSP0700!.single;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.text(title,
              style: AppTextStyle.bold_18,
              maxLines: 4,
              textAlign: TextAlign.start),
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
      var text = '';
      provider.homeNoticeDetailResponseModel!.tText!.forEach((model) {
        text = text + '\n' + model.ztext!;
      });
      return Column(
        children: [
          defaultSpacing(),
          AppText.text(text,
              maxLines: 100,
              style: AppTextStyle.default_16,
              textAlign: TextAlign.start)
        ],
      );
    });
  }

  Widget _buildNoticeDetailPageShimmer(BuildContext context) {
    return DefaultShimmer.buildDefaultResultShimmer(isNotPadding: true);
  }

  Widget _buildDividerLine() {
    return Divider();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final noticeNumber = arguments['noticeNumber'];
    final noticeTitle = arguments['noticeTitle'];
    return ChangeNotifierProvider(
      create: (context) => NoticeProvider(),
      builder: (context, _) {
        final p = context.read<NoticeProvider>();
        return BaseLayout(
            hasForm: false,
            appBar: MainAppBar(
              context,
              titleText: ValueListenableBuilder<String>(
                  valueListenable: _appBarTitle,
                  builder: (context, title, _) {
                    return AppText.text(title, style: AppTextStyle.w500_22);
                  }),
              callback: () {
                Navigator.pop(context);
              },
            ),
            child: FutureBuilder(
                future: context
                    .read<NoticeProvider>()
                    .getNoticeDetail(noticeNumber: noticeNumber),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    Future.delayed(Duration.zero, () {
                      _appBarTitle.value = p.noticeDetailTitle!;
                    });
                    return Padding(
                      padding: AppSize.defaultSidePadding,
                      child: ListView(
                        children: [
                          _buildNoticeTitle(context, noticeTitle),
                          _buildDividerLine(),
                          _buildNoticeBody(context),
                        ],
                      ),
                    );
                  }
                  return _buildNoticeDetailPageShimmer(context);
                }));
      },
    );
  }
}
