/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderSearch/order_search_page.dart
 * Created Date: 2022-07-05 09:58:56
 * Last Modified: 2022-07-12 15:21:56
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/model/rfc/t_list_search_order_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_null_data.dart';
import 'package:medsalesportal/view/orderSearch/order_detail_page.dart';
import 'package:medsalesportal/view/salesActivitySearch/salse_activity_detail_page.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_tag_button.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_next_page_loading.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';
import 'package:medsalesportal/globalProvider/next_page_loading_provider.dart';
import 'package:medsalesportal/view/common/base_column_with_title_and_textfiled.dart';
import 'package:medsalesportal/view/orderSearch/provider/order_search_page_provider.dart';

class OrderSearchPage extends StatefulWidget {
  const OrderSearchPage({Key? key}) : super(key: key);
  static const String routeName = '/orderSearchPage';
  @override
  State<OrderSearchPage> createState() => _OrderSearchPageState();
}

class _OrderSearchPageState extends State<OrderSearchPage> {
  late ScrollController _scrollController;
  late ScrollController _scrollController2;
  bool upLock = true;
  bool downLock = true;
  DateTime selectedDate = DateTime.now();
  var _scrollSwich = ValueNotifier<bool>(false);
  var _panelSwich = ValueNotifier<bool>(true);
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController2 = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollSwich.dispose();
    _panelSwich.dispose();
    _scrollController.dispose();
    _scrollController2.dispose();
    super.dispose();
  }

  Widget _buildPanel(BuildContext context) {
    final p = context.read<OrderSearchPageProvider>();
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
                                '${tr('date', args: [''])}',
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Selector<OrderSearchPageProvider, String?>(
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
                                    Selector<OrderSearchPageProvider, String?>(
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
                            Selector<OrderSearchPageProvider,
                                Tuple2<bool, String?>>(
                              selector: (context, provider) => Tuple2(
                                  provider.isTeamLeader, provider.staffName),
                              builder: (context, tuple, _) {
                                return BaseColumWithTitleAndTextFiled.build(
                                    '${tr('manager')}',
                                    BaseInputWidget(
                                      context: context,
                                      iconType: tuple.item1
                                          ? InputIconType.SEARCH
                                          : null,
                                      iconColor: tuple.item2 != null
                                          ? AppColors.defaultText
                                          : AppColors.textFieldUnfoucsColor,
                                      hintText: tuple.item2 ??
                                          '${tr('plz_select_something', args: [
                                                tr('manager')
                                              ])}',
                                      // 팀장 일때 만 팀원선택후 삭제가능.
                                      isShowDeleteForHintText: tuple.item1 &&
                                              tuple.item2 != null &&
                                              tuple.item2 != tr('all')
                                          ? true
                                          : false,
                                      deleteIconCallback: () => tuple.item1
                                          ? p.setStaffName(tr('all'))
                                          : p.setStaffName(null),
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
                            Selector<OrderSearchPageProvider, String?>(
                              selector: (context, provider) =>
                                  provider.selectedProcessingStatus,
                              builder: (context, status, _) {
                                return BaseColumWithTitleAndTextFiled.build(
                                    '${tr('product_process_status')}',
                                    BaseInputWidget(
                                      context: context,
                                      iconType: InputIconType.SELECT,
                                      iconColor: status != null
                                          ? AppColors.defaultText
                                          : AppColors.textFieldUnfoucsColor,
                                      hintText: status ??
                                          '${tr('plz_select_something', args: [
                                                tr('product_process_status')
                                              ])}',
                                      // 팀장 일때 만 팀원선택후 삭제가능.
                                      width: AppSize.defaultContentsWidth,
                                      hintTextStyleCallBack: () =>
                                          status != null
                                              ? AppTextStyle.default_16
                                              : AppTextStyle.hint_16,
                                      oneCellType:
                                          OneCellType.SEARCH_PROCESS_STATUS,
                                      commononeCellDataCallback:
                                          p.getProcessingStatus,
                                      isSelectedStrCallBack: (status) {
                                        return p.setProcessingStatus(status);
                                      },
                                      enable: false,
                                    ),
                                    isNotShowStar: true);
                              },
                            ),
                            Selector<OrderSearchPageProvider, String?>(
                              selector: (context, provider) =>
                                  provider.selectedProductsFamily,
                              builder: (context, family, _) {
                                return BaseColumWithTitleAndTextFiled.build(
                                    '${tr('product_family')}',
                                    BaseInputWidget(
                                      context: context,
                                      iconType: InputIconType.SELECT,
                                      iconColor: family != null
                                          ? AppColors.defaultText
                                          : AppColors.textFieldUnfoucsColor,
                                      hintText: family ??
                                          '${tr('plz_select_something', args: [
                                                tr('product_family')
                                              ])}',
                                      // 팀장 일때 만 팀원선택후 삭제가능.
                                      isShowDeleteForHintText: false,
                                      width: AppSize.defaultContentsWidth,
                                      hintTextStyleCallBack: () =>
                                          family != null
                                              ? AppTextStyle.default_16
                                              : AppTextStyle.hint_16,
                                      oneCellType:
                                          OneCellType.SEARCH_PRODUCT_FAMILY,
                                      commononeCellDataCallback:
                                          p.getProductsFamily,
                                      isSelectedStrCallBack: (status) {
                                        return p.setProductsFamily(status);
                                      },
                                      enable: false,
                                    ),
                                    isNotShowStar: true);
                              },
                            ),
                            Selector<OrderSearchPageProvider, String?>(
                              selector: (context, provider) =>
                                  provider.customerName,
                              builder: (context, customerName, _) {
                                return BaseColumWithTitleAndTextFiled.build(
                                    '${tr('sales_office')}',
                                    BaseInputWidget(
                                      context: context,
                                      iconType: InputIconType.SEARCH,
                                      iconColor: customerName != null
                                          ? AppColors.defaultText
                                          : AppColors.textFieldUnfoucsColor,
                                      deleteIconCallback: () =>
                                          p.setCustomerName(null),
                                      hintText: customerName ??
                                          '${tr('plz_select_something', args: [
                                                tr('sales_office')
                                              ])}',
                                      // 팀장 일때 만 팀원선택후 삭제가능.
                                      isShowDeleteForHintText:
                                          customerName != null ? true : false,
                                      width: AppSize.defaultContentsWidth,
                                      hintTextStyleCallBack: () =>
                                          customerName != null
                                              ? AppTextStyle.default_16
                                              : AppTextStyle.hint_16,
                                      popupSearchType:
                                          PopupSearchType.SEARCH_SALLER,
                                      isSelectedStrCallBack: (customer) {
                                        return p.setCustomerModel(customer);
                                      },
                                      bodyMap: {
                                        'product_family':
                                            p.selectedProductsFamily,
                                        'staff': p.staffName
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
      BuildContext context, TlistSearchOrderModel model, bool isShowLastPage) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, OrderDetailPage.routeName,
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
                    FormatUtil.addDashForDateStr2(model.zreqDate ?? ''),
                    isSubTitle: true),
                BaseTagButton.build(
                    model.zreqmsg != null && model.zreqmsg == 'Y'
                        ? '${tr('visited')}'
                        : '${tr('not_visited')}')
              ],
            ),
            defaultSpacing(),
            AppText.listViewText(model.kunnrNm!),
            defaultSpacing(height: AppSize.defaultListItemSpacing / 2),
            Row(
              children: [
                AppText.listViewText('${tr('salse_person')}:',
                    isSubTitle: true),
                AppText.listViewText(model.posnr!, isSubTitle: true),
                AppStyles.buildPipe(),
                AppText.listViewText(model.kunnrNm!, isSubTitle: true),
              ],
            ),
            defaultSpacing(),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(OrderSearchPageProvider provider) {
    return Column(
      children: [
        provider.searchOrderResponseModel != null &&
                provider.searchOrderResponseModel!.tList != null &&
                provider.searchOrderResponseModel!.tList!.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: provider.searchOrderResponseModel!.tList!.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildListViewItem(
                      context,
                      provider.searchOrderResponseModel!.tList![index],
                      !provider.hasMore &&
                          index ==
                              provider.searchOrderResponseModel!.tList!.length -
                                  1);
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
    return Consumer<OrderSearchPageProvider>(builder: (context, provider, _) {
      return _buildListView(provider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: true,
        appBar: MainAppBar(context,
            titleText: AppText.text('${tr('salse_order_search')}',
                style: AppTextStyle.w500_20)),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => OrderSearchPageProvider()),
            ChangeNotifierProvider(
                create: (context) => NextPageLoadingProvider()),
          ],
          builder: (context, _) {
            final p = context.watch<OrderSearchPageProvider>();
            if (p.isFirstRun) {
              p.initPageData();
            }
            return Stack(
              fit: StackFit.expand,
              children: [
                RefreshIndicator(
                    child: ListView(
                      controller: _scrollController2
                        ..addListener(() {
                          if (_scrollController2.offset > AppSize.realHeight) {
                            if (downLock == true) {
                              downLock = false;
                              upLock = true;
                              _scrollSwich.value = true;
                            }
                          } else {
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
