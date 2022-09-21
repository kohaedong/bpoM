/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activityManeger/activity_manager_page.dart
 * Created Date: 2022-07-05 09:46:17
 * Last Modified: 2022-09-21 18:34:11
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
import 'package:medsalesportal/service/hive_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/service/cache_service.dart';
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
import 'package:medsalesportal/view/common/widget_of_null_data.dart';
import 'package:medsalesportal/view/common/widget_of_tag_button.dart';
import 'package:medsalesportal/view/common/widget_of_loading_view.dart';
import 'package:medsalesportal/model/rfc/sales_activity_weeks_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_260.dart';
import 'package:medsalesportal/model/rfc/sales_activity_single_date_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/view/salesActivityManager/add_activity_page.dart';
import 'package:medsalesportal/model/rfc/salse_activity_location_response_model.dart';
import 'package:medsalesportal/view/salesActivityManager/select_location_widget.dart';
import 'package:medsalesportal/view/salesActivityManager/provider/activity_menu_provider.dart';
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
      child: AppText.text(weekdayName, style: AppTextStyle.sub_16),
    );
  }

  Widget _buildWeekDayBox(
      BuildContext context, SalesActivitySingleDateModel model) {
    var holidayList =
        context.read<SalseActivityManagerPageProvider>().holidayList;
    var isDataNotEmpty = ((int.parse(
                model.column1 != null && model.column1!.isNotEmpty
                    ? model.column1!
                    : '0') >
            0) ||
        (int.parse(model.column2 != null && model.column2!.isNotEmpty
                ? model.column2!
                : '0') >
            0));
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
        height: AppSize.weekDayHeight,
        width: AppSize.calendarWidth / 7,
        child: model.dateStr != null
            ? Column(
                children: [
                  DateUtil.equlse(
                          DateUtil.getDate(model.dateStr!), DateTime.now())
                      ? Container(
                          alignment: Alignment.center,
                          height: AppSize.weekDayNumberBoxHeight,
                          child: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: AppText.text(
                                '${DateUtil.getDate(model.dateStr!).day}',
                                style: AppTextStyle.default_16
                                    .copyWith(color: AppColors.whiteText)),
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          height: AppSize.weekDayNumberBoxHeight,
                          child: AppText.text(
                              '${DateUtil.getDate(model.dateStr!).day}',
                              style: AppTextStyle.default_16.copyWith(
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
                  AppText.text(
                      model.column4 == 'C'
                          ? '확정'
                          : model.dateStr != null &&
                                  model.dateStr!.isNotEmpty &&
                                  isDataNotEmpty &&
                                  DateUtil.getDate(model.dateStr!)
                                      .isBefore(DateTime.now())
                              ? '미확정'
                              : '',
                      style: AppTextStyle.default_16.copyWith(
                          color: model.column4 == 'C'
                              ? AppColors.primary
                              : AppColors.dangerColor,
                          fontWeight: FontWeight.bold)),
                  AppText.text(
                      isDataNotEmpty
                          ? '${model.column1 != null && model.column1!.isNotEmpty ? model.column1!.trim() : '0'}/${model.column2 != null && model.column2!.isNotEmpty ? model.column2!.trim() : '0'}'
                          : '',
                      style: AppTextStyle.sub_14)
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
      {bool? isLeft, bool? isMonth}) {
    return GestureDetector(
        onTap: () {
          final p = context.read<SalseActivityManagerPageProvider>();
          if (isMonth != null && isMonth) {
            isLeft != null && isLeft
                ? p.getPreviousMonthData()
                : p.getNextMonthData();
          } else {
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
                          ? DateUtil.getDateStrForKR(day)
                          : '${DateUtil.getMonthStrForKR(DateTime.now())}',
                      style: AppTextStyle.default_18
                          .copyWith(fontWeight: FontWeight.w500)),
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

  Widget _buildPopupView(BuildContext context) {
    final p = context.read<SalseActivityManagerPageProvider>();
    return Selector<SalseActivityManagerPageProvider, bool?>(
      selector: (context, provider) => provider.isShowPopup,
      builder: (context, isShowPopup, _) {
        return Builder(builder: (context) {
          if (isShowPopup != null && isShowPopup) {
            Future.delayed(Duration.zero, () async {
              await AppDialog.showSimpleDialog(
                  context,
                  null,
                  tr('have_unconfirmed_activity', args: [
                    '${DateUtil.getDateStrForKR(p.previousWorkingDay!)}'
                  ]), callBack: (isPressedTrue) {
                Navigator.pop(context);
                final p = context.read<SalseActivityManagerPageProvider>();
                p.setSelectedDate(p.previousWorkingDay!);
                p.setIsResetDay(false);
                p.getDayData(isWithLoading: true);
                if (_tabController.index == 0) {
                  _tabController.animateTo(1);
                  p.resetIsShowPopup();
                }
              }, isSingleButton: true);
            });
          }
          return Container();
        });
      },
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
                      Column(
                        children: [
                          ...weeks
                              .asMap()
                              .entries
                              .map((map) => _buildWeekRow(context, map.value))
                              .toList()
                        ],
                      )
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
        ),
        _buildPopupView(context),
      ],
    );
  }

  Widget _buildDayListItem(
      BuildContext context, SalesActivityDayTable260 model, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _routeToAddActivityPage(context, index: index);
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
                BaseTagButton.build(
                    tr(model.xmeet == 'S' ? 'successful' : 'faild'))
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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

  Future<void> _showLocationPopup(BuildContext context) async {
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
      //!  영업활동 시작/종료 성공 의미.
      if (popupResult.isSuccessful) {
        if (p.activityStatus == ActivityStatus.STARTED) {
          AppToast().show(context, tr('activity_is_stoped'));
          Navigator.pop(context, true);
        }
        if (p.activityStatus == ActivityStatus.INIT) {
          var parentModel = popupResult.data as SalesActivityDayResponseModel;
          p.initData(parentModel, ActivityStatus.STARTED, isMounted: true);
          pr('2');
          p.setIsNeedUpdate(true);
          AppToast().show(context, tr('activity_is_started'));
          // await _routeToAddActivityPage(context);
        }
      }
    }
  }

  void _showIsDeleteLastAvtivityPopup(BuildContext context) async {
    final p = context.read<ActivityMenuProvider>();
    if (p.editModel!.table260!.isNotEmpty) {
      var date = DateUtil.getDateStrForKR(
          DateUtil.getDate(p.editModel!.table260![0].adate!));
      var person = p.editModel!.table260![0].ernam!;
      final result = await AppDialog.showPopup(
          context,
          buildDialogContents(
            context,
            Container(
                alignment: Alignment.center,
                height: AppSize.singlePopupHeight - AppSize.buttonHeight,
                child: AppText.text(
                    tr('is_realy_delete_last_activity', args: [date, person]),
                    maxLines: 4,
                    style: AppTextStyle.default_16)),
            false,
            AppSize.singlePopupHeight,
          ));
      if (result != null && result) {
        p.deletLastActivity().then((result) {
          if (result.isSuccessful) {
            AppToast().show(context, tr('success'));
            Navigator.pop(context, true);
          }
        });
      }
    } else {
      AppToast().show(context, tr('nothing_to_delete'));
    }
  }

  void _showIsStartAvtivityPopup(BuildContext context) async {
    final result = await AppDialog.showPopup(
        context,
        buildDialogContents(
          context,
          Container(
              alignment: Alignment.center,
              height: AppSize.singlePopupHeight - AppSize.buttonHeight,
              child: AppText.text(tr('start_activity_first_commont'),
                  maxLines: 4, style: AppTextStyle.default_16)),
          false,
          AppSize.singlePopupHeight,
        ));
    if (result != null) {
      result as bool;
      if (result) {
        await _showLocationPopup(context);
      }
    }
  }

  Future<void> _routeToAddActivityPage(BuildContext context,
      {int? index}) async {
    //! context 가 다릅니다.
    //! [ActivityMenuProvider]  와  [SalseActivityManagerPageProvider] 구분 필요.
    if (index == null) {
      final p = context.read<ActivityMenuProvider>();
      // await Navigator.popAndPushNamed(context, AddActivityPage.routeName,
      //     arguments: {
      //       'model': p.editModel,
      //       'status': p.activityStatus,
      //       'index': index
      //     });

      final naviResult = await Navigator.pushNamed(
          context, AddActivityPage.routeName, arguments: {
        'model': p.editModel,
        'status': p.activityStatus,
        'index': index
      });
      if (naviResult != null) {
        pr('naviResult::::$naviResult');
        naviResult as bool;
        if (!p.isNeedUpdate) {
          p.setIsNeedUpdate(naviResult);
        }
        if (naviResult) {
          try {
            Navigator.pop(context, p.isNeedUpdate);
          } catch (e) {
            pr('nothing');
          }
        }
      }
    } else {
      final p = context.read<SalseActivityManagerPageProvider>();
      final naviResult = await Navigator.pushNamed(
          context, AddActivityPage.routeName, arguments: {
        'model': p.dayResponseModel,
        'status': p.activityStatus,
        'index': index
      });
      if (naviResult != null) {
        naviResult as bool;
        if (naviResult) {
          p.getDayData(isWithLoading: true);
        }
      }
    }
  }

  Widget _buildMenuItem(BuildContext context, String text, MenuType menuType) {
    return Selector<ActivityMenuProvider, ActivityStatus?>(
      selector: (context, provider) => provider.activityStatus,
      builder: (context, status, _) {
        return AppStyles.buildButton(
            context,
            menuType == MenuType.ACTIVITY_STATUS
                ? status == ActivityStatus.STARTED
                    ? tr('stop_sales_activity')
                    : tr('start_sales_activity')
                : '$text',
            120,
            AppColors.whiteText,
            AppTextStyle.default_14.copyWith(color: AppColors.primary),
            AppSize.radius25, () async {
          final p = context.read<ActivityMenuProvider>();
          switch (menuType) {
            case MenuType.ACTIVITY_DELETE:
              //! remove last table.
              _showIsDeleteLastAvtivityPopup(context);
              break;
            case MenuType.ACTIVITY_ADD:
              if (p.activityStatus == ActivityStatus.STARTED) {
                _routeToAddActivityPage(context);
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
      SalseActivityLocationResponseModel officeAddress) {
    return ChangeNotifierProvider(
      create: (context) => ActivityMenuProvider(),
      builder: (context, _) {
        final p = context.read<ActivityMenuProvider>();
        p.initData(fromParentWindowModel, activityStatus,
            officeAddress: officeAddress);
        return Material(
          type: MaterialType.transparency,
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
                        _buildMenuItem(
                            context, '최종콜 삭제', MenuType.ACTIVITY_DELETE),
                        defaultSpacing(times: 2),
                        _buildMenuItem(
                            context, '신규활동 추가', MenuType.ACTIVITY_ADD),
                        defaultSpacing(times: 2),
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
        );
      },
    );
  }

  Widget _buildMenuButton(BuildContext context) {
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
                  return _buildDialogContents(context, p.dayResponseModel!,
                      p.activityStatus, p.locationResponseModel!);
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
            return ListView(
              physics: ClampingScrollPhysics(),
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
                                      context, map.value, map.key))
                                  .toList()
                            ],
                          )
                        : BaseNullDataWidget.build()
                    : Container()
              ],
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
                : Container();
          },
        ),
        Selector<SalseActivityManagerPageProvider, bool>(
          selector: (context, provider) => provider.isLoadDayData,
          builder: (context, isLoadDayData, _) {
            return BaseLoadingViewOnStackWidget.build(context, isLoadDayData);
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
                  p.setIsShowConfirm(false);
                  _actionButton.value = Container();
                }
                if (_tabController.index == 1) {
                  _actionButton.value = _pageType.value!.actionWidget;
                  final p = context.read<SalseActivityManagerPageProvider>();
                  var isLock = false;
                  if ((p.isResetDay == null && !p.isLoadDayData && !isLock)) {
                    isLock = true;
                    if (p.dayResponseModel == null) {
                      p.setSelectedDate(DateTime.now());
                    }
                  }
                  if (!p.isLoadDayData) {
                    if (p.dayResponseModel == null) {
                      p
                          .getDayData(isWithLoading: true)
                          .whenComplete(() => isLock = false);
                    }
                  }
                }
              }),
            tabs: [
              _buildTabs(context, '월별'),
              _buildTabs(context, '일별'),
            ]));
  }

  Widget _buildShimmerView(BuildContext context, ResultModel? resultModel) {
    return Expanded(
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

  @override
  Widget build(BuildContext context) {
    pr('엉업사원 맞나 ?${CacheService.getEsLogin()!.salem}');
    return ChangeNotifierProvider(
        create: (context) => SalseActivityManagerPageProvider(),
        builder: (context, _) {
          final p = context.read<SalseActivityManagerPageProvider>();
          return BaseLayout(
              hasForm: true,
              appBar: MainAppBar(context,
                  titleText: AppText.text('${tr('salse_activity_manager')}',
                      style: AppTextStyle.w500_22),
                  action: ValueListenableBuilder<Widget>(
                      valueListenable: _actionButton,
                      builder: (context, _actionButton, _) {
                        return _actionButton;
                      }), actionCallback: () async {
                final p = context.read<SalseActivityManagerPageProvider>();
                switch (p.activityStatus!) {
                  case ActivityStatus.STOPED:
                    // save
                    p
                        .confirmAcitivityTable()
                        .then((result) => result.isSuccessful
                            ? () {
                                p.setActivityStatus(ActivityStatus.FINISH);
                                AppToast()
                                    .show(context, tr('confirm_successful'));
                              }()
                            : () async {
                                AppToast().show(
                                    context, tr('plz_check_essential_option'));
                                var popResult = await Navigator.pushNamed(
                                    context, AddActivityPage.routeName,
                                    arguments: {
                                      'model': p.dayResponseModel,
                                      'status': p.activityStatus,
                                      'index': result.data as int
                                    });
                                if (popResult != null) {
                                  p.getDayData(isWithLoading: true);
                                }
                              }());
                    break;
                  case ActivityStatus.FINISH:
                    DoNothingAction();
                    break;
                  default:
                    AppDialog.showSimpleDialog(
                        context, null, tr('stop_activity_first_commont'),
                        isSingleButton: true);
                }
              }),
              child: FutureBuilder<ResultModel>(
                  future: p.getMonthData(),
                  builder: (context, snapshot) {
                    var hasData = snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done &&
                        snapshot.data!.isSuccessful;
                    return Column(
                      children: [
                        _buildTabBar(context),
                        Divider(color: AppColors.textGrey, height: 0),
                        hasData
                            ? _buildTapBarView(context)
                            : _buildShimmerView(
                                context, hasData ? snapshot.data : null),
                      ],
                    );
                  }));
        });
  }
}
