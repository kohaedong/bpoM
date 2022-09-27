/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/bulkOrderSearch/bulk_order_search_page.dart
 * Created Date: 2022-07-05 09:53:16
 * Last Modified: 2022-09-27 10:20:50
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/enums/account_type.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_null_data.dart';
import 'package:medsalesportal/view/common/widget_of_tag_button.dart';
import 'package:medsalesportal/model/rfc/bulk_order_et_t_list_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_next_page_loading.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';
import 'package:medsalesportal/globalProvider/next_page_loading_provider.dart';
import 'package:medsalesportal/view/bulkOrderSearch/bulk_order_detail_page.dart';
import 'package:medsalesportal/view/common/base_column_with_title_and_textfiled.dart';
import 'package:medsalesportal/view/bulkOrderSearch/provider/bulk_order_search_page_provider.dart';

class BulkOrderSearchPage extends StatefulWidget {
  const BulkOrderSearchPage({Key? key}) : super(key: key);
  static const String routeName = '/bulkOrderSearchPage';
  @override
  State<BulkOrderSearchPage> createState() => _BulkOrderSearchPageState();
}

class _BulkOrderSearchPageState extends State<BulkOrderSearchPage> {
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
    final p = context.read<BulkOrderSearchPageProvider>();
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
                                    Selector<BulkOrderSearchPageProvider,
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
                                    Selector<BulkOrderSearchPageProvider,
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
                            Selector<BulkOrderSearchPageProvider, String?>(
                              selector: (context, provider) =>
                                  provider.staffName,
                              builder: (context, staffName, _) {
                                var isSuperAccount =
                                    CacheService.getAccountType() ==
                                            AccountType.MULTI ||
                                        CacheService.getAccountType() ==
                                            AccountType.LEADER;
                                return BaseColumWithTitleAndTextFiled.build(
                                    '${tr('manager')}',
                                    BaseInputWidget(
                                      context: context,
                                      iconType: isSuperAccount
                                          ? staffName != null
                                              ? InputIconType.SEARCH
                                              : null
                                          : null,
                                      iconColor:
                                          AppColors.textFieldUnfoucsColor,
                                      hintText: staffName ??
                                          '${tr('plz_select_something_1', args: [
                                                tr('manager'),
                                                ''
                                              ])}',
                                      // 팀장 일때 만 팀원선택후 삭제가능.
                                      isShowDeleteForHintText: isSuperAccount &&
                                              staffName != null &&
                                              staffName != tr('all')
                                          ? true
                                          : false,
                                      deleteIconCallback: () => isSuperAccount
                                          ? p.setStaffName(tr('all'))
                                          : p.setStaffName(null),
                                      width: AppSize.defaultContentsWidth,
                                      hintTextStyleCallBack: () =>
                                          staffName != null
                                              ? AppTextStyle.default_16
                                              : AppTextStyle.hint_16,
                                      popupSearchType: isSuperAccount
                                          ? PopupSearchType.SEARCH_SALSE_PERSON
                                          : null,
                                      isSelectedStrCallBack: (persion) {
                                        return p.setSalesPerson(persion);
                                      },
                                      enable: false,
                                    ));
                              },
                            ),
                            Selector<BulkOrderSearchPageProvider, String?>(
                              selector: (context, provider) =>
                                  provider.selectedOrderStatus,
                              builder: (context, status, _) {
                                return BaseColumWithTitleAndTextFiled.build(
                                    '${tr('product_process_status')}',
                                    BaseInputWidget(
                                      context: context,
                                      iconType: InputIconType.SELECT,
                                      iconColor:
                                          AppColors.textFieldUnfoucsColor,
                                      hintText: status ??
                                          '${tr('plz_select_something_2', args: [
                                                tr('product_process_status'),
                                                ''
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
                                          p.getOrderStatus,
                                      isSelectedStrCallBack: (status) {
                                        return p.setOrderStatus(status);
                                      },
                                      enable: false,
                                    ),
                                    isNotShowStar: true);
                              },
                            ),
                            Selector<BulkOrderSearchPageProvider, String?>(
                              selector: (context, provider) =>
                                  provider.selectedProductsFamily,
                              builder: (context, family, _) {
                                return BaseColumWithTitleAndTextFiled.build(
                                    '${tr('product_family')}',
                                    BaseInputWidget(
                                      context: context,
                                      iconType: InputIconType.SELECT,
                                      iconColor:
                                          AppColors.textFieldUnfoucsColor,
                                      hintText: family ??
                                          '${tr('plz_select_something_1', args: [
                                                tr('product_family'),
                                                ''
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
                            Selector<BulkOrderSearchPageProvider, String?>(
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
                                                        tr('product_family'),
                                                        ''
                                                      ]));
                                              return 'continue';
                                            }
                                          : null,
                                      iconType: InputIconType.SEARCH,
                                      iconColor:
                                          AppColors.textFieldUnfoucsColor,
                                      deleteIconCallback: () =>
                                          p.setCustomerName(null),
                                      hintText: customerName ??
                                          '${tr('plz_select_something_2', args: [
                                                tr('sales_office'),
                                                ''
                                              ])}',
                                      // 팀장 일때 만 팀원선택후 삭제가능.
                                      isShowDeleteForHintText:
                                          customerName != null ? true : false,
                                      width: AppSize.defaultContentsWidth,
                                      hintTextStyleCallBack: () =>
                                          customerName != null
                                              ? AppTextStyle.default_16
                                              : AppTextStyle.hint_16,
                                      popupSearchType: PopupSearchType
                                          .SEARCH_SALLER_FOR_BULK_ORDER,
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
                                p.refresh().then((result) {
                                  hideKeyboard(context);
                                  if (result.isSuccessful) {
                                    Future.delayed(Duration.zero, () {
                                      if (!result.data) {
                                        _panelSwich.value = true;
                                      }
                                    });
                                  }
                                });
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
      BuildContext context, BulkOrderEtTListModel model, bool isShowLastPage) {
    final p = context.read<BulkOrderSearchPageProvider>();
    var temp = p.orderStatusListWithCode
        ?.where((item) {
          return item.contains(model.zdmstatus!);
        })
        .toList()
        .first;
    var status = p.orderStatusListWithCode != null
        ? temp!.substring(0, temp.indexOf('-'))
        : '';

    return InkWell(
      onTap: () async {
        final result = await Navigator.pushNamed(
            context, BulkOrderDetailPage.routeName,
            arguments: model);
        if (result != null) {
          p.refresh();
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
                AppText.listViewText(
                    FormatUtil.addDashForDateStr2(model.zreqDate ?? ''),
                    isSubTitle: true),
                BaseTagButton.build(status)
              ],
            ),
            defaultSpacing(),
            AppText.listViewText('${model.kunnrNm}${model.kunnr}',
                textAlign: TextAlign.start),
            // model.kunnrNm != model.zzkunnrEndNm!
            //     ? Row(
            //         children: [
            //           AppText.listViewText(model.zzkunnrEndNm!,
            //               textAlign: TextAlign.start),
            //           AppText.listViewText('(${model.zzkunnrEnd!})',
            //               textAlign: TextAlign.start),
            //         ],
            //       )
            //     : Container(),
            AppText.listViewText('${model.zzkunnrEndNm!} ${model.zzkunnrEnd!}',
                textAlign: TextAlign.start),

            defaultSpacing(isHalf: true),
            Row(
              children: [
                SizedBox(
                  child: AppText.text(
                      '${tr('salse_order_number')}:${model.zreqno!}'),
                ),
                model.zdmstatus == 'A' ? Container() : AppStyles.buildPipe(),
                AppText.text(
                  // 주문요청상태시 주문번호 없음.
                  model.zdmstatus == 'A'
                      ? ''
                      : '${tr('request_order_number')}:${model.vbeln!}',
                ),
              ],
            ),
            defaultSpacing(),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(BulkOrderSearchPageProvider provider) {
    return Column(
      children: [
        provider.bulkOrderResponseModel != null &&
                provider.bulkOrderResponseModel!.tList != null &&
                provider.bulkOrderResponseModel!.tList!.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: provider.bulkOrderResponseModel!.tList!.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildListViewItem(
                      context,
                      provider.bulkOrderResponseModel!.tList![index],
                      !provider.hasMore &&
                          index ==
                              provider.bulkOrderResponseModel!.tList!.length -
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
                          child: BaseNullDataWidget.build(
                              message:
                                  provider.hasResultData == null ? '' : null))
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
    return Consumer<BulkOrderSearchPageProvider>(
        builder: (context, provider, _) {
      return _buildListView(provider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: true,
        appBar: MainAppBar(context,
            titleText: AppText.text('${tr('buld_order_search')}',
                style: AppTextStyle.w500_22)),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => BulkOrderSearchPageProvider()),
            ChangeNotifierProvider(
                create: (context) => NextPageLoadingProvider()),
          ],
          builder: (context, _) {
            final p = context.read<BulkOrderSearchPageProvider>();
            if (p.isFirstRun) {
              _panelSwich.value = false;
              p.initPageData().then((result) {
                hideKeyboard(context);
                if (result.isSuccessful) {
                  Future.delayed(Duration.zero, () {
                    if (!result.data) {
                      _panelSwich.value = true;
                    }
                  });
                }
              });
            }
            return Stack(
              fit: StackFit.expand,
              children: [
                RefreshIndicator(
                    child: ListView(
                      controller: _scrollController2
                        ..addListener(() {
                          if (_scrollController2.offset >
                              AppSize.appBarHeight) {
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
                      return p.refresh().then((result) {
                        hideKeyboard(context);
                        if (result.isSuccessful) {
                          Future.delayed(Duration.zero, () {
                            if (!result.data) {
                              _panelSwich.value = true;
                            }
                          });
                        }
                      });
                    }),
                _buildScrollToTop(context)
              ],
            );
          },
        ));
  }
}
