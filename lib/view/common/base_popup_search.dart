/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_popup_search.dart
 * Created Date: 2021-09-11 00:27:49
 * Last Modified: 2022-11-15 11:12:57
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---  --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 *                        Discription                         
 * ---  --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 */

import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bpom/util/format_util.dart';
import 'package:bpom/service/cache_service.dart';
import 'package:bpom/util/is_super_account.dart';
import 'package:bpom/enums/popup_list_type.dart';
import 'package:bpom/service/hive_service.dart';
import 'package:bpom/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bpom/enums/input_icon_type.dart';
import 'package:bpom/enums/popup_search_type.dart';
import 'package:bpom/view/common/base_shimmer.dart';
import 'package:bpom/model/common/result_model.dart';
import 'package:bpom/view/common/base_app_toast.dart';
import 'package:bpom/model/common/et_kunnr_model.dart';
import 'package:bpom/view/common/base_app_dialog.dart';
import 'package:bpom/globalProvider/timer_provider.dart';
import 'package:bpom/view/common/function_of_print.dart';
import 'package:bpom/view/common/base_input_widget.dart';
import 'package:bpom/model/common/et_customer_model.dart';
import 'package:bpom/model/common/et_cust_list_model.dart';
import 'package:bpom/model/common/et_staff_list_model.dart';
import 'package:bpom/view/common/widget_of_last_page_text.dart';
import 'package:bpom/view/common/widget_of_default_spacing.dart';
import 'package:bpom/view/common/widget_of_default_shimmer.dart';
import 'package:bpom/model/common/add_activity_key_man_model.dart';
import 'package:bpom/view/common/widget_of_next_page_loading.dart';
import 'package:bpom/view/common/fountion_of_hidden_key_borad.dart';
import 'package:bpom/model/common/order_manager_material_model.dart';
import 'package:bpom/globalProvider/next_page_loading_provider.dart';
import 'package:bpom/model/common/add_activity_suggetion_item_model.dart';
import 'package:bpom/view/common/provider/base_popup_search_provider.dart';

class BasePopupSearch {
  final PopupSearchType? type;
  final Map<String, dynamic>? bodyMap;
  BasePopupSearch({required this.type, this.bodyMap});

  Future<dynamic> show(BuildContext context) async {
    final result = await AppDialog.showPopup(
        context, PopupSearchOneRowContents(type!, bodyMap: bodyMap));
    if (result != null) return result;
  }
}

Widget shimmer() {
  return Padding(
      padding: EdgeInsets.all(AppSize.padding),
      child: Column(
        children: List.generate(
            6,
            (index) => Container(
                  child: BaseShimmer.shimmerBox(
                      AppTextStyle.default_16.fontSize!,
                      AppSize.updatePopupWidth - AppSize.padding * 2),
                )).toList(),
      ));
}

class PopupSearchOneRowContents extends StatefulWidget {
  PopupSearchOneRowContents(
    this.type, {
    Key? key,
    this.bodyMap,
  }) : super(key: key);
  final PopupSearchType type;
  final Map<String, dynamic>? bodyMap;
  @override
  _PopupSearchOneRowContentsState createState() =>
      _PopupSearchOneRowContentsState();
}

