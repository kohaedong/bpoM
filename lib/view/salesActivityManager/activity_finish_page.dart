/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/activity_finish_page.dart
 * Created Date: 2022-10-11 04:29:49
 * Last Modified: 2022-10-11 07:26:23
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/salesActivityManager/current_month_scenario_page.dart';
import 'package:medsalesportal/view/salesActivityManager/visit_result_history_page.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_260.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/view/common/base_info_row_by_key_and_value.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/view/salesActivityManager/provider/activity_finish_page_provider.dart';

class SalseActivityFinishPage extends StatelessWidget {
  const SalseActivityFinishPage({Key? key}) : super(key: key);
  static const String routeName = '/salseActivityFinishPage';

  Widget _buildContents(BuildContext context) {
    final p = context.read<ActivityFinishPageProvider>();
    var t260 = p.t260!;
    var t361 = p.t361;
    var isWithTeamLeader = p.isWithTeamLeader;
    var suggestedItemList = p.suggestedItemList;
    return ListView(
      children: [
        CustomerinfoWidget.buildSubTitle(context, '${tr('activity_report')}'),
        Padding(
          padding: AppSize.defaultSidePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseInfoRowByKeyAndValue.build(
                  tr('customer_name'), t260.zskunnrNm ?? ''),
              FutureBuilder<List<String>?>(
                  future: HiveService.getCustomerType(t260.zstatus!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      return BaseInfoRowByKeyAndValue.build(
                          tr('customer_type_2'), snapshot.data!.single);
                    }
                    return BaseInfoRowByKeyAndValue.build(
                        tr('customer_type_2'), '');
                  }),
              BaseInfoRowByKeyAndValue.build(tr('address'), t260.zaddr ?? ''),
              BaseInfoRowByKeyAndValue.build(tr('key_man'), t260.zkmnoNm ?? ''),
              BaseInfoRowByKeyAndValue.build(
                tr('is_visited'),
                t260.xvisit != null && t260.xvisit == 'Y'
                    ? '${tr('visited')}'
                    : '${tr('not_visited')}',
              ),
              BaseInfoRowByKeyAndValue.build(
                  tr('leader_together'), isWithTeamLeader ? 'Y' : '-'),
              BaseInfoRowByKeyAndValue.build(tr('colleague_together'),
                  t361 != null ? '${t361.ernam!}' : '-'),
              BaseInfoRowByKeyAndValue.build(tr('distance'),
                  FormatUtil.getDistance(t260.dist != null ? t260.dist! : '')),
              BaseInfoRowByKeyAndValue.build(
                  tr('reason_for_not_visiting'),
                  t260.visitRmk != null && t260.visitRmk!.isNotEmpty
                      ? t260.visitRmk!
                      : '-'),
              BaseInfoRowByKeyAndValue.build(
                  tr('is_interview'),
                  t260.xmeet != null && t260.xmeet!.isNotEmpty
                      ? t260.xmeet == 'S'
                          ? '${tr('success_lable')}'
                          : '${tr('faild')}'
                      : '${tr('faild')}'),
              BaseInfoRowByKeyAndValue.build(
                  tr('reason_for_interview_faild'),
                  t260.meetRmk != null && t260.meetRmk!.isNotEmpty
                      ? t260.meetRmk!
                      : '-'),
            ],
          ),
        ),
        CustomerinfoWidget.buildSubTitle(context, '${tr('activity_type_2')}'),
        Padding(
          padding: AppSize.defaultSidePadding,
          child: Column(
            children: [
              BaseInfoRowByKeyAndValue.build(
                  '${tr('suggested_item')}1',
                  suggestedItemList.isNotEmpty &&
                          suggestedItemList[0].matnr != null &&
                          suggestedItemList[0].matnr!.isNotEmpty
                      ? suggestedItemList[0].maktx!
                      : '-'),
              BaseInfoRowByKeyAndValue.build(
                  tr('is_give_sample'),
                  suggestedItemList.isNotEmpty &&
                          suggestedItemList[0].isChecked != null &&
                          suggestedItemList[0].isChecked!
                      ? 'Y'
                      : '-'),
              BaseInfoRowByKeyAndValue.build(
                  '${tr('suggested_item')}2',
                  suggestedItemList.isNotEmpty &&
                          suggestedItemList[1].matnr != null &&
                          suggestedItemList[1].matnr!.isNotEmpty
                      ? suggestedItemList[1].maktx!
                      : '-'),
              BaseInfoRowByKeyAndValue.build(
                  tr('is_give_sample'),
                  suggestedItemList.isNotEmpty &&
                          suggestedItemList[1].isChecked != null &&
                          suggestedItemList[1].isChecked!
                      ? 'Y'
                      : '-'),
              BaseInfoRowByKeyAndValue.build(
                  '${tr('suggested_item')}3',
                  suggestedItemList.isNotEmpty &&
                          suggestedItemList[2].matnr != null &&
                          suggestedItemList[2].matnr!.isNotEmpty
                      ? suggestedItemList[2].maktx!
                      : '-'),
              BaseInfoRowByKeyAndValue.build(
                  tr('is_give_sample'),
                  suggestedItemList.isNotEmpty &&
                          suggestedItemList[2].isChecked != null &&
                          suggestedItemList[2].isChecked!
                      ? 'Y'
                      : '-'),
            ],
          ),
        ),
        CustomerinfoWidget.buildSubTitle(context, '${tr('result_and_future')}'),
        Padding(
          padding: AppSize.defaultSidePadding,
          child: Column(
            children: [
              BaseInfoRowByKeyAndValue.build(tr('visit_result'),
                  p.resultDescription.isNotEmpty ? p.resultDescription : '-',
                  isWithShowAllButton: true,
                  showAllButtonWidth: AppSize.defaultContentsWidth * .6,
                  showAllButtonText: tr('look_visit_result_history'),
                  callback: () {
                Navigator.pushNamed(context, VisitResultHistoryPage.routeName,
                    arguments: {
                      'date': p.t260!.adate,
                      'customerName': p.t260!.zskunnrNm ?? '',
                      'zskunnr': p.t260!.zskunnr,
                      'keyMan': p.t260!.zkmnoNm ?? ''
                    });
              }),
              BaseInfoRowByKeyAndValue.build(
                  tr('review'), p.review.isNotEmpty ? p.review : '-'),
              BaseInfoRowByKeyAndValue.build(
                tr('leader_advice2'),
                p.leaderAdvice.isNotEmpty ? p.leaderAdvice : '-',
                isTitleTowRow: true,
                maxLine: 50,
              ),
              BaseInfoRowByKeyAndValue.build(tr('curren_month_scenario'), '',
                  isWithEndShowAllButton: true,
                  showAllButtonText: tr('look_curren_month_scenario'),
                  isLeftIcon: true,
                  icon: Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: AppColors.showAllTextColor,
                    size: AppSize.iconSmallDefaultWidth,
                  ), callback: () {
                Navigator.pushNamed(context, CurruntMonthScenarioPage.routeName,
                    arguments: {
                      'model': p.dayResponseModel!.table430,
                      'zskunnr': p.t260!.zskunnr,
                      'zkmon': p.t260!.zkmno,
                    });
              }),
            ],
          ),
        ),
        defaultSpacing(times: 5)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    var dayModel = arguments['dayModel'] as SalesActivityDayResponseModel;
    var t260 = arguments['t260'] as SalesActivityDayTable260;
    return ChangeNotifierProvider(
        create: (context) => ActivityFinishPageProvider(),
        builder: (context, _) {
          return BaseLayout(
              hasForm: false,
              appBar: MainAppBar(context,
                  titleText: AppText.text('${tr('salse_activity_manager')}',
                      style: AppTextStyle.w500_22)),
              child: FutureBuilder<ResultModel>(
                  future: context
                      .read<ActivityFinishPageProvider>()
                      .init(dayModel, t260),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      return _buildContents(context);
                    }
                    return DefaultShimmer.buildDefaultPageShimmer(5,
                        isWithSet: true, setLenght: 5);
                  }));
        });
  }
}
