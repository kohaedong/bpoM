/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activityManeger/activity_manager_page.dart
 * Created Date: 2022-07-05 09:46:17
 * Last Modified: 2022-10-28 00:32:34
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/enums/menu_type.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/enums/customer_report_type.dart';
import 'package:medsalesportal/view/common/dialog_contents.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/base_popup_list.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/view/common/widget_of_tag_button.dart';
import 'package:medsalesportal/view/common/widget_of_loading_view.dart';
import 'package:medsalesportal/view/common/function_of_pop_to_first.dart';
import 'package:medsalesportal/model/rfc/sales_activity_weeks_model.dart';
import 'package:medsalesportal/globalProvider/activity_state_provder.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/base_date_picker_for_month.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_260.dart';
import 'package:medsalesportal/model/rfc/sales_activity_single_date_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/view/salesActivityManager/add_activity_page.dart';
import 'package:medsalesportal/view/salesActivityManager/activity_finish_page.dart';
import 'package:medsalesportal/model/rfc/salse_activity_location_response_model.dart';
import 'package:medsalesportal/view/salesActivityManager/select_location_widget.dart';
import 'package:medsalesportal/view/salesActivityManager/provider/activity_menu_provider.dart';
import 'package:medsalesportal/view/salesActivityManager/provider/sales_activity_manager_page_provider.dart';

