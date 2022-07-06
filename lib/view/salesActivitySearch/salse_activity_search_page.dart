/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/activitySearch/activity_search_page.dart
 * Created Date: 2022-07-05 09:51:03
 * Last Modified: 2022-07-06 13:02:54
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/view/common/base_column_with_title_and_textfiled.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';
import 'package:medsalesportal/view/common/provider/next_page_loading_provider.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_next_page_loading.dart';
import 'package:medsalesportal/view/common/widget_of_null_data.dart';
import 'package:medsalesportal/view/salesActivitySearch/provider/salse_activity_search_page_provider.dart';
import 'package:provider/provider.dart';

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
  DateTime selectedDate = DateTime.now();
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

  Widget buildPanel(BuildContext context) {
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
                                        selector: (context, provider) => provider
                                            .selectedRequestedShippingStartDate,
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
                                                  '',
                                              width: AppSize.timeBoxWidth,
                                              enable: false);
                                        }),
                                    Center(
                                        child: AppText.text('~',
                                            style: AppTextStyle.default_16)),
                                    Selector<
                                            SalseSalseActivitySearchPageProvider,
                                            String?>(
                                        selector: (context, provider) => provider
                                            .selectedRequestedShippingEndDate,
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
                                                  'null',
                                              width: AppSize.timeBoxWidth,
                                              enable: false);
                                        }),
                                  ],
                                ),
                              );
                            }),
                            Selector<SalseSalseActivitySearchPageProvider,
                                String?>(
                              selector: (context, provider) =>
                                  provider.selectedCompanyDistribution,
                              builder: (context, compnay, _) {
                                return Builder(builder: (context) {
                                  return BaseColumWithTitleAndTextFiled.build(
                                      '${tr('company_distribution')}',
                                      BaseInputWidget(
                                        context: context,
                                        textEditingController:
                                            _companyDistributionEditingController,
                                        hintText: compnay ?? '',
                                        hintTextStyleCallBack: () =>
                                            AppTextStyle.hint_16,
                                        iconType: null,
                                        width: AppSize.defaultContentsWidth,
                                        enable: false,
                                      ));
                                });
                              },
                            ),
                            Selector<SalseSalseActivitySearchPageProvider,
                                String?>(
                              selector: (context, prvider) =>
                                  prvider.selectedSalesOrg,
                              builder: (context, org, _) {
                                return Builder(builder: (context) {
                                  return BaseColumWithTitleAndTextFiled.build(
                                      '${tr('sales_org')}',
                                      BaseInputWidget(
                                        context: context,
                                        iconType: InputIconType.SEARCH,
                                        hintText: org ?? '${tr('plz_select')}',
                                        width: AppSize.defaultContentsWidth,
                                        hintTextStyleCallBack: org != null
                                            ? () => AppTextStyle.default_16
                                            : () => AppTextStyle.hint_16,
                                        commononeCellDataCallback: () async {
                                          return null;
                                        },
                                        oneCellType: OneCellType.SEARCH_ORG,
                                        isSelectedStrCallBack: (str) => 'true',
                                        enable: false,
                                      ));
                                });
                              },
                            ),
                            Selector<SalseSalseActivitySearchPageProvider,
                                String?>(
                              selector: (context, prvider) =>
                                  prvider.selectedBusinessGroup,
                              builder: (context, group, _) {
                                return Builder(builder: (context) {
                                  return BaseColumWithTitleAndTextFiled.build(
                                      '${tr('business_group')}',
                                      BaseInputWidget(
                                        context: context,
                                        iconType: InputIconType.SEARCH,
                                        hintText:
                                            group ?? '${tr('plz_select')}',
                                        width: AppSize.defaultContentsWidth,
                                        hintTextStyleCallBack: group != null
                                            ? () => AppTextStyle.default_16
                                            : () => AppTextStyle.hint_16,
                                        commononeCellDataCallback: () =>
                                            Future.delayed(
                                                Duration.zero, () => []),
                                        oneCellType:
                                            OneCellType.SEARCH_BUSINESS_GROUP,
                                        isSelectedStrCallBack: (str) => 'null',
                                        enable: false,
                                      ));
                                });
                              },
                            ),
                            Selector<SalseSalseActivitySearchPageProvider,
                                String?>(
                              selector: (context, provider) =>
                                  provider.selectedOrderNumber,
                              builder: (context, orderNumber, _) {
                                return Builder(builder: (context) {
                                  return BaseColumWithTitleAndTextFiled.build(
                                      '${tr('order_number')}',
                                      BaseInputWidget(
                                        context: context,
                                        hintText: orderNumber != null
                                            ? null
                                            : '${tr('plz_enter')}',
                                        hintTextStyleCallBack: () =>
                                            AppTextStyle.hint_16,
                                        textEditingController:
                                            _orderNumberEditingController,
                                        onChangeCallBack: (str) => null,
                                        iconType: orderNumber != null
                                            ? InputIconType.DELETE
                                            : null,
                                        defaultIconCallback: () {
                                          _orderNumberEditingController.text =
                                              '';
                                          // p.setOrderNumber(null);
                                        },
                                        width: AppSize.defaultContentsWidth,
                                        enable: true,
                                      ),
                                      isNotShowStar: true,
                                      isTextSize14: true);
                                });
                              },
                            ),
                            Selector<SalseSalseActivitySearchPageProvider,
                                String?>(
                              selector: (context, provider) =>
                                  provider.selectedDeliveryNumber,
                              builder: (context, deliveryNumber, _) {
                                return Builder(builder: (context) {
                                  return BaseColumWithTitleAndTextFiled.build(
                                      '${tr('delivery_number')}',
                                      BaseInputWidget(
                                        context: context,
                                        hintText: deliveryNumber != null
                                            ? null
                                            : '${tr('plz_enter')}',
                                        hintTextStyleCallBack:
                                            deliveryNumber != null
                                                ? null
                                                : () => AppTextStyle.hint_16,
                                        textEditingController:
                                            _deliveryNumberEditingController,
                                        onChangeCallBack: (str) =>
                                            // p.setDeliveryNumber(str),
                                            null,
                                        iconType: deliveryNumber != null
                                            ? InputIconType.DELETE
                                            : null,
                                        defaultIconCallback: () {
                                          _deliveryNumberEditingController
                                              .text = '';
                                          // p.setDeliveryNumber(null);
                                        },
                                        width: AppSize.defaultContentsWidth,
                                        enable: true,
                                      ),
                                      isNotShowStar: true,
                                      isTextSize14: true);
                                });
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

  Widget _buildListViewItem() {
    return Container();
  }

  Widget buildResult(BuildContext context) {
    return Consumer<SalseSalseActivitySearchPageProvider>(
        builder: (context, provider, _) {
      return provider.isFirstIn
          ? Container()
          : 1 + 1 == 2
              ? ListView.builder(
                  // physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  controller: _scrollController,
                  // itemCount: provider.model!.modelList!.length,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildListViewItem();
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
                    );
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
            return RefreshIndicator(
                child: ListView(
                  controller: _scrollController2
                    ..addListener(() {
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
                    buildPanel(context),
                    CustomerinfoWidget.buildDividingLine(),
                    buildResult(context),
                    Padding(
                        padding:
                            EdgeInsets.only(bottom: AppSize.appBarHeight / 2),
                        child: NextPageLoadingWdiget.build(context))
                  ],
                ),
                onRefresh: () {
                  _panelSwich.value = false;
                  return p.refresh();
                });
          },
        ));
  }
}
