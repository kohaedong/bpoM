/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activitySearch/activity_search_page.dart
 * Created Date: 2022-07-05 09:51:03
 * Last Modified: 2022-07-08 10:21:11
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/model/rfc/t_list_model.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/view/common/widget_of_null_data.dart';
import 'package:medsalesportal/view/common/widget_of_tag_button.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/view/common/widget_of_next_page_loading.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';
import 'package:medsalesportal/globalProvider/next_page_loading_provider.dart';
import 'package:medsalesportal/view/common/base_column_with_title_and_textfiled.dart';
import 'package:medsalesportal/view/salesActivitySearch/salse_activity_detail_page.dart';
import 'package:medsalesportal/view/salesActivitySearch/provider/salse_activity_search_page_provider.dart';

class SalseActivitySearchPage extends StatefulWidget {
  const SalseActivitySearchPage({Key? key}) : super(key: key);
  static const String routeName = '/activitySearchPage';
  @override
  State<SalseActivitySearchPage> createState() =>
      _SalseActivitySearchPageState();
}

class _SalseActivitySearchPageState extends State<SalseActivitySearchPage> {
  late TextEditingController _orderNumberEditingController;
  late TextEditingController _deliveryNumberEditingController;
  late TextEditingController _companyDistributionEditingController;
  late ScrollController _scrollController;
  late ScrollController _scrollController2;
  bool upLock = true;
  bool downLock = true;
  DateTime selectedDate = DateTime.now();
  var _scrollSwich = ValueNotifier<bool>(false);
  var _panelSwich = ValueNotifier(true);
  var mountedSwich = ValueNotifier(false);
  @override
  void initState() {
    _orderNumberEditingController = TextEditingController();
    _deliveryNumberEditingController = TextEditingController();
    _companyDistributionEditingController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController2 = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _orderNumberEditingController.dispose();
    _deliveryNumberEditingController.dispose();
    _companyDistributionEditingController.dispose();
    _scrollController.dispose();
    _scrollController2.dispose();
    super.dispose();
  }

