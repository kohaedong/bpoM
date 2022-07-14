/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salseReport/salse_search_page.dart
 * Created Date: 2022-07-05 10:00:17
 * Last Modified: 2022-07-14 15:28:40
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:tuple/tuple.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_null_data.dart';
import 'package:medsalesportal/model/rfc/trans_ledger_t_list_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_next_page_loading.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';
import 'package:medsalesportal/globalProvider/next_page_loading_provider.dart';
import 'package:medsalesportal/view/common/base_column_with_title_and_textfiled.dart';
import 'package:medsalesportal/view/transactionLedger/provider/transaction_ledger_page_provider.dart';

class TransactionLedgerPage extends StatefulWidget {
  const TransactionLedgerPage({Key? key}) : super(key: key);
  static const String routeName = '/salseReportPage';
  @override
  State<TransactionLedgerPage> createState() => _TransactionLedgerPageState();
}

class _TransactionLedgerPageState extends State<TransactionLedgerPage> {
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Widget _buildPanel(BuildContext context) {
    final p = context.read<TransactionLedgerPageProvider>();
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
                            BaseColumWithTitleAndTextFiled.build(
                              '${tr('date', args: [''])}',
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Selector<TransactionLedgerPageProvider,
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
                                            iconType: InputIconType.DATA_PICKER,
                                            isSelectedStrCallBack: (str) =>
                                                p.setStartDate(context, str),
                                            width: AppSize.timeBoxWidth,
                                            enable: false);
                                      }),
                                  Center(
                                      child: AppText.text('~',
                                          style: AppTextStyle.default_16)),
                                  Selector<TransactionLedgerPageProvider,
                                          String?>(
                                      selector: (context, provider) =>
                                          provider.selectedEndDate,
                                      builder: (context, endDate, _) {
                                        return BaseInputWidget(
                                            context: context,
                                            dateStr: endDate != null
                                                ? FormatUtil.removeDash(endDate)
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
                                            iconType: InputIconType.DATA_PICKER,
                                            isSelectedStrCallBack: (str) =>
                                                p.setEndDate(context, str),
                                            width: AppSize.timeBoxWidth,
                                            enable: false);
                                      }),
                                ],
                              ),
                            ),
                            Selector<TransactionLedgerPageProvider, String?>(
                                selector: (context, provider) =>
                                    provider.customerName,
                                builder: (context, customerName, _) {
                                  return BaseColumWithTitleAndTextFiled.build(
                                    '${tr('sales_office')}',
                                    BaseInputWidget(
                                      context: context,
                                      onTap: p.selectedProductsFamily == null
                                          ? () {
                                              AppToast().show(
                                                  context,
                                                  tr('plz_select_something_1',
                                                      args: [
                                                        tr('product_family')
                                                      ]));
                                              return 'continue';
                                            }
                                          : null,
                                      iconType: InputIconType.SEARCH,
                                      iconColor: customerName != null
                                          ? AppColors.defaultText
                                          : AppColors.textFieldUnfoucsColor,
                                      deleteIconCallback: () =>
                                          p.setCustomerName(null),
                                      hintText: customerName ??
                                          '${tr('plz_select_something_2', args: [
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
                                  );
                                }),
                            Selector<TransactionLedgerPageProvider, String?>(
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
                                          '${tr('plz_select_something_1', args: [
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
                            Selector<TransactionLedgerPageProvider,
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
                                          '${tr('plz_select_something_1', args: [
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
                                    ),
                                    isNotShowStar: true);
                              },
                            ),
                            Selector<TransactionLedgerPageProvider, String?>(
                                selector: (context, provider) =>
                                    provider.endCustomerName,
                                builder: (context, endCustomerName, _) {
                                  return BaseColumWithTitleAndTextFiled.build(
                                      '${tr('end_customer')}',
                                      BaseInputWidget(
                                        context: context,
                                        onTap: p.selectedCustomerModel == null
                                            ? () {
                                                AppToast().show(
                                                    context,
                                                    tr('plz_select_something_2',
                                                        args: [
                                                          tr('sales_office')
                                                        ]));
                                                return 'continue';
                                              }
                                            : null,
                                        iconType: InputIconType.SEARCH,
                                        iconColor: endCustomerName != null
                                            ? AppColors.defaultText
                                            : AppColors.textFieldUnfoucsColor,
                                        deleteIconCallback: () =>
                                            p.setEndCustomerName(null),
                                        hintText: endCustomerName ??
                                            '${tr('plz_select_something_1', args: [
                                                  tr('end_customer')
                                                ])}',
                                        // 팀장 일때 만 팀원선택후 삭제가능.
                                        isShowDeleteForHintText:
                                            endCustomerName != null
                                                ? true
                                                : false,
                                        width: AppSize.defaultContentsWidth,
                                        hintTextStyleCallBack: () =>
                                            endCustomerName != null
                                                ? AppTextStyle.default_16
                                                : AppTextStyle.hint_16,
                                        popupSearchType:
                                            PopupSearchType.SEARCH_END_CUSTOMER,
                                        isSelectedStrCallBack: (customer) {
                                          return p.setEndCustomerName(customer);
                                        },
                                        // bodyMap: {
                                        //   'product_family':
                                        //       p.selectedProductsFamily,
                                        //   'staff': p.staffName
                                        // },
                                        enable: false,
                                      ),
                                      isNotShowStar: true);
                                }),
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
      BuildContext context, TransLedgerTListModel model, bool isShowLastPage) {
    return InkWell(
      onTap: () async {
        //
      },
      child: Padding(
        padding: AppSize.defaultSidePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            defaultSpacing(),
            defaultSpacing(),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(TransactionLedgerPageProvider provider) {
    return Column(
      children: [
        provider.transLedgerResponseModel != null &&
                provider.transLedgerResponseModel!.tList != null &&
                provider.transLedgerResponseModel!.tList!.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: provider.transLedgerResponseModel!.tList!.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildListViewItem(
                      context,
                      provider.transLedgerResponseModel!.tList![index],
                      !provider.hasMore &&
                          index ==
                              provider.transLedgerResponseModel!.tList!.length -
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
    return Consumer<TransactionLedgerPageProvider>(
        builder: (context, provider, _) {
      return _buildListView(provider);
    });
  }

  Widget _buildPortraitView(BuildContext context) {
    final p = context.watch<TransactionLedgerPageProvider>();
    if (p.isFirstRun) {
      p.initPageData();
    }
    return BaseLayout(
        hasForm: true,
        appBar: MainAppBar(context,
            titleText: AppText.text('${tr('transaction_ledger')}',
                style: AppTextStyle.w500_22)),
        child: Stack(
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
                        padding:
                            EdgeInsets.only(bottom: AppSize.appBarHeight / 2),
                        child: NextPageLoadingWdiget.build(context))
                  ],
                ),
                onRefresh: () {
                  _panelSwich.value = false;
                  return p.refresh();
                }),
            _buildScrollToTop(context)
          ],
        ));
  }

  Widget _buildLandSpaceView(BuildContext context) {
    return BaseLayout(
        hasForm: false,
        appBar: null,
        child: Center(child: AppText.text('가로모드')));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => TransactionLedgerPageProvider()),
        ChangeNotifierProvider(create: (context) => NextPageLoadingProvider()),
      ],
      child: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _buildPortraitView(context);
        } else {
          return _buildLandSpaceView(context);
        }
      }),
    );
  }
}
