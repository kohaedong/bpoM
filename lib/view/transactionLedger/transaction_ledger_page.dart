/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salseReport/salse_search_page.dart
 * Created Date: 2022-07-05 10:00:17
 * Last Modified: 2022-09-26 19:57:19
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'dart:io';
import 'dart:math' as math;
import 'package:medsalesportal/model/rfc/et_cust_list_model.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/util/is_super_account.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/enums/offset_direction_type.dart';
import 'package:medsalesportal/model/rfc/et_customer_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/view/common/widget_of_null_data.dart';
import 'package:medsalesportal/model/rfc/trans_ledger_t_list_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/model/rfc/trans_ledger_response_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_next_page_loading.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';
import 'package:medsalesportal/globalProvider/next_page_loading_provider.dart';
import 'package:medsalesportal/view/common/base_column_with_title_and_textfiled.dart';
import 'package:medsalesportal/view/common/widget_of_offset_animation_components.dart';
import 'package:medsalesportal/view/common/widget_of_rotation_animation_components.dart';
import 'package:medsalesportal/view/transactionLedger/drawer_button_animation_widget.dart';
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
  late Key key;
  bool upLock = true;
  bool downLock = true;
  DateTime selectedDate = DateTime.now();
  var _scrollSwich = ValueNotifier<bool>(false);
  var _panelSwich = ValueNotifier<bool>(true);
  var _bottomPanelSwich = ValueNotifier<bool>(true);
  @override
  void initState() {
    key = Key('last');
    _scrollController = ScrollController();
    _scrollController2 = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _scrollSwich.dispose();
    _panelSwich.dispose();
    _bottomPanelSwich.dispose();
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
                                                ? FormatUtil.monthStr(startDate,
                                                    isWithDash: true)
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
                                                ? FormatUtil.monthStr(endDate,
                                                    isWithDash: true)
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
                            Selector<TransactionLedgerPageProvider, String?>(
                              selector: (context, provider) =>
                                  provider.staffName,
                              builder: (context, staffName, _) {
                                return BaseColumWithTitleAndTextFiled.build(
                                    '${tr('manager')}',
                                    BaseInputWidget(
                                      context: context,
                                      iconType: CheckSuperAccount
                                              .isMultiAccountOrLeaderAccount()
                                          ? InputIconType.SEARCH
                                          : null,
                                      iconColor:
                                          AppColors.textFieldUnfoucsColor,
                                      hintText: staffName ??
                                          '${tr('plz_select_something_1', args: [
                                                tr('manager'),
                                                ''
                                              ])}',
                                      // 팀장 일때 만 팀원선택후 삭제가능.
                                      isShowDeleteForHintText: CheckSuperAccount
                                                  .isMultiAccountOrLeaderAccount() &&
                                              staffName != null &&
                                              staffName != tr('all')
                                          ? true
                                          : false,
                                      deleteIconCallback: () => CheckSuperAccount
                                              .isMultiAccountOrLeaderAccount()
                                          ? p.setStaffName(tr('all'))
                                          : p.setStaffName(null),
                                      width: AppSize.defaultContentsWidth,
                                      hintTextStyleCallBack: () =>
                                          staffName != null
                                              ? AppTextStyle.default_16
                                              : AppTextStyle.hint_16,
                                      popupSearchType: CheckSuperAccount
                                              .isMultiAccountOrLeaderAccount()
                                          ? PopupSearchType.SEARCH_SALSE_PERSON
                                          : null,
                                      isSelectedStrCallBack: (persion) {
                                        return p.setSalesPerson(persion);
                                      },
                                      // 멀티계정 전부 조회.
                                      // 팀장계정 조속팀 조회.
                                      bodyMap: CheckSuperAccount
                                              .isMultiAccount()
                                          ? {'dptnm': ''}
                                          : CheckSuperAccount.isLeaderAccount()
                                              ? {'dptnm': p.dptnm}
                                              : null,
                                      enable: false,
                                    ),
                                    isNotShowStar: true);
                              },
                            ),
                            Selector<TransactionLedgerPageProvider,
                                Tuple3<String?, String?, EtStaffListModel?>>(
                              selector: (context, provider) => Tuple3(
                                  provider.customerName,
                                  provider.selectedProductsFamily,
                                  provider.selectedSalesPerson),
                              builder: (context, tuple, _) {
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
                                    iconColor: AppColors.textFieldUnfoucsColor,
                                    deleteIconCallback: () =>
                                        p.setCustomerName(null),
                                    hintText: tuple.item1 ??
                                        '${tr('plz_select_something_2', args: [
                                              tr('sales_office'),
                                              ''
                                            ])}',
                                    // 팀장 일때 만 팀원선택후 삭제가능.
                                    isShowDeleteForHintText:
                                        tuple.item1 != null ? true : false,
                                    width: AppSize.defaultContentsWidth,
                                    hintTextStyleCallBack: () =>
                                        tuple.item1 != null
                                            ? AppTextStyle.default_16
                                            : AppTextStyle.hint_16,
                                    popupSearchType:
                                        PopupSearchType.SEARCH_SALLER,
                                    isSelectedStrCallBack: (customer) {
                                      return p.setCustomerModel(customer);
                                    },
                                    bodyMap: {
                                      'product_family': tuple.item2,
                                      'staff': CheckSuperAccount
                                              .isMultiAccountOrLeaderAccount()
                                          ? tuple.item3 != null
                                              ? tuple.item3!.sname
                                              : tr('all')
                                          : CacheService.getEsLogin()!.ename,
                                      'dptnm':
                                          CheckSuperAccount.isMultiAccount()
                                              ? tuple.item3 != null
                                                  ? tuple.item3!.dptnm
                                                  : CacheService.getEsLogin()!
                                                      .dptnm
                                              : CacheService.getEsLogin()!.dptnm
                                    },
                                    enable: false,
                                  ),
                                );
                              },
                            ),
                            Selector<
                                    TransactionLedgerPageProvider,
                                    Tuple3<EtCustomerModel?, EtCustListModel?,
                                        List<EtCustListModel>>>(
                                selector: (context, provider) => Tuple3(
                                    provider.selectedCustomerModel,
                                    provider.selectedEndCustomerModel,
                                    provider.endCustomerList),
                                builder: (context, tuple, _) {
                                  return BaseColumWithTitleAndTextFiled.build(
                                      '${tr('end_customer')}',
                                      BaseInputWidget(
                                        context: context,
                                        onTap: tuple.item1 == null
                                            ? () {
                                                AppToast().show(
                                                    context,
                                                    tr('plz_select_something_2',
                                                        args: [
                                                          tr('sales_office'),
                                                          ''
                                                        ]));
                                                return 'continue';
                                              }
                                            : null,
                                        iconType: InputIconType.SELECT,
                                        iconColor:
                                            AppColors.textFieldUnfoucsColor,
                                        deleteIconCallback: () =>
                                            p.setEndCustomerModel(null),
                                        hintText: tuple.item3.isEmpty ||
                                                tuple.item2 == null
                                            ? '${tr('plz_select_something_1', args: [
                                                    tr('end_customer'),
                                                    ''
                                                  ])}'
                                            : tuple.item2!.kunnrNm!,
                                        width: AppSize.defaultContentsWidth,
                                        isNotInsertAll: true,
                                        hintTextStyleCallBack: () =>
                                            tuple.item1 != null
                                                ? AppTextStyle.default_16
                                                : AppTextStyle.hint_16,
                                        oneCellType: tuple.item3.isEmpty
                                            ? OneCellType.DO_NOTHING
                                            : OneCellType.END_CUSTOMER,
                                        commononeCellDataCallback: () =>
                                            p.getEndCustomerList(),
                                        isSelectedStrCallBack: (customer) {
                                          return p
                                              .setEndCustomerModel(customer);
                                        },
                                        enable: false,
                                      ),
                                      isNotShowStar: true);
                                }),
                            Consumer<TransactionLedgerPageProvider>(
                                builder: (context, provider, _) {
                              return AppStyles.buildSearchButton(
                                  context, '${tr('search')}', () {
                                if (provider.isValidate) {
                                  _panelSwich.value = false;
                                  provider.refresh().then((result) {
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
                              });
                            })
                          ])))
            ],
          );
        });
  }

  Widget _buildListViewItem(BuildContext context, TransLedgerTListModel model,
      int index, bool isShowLastPage) {
    final isTotalRow = model.spmon!.contains('<');
    return Column(
      children: [
        Table(
          border: index == 0
              ? null
              : TableBorder(
                  top: BorderSide(
                      color: AppColors.unReadyButtonBorderColor, width: .4)),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: FlexColumnWidth(.25),
            1: FlexColumnWidth(.5),
            2: FlexColumnWidth(.25),
          },
          children: [
            TableRow(children: [
              _buildTableBox(model.bschlTx!, 0,
                  isBody: true, isTotalRow: isTotalRow),
              _buildTableBox(model.arktx!.trim(), 1,
                  isBody: true, isTotalRow: isTotalRow),
              _buildTableBox(
                  model.fkimgC != null &&
                          model.fkimgC!.isNotEmpty &&
                          model.freeQtyC != null &&
                          model.freeQtyC!.isNotEmpty
                      ? '${model.fkimgC!}/${model.freeQtyC!}'
                      : model.fkimgC == null || model.fkimgC!.isEmpty
                          ? ''
                          : '${model.fkimgC!}/${model.freeQtyC == null || model.freeQtyC!.isEmpty ? '0' : model.freeQtyC}',
                  2,
                  isBody: true,
                  alignment: Alignment.centerRight,
                  isTotalRow: isTotalRow),
            ]),
          ],
        ),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: FlexColumnWidth(.25),
            1: FlexColumnWidth(.25),
            2: FlexColumnWidth(.25),
            3: FlexColumnWidth(.25),
          },
          children: [
            TableRow(children: [
              _buildTableBox(
                  isTotalRow
                      ? model.spmon!.contains('총 계')
                          ? '총 합계'
                          : model.spmon!
                      : FormatUtil.addDashForDateStr2(
                          model.spmon!.replaceAll('-', '')),
                  0,
                  isBody: true,
                  isTotalRow: isTotalRow),
              _buildTableBox(model.netwrTC!, 1,
                  isBody: true, isTotalRow: isTotalRow),
              _buildTableBox(model.dmbtrC!, 2,
                  isBody: true, isTotalRow: isTotalRow),
              _buildTableBox(model.otherC!, 3,
                  isBody: true, isTotalRow: isTotalRow),
            ])
          ],
        ),
      ],
    );
  }

  Widget _buildListViewItemForLandSpace(BuildContext context,
      TransLedgerTListModel model, int index, bool isShowLastPage) {
    final isTotalRow = model.spmon!.contains('<');
    return Column(
      children: [
        Table(
          border: TableBorder(
              top: BorderSide.none,
              left: BorderSide(
                  color: AppColors.unReadyButtonBorderColor, width: .4),
              bottom: BorderSide(
                  color: AppColors.unReadyButtonBorderColor, width: .4),
              horizontalInside: BorderSide(
                  color: AppColors.unReadyButtonBorderColor, width: .4),
              verticalInside: BorderSide(
                  color: AppColors.unReadyButtonBorderColor, width: .4)),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: FlexColumnWidth(.12),
            1: FlexColumnWidth(.12),
            2: FlexColumnWidth(.24),
            3: FlexColumnWidth(.12),
            4: FlexColumnWidth(.133),
            5: FlexColumnWidth(.133),
            6: FlexColumnWidth(.133),
          },
          children: [
            TableRow(children: [
              _buildTableBox(model.bschlTx!, 0,
                  isBody: true, isLandSpace: true, isTotalRow: isTotalRow),
              _buildTableBox(
                  isTotalRow
                      ? model.spmon!.contains('총 계')
                          ? '총 합계'
                          : model.spmon!
                      : FormatUtil.addDashForDateStr2(
                          model.spmon!.replaceAll('-', '')),
                  1,
                  isBody: true,
                  isLandSpace: true,
                  isTotalRow: isTotalRow),
              _buildTableBox(model.arktx!.trim(), 2,
                  isBody: true, isLandSpace: true, isTotalRow: isTotalRow),
              _buildTableBox(
                  model.fkimgC != null &&
                          model.fkimgC!.isNotEmpty &&
                          model.freeQtyC != null &&
                          model.freeQtyC!.isNotEmpty
                      ? '${model.fkimgC!}/${model.freeQtyC!}'
                      : model.fkimgC == null || model.fkimgC!.isEmpty
                          ? ''
                          : '${model.fkimgC!}/${model.freeQtyC == null || model.freeQtyC!.isEmpty ? '0' : model.freeQtyC}',
                  3,
                  isBody: true,
                  isLandSpace: true,
                  isTotalRow: isTotalRow),
              _buildTableBox(model.netwrTC!, 4,
                  isBody: true, isLandSpace: true, isTotalRow: isTotalRow),
              _buildTableBox(model.dmbtrC!, 5,
                  isBody: true, isLandSpace: true, isTotalRow: isTotalRow),
              _buildTableBox(model.otherC!, 6,
                  isBody: true, isLandSpace: true, isTotalRow: isTotalRow),
            ])
          ],
        ),
      ],
    );
  }

  Widget _buildTableBox(String text, int index,
      {bool? isBody,
      AlignmentGeometry? alignment,
      bool? isTotalRow,
      bool? isLandSpace}) {
    return Container(
        padding: EdgeInsets.only(
            left: index == 0
                ? isLandSpace != null && isLandSpace
                    ? AppSize.padding / 2
                    : AppSize.padding
                : isLandSpace != null && isLandSpace
                    ? AppSize.defaultListItemSpacing / 2
                    : AppSize.defaultListItemSpacing,
            right: alignment != null ? AppSize.padding : AppSize.zero),
        height: isLandSpace != null && isLandSpace
            ? AppSize.defaultTextFieldHeight * .4
            : AppSize.defaultTextFieldHeight * .6,
        decoration: BoxDecoration(
            color: isBody != null && isBody
                ? isTotalRow != null && isTotalRow
                    ? AppColors.tableBorderColor.withOpacity(.2)
                    : AppColors.whiteText
                : AppColors.tableBorderColor.withOpacity(.2)),
        alignment: alignment != null ? alignment : Alignment.centerLeft,
        child: AppText.text(text,
            style: isBody != null && isBody
                ? isTotalRow != null && isTotalRow && text.contains('계')
                    ? AppTextStyle.blod_16
                    : null
                : AppTextStyle.blod_16.copyWith(fontWeight: FontWeight.w600)));
  }

  Widget _buildResultTitle(BuildContext context) {
    return Column(
      children: [
        Table(
          border: TableBorder.all(
              color: AppColors.unReadyButtonBorderColor, width: .4),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: FlexColumnWidth(.25),
            1: FlexColumnWidth(.5),
            2: FlexColumnWidth(.25),
          },
          children: [
            TableRow(children: [
              _buildTableBox(tr('division'), 0,
                  isBody: false, isTotalRow: true),
              _buildTableBox(tr('item_name'), 1,
                  isBody: false, isTotalRow: true),
              _buildTableBox(tr('quantity_and_add'), 2,
                  isBody: false, isTotalRow: true),
            ]),
          ],
        ),
        Table(
          border: TableBorder(
              top: BorderSide.none,
              bottom: BorderSide(
                  color: AppColors.unReadyButtonBorderColor, width: .4),
              horizontalInside: BorderSide(
                  color: AppColors.unReadyButtonBorderColor, width: .4),
              verticalInside: BorderSide(
                  color: AppColors.unReadyButtonBorderColor, width: .4)),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: FlexColumnWidth(.25),
            1: FlexColumnWidth(.25),
            2: FlexColumnWidth(.25),
            3: FlexColumnWidth(.25),
          },
          children: [
            TableRow(children: [
              _buildTableBox(tr('date_1'), 0, isBody: false, isTotalRow: true),
              _buildTableBox(tr('total_sales'), 1,
                  isBody: false, isTotalRow: true),
              _buildTableBox(tr('collection_amount'), 2,
                  isBody: false, isTotalRow: true),
              _buildTableBox(tr('other_amount'), 3,
                  isBody: false, isTotalRow: true),
            ])
          ],
        ),
      ],
    );
  }

  Widget _buildChangeOrientationButton(BuildContext context) {
    return Selector<TransactionLedgerPageProvider, TransLedgerResponseModel?>(
      selector: (context, provider) => provider.transLedgerResponseModel,
      builder: (context, model, _) {
        return model != null && model.tList != null && model.tList!.isNotEmpty
            ? Positioned(
                right: AppSize.padding,
                bottom: AppSize.padding + AppSize.buttonHeight,
                child: FloatingActionButton(
                  backgroundColor: AppColors.whiteText,
                  foregroundColor: AppColors.primary,
                  onPressed: () {
                    final p = context.read<TransactionLedgerPageProvider>();
                    p.setIsShowAppBar();
                    CacheService.setIsDisableUpdate(true);
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.landscapeRight,
                    ]);
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                        overlays: []);
                  },
                  child: AppImage.getImage(ImageType.SCREEN_ROTATION),
                ))
            : Container();
      },
    );
  }

  Widget _buildResult(BuildContext context) {
    final p = context.read<TransactionLedgerPageProvider>();
    return Selector<TransactionLedgerPageProvider,
        Tuple2<TransLedgerResponseModel?, bool>>(
      selector: (context, provider) =>
          Tuple2(provider.transLedgerResponseModel, provider.isLoadData),
      builder: (context, tuple, _) {
        var isModelNotNull = tuple.item1 != null &&
            tuple.item1!.tList != null &&
            tuple.item1!.tList!.isNotEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isModelNotNull
                ? Column(
                    children: [
                      defaultSpacing(times: 2),
                      _buildResultTitle(context),
                    ],
                  )
                : Container(),
            isModelNotNull
                ? Container(
                    constraints: BoxConstraints(
                      maxHeight: AppSize.realHeight -
                          AppSize.appBarHeight -
                          AppSize.buttonHeight * 3,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: tuple.item1!.tList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildListViewItem(
                            context,
                            tuple.item1!.tList![index],
                            index,
                            !p.hasMore &&
                                index ==
                                    p.transLedgerResponseModel!.tList!.length -
                                        1);
                      },
                    ),
                  )
                : tuple.item2
                    ? DefaultShimmer.buildDefaultResultShimmer()
                    : ListView(
                        shrinkWrap: true,
                        children: [
                          Padding(
                              padding: AppSize.nullValueWidgetPadding,
                              child: BaseNullDataWidget.build(
                                  message: p.hasResultData == null ? '' : null))
                        ],
                      ),
            Padding(padding: EdgeInsets.only(top: AppSize.buttonHeight))
          ],
        );
      },
    );
  }

  Widget _buildTitleRow(String t1, String t2, String t3,
      {TextStyle? style1,
      TextStyle? style2,
      TextStyle? style3,
      double? width}) {
    var widthSize = width ?? AppSize.realWidth - AppSize.padding * 2;
    return Padding(
        padding: width != null
            ? EdgeInsets.symmetric(horizontal: AppSize.padding / 2)
            : AppSize.defaultSidePadding,
        child: Row(
          children: [
            SizedBox(
              width: widthSize * .3,
              child:
                  AppText.text(t1, textAlign: TextAlign.start, style: style1),
            ),
            SizedBox(
              width: widthSize * .3,
              child: AppText.text(t2, textAlign: TextAlign.end, style: style2),
            ),
            SizedBox(
              width: widthSize * .4,
              child: AppText.text(t3, textAlign: TextAlign.end, style: style3),
            ),
          ],
        ));
  }

  Widget _buildAmountRow(String t1, String t2,
      {TextStyle? style1, TextStyle? style2, double? width}) {
    var widthSize = width ?? AppSize.realWidth - AppSize.padding * 2;
    return Padding(
        padding: width != null
            ? EdgeInsets.symmetric(horizontal: AppSize.padding / 2)
            : AppSize.defaultSidePadding,
        child: Row(
          children: [
            SizedBox(
              width: widthSize * .4,
              child:
                  AppText.text(t1, textAlign: TextAlign.start, style: style1),
            ),
            SizedBox(
              width: widthSize * .6,
              child: AppText.text(t2, textAlign: TextAlign.end, style: style2),
            ),
          ],
        ));
  }

  Widget _buildAnimationBody(BuildContext context, {bool? isLandSpace}) {
    return ListView(
      children: [
        Selector<TransactionLedgerPageProvider, TransLedgerResponseModel?>(
          selector: (context, provider) => provider.transLedgerResponseModel,
          builder: (context, model, _) {
            var head = model?.esHead;
            var report = model?.tReport;
            var defaultSpacingWidget = isLandSpace != null
                ? defaultSpacing(height: AppSize.defaultListItemSpacing * .8)
                : defaultSpacing();
            var width = Platform.isAndroid
                ? AppSize.bottomSheetWidth - AppSize.padding
                : AppSize.bottomSheetWidth -
                    AppSize.padding -
                    MediaQuery.of(context).padding.top;
            return head != null && report != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLandSpace != null ? defaultSpacingWidget : Container(),
                      isLandSpace != null
                          ? Container(
                              padding:
                                  EdgeInsets.only(left: AppSize.padding / 2),
                              alignment: Alignment.centerLeft,
                              child: AppText.text(tr('balance_status'),
                                  style: AppTextStyle.default_14
                                      .copyWith(fontWeight: FontWeight.w600)))
                          : defaultSpacingWidget,
                      defaultSpacingWidget,
                      _buildTitleRow('', tr('start_date'), tr('end_date'),
                          style2: AppTextStyle.default_16,
                          style3: AppTextStyle.default_16,
                          width: isLandSpace != null ? width : null),
                      defaultSpacingWidget,
                      _buildTitleRow(
                          tr('card_balance'),
                          '${head.cardAmtS}/${head.cardDueS}',
                          '${head.cardAmtE}/${head.cardDueE}',
                          style1: AppTextStyle.default_14
                              .copyWith(fontWeight: FontWeight.w600),
                          width: isLandSpace != null ? width : null),
                      defaultSpacingWidget,
                      _buildTitleRow(
                          tr('real_balance'),
                          '${head.realAmtS}/${head.realDueS}',
                          '${head.realAmtE}/${head.realDueE}',
                          style1: AppTextStyle.default_14
                              .copyWith(fontWeight: FontWeight.w600),
                          width: isLandSpace != null ? width : null),
                      defaultSpacingWidget,
                      Padding(
                          padding: isLandSpace != null
                              ? EdgeInsets.zero
                              : AppSize.defaultSidePadding,
                          child: Divider()),
                      defaultSpacingWidget,
                      Padding(
                        padding: EdgeInsets.only(
                            right: isLandSpace != null
                                ? AppSize.padding / 2
                                : AppSize.padding),
                        child: AppText.text(tr('supply_price_and_tex'),
                            style: AppTextStyle.default_16),
                      ),
                      defaultSpacingWidget,
                      _buildAmountRow(
                          tr('total_sales'),
                          head.saleAmt != null && head.saleAmt!.isNotEmpty
                              ? '${head.saleAmt!}/${head.saleAmtT!}'
                              : '0',
                          style1: AppTextStyle.default_14
                              .copyWith(fontWeight: FontWeight.w600),
                          width: isLandSpace != null ? width : null),
                      defaultSpacingWidget,
                      _buildAmountRow(
                          tr('return_amount'),
                          head.reAmt != null && head.reAmt!.isNotEmpty
                              ? '${head.reAmt!}/${head.reAmtT!}'
                              : '0',
                          style1: AppTextStyle.default_14
                              .copyWith(fontWeight: FontWeight.w600),
                          width: isLandSpace != null ? width : null),
                      defaultSpacingWidget,
                      _buildAmountRow(
                          tr('collection_amount'),
                          head.dmbtrD != null &&
                                  head.dmbtrD!.isNotEmpty &&
                                  head.dmbtr != null &&
                                  head.dmbtr!.isNotEmpty
                              ? '${head.dmbtr}/${head.dmbtr}'
                              : head.dmbtr != null && head.dmbtr!.isNotEmpty
                                  ? '${head.dmbtr}'
                                  : head.dmbtrD != null &&
                                          head.dmbtrD!.isNotEmpty
                                      ? '${head.dmbtrD}'
                                      : '0',
                          style1: AppTextStyle.default_14
                              .copyWith(fontWeight: FontWeight.w600),
                          width: isLandSpace != null ? width : null),
                      defaultSpacingWidget,
                      isLandSpace != null ? Container() : defaultSpacing(),
                    ],
                  )
                : DefaultShimmer.buildDefaultResultShimmer();
          },
        )
      ],
    );
  }

  Widget _buildBottomAnimationBox(BuildContext context) {
    return Selector<TransactionLedgerPageProvider, Tuple2<bool, bool>>(
      selector: (context, provider) =>
          Tuple2(provider.isOpenBottomSheet, provider.isAnimationNotReady),
      builder: (context, tuple, _) {
        return WidgetOfOffSetAnimationWidget(
            key: Key('first'),
            animationSwich: tuple.item2 ? null : () => tuple.item1,
            body: _buildAnimationBody(context),
            height: AppSize.bottomSheetHeight,
            offset: Offset(0, (AppSize.bottomSheetHeight)),
            offsetType: OffsetDirectionType.UP);
      },
    );
  }

  Widget _buildBottomTitleBar(BuildContext context) {
    return Selector<TransactionLedgerPageProvider, TransLedgerResponseModel?>(
      selector: (context, provider) => provider.transLedgerResponseModel,
      builder: (context, responseModel, _) {
        return responseModel != null &&
                responseModel.tList != null &&
                responseModel.tList!.isNotEmpty
            ? Positioned(
                bottom: 0,
                right: 0,
                child: Selector<TransactionLedgerPageProvider, bool>(
                  selector: (context, provider) => provider.isShowShadow,
                  builder: (context, isShowShadow, _) {
                    return InkWell(
                      onTap: () {
                        context
                            .read<TransactionLedgerPageProvider>()
                            .setIsOpenBottomSheet();
                      },
                      child: Container(
                        height: AppSize.buttonHeight,
                        width: AppSize.realWidth,
                        decoration: BoxDecoration(
                          color: AppColors.whiteText,
                          boxShadow: isShowShadow
                              ? [
                                  BoxShadow(
                                    color: AppColors.textGrey.withOpacity(0.5),
                                    blurRadius: AppSize.radius5,
                                    offset: Offset(0, -3),
                                  ),
                                ]
                              : [],
                        ),
                        child: Padding(
                          padding: AppSize.defaultSidePadding,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText.text(tr('balance_status'),
                                  style: AppTextStyle.blod_16),
                              WidgetOfRotationAnimationComponents(
                                animationSwich: () => isShowShadow,
                                rotationValue: math.pi,
                                body: Container(
                                  height: AppSize.defaultIconWidth,
                                  width: AppSize.defaultIconWidth,
                                  child: AppImage.getImage(ImageType.SELECT,
                                      color: AppColors.subText),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ))
            : Container();
      },
    );
  }

  Widget _buildResultTitleWithLandSpaceScrren(BuildContext context) {
    return Column(
      children: [
        Table(
          border: TableBorder.all(
              color: AppColors.unReadyButtonBorderColor, width: .4),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: FlexColumnWidth(.12),
            1: FlexColumnWidth(.12),
            2: FlexColumnWidth(.24),
            3: FlexColumnWidth(.12),
            4: FlexColumnWidth(.133),
            5: FlexColumnWidth(.133),
            6: FlexColumnWidth(.133),
          },
          children: [
            TableRow(children: [
              _buildTableBox(tr('division'), 0,
                  isBody: false, isTotalRow: true, isLandSpace: true),
              _buildTableBox(tr('date_1'), 1,
                  isBody: false, isTotalRow: true, isLandSpace: true),
              _buildTableBox(tr('item_name'), 2,
                  isBody: false, isTotalRow: true, isLandSpace: true),
              _buildTableBox(tr('quantity_and_add'), 3,
                  isBody: false, isTotalRow: true, isLandSpace: true),
              _buildTableBox(tr('total_sales'), 4,
                  isBody: false, isTotalRow: true, isLandSpace: true),
              _buildTableBox(tr('collection_amount'), 5,
                  isBody: false, isTotalRow: true, isLandSpace: true),
              _buildTableBox(tr('other_amount'), 6,
                  isBody: false, isTotalRow: true, isLandSpace: true),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _buildResultForLandSpace(BuildContext context) {
    final p = context.read<TransactionLedgerPageProvider>();
    return Expanded(
        child: Selector<TransactionLedgerPageProvider,
            Tuple2<TransLedgerResponseModel?, bool>>(
      selector: (context, provider) =>
          Tuple2(provider.transLedgerResponseModel, provider.isLoadData),
      builder: (context, tuple, _) {
        var isModelNotNull = tuple.item1 != null &&
            tuple.item1!.tList != null &&
            tuple.item1!.tList!.isNotEmpty;
        return isModelNotNull
            ? ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: tuple.item1!.tList!.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildListViewItemForLandSpace(
                      context,
                      tuple.item1!.tList![index],
                      index,
                      !p.hasMore &&
                          index ==
                              p.transLedgerResponseModel!.tList!.length - 1);
                },
              )
            : tuple.item2
                ? DefaultShimmer.buildDefaultResultShimmer()
                : ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                          padding: AppSize.nullValueWidgetPadding,
                          child: BaseNullDataWidget.build(
                              message: p.hasResultData == null ? '' : null))
                    ],
                  );
      },
    ));
  }

  Widget _buildAppBar(BuildContext context) {
    return InkWell(
      onTap: () {
        final p = context.read<TransactionLedgerPageProvider>();
        if (!p.isOpenBottomSheet) {
          p.setIsOpenBottomSheet();
        }
        p.setIsShowAppBar();

        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.top]);
        CacheService.setIsDisableUpdate(false);
      },
      child: Container(
          padding: Platform.isIOS
              ? EdgeInsets.zero
              : EdgeInsets.only(left: AppSize.padding),
          alignment: Alignment.centerLeft,
          width: AppSize.realWidth,
          height: AppSize.appBarHeight,
          child: AppImage.getImage(ImageType.LAND_SPACE_PAGE_APPBAR_ICON)),
    );
  }

  Widget _buildLandSpaceView(BuildContext context) {
    return SafeArea(
      left: false,
      right: true,
      child: Stack(
        children: [
          Container(
            height: AppSize.realHeight,
            width: AppSize.realWidth,
            child: Column(
              children: [
                defaultSpacing(height: AppSize.defaultListItemSpacing / 4),
                _buildAppBar(context),
                defaultSpacing(height: AppSize.defaultListItemSpacing / 4),
                _buildResultTitleWithLandSpaceScrren(context),
                _buildResultForLandSpace(context),
                defaultSpacing(times: 2),
              ],
            ),
          ),
          Selector<TransactionLedgerPageProvider, Tuple2<bool, bool>>(
            selector: (context, provider) => Tuple2(
                provider.isOpenBottomSheet, provider.isAnimationNotReady),
            builder: (context, tuple, _) {
              return WidgetOfOffSetAnimationWidget(
                  key: key,
                  animationSwich: tuple.item2 ? null : () => tuple.item1,
                  body: _buildAnimationBody(context, isLandSpace: true),
                  height: AppSize.realHeight,
                  width: AppSize.bottomSheetWidth,
                  offset: Offset(-AppSize.bottomSheetWidth, 0),
                  offsetType: OffsetDirectionType.RIGHT);
            },
          ),
          Selector<TransactionLedgerPageProvider, Tuple2<bool, bool>>(
            selector: (context, provider) => Tuple2(
                provider.isOpenBottomSheetForLandSpace, provider.isFirstRun),
            builder: (context, tuple, _) {
              return DrawerButtonAnimationWidget(
                animationSwich: () => tuple.item1,
                body: InkWell(
                    onTap: () {
                      final p = context.read<TransactionLedgerPageProvider>();
                      p.setIsOpenBottomSheet();
                      p.setIsOpenBottomSheetForLandSpace();
                    },
                    child: WidgetOfRotationAnimationComponents(
                      // 반대로.
                      animationSwich: () => !tuple.item1,
                      rotationValue: math.pi,
                      body: Container(
                          child: AppImage.getImage(ImageType.SELECT_RIGHT)),
                    )),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitView(BuildContext context) {
    final p = context.read<TransactionLedgerPageProvider>();
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () {
            _panelSwich.value = false;
            return p.refresh().then((value) {
              hideKeyboard(context);
              Future.delayed(Duration(seconds: 1), () {
                if (p.transLedgerResponseModel == null ||
                    p.transLedgerResponseModel!.tList!.isEmpty) {
                  Future.delayed(Duration(seconds: 1), () {
                    _panelSwich.value = true;
                  });
                }
              });
            });
          },
          child: ListView(
            controller: _scrollController2,
            children: [
              CustomerinfoWidget.buildDividingLine(),
              _buildPanel(context),
              CustomerinfoWidget.buildDividingLine(),
              _buildResult(context),
              Padding(
                  padding: EdgeInsets.only(bottom: AppSize.appBarHeight / 2),
                  child: NextPageLoadingWdiget.build(context))
            ],
          ),
        ),
        _buildChangeOrientationButton(context),
        _buildBottomAnimationBox(context),
        _buildBottomTitleBar(context)
      ],
    );
  }

  Widget _buildContents(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        return _buildPortraitView(context);
      } else if (orientation == Orientation.landscape) {
        return _buildLandSpaceView(context);
      }
      return Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => TransactionLedgerPageProvider()),
          ChangeNotifierProvider(
              create: (context) => NextPageLoadingProvider()),
        ],
        builder: (context, _) {
          pr('build');
          final p = context.read<TransactionLedgerPageProvider>();

          return Selector<TransactionLedgerPageProvider, bool>(
            selector: (context, provider) => provider.isShowAppBar,
            builder: (context, isShowAppBar, _) {
              return BaseLayout(
                  hasForm: true,
                  isResizeToAvoidBottomInset: false,
                  isWithWillPopScope: isShowAppBar ? true : false,
                  appBar: !isShowAppBar
                      ? null
                      : MainAppBar(
                          context,
                          titleText: AppText.text(
                            '${tr('transaction_ledger')}',
                            style: AppTextStyle.w500_22,
                          ),
                        ),
                  child: FutureBuilder(
                      future: isShowAppBar
                          ? p.initPageData()
                          : Future.delayed(Duration.zero, () {
                              return;
                            }),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return _buildContents(context);
                        }
                        return Scaffold(
                            body: DefaultShimmer.buildDefaultResultShimmer());
                      }));
            },
          );
        });
  }
}