class _PopupSearchOneRowContentsState extends State<PopupSearchOneRowContents> {
  late TextEditingController _personInputController;
  late TextEditingController _customerInputController;
  late TextEditingController _endCustomerInputController;
  late TextEditingController _suggetionNameInputController;
  late TextEditingController _suggetionGroupInputController;
  late TextEditingController _materialQuantityInputController;
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _suggetionNameInputController = TextEditingController();
    _suggetionGroupInputController = TextEditingController();
    _personInputController = TextEditingController();
    _customerInputController = TextEditingController();
    _endCustomerInputController = TextEditingController();
    _materialQuantityInputController = TextEditingController();
  }

  @override
  void dispose() {
    _personInputController.dispose();
    _customerInputController.dispose();
    _endCustomerInputController.dispose();
    _suggetionNameInputController.dispose();
    _suggetionGroupInputController.dispose();
    _materialQuantityInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildPersonSearchBar(BuildContext context) {
    final p = context.read<BasePopupSearchProvider>();
    return Column(
      children: [
        defaultSpacing(),
        Selector<BasePopupSearchProvider, String?>(
            selector: (context, provider) => provider.personInputText,
            builder: (context, personInputText, _) {
              return BaseInputWidget(
                  context: context,
                  width: AppSize.defaultContentsWidth - AppSize.padding * 2,
                  enable: true,
                  hintTextStyleCallBack: _personInputController.text.isNotEmpty
                      ? null
                      : () => AppTextStyle.hint_16,
                  iconType: _personInputController.text.isNotEmpty
                      ? InputIconType.DELETE_AND_SEARCH
                      : InputIconType.SEARCH,
                  onChangeCallBack: (e) => p.setPersonInputText(e),
                  iconColor: AppColors.textFieldUnfoucsColor,
                  defaultIconCallback: () {
                    hideKeyboard(context);
                    final tp = context.read<TimerProvider>();
                    if (tp.getTimer == null ||
                        (tp.isRunning != null && !tp.isRunning!)) {
                      tp.perdict(p.refresh());
                    }
                  },
                  textEditingController: _personInputController,
                  otherIconcallback: () {
                    p.setPersonInputText(null);
                    _personInputController.text = '';
                  },
                  hintText: _personInputController.text.isNotEmpty
                      ? _personInputController.text
                      : '${tr('plz_enter_search_key_for_something_1', args: [
                              '${tr('name')}',
                              ''
                            ])}');
            }),
        defaultSpacing()
      ],
    );
  }

  Widget _buildSuggetionItemSearchBar(BuildContext context) {
    final p = context.read<BasePopupSearchProvider>();
    return Column(
      children: [
        defaultSpacing(),
        Selector<BasePopupSearchProvider, String?>(
            selector: (context, provider) =>
                provider.suggetionItemGroupInputText,
            builder: (context, group, _) {
              return BaseInputWidget(
                  context: context,
                  width: AppSize.defaultContentsWidth - AppSize.padding * 2,
                  enable: true,
                  hintTextStyleCallBack:
                      _suggetionGroupInputController.text.isNotEmpty
                          ? null
                          : () => AppTextStyle.hint_16,
                  iconType: _suggetionGroupInputController.text.isNotEmpty
                      ? InputIconType.DELETE
                      : null,
                  onChangeCallBack: (e) => p.setSuggetionItemGroupInputText(e),
                  iconColor: AppColors.textFieldUnfoucsColor,
                  defaultIconCallback: () {
                    p.setSuggetionItemGroupInputText(null);
                    _suggetionGroupInputController.text = '';
                  },
                  textEditingController: _suggetionGroupInputController,
                  hintText: _suggetionGroupInputController.text.isNotEmpty
                      ? _suggetionGroupInputController.text
                      : '${tr('plz_enter_search_key_for_something_1', args: [
                              '${tr('materials_group')}',
                              ''
                            ])}');
            }),
        defaultSpacing(),
        Selector<BasePopupSearchProvider, String?>(
            selector: (context, provider) =>
                provider.suggetionItemNameInputText,
            builder: (context, name, _) {
              return BaseInputWidget(
                  context: context,
                  width: AppSize.defaultContentsWidth - AppSize.padding * 2,
                  enable: true,
                  hintTextStyleCallBack:
                      _suggetionNameInputController.text.isNotEmpty
                          ? null
                          : () => AppTextStyle.hint_16,
                  iconType: _suggetionNameInputController.text.isNotEmpty
                      ? InputIconType.DELETE
                      : null,
                  onChangeCallBack: (e) => p.setSuggetionItemNameInputText(e),
                  iconColor: AppColors.textFieldUnfoucsColor,
                  defaultIconCallback: () {
                    p.setSuggetionItemNameInputText(null);
                    _suggetionNameInputController.text = '';
                  },
                  textEditingController: _suggetionNameInputController,
                  hintText: _suggetionNameInputController.text.isNotEmpty
                      ? _suggetionNameInputController.text
                      : '${tr('plz_enter_search_key_for_something_1', args: [
                              '${tr('materials_name')}',
                              ''
                            ])}');
            }),
        defaultSpacing(),
        AppStyles.buildSearchButton(context, tr('search'), () {
          final p = context.read<BasePopupSearchProvider>();
          if (!((p.suggetionItemGroupInputText != null &&
                  p.suggetionItemGroupInputText!.isNotEmpty) ||
              (p.suggetionItemNameInputText != null &&
                  p.suggetionItemNameInputText!.isNotEmpty))) {
            AppToast().show(context, tr('keyword_must_not_null'));
          } else {
            final tp = context.read<TimerProvider>();
            if (tp.getTimer == null ||
                (tp.isRunning != null && !tp.isRunning!)) {
              tp.perdict(p.refresh().then((value) => hideKeyboard(context)));
            }
          }
        }, doNotWithPadding: true),
        defaultSpacing()
      ],
    );
  }

  Widget _buildKeyManSearchBar(BuildContext context) {
    final p = context.read<BasePopupSearchProvider>();
    return Column(
      children: [
        defaultSpacing(),
        Selector<BasePopupSearchProvider, String?>(
            selector: (context, provider) => provider.keymanInputText,
            builder: (context, keymanInputText, _) {
              return BaseInputWidget(
                  context: context,
                  width: AppSize.defaultContentsWidth - AppSize.padding * 2,
                  enable: true,
                  hintTextStyleCallBack: _personInputController.text.isNotEmpty
                      ? null
                      : () => AppTextStyle.hint_16,
                  iconType: _personInputController.text.isNotEmpty
                      ? InputIconType.DELETE_AND_SEARCH
                      : InputIconType.SEARCH,
                  onChangeCallBack: (e) => p.setKeymanInputText(e),
                  iconColor: AppColors.textFieldUnfoucsColor,
                  defaultIconCallback: () {
                    hideKeyboard(context);
                    final tp = context.read<TimerProvider>();
                    if (tp.getTimer == null ||
                        (tp.isRunning != null && !tp.isRunning!)) {
                      tp.perdict(p.refresh());
                    }
                  },
                  textEditingController: _personInputController,
                  otherIconcallback: () {
                    p.setKeymanInputText(null);
                    _personInputController.text = '';
                  },
                  hintText: _personInputController.text.isNotEmpty
                      ? _personInputController.text
                      : '${tr('plz_enter_search_key_for_something_1', args: [
                              '${tr('name')}',
                              ''
                            ])}');
            }),
        defaultSpacing()
      ],
    );
  }

  Widget _buildCustomerSearchBar(BuildContext context) {
    final p = context.read<BasePopupSearchProvider>();

    return Expanded(
        child: Column(
      children: [
        defaultSpacing(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Selector<BasePopupSearchProvider, String?>(
                selector: (context, provider) =>
                    provider.selectedProductCategory,
                builder: (context, selectedProductCategory, _) {
                  return BaseInputWidget(
                      context: context,
                      width:
                          (AppSize.defaultContentsWidth - AppSize.padding * 2),
                      enable: false,
                      hintTextStyleCallBack: selectedProductCategory != null
                          ? () => AppTextStyle.default_16
                          : () => AppTextStyle.hint_16,
                      iconType: InputIconType.SELECT,
                      iconColor: AppColors.textFieldUnfoucsColor,
                      commononeCellDataCallback: p.getProductCategory,
                      oneCellType: OneCellType.SEARCH_PRODUCTS_CATEGORY,
                      isSelectedStrCallBack: (str) =>
                          p.setProductsCategory(str),
                      hintText: selectedProductCategory != null
                          ? selectedProductCategory
                          : '${tr('plz_select_something_1', args: [
                                  tr('products_category'),
                                  ''
                                ])}');
                }),
          ],
        ),
        defaultSpacing(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Selector<BasePopupSearchProvider, String?>(
                selector: (context, provider) => provider.selectedProductFamily,
                builder: (context, selectedProductFamily, _) {
                  return BaseInputWidget(
                      context: context,
                      width:
                          (AppSize.defaultContentsWidth - AppSize.padding * 2),
                      enable: false,
                      hintTextStyleCallBack: selectedProductFamily != null
                          ? () => AppTextStyle.default_16
                          : () => AppTextStyle.hint_16,
                      iconType: InputIconType.SELECT,
                      iconColor: AppColors.textFieldUnfoucsColor,
                      commononeCellDataCallback: p.getProductFamily,
                      oneCellType: OneCellType.SEARCH_PRODUCT_FAMILY,
                      isSelectedStrCallBack: (str) => p.setProductsFamily(str),
                      hintText: selectedProductFamily != null
                          ? selectedProductFamily
                          : '${tr('plz_select_something_1', args: [
                                  tr('product_family'),
                                  ''
                                ])}');
                }),
          ],
        ),
        defaultSpacing(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Selector<BasePopupSearchProvider, String?>(
                selector: (context, provider) => provider.customerInputText,
                builder: (context, customerInputText, _) {
                  return BaseInputWidget(
                      context: context,
                      width:
                          (AppSize.defaultContentsWidth - AppSize.padding * 2),
                      enable: true,
                      hintTextStyleCallBack:
                          _customerInputController.text.isNotEmpty
                              ? null
                              : () => AppTextStyle.hint_16,
                      iconType: _customerInputController.text.isNotEmpty
                          ? InputIconType.DELETE
                          : null,
                      onChangeCallBack: (e) => p.setCustomerInputText(e),
                      iconColor: AppColors.textFieldUnfoucsColor,
                      defaultIconCallback: () {
                        p.setCustomerInputText(null);
                        _customerInputController.text = '';
                      },
                      textEditingController: _customerInputController,
                      hintText: _customerInputController.text.isNotEmpty
                          ? _customerInputController.text
                          : '${tr('plz_enter_search_key_for_something_1', args: [
                                  '${tr('customer_name')}',
                                  '(*)'
                                ])}');
                }),
          ],
        ),
        defaultSpacing(),
        AppStyles.buildSearchButton(context, tr('search'), () {
          final p = context.read<BasePopupSearchProvider>();
          if (p.customerInputText == null || p.customerInputText!.isEmpty) {
            AppToast().show(context, tr('keyword_must_not_null'));
          } else {
            final tp = context.read<TimerProvider>();
            if (tp.getTimer == null ||
                (tp.isRunning != null && !tp.isRunning!)) {
              tp.perdict(p.refresh().then((value) => hideKeyboard(context)));
            }
          }
        }, doNotWithPadding: true),
      ],
    ));
  }

  Widget _buildSallerSearchBar(BuildContext context) {
    final p = context.read<BasePopupSearchProvider>();

    return Expanded(
        child: Column(
      children: [
        defaultSpacing(),
        Selector<BasePopupSearchProvider, String?>(
            selector: (context, provider) => provider.selectedProductFamily,
            builder: (context, selectedProductFamily, _) {
              return BaseInputWidget(
                  context: context,
                  width: (AppSize.defaultContentsWidth - AppSize.padding * 2),
                  enable: false,
                  hintTextStyleCallBack: selectedProductFamily != null
                      ? () => AppTextStyle.default_16
                      : () => AppTextStyle.hint_16,
                  iconType: InputIconType.SELECT,
                  isNotInsertAll: p.bodyMap?['isFamilyNotUseAll'] != null &&
                          p.bodyMap!['isFamilyNotUseAll']
                      ? true
                      : null,
                  iconColor: AppColors.textFieldUnfoucsColor,
                  commononeCellDataCallback: p.getProductFamily,
                  oneCellType: OneCellType.SEARCH_PRODUCT_FAMILY,
                  isSelectedStrCallBack: (str) => p.setProductsFamily(str),
                  hintText: selectedProductFamily != null
                      ? selectedProductFamily
                      : '${tr('plz_select_something_1', args: [
                              tr('product_family'),
                              ''
                            ])}');
            }),
        defaultSpacing(),
        Selector<BasePopupSearchProvider, String?>(
            selector: (context, provider) => provider.selectedSalesGroup,
            builder: (context, salesGroup, _) {
              return BaseInputWidget(
                  context: context,
                  width: (AppSize.defaultContentsWidth - AppSize.padding * 2),
                  enable: false,
                  bgColor: CheckSuperAccount.isMultiAccount()
                      ? null
                      : AppColors.unReadySigninBg,
                  hintTextStyleCallBack: salesGroup != null
                      ? () => CheckSuperAccount.isMultiAccount()
                          ? AppTextStyle.default_16
                          : AppTextStyle.hint_16
                      : () => AppTextStyle.hint_16,
                  // hintTextStyleCallBack: () => AppTextStyle.hint_16,
                  iconType: CheckSuperAccount.isMultiAccount()
                      ? InputIconType.SELECT
                      : null,
                  // iconType: null,
                  iconColor: AppColors.textFieldUnfoucsColor,
                  isNotInsertAll: p.bodyMap?['isSalseGroupNotUseAll'] != null &&
                          p.bodyMap!['isSalseGroupNotUseAll']
                      ? true
                      : null,
                  commononeCellDataCallback: p.getSalesGroup,
                  oneCellType: CheckSuperAccount.isMultiAccount()
                      ? OneCellType.SEARCH_BUSINESS_GROUP
                      : OneCellType.DO_NOTHING,
                  // oneCellType: OneCellType.DO_NOTHING,
                  isSelectedStrCallBack: (str) => p.setSalesGroup(str),
                  hintText: CheckSuperAccount.isMultiAccount()
                      ? salesGroup != null
                          ? salesGroup
                          : '${tr('plz_select_something_1', args: [
                                  tr('salse_group'),
                                  ''
                                ])}'
                      : CacheService.getEsLogin()!.dptnm);
            }),
        defaultSpacing(),
        Selector<BasePopupSearchProvider, Tuple2<EtStaffListModel?, String?>>(
            selector: (context, provider) => Tuple2(
                provider.selectedSalesPerson, provider.selectedSalesGroup),
            builder: (context, tuple, _) {
              return BaseInputWidget(
                context: context,
                bgColor: CheckSuperAccount.isMultiAccountOrLeaderAccount()
                    ? null
                    : AppColors.unReadySigninBg,
                width: (AppSize.defaultContentsWidth - AppSize.padding * 2),
                iconType: CheckSuperAccount.isMultiAccountOrLeaderAccount()
                    ? InputIconType.SEARCH
                    : null,
                iconColor: AppColors.textFieldUnfoucsColor,
                hintText: tuple.item1 != null
                    ? tuple.item1!.sname
                    : '${tr('plz_select_something_2', args: [
                            tr('manager'),
                            ''
                          ])}(*)',
                // ?????? ?????? ??? ??????????????? ????????????.
                isShowDeleteForHintText:
                    CheckSuperAccount.isMultiAccountOrLeaderAccount() &&
                            tuple.item1 != null &&
                            tuple.item1 != tr('all')
                        ? true
                        : false,
                deleteIconCallback: () => p.setSalesPerson(null),
                hintTextStyleCallBack: tuple.item1 != null
                    ? () => CheckSuperAccount.isMultiAccountOrLeaderAccount()
                        ? AppTextStyle.default_16
                        : AppTextStyle.hint_16
                    : () => AppTextStyle.hint_16,
                popupSearchType:
                    CheckSuperAccount.isMultiAccountOrLeaderAccount()
                        ? PopupSearchType.SEARCH_SALSE_PERSON
                        : null,
                isSelectedStrCallBack: (persion) {
                  return p.setSalesPerson(persion);
                },
                bodyMap: {
                  'dptnm': CheckSuperAccount.isMultiAccount() &&
                          tuple.item2 == tr('all')
                      ? ''
                      : CheckSuperAccount.isMultiAccount()
                          ? tuple.item2
                          : CacheService.getEsLogin()!.dptnm
                },
                enable: false,
              );
            }),
        defaultSpacing(),
        Selector<BasePopupSearchProvider, String?>(
            selector: (context, provider) => provider.customerInputText,
            builder: (context, customerInputText, _) {
              return BaseInputWidget(
                  context: context,
                  width: (AppSize.defaultContentsWidth - AppSize.padding * 2),
                  enable: true,
                  hintTextStyleCallBack:
                      _customerInputController.text.isNotEmpty
                          ? null
                          : () => AppTextStyle.hint_16,
                  iconType: _customerInputController.text.isNotEmpty
                      ? InputIconType.DELETE
                      : null,
                  onChangeCallBack: (e) => p.setCustomerInputText(e),
                  iconColor: AppColors.textFieldUnfoucsColor,
                  defaultIconCallback: () {
                    p.setCustomerInputText(null);
                    _customerInputController.text = '';
                  },
                  textEditingController: _customerInputController,
                  hintText: _customerInputController.text.isNotEmpty
                      ? _customerInputController.text
                      : '${tr('plz_enter_search_key_for_something_1', args: [
                              '${tr('customer_name')}',
                              '(*)'
                            ])}');
            }),
        defaultSpacing(),
        AppStyles.buildSearchButton(context, tr('search'), () {
          hideKeyboard(context);
          final p = context.read<BasePopupSearchProvider>();
          if (p.selectedSalesPerson == null) {
            AppToast().show(context, tr('select_manager'));
          } else if (p.customerInputText == null ||
              p.customerInputText!.isEmpty) {
            AppToast().show(context, tr('keyword_must_not_null'));
          } else {
            final tp = context.read<TimerProvider>();
            if (tp.getTimer == null ||
                (tp.isRunning != null && !tp.isRunning!)) {
              tp.perdict(p.refresh().then((value) => hideKeyboard(context)));
            }
          }
        }, doNotWithPadding: true),
      ],
    ));
  }

  Widget _buildMateRialSearchBar(BuildContext context) {
    final p = context.read<BasePopupSearchProvider>();
    return Expanded(
        child: Column(
      children: [
        defaultSpacing(),
        Selector<BasePopupSearchProvider, String?>(
            selector: (context, provider) => provider.selectedProductFamily,
            builder: (context, itemType, _) {
              return BaseInputWidget(
                  context: context,
                  bgColor: AppColors.unReadySigninBg,
                  width: (AppSize.defaultContentsWidth - AppSize.padding * 2),
                  enable: false,
                  hintTextStyleCallBack: () => AppTextStyle.hint_16,
                  // iconType: InputIconType.SELECT,
                  iconColor: AppColors.textFieldUnfoucsColor,
                  commononeCellDataCallback: p.getMateralItemType,
                  // oneCellType: OneCellType.SEARCH_PRODUCT_FAMILY,
                  oneCellType: OneCellType.DO_NOTHING,
                  isSelectedStrCallBack: (str) => p.setProductsFamily(str),
                  hintText: itemType != null
                      ? itemType
                      : '${tr('plz_select_something_1', args: [
                              '${tr('product_family')}',
                              '(*)'
                            ])}');
            }),
        defaultSpacing(),
        Selector<BasePopupSearchProvider, String?>(
            selector: (context, provider) => provider.seletedMaterialSearchKey,
            builder: (context, key, _) {
              return BaseInputWidget(
                context: context,
                textEditingController: _materialQuantityInputController,
                width: (AppSize.defaultContentsWidth - AppSize.padding * 2),
                iconType: _materialQuantityInputController.text.isNotEmpty
                    ? InputIconType.DELETE
                    : null,
                defaultIconCallback: () {
                  p.setMeatrialSearchKeyInputText(null);
                  _materialQuantityInputController.text = '';
                },
                hintText: _materialQuantityInputController.text.isNotEmpty
                    ? _materialQuantityInputController.text
                    : '${tr('plz_enter_search_key_for_something_2', args: [
                            '${tr('search_by_keywords')}',
                            ''
                          ])}',
                hintTextStyleCallBack:
                    _materialQuantityInputController.text.isNotEmpty
                        ? null
                        : () => AppTextStyle.hint_16,
                onChangeCallBack: (t) => p.setMeatrialSearchKeyInputText(t),
                enable: true,
              );
            }),
        defaultSpacing(),
        AppStyles.buildSearchButton(context, tr('search'), () {
          final p = context.read<BasePopupSearchProvider>();
          if (p.seletedMaterialSearchKey == null) {
            AppToast().show(context, tr('keyword_must_not_null'));
          } else if (p.selectedProductFamily == null) {
            AppToast().show(context,
                tr('plz_select_something_1', args: [tr('product_family')]));
          } else {
            final tp = context.read<TimerProvider>();
            if (tp.getTimer == null ||
                (tp.isRunning != null && !tp.isRunning!)) {
              tp.perdict(p.refresh());
            }
          }
        }, doNotWithPadding: true),
      ],
    ));
  }

  Widget _buildEndCustomerAndSupplierBar(
      BuildContext context, bool isSupplier) {
    final p = context.read<BasePopupSearchProvider>();
    return Column(
      children: [
        defaultSpacing(),
        Selector<BasePopupSearchProvider, String?>(
            selector: (context, provider) => provider.endCustomerInputText,
            builder: (context, endCustomer, _) {
              return BaseInputWidget(
                  context: context,
                  width: AppSize.defaultContentsWidth - AppSize.padding * 2,
                  enable: true,
                  hintTextStyleCallBack: _personInputController.text.isNotEmpty
                      ? null
                      : () => AppTextStyle.hint_16,
                  iconType: _personInputController.text.isNotEmpty
                      ? InputIconType.DELETE_AND_SEARCH
                      : InputIconType.SEARCH,
                  onChangeCallBack: (e) => p.setEndCustomerInputText(e),
                  iconColor: AppColors.textFieldUnfoucsColor,
                  defaultIconCallback: () {
                    hideKeyboard(context);
                    final tp = context.read<TimerProvider>();
                    if (tp.getTimer == null ||
                        (tp.isRunning != null && !tp.isRunning!)) {
                      tp.perdict(p.refresh());
                    }
                  },
                  textEditingController: _personInputController,
                  otherIconcallback: () {
                    p.setEndCustomerInputText(null);
                    _personInputController.text = '';
                  },
                  hintText: _personInputController.text.isNotEmpty
                      ? _personInputController.text
                      : '${tr('plz_enter_search_key_for_something_1', args: [
                              isSupplier
                                  ? '${tr('end_customer')}'
                                  : '${tr('supplier')}',
                              ''
                            ])}');
            })
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    pr('buildBar');
    return Container(
      height: widget.type.appBarHeight + 1.5,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: AppSize.padding),
            alignment: Alignment.centerLeft,
            height: AppSize.buttonHeight,
            width: AppSize.updatePopupWidth,
            child: AppText.text(widget.type.popupStrListType[0].title,
                style: AppTextStyle.w500_18),
          ),
          Divider(
            height: 1,
            color: AppColors.textGrey,
          ),
          widget.type == PopupSearchType.SEARCH_SALSE_PERSON ||
                  widget.type ==
                      PopupSearchType.SEARCH_SALSE_PERSON_FOR_ACTIVITY
              ? _buildPersonSearchBar(context)
              : widget.type == PopupSearchType.SEARCH_CUSTOMER
                  ? _buildCustomerSearchBar(context)
                  : widget.type == PopupSearchType.SEARCH_SALLER ||
                          widget.type ==
                              PopupSearchType.SEARCH_SALLER_FOR_BULK_ORDER
                      ? _buildSallerSearchBar(context)
                      : widget.type == PopupSearchType.SEARCH_END_CUSTOMER ||
                              widget.type == PopupSearchType.SEARCH_SUPPLIER
                          ? _buildEndCustomerAndSupplierBar(context,
                              widget.type == PopupSearchType.SEARCH_SUPPLIER)
                          : widget.type == PopupSearchType.SEARCH_KEY_MAN
                              ? _buildKeyManSearchBar(context)
                              : widget.type ==
                                      PopupSearchType.SEARCH_SUGGETION_ITEM
                                  ? _buildSuggetionItemSearchBar(context)
                                  : widget.type ==
                                          PopupSearchType.SEARCH_MATERIAL
                                      ? _buildMateRialSearchBar(context)
                                      : Container(),
          Divider(height: 0.5)
        ],
      ),
    );
  }

  Widget _buildListViewContents(BuildContext context) {
    final p = context.read<BasePopupSearchProvider>();
    return FutureBuilder<ResultModel>(
        future: p.onSearch(widget.type.popupStrListType[0], false,
            bodyMaps: widget.bodyMap),
        builder: (context, snapshot) {
          return Consumer<BasePopupSearchProvider>(
              builder: (context, provider, _) {
            return (provider.staList != null &&
                        provider.staList!.staffList != null &&
                        provider.staList!.staffList!.isNotEmpty) ||
                    (provider.etKunnrResponseModel != null &&
                        provider.etKunnrResponseModel!.etKunnr != null &&
                        provider.etKunnrResponseModel!.etKunnr!.isNotEmpty) ||
                    (provider.etCustomerResponseModel != null &&
                        provider.etCustomerResponseModel!.etCustomer != null &&
                        provider
                            .etCustomerResponseModel!.etCustomer!.isNotEmpty) ||
                    (provider.etEndCustomerOrSupplierResponseModel != null &&
                        provider.etEndCustomerOrSupplierResponseModel!
                                .etCustList !=
                            null &&
                        provider.etEndCustomerOrSupplierResponseModel!
                            .etCustList!.isNotEmpty) ||
                    (provider.keyManResponseModel != null &&
                        provider.keyManResponseModel!.etList != null &&
                        provider.keyManResponseModel!.etList!.isNotEmpty) ||
                    (provider.suggetionResponseModel != null &&
                        provider.suggetionResponseModel!.etOutput != null &&
                        provider
                            .suggetionResponseModel!.etOutput!.isNotEmpty) ||
                    (provider.metarialResponseModel != null &&
                        provider.metarialResponseModel!.etOutput != null &&
                        provider.metarialResponseModel!.etOutput!.isNotEmpty)
                ? RefreshIndicator(
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                          top: AppSize.padding,
                          left: AppSize.padding,
                          right: AppSize.padding,
                          bottom: AppSize.buttonHeight),
                      controller: _scrollController
                        ..addListener(() {
                          if (_scrollController.offset ==
                                  _scrollController.position.maxScrollExtent &&
                              !provider.isLoadData &&
                              provider.hasMore) {
                            final nextPageProvider =
                                context.read<NextPageLoadingProvider>();
                            nextPageProvider.show();
                            provider
                                .nextPage()
                                .then((_) => nextPageProvider.stop());
                          }
                        }),
                      shrinkWrap: true,
                      itemCount: widget.type ==
                                  PopupSearchType.SEARCH_SALSE_PERSON ||
                              widget.type ==
                                  PopupSearchType
                                      .SEARCH_SALSE_PERSON_FOR_ACTIVITY
                          ? provider.staList!.staffList!.length
                          : widget.type == PopupSearchType.SEARCH_CUSTOMER
                              ? provider.etKunnrResponseModel!.etKunnr!.length
                              : widget.type == PopupSearchType.SEARCH_SALLER ||
                                      widget.type ==
                                          PopupSearchType
                                              .SEARCH_SALLER_FOR_BULK_ORDER
                                  ? provider.etCustomerResponseModel!
                                      .etCustomer!.length
                                  : widget.type ==
                                              PopupSearchType
                                                  .SEARCH_END_CUSTOMER ||
                                          widget.type ==
                                              PopupSearchType.SEARCH_SUPPLIER
                                      ? provider
                                          .etEndCustomerOrSupplierResponseModel!
                                          .etCustList!
                                          .length
                                      : widget.type ==
                                              PopupSearchType.SEARCH_KEY_MAN
                                          ? provider.keyManResponseModel!
                                              .etList!.length
                                          : widget.type ==
                                                  PopupSearchType
                                                      .SEARCH_SUGGETION_ITEM
                                              ? provider.suggetionResponseModel!
                                                  .etOutput!.length
                                              : widget.type ==
                                                      PopupSearchType
                                                          .SEARCH_MATERIAL
                                                  ? provider
                                                      .metarialResponseModel!
                                                      .etOutput!
                                                      .length
                                                  : 0,
                      itemBuilder: (BuildContext context, int index) {
                        return widget.type == PopupSearchType.SEARCH_SALSE_PERSON ||
                                widget.type ==
                                    PopupSearchType
                                        .SEARCH_SALSE_PERSON_FOR_ACTIVITY
                            ? _buildPersonContentsItem(
                                context,
                                provider.staList!.staffList![index],
                                index,
                                !provider.hasMore &&
                                    index ==
                                        provider.staList!.staffList!.length - 1)
                            : widget.type == PopupSearchType.SEARCH_CUSTOMER
                                ? _buildCustomerContentsItem(
                                    context,
                                    provider
                                        .etKunnrResponseModel!.etKunnr![index],
                                    index,
                                    !provider.hasMore &&
                                        index ==
                                            provider.etKunnrResponseModel!
                                                    .etKunnr!.length -
                                                1)
                                : widget.type == PopupSearchType.SEARCH_SALLER ||
                                        widget.type ==
                                            PopupSearchType
                                                .SEARCH_SALLER_FOR_BULK_ORDER
                                    ? _buildSallerContentsItem(
                                        context,
                                        provider.etCustomerResponseModel!
                                            .etCustomer![index],
                                        index,
                                        !provider.hasMore &&
                                            index ==
                                                provider.etCustomerResponseModel!
                                                        .etCustomer!.length -
                                                    1)
                                    : widget.type == PopupSearchType.SEARCH_END_CUSTOMER ||
                                            widget.type ==
                                                PopupSearchType.SEARCH_SUPPLIER
                                        ? _buildEndCustomerContentsItem(
                                            context,
                                            provider
                                                .etEndCustomerOrSupplierResponseModel!
                                                .etCustList![index],
                                            index,
                                            !provider.hasMore &&
                                                index == provider.etEndCustomerOrSupplierResponseModel!.etCustList!.length - 1)
                                        : widget.type == PopupSearchType.SEARCH_KEY_MAN
                                            ? _buildKeymanContentsItem(context, provider.keyManResponseModel!.etList![index], index, !provider.hasMore && index == provider.keyManResponseModel!.etList!.length - 1)
                                            : widget.type == PopupSearchType.SEARCH_SUGGETION_ITEM
                                                ? _buildSuggetionContentsItem(context, provider.suggetionResponseModel!.etOutput![index], index, !provider.hasMore && index == provider.suggetionResponseModel!.etOutput!.length - 1)
                                                : widget.type == PopupSearchType.SEARCH_MATERIAL
                                                    ? _buildMaterialContentsItem(context, provider.metarialResponseModel!.etOutput![index], index, !provider.hasMore && index == provider.metarialResponseModel!.etOutput!.length - 1)
                                                    : Container();
                      },
                    ),
                    // ?????? ! nextPage ->  refresh
                    onRefresh: () => provider.refresh())
                : provider.isLoadData
                    ? Container(
                        height: widget.type.height -
                            AppSize.buttonHeight -
                            widget.type.appBarHeight,
                        child: Padding(
                          padding: AppSize.defaultSidePadding,
                          child: DefaultShimmer.buildDefaultPopupShimmer(),
                        ),
                      )
                    : Container(
                        child: Center(
                          child: AppText.listViewText(
                              widget.type == PopupSearchType.SEARCH_SALLER
                                  ? provider.isShhowNotResultText == null ||
                                          !provider.isShhowNotResultText!
                                      ? ''
                                      : tr('no_data')
                                  : provider.isShhowNotResultText == null
                                      ? ''
                                      : tr('no_data')),
                        ),
                      );
          });
        });
  }

  Widget _buildPersonContentsItem(BuildContext context, EtStaffListModel model,
      int index, bool isShowLastPageText) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, model);
      },
      child: Padding(
        padding:
            index == 0 ? EdgeInsets.all(0) : AppSize.searchPopupListPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.text(
                    '${model.sname} ${model.levelcdnm!.trim().isEmpty ? '' : '(${model.levelcdnm!})'} ',
                    style: AppTextStyle.h3,
                    textAlign: TextAlign.start),
                AppText.text('${model.dptnm}', style: AppTextStyle.h5)
              ],
            ),
            isShowLastPageText ? lastPageText() : Container()
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerContentsItem(BuildContext context, EtKunnrModel model,
      int index, bool isShowLastPageText) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, model);
      },
      child: Padding(
          padding:
              index == 0 ? EdgeInsets.all(0) : AppSize.searchPopupListPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<List<String>?>(
                      future: HiveService.getCustomerType(model.zstatus!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          return AppText.listViewText(
                              '${model.name} (${(snapshot.data == null || snapshot.data!.isEmpty) ? '-' : snapshot.data!.single})',
                              maxLines: 2);
                        }
                        return Container();
                      }),
                  AppText.listViewText('${model.zaddName1}',
                      maxLines: 2, isSubTitle: true),
                  AppText.text('${model.telf1}',
                      style:
                          AppTextStyle.h5.copyWith(color: AppColors.subText)),
                ],
              ),
              isShowLastPageText ? lastPageText() : Container()
            ],
          )),
    );
  }

  Widget _buildSallerContentsItem(BuildContext context, EtCustomerModel model,
      int index, bool isShowLastPageText) {
    final p = context.read<BasePopupSearchProvider>();
    return InkWell(
      onTap: () async {
        Navigator.pop(
          context,
          {
            'model': model,
            'staff': p.selectedSalesPerson,
            'product_family': p.selectedProductFamily ?? '',
            'sales_group': p.selectedSalesGroup
          },
        );
      },
      child: Padding(
          padding: AppSize.searchPopupListPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.listViewText('${model.kunnrNm!} (${model.kunnr})',
                      textAlign: TextAlign.start, maxLines: 2),
                  AppText.listViewText('${model.ort01} ${model.stras}',
                      isSubTitle: true,
                      maxLines: 2,
                      textAlign: TextAlign.start),
                  Row(
                    children: [
                      model.telf1 != null && model.telf1!.isNotEmpty
                          ? AppText.listViewText('${model.telf1}',
                              isSubTitle: true)
                          : Container(),
                      model.stcd2 != null && model.stcd2!.isNotEmpty
                          ? AppStyles.buildPipe()
                          : Container(),
                      AppText.listViewText('${model.stcd2}', isSubTitle: true),
                    ],
                  )
                ],
              ),
              isShowLastPageText ? lastPageText() : Container()
            ],
          )),
    );
  }

  Widget _buildEndCustomerContentsItem(BuildContext context,
      EtCustListModel model, int index, bool isShowLastPageText) {
    final p = context.read<BasePopupSearchProvider>();
    return InkWell(
      onTap: () {
        Navigator.pop(context, model);
      },
      child: Padding(
          padding:
              index == 0 ? EdgeInsets.all(0) : AppSize.searchPopupListPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Selector<BasePopupSearchProvider, bool?>(
                  selector: (context, provider) => provider.isSingleData,
                  builder: (context, isSingleData, _) {
                    isSingleData != null && isSingleData
                        ? Navigator.pop(
                            context,
                            p.etEndCustomerOrSupplierResponseModel!.etCustList!
                                .single)
                        : DoNothingAction();
                    return Container();
                  }),
              AppText.listViewText('${model.kunnrNm!} (${model.kunnr})',
                  maxLines: 2),
              AppText.listViewText('${model.ort01} ${model.stras}',
                  isSubTitle: true, maxLines: 2),
              Row(
                children: [
                  model.telf1 != null && model.telf1!.isNotEmpty
                      ? AppText.listViewText('${model.telf1}', isSubTitle: true)
                      : Container(),
                  model.telf1 != null && model.telf1!.isNotEmpty
                      ? AppStyles.buildPipe()
                      : Container(),
                  AppText.listViewText('${model.ort01}', isSubTitle: true),
                ],
              ),
              isShowLastPageText ? lastPageText() : Container()
            ],
          )),
    );
  }

  Widget _buildKeymanContentsItem(BuildContext context,
      AddActivityKeyManModel model, int index, bool isShowLastPageText) {
    final p = context.read<BasePopupSearchProvider>();
    return InkWell(
      onTap: () {
        Navigator.pop(context, model);
      },
      child: Padding(
          padding: index == 0
              ? AppSize.searchPopupListPadding.copyWith(top: 0)
              : AppSize.searchPopupListPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Selector<BasePopupSearchProvider, bool?>(
                  selector: (context, provider) => provider.isSingleData,
                  builder: (context, isSingleData, _) {
                    isSingleData != null && isSingleData
                        ? Navigator.pop(
                            context,
                            p.etEndCustomerOrSupplierResponseModel!.etCustList!
                                .single)
                        : DoNothingAction();
                    return Container();
                  }),
              AppText.listViewText(model.zkmnoNm!),
              SizedBox(width: AppSize.defaultShimmorSpacing),
              AppText.listViewText('${model.zskunnrNm!}/${model.zskunnr!}',
                  maxLines: 2, isSubTitle: true),
              isShowLastPageText ? lastPageText() : Container()
            ],
          )),
    );
  }

  Widget _buildSuggetionContentsItem(BuildContext context,
      AddActivitySuggetionItemModel model, int index, bool isShowLastPageText) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, model);
      },
      child: Padding(
          padding: index == 0
              ? AppSize.searchPopupListPadding.copyWith(top: 0)
              : AppSize.searchPopupListPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppText.listViewText(
                  model.maktx != null
                      ? '${model.maktx!}${model.wgbez != null ? '(${model.wgbez})' : ''}'
                      : '',
                  style: AppTextStyle.h4.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  textAlign: TextAlign.start),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppText.listViewText(model.matnr ?? '',
                      style: AppTextStyle.sub_12),
                  model.kbetr2!.trim().isNotEmpty
                      ? AppStyles.buildPipe()
                      : Container(),
                  model.kbetr2!.trim().isNotEmpty
                      ? AppText.listViewText(
                          FormatUtil.addComma(model.kbetr2!.trim()),
                          style: AppTextStyle.sub_12)
                      : Container(),
                ],
              ),
              isShowLastPageText ? lastPageText() : Container()
            ],
          )),
    );
  }

  Widget _buildMaterialContentsItem(BuildContext context,
      OrderManagerMaterialModel model, int index, bool isShowLastPageText) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, model);
      },
      child: Padding(
          padding: index == 0
              ? AppSize.searchPopupListPadding.copyWith(top: 0)
              : AppSize.searchPopupListPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppText.listViewText(
                  model.maktx != null
                      ? '${model.maktx!}${model.wgbez != null ? '(${model.wgbez})' : ''}'
                      : '',
                  style: AppTextStyle.h4.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  textAlign: TextAlign.start),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppText.listViewText(model.matnr ?? '',
                      style: AppTextStyle.sub_12),
                  model.kbetr2!.trim().isNotEmpty
                      ? AppStyles.buildPipe()
                      : Container(),
                  model.kbetr2!.trim().isNotEmpty
                      ? AppText.listViewText(
                          FormatUtil.addComma(model.kbetr2!.trim()),
                          style: AppTextStyle.sub_12)
                      : Container(),
                ],
              ),
              isShowLastPageText ? lastPageText() : Container()
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BasePopupSearchProvider()),
        ChangeNotifierProvider(create: (context) => NextPageLoadingProvider()),
      ],
      builder: (context, _) {
        pr('build page');
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(AppSize.radius8))),
          width: AppSize.updatePopupWidth,
          height: widget.type.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSearchBar(context),
                  Expanded(child: _buildListViewContents(context))
                ],
              ),
              Positioned(
                  left: 0,
                  bottom: AppSize.buttonHeight / 2,
                  child: Container(
                      width: AppSize.defaultContentsWidth,
                      child: Padding(
                          padding:
                              EdgeInsets.only(bottom: AppSize.appBarHeight / 2),
                          child: NextPageLoadingWdiget.build(context)))),
              Positioned(
                  left: 0,
                  bottom: 0,
                  child: InkWell(
                    onTap: () {
                      final p = context.read<BasePopupSearchProvider>();
                      Navigator.pop(
                          context,
                          widget.type == PopupSearchType.SEARCH_SALLER ||
                                  widget.type ==
                                      PopupSearchType
                                          .SEARCH_SALLER_FOR_BULK_ORDER
                              ? {
                                  'staff': p.selectedSalesPerson,
                                  'product_family': p.selectedProductFamily ??
                                      p.bodyMap?['product_family'],
                                }
                              : null);
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(AppSize.radius15),
                            bottomRight: Radius.circular(AppSize.radius15)),
                        child: Container(
                            alignment: Alignment.center,
                            width: AppSize.defaultContentsWidth,
                            height: AppSize.buttonHeight,
                            decoration: BoxDecoration(
                                color: AppColors.whiteText,
                                border: Border(
                                    top: BorderSide(
                                        color: AppColors.tableBorderColor,
                                        width: AppSize.defaultBorderWidth))),
                            child: AppText.text(
                              widget.type.popupStrListType.first.buttonText,
                              style: AppTextStyle.default_16
                                  .copyWith(color: AppColors.primary),
                            ))),
                  ))
            ],
          ),
        );
      },
    );
  }
}
