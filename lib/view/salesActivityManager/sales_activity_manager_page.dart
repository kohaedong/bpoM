/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activityManeger/activity_manager_page.dart
 * Created Date: 2022-07-05 09:46:17
 * Last Modified: 2022-08-03 14:55:28
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/model/rfc/sales_activity_single_date_model.dart';
import 'package:medsalesportal/view/common/base_popup_list.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/widget_of_loading_view.dart';
import 'package:medsalesportal/model/rfc/sales_activity_weeks_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/salesActivityManager/provider/sales_activity_manager_page_provider.dart';

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

  Widget _buildWeekRow(BuildContext context, SalesActivityWeeksModel model) {
    return SizedBox(
      width: AppSize.calendarWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildWeekDayBox(
              context,
              SalesActivitySingleDateModel(model.day0, model.day01, model.day02,
                  model.day03, model.day04)),
          _buildWeekDayBox(
              context,
              SalesActivitySingleDateModel(model.day1, model.day11, model.day12,
                  model.day13, model.day14)),
          _buildWeekDayBox(
              context,
              SalesActivitySingleDateModel(model.day2, model.day21, model.day22,
                  model.day23, model.day24)),
          _buildWeekDayBox(
              context,
              SalesActivitySingleDateModel(model.day3, model.day31, model.day32,
                  model.day33, model.day34)),
          _buildWeekDayBox(
              context,
              SalesActivitySingleDateModel(model.day4, model.day41, model.day42,
                  model.day43, model.day44)),
          _buildWeekDayBox(
              context,
              SalesActivitySingleDateModel(model.day5, model.day51, model.day52,
                  model.day53, model.day54)),
          _buildWeekDayBox(
              context,
              SalesActivitySingleDateModel(model.day6, model.day61, model.day62,
                  model.day63, model.day64))
        ],
      ),
    );
  }

  Widget _buildWeekDayTitleBox(String weekdayName) {
    return SizedBox(
      height: AppSize.weekDayHeight * .5,
      width: AppSize.calendarWidth / 7,
      child: AppText.text(weekdayName, style: AppTextStyle.sub_14),
    );
  }

  Widget _buildWeekDayBox(
      BuildContext context, SalesActivitySingleDateModel model) {
    var isWorkDay = (int.parse(
            model.column1 != null && model.column1!.isNotEmpty
                ? model.column1!.trim()
                : '0') !=
        int.parse(model.column2 != null && model.column2!.isNotEmpty
            ? model.column2!.trim()
            : '0'));
    return InkWell(
      onTap: () {
        final p = context.read<SalseActivityManagerPageProvider>();
        p.setSelectedDate(DateUtil.getDate(model.dateStr!));
        p.getDayData();
        _tabController.animateTo(1);
      },
      child: SizedBox(
        height: AppSize.weekDayHeight,
        width: AppSize.calendarWidth / 7,
        child: model.dateStr != null
            ? Column(
                children: [
                  DateUtil.getDate(model.dateStr!).year ==
                              DateTime.now().year &&
                          DateUtil.getDate(model.dateStr!).month ==
                              DateTime.now().month &&
                          DateUtil.getDate(model.dateStr!).day ==
                              DateTime.now().day
                      ? Container(
                          alignment: Alignment.center,
                          height: AppSize.weekDayNumberBoxHeight,
                          child: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: AppText.text(
                                '${DateUtil.getDate(model.dateStr!).day}',
                                style: AppTextStyle.default_14
                                    .copyWith(color: AppColors.whiteText)),
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          height: AppSize.weekDayNumberBoxHeight,
                          child: AppText.text(
                              '${DateUtil.getDate(model.dateStr!).day}',
                              style: AppTextStyle.default_14.copyWith(
                                  color: DateUtil.getDate(model.dateStr!)
                                              .weekday ==
                                          7
                                      ? AppColors.dangerColor
                                      : DateUtil.getDate(model.dateStr!)
                                                  .weekday ==
                                              6
                                          ? AppColors.primary
                                          : AppColors.defaultText)),
                        ),
                  AppText.text(
                      model.column4 == 'C'
                          ? '확정'
                          : model.dateStr != null &&
                                  model.dateStr!.isNotEmpty &&
                                  isWorkDay &&
                                  DateUtil.getDate(model.dateStr!)
                                      .isBefore(DateTime.now())
                              ? '미확정'
                              : '',
                      style: AppTextStyle.default_14.copyWith(
                          color: model.column4 == 'C'
                              ? AppColors.primary
                              : AppColors.dangerColor,
                          fontWeight: FontWeight.bold)),
                  AppText.text(
                      isWorkDay
                          ? '${model.column1 != null && model.column1!.isNotEmpty ? model.column1!.trim() : '0'}/${model.column2 != null && model.column2!.isNotEmpty ? model.column2!.trim() : '0'}'
                          : '',
                      style: AppTextStyle.sub_12)
                ],
              )
            : Container(),
      ),
    );
  }

  Widget _buildWeekTitle() {
    return SizedBox(
      width: AppSize.calendarWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildWeekDayTitleBox(tr('sunday', args: [''])),
          _buildWeekDayTitleBox(tr('monday', args: [''])),
          _buildWeekDayTitleBox(tr('tuesday', args: [''])),
          _buildWeekDayTitleBox(tr('wednesday', args: [''])),
          _buildWeekDayTitleBox(tr('thursday', args: [''])),
          _buildWeekDayTitleBox(tr('friday', args: [''])),
          _buildWeekDayTitleBox(tr('saturday', args: [''])),
        ],
      ),
    );
  }

  Widget _buildLeftAndRightIcons(BuildContext context,
      {bool? isLeft, bool? isMonth}) {
    return GestureDetector(
        onTap: () {
          final p = context.read<SalseActivityManagerPageProvider>();
          if (isMonth != null && isMonth) {
            isLeft != null && isLeft
                ? p.getLastMonthData()
                : p.getNextMonthData();
          } else {
            isLeft != null && isLeft ? p.getLastDayData() : p.getNextDayData();
          }
        },
        child: Container(
          width: 100,
          height: 50,
          color: AppColors.whiteText,
          child: Icon(
            isLeft != null && isLeft
                ? Icons.arrow_back_ios
                : Icons.arrow_forward_ios_sharp,
            color: AppColors.subText,
            size: AppSize.iconSmallDefaultWidth,
          ),
        ));
  }

  Widget _buildDateText(BuildContext context, {bool? isMonth}) {
    return InkWell(
      onTap: () async {
        final p = context.read<SalseActivityManagerPageProvider>();
        final result = await BasePopupList(
                OneCellType.DATE_PICKER, InputIconType.DATA_PICKER)
            .show(context,
                selectedDateStr: DateUtil.getDateStr('',
                    dt: isMonth != null && isMonth
                        ? p.selectedMonth ?? DateTime.now()
                        : p.selectedDay ?? DateTime.now()));

        if (result != null) {
          isMonth != null && isMonth
              ? p.getSelectedMonthData(DateUtil.getDate(result))
              : p.getSelectedDayData(DateUtil.getDate(result));
        }
      },
      child: isMonth != null && isMonth
          ? Selector<SalseActivityManagerPageProvider, DateTime?>(
              selector: (context, provider) => provider.selectedMonth,
              builder: (context, month, _) {
                return Container(
                  child: AppText.text(month != null
                      ? DateUtil.getMonthStrForKR(month)
                      : '${DateUtil.getMonthStrForKR(DateTime.now())}'),
                );
              },
            )
          : Selector<SalseActivityManagerPageProvider, DateTime?>(
              selector: (context, provider) => provider.selectedDay,
              builder: (context, day, _) {
                return Container(
                  child: AppText.text(day != null
                      ? DateUtil.getDateStrForKR(day)
                      : '${DateUtil.getMonthStrForKR(DateTime.now())}'),
                );
              },
            ),
    );
  }

  Widget _buildDateSelector(BuildContext context, {bool? isMonthSelector}) {
    return SizedBox(
      width: AppSize.calendarWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLeftAndRightIcons(context,
              isLeft: true, isMonth: isMonthSelector),
          _buildDateText(context, isMonth: isMonthSelector),
          _buildLeftAndRightIcons(context,
              isLeft: false, isMonth: isMonthSelector),
        ],
      ),
    );
  }

  Widget _buildMonthView(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Selector<SalseActivityManagerPageProvider,
            List<SalesActivityWeeksModel>?>(
          selector: (context, provider) => provider.monthResponseModel?.tList,
          builder: (context, weeks, _) {
            return weeks != null
                ? ListView(
                    physics: ClampingScrollPhysics(),
                    children: [
                      defaultSpacing(),
                      _buildDateSelector(context, isMonthSelector: true),
                      defaultSpacing(),
                      Divider(),
                      _buildWeekTitle(),
                      ...weeks
                          .asMap()
                          .entries
                          .map((map) => _buildWeekRow(context, map.value))
                          .toList()
                    ],
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
    return Stack(
      alignment: Alignment.center,
      children: [
        Selector<SalseActivityManagerPageProvider,
            List<SalesActivityWeeksModel>?>(
          selector: (context, provider) => provider.monthResponseModel?.tList,
          builder: (context, weeks, _) {
            return weeks != null
                ? ListView(
                    physics: ClampingScrollPhysics(),
                    children: [
                      defaultSpacing(),
                      _buildDateSelector(context, isMonthSelector: false),
                      defaultSpacing(),
                      Divider(),
                    ],
                  )
                : Container();
          },
        )
      ],
    );
  }

  Widget _buildTapView(BuildContext context) {
    return TabBarView(controller: _tabController, children: [
      _buildMonthView(context),
      _buildDayView(context),
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
                future: p.getMonthData(),
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