  Widget _buildPanel(BuildContext context) {
    final p = context.read<SalseSalseActivitySearchPageProvider>();
    p.initPageData();
    return ValueListenableBuilder<bool>(
        valueListenable: _panelSwich,
        builder: (context, swichValue, _) {
          return ExpansionPanelList(
            expandedHeaderPadding: EdgeInsets.zero,
            expansionCallback: (index, value) {
              hideKeyboard(context);
              _panelSwich.value = !_panelSwich.value;
            },
            children: [
              ExpansionPanel(
                  isExpanded: swichValue,
                  canTapOnHeader: true,
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      title: AppText.text('${tr('search_condition')}',
                          style: AppTextStyle.blod_16,
                          textAlign: TextAlign.start),
                    );
                  },
                  body: Padding(
                      padding: AppSize.defaultSidePadding,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Builder(builder: (context) {
                              return BaseColumWithTitleAndTextFiled.build(
                                '${tr('salse_activity_cycle')}',
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Selector<
                                            SalseSalseActivitySearchPageProvider,
                                            String?>(
                                        selector: (context, provider) =>
                                            provider.selectedStartDate,
                                        builder: (context, startDate, _) {
                                          return BaseInputWidget(
                                              context: context,
                                              dateStr: startDate != null
                                                  ? FormatUtil.removeDash(
                                                      startDate)
                                                  : null,
                                              oneCellType:
                                                  OneCellType.DATE_PICKER,
                                              hintTextStyleCallBack: () =>
                                                  startDate != null
                                                      ? AppTextStyle.default_16
                                                      : AppTextStyle.hint_16,
                                              hintText: startDate != null
                                                  ? startDate
                                                  : '${tr('plz_enter_date')}',
                                              iconType:
                                                  InputIconType.DATA_PICKER,
                                              isSelectedStrCallBack: (str) =>
                                                  p.setStartDate(context, str),
                                              width: AppSize.timeBoxWidth,
                                              enable: false);
                                        }),
                                    Center(
                                        child: AppText.text('~',
                                            style: AppTextStyle.default_16)),
                                    Selector<
                                            SalseSalseActivitySearchPageProvider,
                                            String?>(
                                        selector: (context, provider) =>
                                            provider.selectedEndDate,
                                        builder: (context, endDate, _) {
                                          return BaseInputWidget(
                                              context: context,
                                              dateStr: endDate != null
                                                  ? FormatUtil.removeDash(
                                                      endDate)
                                                  : null,
                                              oneCellType:
                                                  OneCellType.DATE_PICKER,
                                              hintTextStyleCallBack: () =>
                                                  endDate != null
                                                      ? AppTextStyle.default_16
                                                      : AppTextStyle.hint_16,
                                              hintText: endDate != null
                                                  ? endDate
                                                  : '${tr('plz_enter_date')}',
                                              iconType:
                                                  InputIconType.DATA_PICKER,
                                              isSelectedStrCallBack: (str) =>
                                                  p.setEndDate(context, str),
                                              width: AppSize.timeBoxWidth,
                                              enable: false);
                                        }),
                                  ],
                                ),
                              );
                            }),
                            Selector<SalseSalseActivitySearchPageProvider,
                                Tuple2<bool, String?>>(
                              selector: (context, provider) => Tuple2(
                                  provider.isTeamLeader, provider.staffName),
                              builder: (context, tuple, _) {
                                return BaseColumWithTitleAndTextFiled.build(
                                    '${tr('salse_person')}',
                                    BaseInputWidget(
                                      context: context,
                                      iconType: tuple.item1
                                          ? InputIconType.SEARCH
                                          : null,
                                      iconColor: tuple.item2 != null
                                          ? AppColors.defaultText
                                          : AppColors.textFieldUnfoucsColor,
                                      hintText: tuple.item2 ?? tr('plz_select'),
                                      // 팀장 일때 만 팀원선택후 삭제가능.
                                      isShowDeleteForHintText:
                                          tuple.item1 && tuple.item2 != null
                                              ? true
                                              : false,
                                      deleteIconCallback: () =>
                                          p.setStaffName(null),
                                      width: AppSize.defaultContentsWidth,
                                      hintTextStyleCallBack: () =>
                                          tuple.item1 && tuple.item2 != null
                                              ? AppTextStyle.default_16
                                              : AppTextStyle.hint_16,
                                      popupSearchType: tuple.item1
                                          ? PopupSearchType.SEARCH_SALSE_PERSON
                                          : null,
                                      isSelectedStrCallBack: (persion) {
                                        return p.setSalesPerson(persion);
                                      },
                                      enable: false,
                                    ));
                              },
                            ),
                            Selector<SalseSalseActivitySearchPageProvider,
                                String?>(
                              selector: (context, provider) =>
                                  provider.customerName,
                              builder: (context, customerName, _) {
                                return BaseColumWithTitleAndTextFiled.build(
                                    '${tr('customer_name')}',
                                    BaseInputWidget(
                                      context: context,
                                      iconType: InputIconType.SEARCH,
                                      iconColor: customerName != null
                                          ? AppColors.defaultText
                                          : AppColors.textFieldUnfoucsColor,
                                      deleteIconCallback: () =>
                                          p.setCustomerName(null),
                                      hintText:
                                          customerName ?? tr('plz_select'),
                                      // 팀장 일때 만 팀원선택후 삭제가능.
                                      isShowDeleteForHintText:
                                          customerName != null ? true : false,
                                      width: AppSize.defaultContentsWidth,
                                      hintTextStyleCallBack: () =>
                                          customerName != null
                                              ? AppTextStyle.default_16
                                              : AppTextStyle.hint_16,
                                      popupSearchType:
                                          PopupSearchType.SEARCH_CUSTOMER,
                                      isSelectedStrCallBack: (customer) {
                                        return p.setCustomerModel(customer);
                                      },
                                      enable: false,
                                    ),
                                    isNotShowStar: true);
                              },
                            ),
                            AppStyles.buildSearchButton(
                                context, '${tr('search')}', () {
                              if (p.isValidate) {
                                _panelSwich.value = false;
                                p.refresh();
                              } else {
                                AppToast().show(context,
                                    '${tr('essential_option')}${tr('selecte_first')}');
                              }
                            })
                          ])))
            ],
          );
        });
  }

  Widget _buildListViewItem(
      BuildContext context, TlistModel model, bool isShowLastPage) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, SalseActivityDetailPage.routeName,
            arguments: model);
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
                AppText.listViewText(
                    FormatUtil.addDashForDateStr2(model.adate ?? ''),
                    isSubTitle: true),
                BaseTagButton.build(model.xvisit != null && model.xvisit == 'Y'
                    ? '${tr('visited')}'
                    : '${tr('not_visited')}')
              ],
            ),
            defaultSpacing(),
            AppText.listViewText(model.zskunnrNm!),
            defaultSpacing(height: AppSize.defaultListItemSpacing / 2),
            Row(
              children: [
                AppText.listViewText('${tr('salse_person')}:',
                    isSubTitle: true),
                AppText.listViewText(model.sanumNm!, isSubTitle: true),
                AppStyles.buildPipe(),
                FutureBuilder<List<String>?>(
                    future: HiveService.getCustomerType(model.zstatus!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        return AppText.listViewText(snapshot.data!.single,
                            isSubTitle: true);
                      }
                      return Container(
                        width: AppSize.padding * 4,
                        height: AppSize.padding * 4,
                      );
                    }),
                AppStyles.buildPipe(),
                AppText.listViewText(model.zkmnoNm!, isSubTitle: true),
              ],
            ),
            defaultSpacing(),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotal(BuildContext context) {
    return Consumer<SalseSalseActivitySearchPageProvider>(
        builder: (context, provider, _) {
      return provider.searchResponseModel != null &&
              provider.searchResponseModel!.tList!.isNotEmpty
          ? Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(
                  vertical: AppSize.defaultListItemSpacing / 2,
                  horizontal: AppSize.padding),
              child: Row(
                children: [
                  AppText.text('총', style: AppTextStyle.sub_14),
                  AppText.text(
                      '${provider.searchResponseModel!.tList!.length}'),
                  AppText.text('건', style: AppTextStyle.sub_14)
                ],
              ))
          : Container();
    });
  }

  Widget _buildListView(SalseSalseActivitySearchPageProvider provider) {
    return Column(
      children: [
        _buildTotal(context),
        provider.searchResponseModel != null &&
                provider.searchResponseModel!.tList != null &&
                provider.searchResponseModel!.tList!.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: provider.searchResponseModel!.tList!.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildListViewItem(
                      context,
                      provider.searchResponseModel!.tList![index],
                      !provider.hasMore &&
                          index ==
                              provider.searchResponseModel!.tList!.length - 1);
                },
              )
            : provider.isLoadData
                ? DefaultShimmer.buildDefaultResultShimmer()
                : ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                          padding: AppSize.nullValueWidgetPadding,
                          child: BaseNullDataWidget.build())
                    ],
                  )
      ],
    );
  }

  Widget _buildScrollToTop(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _scrollSwich,
        builder: (context, isCanScroll, _) {
          return isCanScroll
              ? Positioned(
                  right: AppSize.padding,
                  bottom: AppSize.padding,
                  child: FloatingActionButton(
                    backgroundColor: AppColors.whiteText,
                    foregroundColor: AppColors.primary,
                    onPressed: () {
                      _scrollController2.animateTo(0,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeIn);
                    },
                    child: AppImage.getImage(ImageType.SCROLL_TO_TOP),
                  ))
              : Container();
        });
  }

  Widget _buildResult(BuildContext context) {
    return Consumer<SalseSalseActivitySearchPageProvider>(
        builder: (context, provider, _) {
      return provider.isFirstIn ? Container() : _buildListView(provider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: true,
        appBar: MainAppBar(context,
            titleText: AppText.text('${tr('salse_activity_search')}',
                style: AppTextStyle.w500_20)),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => SalseSalseActivitySearchPageProvider()),
            ChangeNotifierProvider(
                create: (context) => NextPageLoadingProvider()),
          ],
          builder: (context, _) {
            final p = context.read<SalseSalseActivitySearchPageProvider>();
            return Stack(
              fit: StackFit.expand,
              children: [
                RefreshIndicator(
                    child: ListView(
                      controller: _scrollController2
                        ..addListener(() {
                          if (_scrollController2.offset > AppSize.realHeight) {
                            if (downLock == true) {
                              pr('downLock');
                              downLock = false;
                              upLock = true;
                              _scrollSwich.value = true;
                            }
                          } else {
                            pr('upLock');
                            if (upLock == true) {
                              upLock = false;
                              downLock = true;
                              _scrollSwich.value = false;
                            }
                          }
                          if (_scrollController2.offset ==
                                  _scrollController2.position.maxScrollExtent &&
                              !p.isLoadData &&
                              p.hasMore) {
                            final nextPageProvider =
                                context.read<NextPageLoadingProvider>();
                            nextPageProvider.show();
                            p.nextPage().then((_) => nextPageProvider.stop());
                          }
                        }),
                      children: [
                        CustomerinfoWidget.buildDividingLine(),
                        _buildPanel(context),
                        CustomerinfoWidget.buildDividingLine(),
                        _buildResult(context),
                        Padding(
                            padding: EdgeInsets.only(
                                bottom: AppSize.appBarHeight / 2),
                            child: NextPageLoadingWdiget.build(context))
                      ],
                    ),
                    onRefresh: () {
                      _panelSwich.value = false;
                      return p.refresh();
                    }),
                _buildScrollToTop(context)
              ],
            );
          },
        ));
  }
}
