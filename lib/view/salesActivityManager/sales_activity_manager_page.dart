/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activityManeger/activity_manager_page.dart
 * Created Date: 2022-07-05 09:46:17
 * Last Modified: 2022-08-01 15:52:28
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_weeks_model.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_loading_view.dart';
import 'package:medsalesportal/view/salesActivityManager/provider/sales_activity_manager_page_provider.dart';
import 'package:provider/provider.dart';

class SalseActivityManagerPage extends StatefulWidget {
  const SalseActivityManagerPage({Key? key}) : super(key: key);
  static const String routeName = '/activityManegerPage';
  @override
  State<SalseActivityManagerPage> createState() =>
      _SalseActivityManagerPageState();
}

class _SalseActivityManagerPageState extends State<SalseActivityManagerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTabs(BuildContext context, String text) {
    return Container(
      alignment: Alignment.center,
      height: AppSize.defaultTextFieldHeight,
      child: Text('$text'),
    );
  }

  Widget _buildMonthView(BuildContext context) {
    return Stack(
      children: [
        Selector<SalseActivityManagerPageProvider,
            List<SalesActivityWeeksModel>?>(
          selector: (context, provider) => provider.monthResponseModel?.tList,
          builder: (context, weeks, _) {
            return weeks != null
                ? Container(
                    child: AppText.text(weeks.first.day4!),
                  )
                : Container();
          },
        ),
        Selector<SalseActivityManagerPageProvider, bool>(
          selector: (context, provider) => provider.isLoadData,
          builder: (context, isLoadData, _) {
            return BaseLoadingViewOnStackWidget.build(context, isLoadData);
          },
        )
      ],
    );
  }

  Widget _buildDayView(BuildContext context) {
    return Container();
  }

  Widget _buildTapView(BuildContext context) {
    return TabBarView(controller: _tabController, children: [
      _buildMonthView(context),
      _buildDayView(context),
      // buildFabricStockContents(context)  2022.02.14 원단재고 탭 삭제
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: true,
        appBar: MainAppBar(context,
            titleText: AppText.text('${tr('salse_activity_manager')}',
                style: AppTextStyle.w500_22)),
        child: ChangeNotifierProvider(
          create: (context) => SalseActivityManagerPageProvider(),
          builder: (context, _) {
            final p = context.read<SalseActivityManagerPageProvider>();
            return FutureBuilder<ResultModel>(
                future: p.getData(),
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      Padding(
                          padding: AppSize.defaultSidePadding,
                          child: TabBar(
                              onTap: (index) {
                                p.setTabIndex(index);
                                // _discriptionController!.text = '';
                              },
                              physics: ScrollPhysics(),
                              padding: EdgeInsets.zero,
                              indicatorColor: AppColors.blueTextColor,
                              labelStyle: AppTextStyle.color_16(
                                  AppColors.blueTextColor),
                              labelColor: AppColors.blueTextColor,
                              unselectedLabelStyle: AppTextStyle.default_16,
                              unselectedLabelColor: AppColors.defaultText,
                              controller: _tabController,
                              tabs: [
                                _buildTabs(context, '월별'),
                                _buildTabs(context, '일별'),
                              ])),
                      Divider(
                        color: AppColors.textGrey,
                        height: 0,
                      ),
                      Expanded(child: _buildTapView(context)),
                    ],
                  );
                });
          },
        ));
  }
}