typedef UpdateHook = Function(bool);

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
  late ValueNotifier<PageType?> _pageType;
  late ValueNotifier<Widget> _actionButton;
  @override
  void initState() {
    _pageType = ValueNotifier<PageType?>(PageType.DEFAULT);
    _actionButton = ValueNotifier(Container());
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageType.dispose();
    _actionButton.dispose();
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
      child: AppText.listViewText(weekdayName, style: AppTextStyle.sub_14),
    );
  }

  Widget _buildWeekDayBox(
      BuildContext context, SalesActivitySingleDateModel model) {
    var holidayList =
        context.read<SalseActivityManagerPageProvider>().holidayList;
    var colum1NotEmpty = model.column1 != null &&
        (int.parse(model.column1!.isNotEmpty ? model.column1! : '0') > 0);
    var colum2NotEmpty = model.column2 != null &&
        (int.parse(model.column2!.isNotEmpty ? model.column2! : '0') > 0);
    var colum3NotEmpty = model.column3 != null &&
        (int.parse(model.column3!.isNotEmpty ? model.column3! : '0') > 0);

    // print(
    //     '${model.column1!.trim()} * ${model.column2!.trim()} * ${model.column3!.trim()} * ${model.column4!.trim()}|');
    var isDataNotEmpty = (colum3NotEmpty || colum2NotEmpty || colum1NotEmpty);
    return GestureDetector(
      onTap: () {
        if (model.dateStr != null && model.dateStr!.trim().isNotEmpty) {
          final p = context.read<SalseActivityManagerPageProvider>();
          p.setSelectedDate(DateUtil.getDate(model.dateStr!));
          p.setIsResetDay(false);
          p.getDayData(isWithLoading: true);
          _tabController.animateTo(1);
        }
      },
      child: Container(
        color: AppColors.whiteText,
        // height: AppSize.weekDayHeight,
        width: AppSize.calendarWidth / 7,
        child: model.dateStr != null
            ? Column(
                children: [
                  DateUtil.equlse(
                          DateUtil.getDate(model.dateStr!), DateTime.now())
                      ? Container(
                          height: AppTextStyle.default_14.fontSize! * 2.4,
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: AppText.listViewText(
                                '${DateUtil.getDate(model.dateStr!).day}',
                                style: AppTextStyle.default_14
                                    .copyWith(color: AppColors.whiteText)),
                          ),
                        )
                      : Container(
                          height: AppTextStyle.default_14.fontSize! * 2.4,
                          alignment: Alignment.center,
                          child: AppText.listViewText(
                              '${DateUtil.getDate(model.dateStr!).day}',
                              style: AppTextStyle.default_14.copyWith(
                                  color: DateUtil.getDate(model.dateStr!)
                                                  .weekday ==
                                              7 ||
                                          holidayList.contains(
                                              DateUtil.getDate(model.dateStr!))
                                      ? AppColors.dangerColor
                                      : DateUtil.getDate(model.dateStr!)
                                                  .weekday ==
                                              6
                                          ? AppColors.primary
                                          : AppColors.defaultText)),
                        ),
                  defaultSpacing(),
                  AppText.listViewText(
                      model.column4 == 'C'
                          ? '확정'
                          : model.dateStr != null &&
                                  model.dateStr!.isNotEmpty &&
                                  isDataNotEmpty &&
                                  DateUtil.getDate(model.dateStr!)
                                      .isBefore(DateTime.now())
                              ? '미확정'
                              : '',
                      style: AppTextStyle.default_14.copyWith(
                          color: model.column4 == 'C'
                              ? AppColors.primary
                              : AppColors.dangerColor,
                          fontWeight: FontWeight.bold)),
                  AppText.listViewText(
                      isDataNotEmpty
                          ? '${int.parse(model.column1!.isEmpty ? '0' : model.column1!)}/${int.parse(model.column2!.isEmpty ? '0' : model.column2!)}'
                          : '',
                      style: AppTextStyle.sub_12),
                  defaultSpacing()
                ],
              )
            : Container(),
      ),
    );
  }

  Widget _buildWeekTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildWeekDayTitleBox(tr('sunday', args: [''])),
        _buildWeekDayTitleBox(tr('monday', args: [''])),
        _buildWeekDayTitleBox(tr('tuesday', args: [''])),
        _buildWeekDayTitleBox(tr('wednesday', args: [''])),
        _buildWeekDayTitleBox(tr('thursday', args: [''])),
        _buildWeekDayTitleBox(tr('friday', args: [''])),
        _buildWeekDayTitleBox(tr('saturday', args: [''])),
      ],
    );
  }

  Widget _buildLeftAndRightIcons(BuildContext context,
      {bool? isLeft,
      bool? isMonth,
      required bool isLoadMonthData,
      required bool isLoadDayData}) {
    return GestureDetector(
        onTap: () {
          final p = context.read<SalseActivityManagerPageProvider>();
          if (isMonth != null &&
              isMonth &&
              !isLoadMonthData &&
              !isLoadMonthData) {
            isLeft != null && isLeft
                ? p.getPreviousMonthData()
                : p.getNextMonthData();
          }
          if (isMonth != null &&
              !isMonth &&
              !isLoadMonthData &&
              !isLoadDayData) {
            isLeft != null && isLeft
                ? p.getPreviousDayData()
                : p.getNextDayData();
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
        pr(1);
        final p = context.read<SalseActivityManagerPageProvider>();
        if (isMonth != null && isMonth) {
          final result = await AppDialog.showPopup(
              context,
              BaseDatePickerForMonth(
                initDate: p.selectedMonth ?? DateTime.now(),
              ));
          if (result != null) {
            if (result != null) {
              var date = DateUtil.getDate(result);
              p.getSelectedMonthData(date);
            }
          }
        } else {
          final rs = await BasePopupList(
                  OneCellType.DATE_PICKER, InputIconType.DATA_PICKER)
              .show(context,
                  selectedDateStr: DateUtil.getDateStr('',
                      dt: isMonth != null && isMonth
                          ? p.selectedMonth ?? DateTime.now()
                          : p.selectedDay ?? DateTime.now()));

          if (rs != null) {
            p.getSelectedDayData(DateUtil.getDate(rs));
          }
        }
      },
      child: isMonth != null && isMonth
          ? Selector<SalseActivityManagerPageProvider, DateTime?>(
              selector: (context, provider) => provider.selectedMonth,
              builder: (context, month, _) {
                return Container(
                  child: AppText.text(
                      month != null
                          ? DateUtil.getMonthStrForKR(month, isWithZero: true)
                          : '${DateUtil.getMonthStrForKR(DateTime.now(), isWithZero: true)}',
                      style: AppTextStyle.default_18
                          .copyWith(fontWeight: FontWeight.w500)),
                );
              },
            )
          : Selector<SalseActivityManagerPageProvider, DateTime?>(
              selector: (context, provider) => provider.selectedDay,
              builder: (context, day, _) {
                return Container(
                  child: AppText.text(
                      day != null
                          ? DateUtil.getDateStrForKR(day, isWithZero: true)
                          : '${DateUtil.getMonthStrForKR(DateTime.now(), isWithZero: true)}',
                      style: AppTextStyle.default_18
                          .copyWith(fontWeight: FontWeight.w500)),
                );
              },
            ),
    );
  }

  Widget _buildDateSelector(BuildContext context, {bool? isMonthSelector}) {
    return Selector<SalseActivityManagerPageProvider, Tuple2<bool, bool>>(
      selector: (context, provider) =>
          Tuple2(provider.isLoadDayData, provider.isLoadMonthData),
      builder: (context, tuple, _) {
        return SizedBox(
          width: AppSize.calendarWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLeftAndRightIcons(context,
                  isLeft: true,
                  isMonth: isMonthSelector,
                  isLoadDayData: tuple.item1,
                  isLoadMonthData: tuple.item2),
              _buildDateText(context, isMonth: isMonthSelector),
              _buildLeftAndRightIcons(context,
                  isLeft: false,
                  isMonth: isMonthSelector,
                  isLoadDayData: tuple.item1,
                  isLoadMonthData: tuple.item2),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopupView(BuildContext context) {
    final p = context.read<SalseActivityManagerPageProvider>();
    return Selector<SalseActivityManagerPageProvider, bool?>(
      selector: (context, provider) => provider.isShowPopup,
      builder: (context, isShowPopup, _) {
        return Builder(builder: (context) {
          if (isShowPopup != null && isShowPopup) {
            Future.delayed(Duration.zero, () async {
              await AppDialog.showSignglePopup(
                  KeyService.baseAppKey.currentContext!,
                  tr('have_unconfirmed_activity', args: [
                    '${DateUtil.getDateStrForKR(p.previousWorkingDay!)}'
                  ]));
              p.resetIsShowPopup();
            });
          }
          return Container();
        });
      },
    );
  }

  Widget _buildMonthView(BuildContext context) {
    final p = context.read<SalseActivityManagerPageProvider>();
    return WillPopScope(
      onWillPop: () async => !p.isLoadMonthData,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Selector<SalseActivityManagerPageProvider,
              Tuple2<List<SalesActivityWeeksModel>?, bool>>(
            selector: (context, provider) => Tuple2(
                provider.monthResponseModel?.tList, provider.isLoadMonthData),
            builder: (context, tuple, _) {
              return tuple.item2
                  ? _buildShimmerCalndar(context, true)
                  : tuple.item1 != null
                      ? RefreshIndicator(
                          onRefresh: () async {
                            pr('refresh');
                            await p.getMonthData(isWithLoading: true);
                          },
                          child: ListView(
                            children: [
                              defaultSpacing(),
                              _buildDateSelector(context,
                                  isMonthSelector: true),
                              defaultSpacing(),
                              Divider(),
                              _buildWeekTitle(),
                              Column(
                                children: [
                                  ...tuple.item1!
                                      .asMap()
                                      .entries
                                      .map((map) =>
                                          _buildWeekRow(context, map.value))
                                      .toList()
                                ],
                              )
                            ],
                          ),
                        )
                      : Container();
            },
          ),
          _buildPopupView(context),
        ],
      ),
    );
  }

  Widget _buildDayListItem(
      BuildContext context, SalesActivityDayTable260 model, String seqNo) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final p = context.read<SalseActivityManagerPageProvider>();
        var isFinish = p.dayResponseModel!.table250!.isNotEmpty &&
            p.dayResponseModel!.table250!.single.stat == 'C';
        if (isFinish || p.activityStatus == ActivityStatus.NONE) {
          await Navigator.pushNamed(context, SalseActivityFinishPage.routeName,
              arguments: {
                't260': model,
                't250': p.dayResponseModel!.table250!.single,
                'dayModel': p.dayResponseModel
              });
        } else {
          final naviResult = await Navigator.pushNamed(
              context, AddActivityPage.routeName, arguments: {
            'model': p.dayResponseModel,
            'status': p.activityStatus,
            'seqNo': seqNo
          });
          if (naviResult != null) {
            naviResult as bool;
            if (naviResult) {
              pr('is pop? $naviResult');
              p.getDayData(isWithLoading: true);
            }
          }
        }
      },
      child: Padding(
        padding: AppSize.defaultSidePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            defaultSpacing(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.listViewText(model.zskunnrNm!),
                model.xmeet == 'S' && model.xvisit == 'Y'
                    ? BaseTagButton.build(tr('successful'))
                    : model.xmeet != 'S' && model.xvisit == 'Y'
                        ? BaseTagButton.build(tr('faild'))
                        : Container()
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              child: Row(
                children: [
                  model.rslt != null && model.rslt!.trim().isEmpty
                      ? Container()
                      : AppImage.getImage(ImageType.L_ICON),
                  SizedBox(
                    width: AppSize.calendarWidth * .7,
                    child: AppText.listViewText('${model.rslt!}',
                        textAlign: TextAlign.start),
                  ),
                ],
              ),
            ),
            defaultSpacing(isHalf: true),
            Row(
              children: [
                FutureBuilder<List<String>?>(
                    future: HiveService.getCustomerType(
                        model.zstatus?.length == 1 &&
                                int.tryParse(model.zstatus!) != null
                            ? '0${model.zstatus}'
                            : '${model.zstatus}'),
                    builder: (context, snapshot) {
                      var hasData = snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done;
                      return AppText.text(hasData ? snapshot.data!.single : '');
                    }),
                model.zkmnoNm != null && model.zkmnoNm!.isNotEmpty
                    ? AppStyles.buildPipe()
                    : Container(),
                AppText.text(model.zkmnoNm ?? ''),
                AppStyles.buildPipe(),
                AppText.text(tr(model.xvisit == 'Y' ? 'visit' : 'not_visit')),
              ],
            ),
            defaultSpacing(height: AppSize.defaultListItemSpacing / 2),
            Divider()
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCount(int? count, {required bool? isNotEmpty}) {
    return isNotEmpty != null && isNotEmpty
        ? Padding(
            padding: AppSize.defaultSidePadding,
            child: Row(
              children: [
                AppText.text('총', style: AppTextStyle.default_14),
                AppText.text('$count', style: AppTextStyle.blod_16),
                AppText.text('건', style: AppTextStyle.default_14),
              ],
            ))
        : Container();
  }

  Future<void> _showLocationPopup(
    BuildContext context,
  ) async {
    final p = context.read<ActivityMenuProvider>();
    final popupResult = await AppDialog.showPopup(
      context,
      SelectLocationWidget(
          status: p.activityStatus,
          locationList: p.officeAddressResponseModel!.tList!,
          model: p.editModel),
    );
    if (popupResult != null) {
      popupResult as ResultModel;
      //!  주소 선택 팝업창에서 리턴된 데이터.
      if (popupResult.isSuccessful) {
        if (p.activityStatus == ActivityStatus.STARTED ||
            p.activityStatus == ActivityStatus.PREV_WORK_DAY_EN_STOPED) {
          AppToast().show(context, tr('activity_is_stoped'));
          Navigator.pop(context, true);
        }
        if (p.activityStatus == ActivityStatus.INIT) {
          var parentModel = popupResult.data as SalesActivityDayResponseModel;
          p.initData(parentModel, ActivityStatus.STARTED, isMounted: true);
          p.setIsNeedUpdate(true);
          AppToast().show(context, tr('activity_is_started'));
          // await _routeToAddActivityPage(context);
          Navigator.pop(context, true);
        }
      }
    }
  }

  void _showIsDeleteLastAvtivityPopup(BuildContext context) async {
    final p = context.read<ActivityMenuProvider>();
    final isProvDay =
        p.activityStatus == ActivityStatus.PREV_WORK_DAY_EN_STOPED ||
            p.activityStatus == ActivityStatus.PREV_WORK_DAY_STOPED;
    var date = DateUtil.getDateStrForKR(isProvDay
        ? DateUtil.getDate(p.editModel!.table250![0].adate!)
        : DateTime.now());
    var person = isProvDay
        ? p.editModel!.table250![0].ernam!
        : CacheService.getEsLogin()!.ename!;
    final result = await AppDialog.showPopup(
        context,
        buildTowButtonTextContents(
            context, tr('is_realy_delete_last_activity', args: [date, person]),
            successButtonText: tr('delete')));

    if (result != null && result) {
      p.deletLastActivity().then((result) {
        if (result.isSuccessful) {
          AppToast().show(context, tr('success'));
          Navigator.pop(context, true);
        } else if (!result.isSuccessful && result.data == 'empty') {
          AppToast().show(context, tr('nothing_to_delete'));
        }
      });
    }
  }

  void _showIsStartAvtivityPopup(BuildContext context) async {
    final result = await AppDialog.showPopup(
        context,
        buildTowButtonTextContents(
          context,
          tr('start_activity_first_commont'),
        ));

    if (result != null) {
      result as bool;
      if (result) {
        await _showLocationPopup(context);
      }
    }
  }

  Future<void> _routeToAddActivityPage(BuildContext context,
      {UpdateHook? hook}) async {
    //! context 가 다릅니다.
    //! [ActivityMenuProvider]  와  [SalseActivityManagerPageProvider] 구분 필요.
    final p = context.read<ActivityMenuProvider>();
    var t250 = p.editModel!.table250!.single;
    if (t250.stat == 'C') {
      pr('confiremState:: finish!');
      //
    } else {
      final p = context.read<ActivityMenuProvider>();

      final naviResult = await Navigator.popAndPushNamed(
          context, AddActivityPage.routeName,
          arguments: {
            'model': p.editModel,
            'status': p.activityStatus,
            'seqNo': null,
          });
      if (naviResult != null) {
        naviResult as bool;
        pr(naviResult);
        if (hook != null) {
          hook.call(naviResult);
        }
      }
    }
  }

  Widget _buildMenuItem(BuildContext context, String text, MenuType menuType,
      {UpdateHook? hook}) {
    return Selector<ActivityMenuProvider, ActivityStatus?>(
      selector: (context, provider) => provider.activityStatus,
      builder: (context, status, _) {
        return AppStyles.buildButton(
            context,
            menuType == MenuType.ACTIVITY_STATUS
                ? status == ActivityStatus.STARTED ||
                        status == ActivityStatus.PREV_WORK_DAY_EN_STOPED
                    ? tr('stop_sales_activity')
                    : tr('start_sales_activity')
                : '$text',
            120,
            AppColors.whiteText,
            AppTextStyle.default_12.copyWith(color: AppColors.primary),
            AppSize.radius25, () async {
          final p = context.read<ActivityMenuProvider>();
          if (p.isDifreentGoinTime) {
            AppToast().show(context, tr('stats_is_changed'));
            popToFirst(context);
            return;
          }
          switch (menuType) {
            case MenuType.ACTIVITY_DELETE:
              //! remove last table.
              _showIsDeleteLastAvtivityPopup(context);
              break;
            case MenuType.ACTIVITY_ADD:
              if (p.activityStatus == ActivityStatus.STARTED) {
                _routeToAddActivityPage(context, hook: hook);
              } else {
                p.setIsNeedUpdate(true);
                _showIsStartAvtivityPopup(context);
              }
              break;
            case MenuType.ACTIVITY_STATUS:
              switch (p.activityStatus) {
                case ActivityStatus.INIT:
                  // 영업활동 시작
                  _showLocationPopup(context);
                  break;
                case ActivityStatus.STARTED:
                  // 영업활동 종료.
                  _showLocationPopup(context);
                  break;
                case ActivityStatus.PREV_WORK_DAY_EN_STOPED:
                  // 영업활동 종료.
                  _showLocationPopup(context);
                  break;
                default:
              }
              break;
          }
        }, selfHeight: AppSize.smallButtonHeight * 1.2);
      },
    );
  }

// 사작/추가/종료 버튼 view
  Widget _buildDialogContents(
      BuildContext context,
      SalesActivityDayResponseModel fromParentWindowModel,
      ActivityStatus? activityStatus,
      SalseActivityLocationResponseModel officeAddress,
      UpdateHook hook,
      {bool? isNotConfirmed}) {
    return ChangeNotifierProvider(
      create: (context) => ActivityMenuProvider(),
      builder: (context, _) {
        final p = context.read<ActivityMenuProvider>();
        p.initData(fromParentWindowModel, activityStatus,
            officeAddress: officeAddress);
        return Material(
          type: MaterialType.transparency,
          child: WillPopScope(
            onWillPop: () async => false,
            child: SafeArea(
              bottom: Platform.isIOS ? false : true,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                      right: AppSize.padding,
                      bottom: (AppSize.defaultListItemSpacing * 2) +
                          AppSize.buttonHeight * 2,
                      child: Column(
                        children: [
                          isNotConfirmed != null && isNotConfirmed
                              ? Container()
                              : Column(
                                  children: [
                                    _buildMenuItem(
                                        context,
                                        tr('delete_prev_activity'),
                                        MenuType.ACTIVITY_DELETE),
                                    defaultSpacing(times: 2),
                                    _buildMenuItem(context, tr('new_activity'),
                                        MenuType.ACTIVITY_ADD,
                                        hook: hook),
                                    defaultSpacing(times: 2),
                                  ],
                                ),
                          _buildMenuItem(context, '', MenuType.ACTIVITY_STATUS),
                        ],
                      )),
                  Positioned(
                      right: AppSize.padding,
                      bottom: AppSize.buttonHeight,
                      child: FloatingActionButton(
                        backgroundColor: AppColors.primary,
                        onPressed: () {
                          Navigator.pop(context, p.isNeedUpdate);
                        },
                        child: Icon(Icons.close, color: AppColors.whiteText),
                      )),
                  Positioned(
                      left: 0,
                      bottom: 0,
                      child: Selector<ActivityMenuProvider, bool>(
                          selector: (context, provider) => provider.isLoadData,
                          builder: (context, isLoadData, _) {
                            return BaseLoadingViewOnStackWidget.build(
                                context, isLoadData);
                          }))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuButton(BuildContext context, {bool? isNotConfirmed}) {
    final p = context.read<SalseActivityManagerPageProvider>();

    return Positioned(
        bottom: AppSize.buttonHeight,
        right: AppSize.padding,
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () async {
            final result = await showDialog(
                useSafeArea: false,
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  // dialog 내부 provider model 전달.
                  return _buildDialogContents(
                    context,
                    p.dayResponseModel!,
                    p.activityStatus,
                    p.locationResponseModel!,
                    (isupdate) {
                      if (isupdate) {
                        p.getDayData(isUpdateLoading: true);
                      }
                    },
                    isNotConfirmed: isNotConfirmed,
                  );
                });
            if (result != null) {
              result as bool;
              //!   업데이트가 필요하면 최신 데이터 가져온다.
              if (result) {
                p.getDayData(isWithLoading: true);
              }
            }
          },
          child: AppImage.getImage(ImageType.PLUS, color: AppColors.whiteText),
        ));
  }

  Widget _buildDayView(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _changeAppbarConfirmButton(context),
        Selector<SalseActivityManagerPageProvider,
            List<SalesActivityDayTable260>?>(
          selector: (context, provider) => provider.dayResponseModel?.table260,
          builder: (context, list260, _) {
            return RefreshIndicator(
              onRefresh: () async {
                final p = context.read<SalseActivityManagerPageProvider>();
                await p.getDayData();
              },
              child: ListView(
                children: [
                  defaultSpacing(),
                  _buildDateSelector(context, isMonthSelector: false),
                  defaultSpacing(),
                  Divider(),
                  defaultSpacing(),
                  _buildTotalCount(list260?.length,
                      isNotEmpty: list260?.isNotEmpty),
                  defaultSpacing(),
                  list260 != null
                      ? list260.isNotEmpty
                          ? Column(
                              children: [
                                ...list260
                                    .asMap()
                                    .entries
                                    .map((map) => _buildDayListItem(
                                        context, map.value, map.value.seqno!))
                                    .toList()
                              ],
                            )
                          : Container(
                              height: AppSize.realHeight * .5,
                              alignment: Alignment.center,
                              child: AppText.listViewText(tr('no_data')),
                            )
                      : Container()
                ],
              ),
            );
          },
        ),
        Selector<SalseActivityManagerPageProvider,
            Tuple2<bool, ActivityStatus?>>(
          selector: (context, provider) => Tuple2(
              DateUtil.equlse(
                  provider.selectedDay ?? DateTime.now(), DateTime.now()),
              provider.activityStatus),
          builder: (context, tuple, _) {
            return tuple.item1
                ? (tuple.item2 == ActivityStatus.FINISH ||
                        tuple.item2 == ActivityStatus.STOPED)
                    ? Container()
                    : _buildMenuButton(context)
                : tuple.item2 == ActivityStatus.PREV_WORK_DAY_EN_STOPED
                    ? _buildMenuButton(context, isNotConfirmed: true)
                    : Container();
          },
        ),
        Selector<SalseActivityManagerPageProvider, bool>(
          selector: (context, provider) => provider.isLoadDayData,
          builder: (context, isLoadDayData, _) {
            pr('isLoad Day data $isLoadDayData');
            return BaseLoadingViewOnStackWidget.build(context, isLoadDayData,
                color: Colors.transparent);
          },
        ),
        Selector<SalseActivityManagerPageProvider, bool>(
          selector: (context, provider) => provider.isLoadConfirmData,
          builder: (context, isLoadConfirmData, _) {
            return BaseLoadingViewOnStackWidget.build(
                context, isLoadConfirmData);
          },
        ),
        Selector<SalseActivityManagerPageProvider, bool>(
          selector: (context, provider) => provider.isLoadUpdateData,
          builder: (context, isLoadUpdateData, _) {
            return BaseLoadingViewOnStackWidget.build(
                context, isLoadUpdateData);
          },
        ),
      ],
    );
  }

  Widget _buildTapBarView(BuildContext context) {
    return Expanded(
        child: TabBarView(controller: _tabController, children: [
      _buildMonthView(context),
      _buildDayView(context),
    ]));
  }

  Widget _changeAppbarConfirmButton(BuildContext context) {
    return Selector<SalseActivityManagerPageProvider, ActivityStatus?>(
      selector: (context, provider) => provider.activityStatus,
      builder: (context, status, _) {
        Future.delayed(Duration.zero, () {
          switch (status) {
            case ActivityStatus.FINISH:
              _pageType.value = PageType.SALES_ACTIVITY_MANAGER_DAY_DISIBLE;
              break;
            case ActivityStatus.PREV_WORK_DAY_EN_STOPED:
              _pageType.value = PageType.SALES_ACTIVITY_MANAGER_DAY;
              break;
            case ActivityStatus.PREV_WORK_DAY_STOPED:
              _pageType.value = PageType.SALES_ACTIVITY_MANAGER_DAY;
              break;
            case ActivityStatus.STARTED:
              _pageType.value = PageType.SALES_ACTIVITY_MANAGER_DAY;
              break;
            case ActivityStatus.STOPED:
              _pageType.value = PageType.SALES_ACTIVITY_MANAGER_DAY;
              break;
            case ActivityStatus.INIT:
              _pageType.value = PageType.SALES_ACTIVITY_MANAGER_DAY;
              break;
            case ActivityStatus.NONE:
              _pageType.value = PageType.DEFAULT;
              break;
            default:
              return;
          }
          _actionButton.value = _pageType.value!.actionWidget;
        });

        return Container();
      },
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final p = context.read<SalseActivityManagerPageProvider>();
    return Padding(
        padding: AppSize.defaultSidePadding,
        child: TabBar(
            physics: ScrollPhysics(),
            padding: EdgeInsets.zero,
            indicatorColor: AppColors.blueTextColor,
            labelStyle: AppTextStyle.color_16(AppColors.blueTextColor),
            labelColor: AppColors.blueTextColor,
            unselectedLabelStyle: AppTextStyle.default_16,
            unselectedLabelColor: AppColors.defaultText,
            controller: _tabController
              ..addListener(() {
                if (_tabController.index == 0) {
                  // 버튼 없에기.
                  var isLock = false;
                  if (!isLock && !p.isLoadMonthData && !p.isLoadDayData) {
                    p.setIsShowConfirm(false);
                    _actionButton.value = Container();
                    p
                        .getMonthData(isWithLoading: true)
                        .then((value) => isLock = true);
                  }
                }

                if (_tabController.index == 1) {
                  _actionButton.value = _pageType.value!.actionWidget;
                  final p = context.read<SalseActivityManagerPageProvider>();
                  var isLock = false;
                  if ((p.isResetDay == null &&
                      !p.isLoadDayData &&
                      !isLock &&
                      !p.isLoadMonthData)) {
                    isLock = true;
                    if (p.dayResponseModel == null) {
                      p.setSelectedDate(DateTime.now());
                    }
                  }
                  if (!p.isLoadDayData &&
                      !p.isLoadMonthData &&
                      p.dayResponseModel == null) {
                    p
                        .getDayData(isWithLoading: true)
                        .whenComplete(() => isLock = false);
                  }
                }
              }),
            tabs: [
              _buildTabs(context, '월별'),
              _buildTabs(context, '일별'),
            ]));
  }

  Widget _buildShimmerCalndar(BuildContext context, bool isFromRefresh) {
    return isFromRefresh
        ? ListView(
            children: [
              defaultSpacing(),
              _buildDateSelector(context, isMonthSelector: true),
              defaultSpacing(),
              Divider(),
              _buildWeekTitle(),
              Padding(
                  padding: AppSize.defaultSidePadding,
                  child: DefaultShimmer.buildCalindaShimmer())
            ],
          )
        : Expanded(
            child: ListView(
            children: [
              defaultSpacing(),
              _buildDateSelector(context, isMonthSelector: true),
              defaultSpacing(),
              Divider(),
              _buildWeekTitle(),
              Padding(
                  padding: AppSize.defaultSidePadding,
                  child: DefaultShimmer.buildCalindaShimmer())
            ],
          ));
  }

  Widget _buildUpdateDayDataHook(BuildContext context) {
    final p = context.read<SalseActivityManagerPageProvider>();
    return Selector<ActivityStateProvider, bool>(
        selector: (context, provider) => provider.isNeedUpdateDayData,
        builder: (context, isNeedUpdate, _) {
          Future.delayed(Duration.zero, () {
            if (isNeedUpdate) {
              p.getDayData();
            }
          });
          return Container();
        });
  }

  Widget _buildErrorPopup(BuildContext context, String error) {
    return Builder(builder: (ctx) {
      Future.delayed(Duration.zero, () async {
        var popupsult = await AppDialog.showSignglePopup(ctx, error);
        if (popupsult != null) {
          Navigator.pop(context);
        }
      });
      return Container();
    });
  }

  Widget _buildShimmerView(BuildContext context) {
    return Column(
      children: [
        _buildTabBar(context),
        Divider(color: AppColors.textGrey, height: 0),
        _buildShimmerCalndar(context, false),
      ],
    );
  }

  Future<void> doConfirmTable(BuildContext context) async {
    final p = context.read<SalseActivityManagerPageProvider>();
    if (p.isDifreentGoinTime) {
      AppToast().show(context, tr('stats_is_changed'));
      popToFirst(context);
      return;
    }
    if (p.activityStatus! == ActivityStatus.STOPED ||
        p.activityStatus == ActivityStatus.PREV_WORK_DAY_STOPED) {
      await Future.delayed(Duration.zero, () async {
        final popupResult = await AppDialog.showPopup(
            context,
            buildTowButtonTextContents(context, tr('is_really_confirem'),
                successButtonText: tr('confirm')));

        if (popupResult != null && popupResult) {
          await p.confirmeAcitivityTable().then((result) => result.isSuccessful
              ? () {
                  p.setActivityStatus(ActivityStatus.FINISH);
                  AppToast().show(context, tr('confirm_successful'));
                }()
              : () async {
                  var seqNo = result.data['seqNo'];
                  var message = result.data['message'];
                  AppToast().show(context, message);
                  var popResult = await Navigator.pushNamed(
                      context, AddActivityPage.routeName,
                      arguments: {
                        'model': p.dayResponseModel,
                        'status': p.activityStatus,
                        'seqNo': seqNo,
                      });
                  if (popResult != null) {
                    p.getDayData(isWithLoading: true);
                  }
                }());
        }
      });
    } else if (p.activityStatus != ActivityStatus.FINISH) {
      AppDialog.showSimpleDialog(
          context, null, tr('stop_activity_first_commont'),
          isSingleButton: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SalseActivityManagerPageProvider(),
        builder: (context, _) {
          final p = context.read<SalseActivityManagerPageProvider>();
          return BaseLayout(
              key: KeyService.activityPageKey,
              hasForm: true,
              isWithWillPopScope: true,
              willpopCallback: () => !p.isLoadMonthData,
              appBar: MainAppBar(context,
                  titleText: AppText.text('${tr('salse_activity_manager')}',
                      style: AppTextStyle.w500_22),
                  callback: () {
                    if (!p.isLoadMonthData) {
                      Navigator.pop(context);
                    }
                  },
                  action: ValueListenableBuilder<Widget>(
                      valueListenable: _actionButton,
                      builder: (context, _actionButton, _) {
                        return _actionButton;
                      }),
                  actionCallback: () async => await doConfirmTable(context)),
              child: FutureBuilder<ResultModel>(
                  future: context
                      .read<SalseActivityManagerPageProvider>()
                      .getMonthData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      return Stack(
                        children: [
                          Column(
                            children: [
                              _buildTabBar(context),
                              Divider(color: AppColors.textGrey, height: 0),
                              snapshot.data!.isSuccessful
                                  ? _buildTapBarView(context)
                                  : _buildErrorPopup(
                                      context, snapshot.data!.errorMassage!),
                              _buildUpdateDayDataHook(context)
                            ],
                          ),
                          // Selector<SalseActivityManagerPageProvider, bool>(
                          //     selector: (context, provider) =>
                          //         provider.isLoadMonthData,
                          //     builder: (context, isloadData, _) {
                          //       return BaseLoadingViewOnStackWidget.build(
                          //           context, isloadData,
                          //           color: Colors.transparent);
                          //     })
                        ],
                      );
                    }
                    return _buildShimmerView(context);
                  }));
        });
  }
}
