/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_popup_search.dart
 * Created Date: 2021-09-11 00:27:49
 * Last Modified: 2022-07-12 17:37:47
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
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/view/common/base_shimmer.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/model/rfc/et_kunnr_model.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/model/rfc/et_customer_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_null_data.dart';
import 'package:medsalesportal/view/common/widget_of_last_page_text.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_next_page_loading.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';
import 'package:medsalesportal/globalProvider/next_page_loading_provider.dart';
import 'package:medsalesportal/view/common/provider/base_popup_search_provider.dart';

class BasePopupSearch {
  final PopupSearchType? type;
  final Map<String, dynamic>? bodyMap;
  BasePopupSearch({required this.type, this.bodyMap});

  Future<dynamic> show(BuildContext context) async {
    final result = await AppDialog.showPopup(
        context,
        type == PopupSearchType.SEARCH_SALSE_PERSON ||
                type == PopupSearchType.SEARCH_CUSTOMER ||
                type == PopupSearchType.SEARCH_SALLER
            ? PopupSearchOneRowContents(type!, bodyMap: bodyMap)
            : PopupSearchThreeRowContents(
                type!,
                bodyMap: bodyMap,
              ));
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

class PopupSearchThreeRowContents extends StatefulWidget {
  PopupSearchThreeRowContents(this.type, {Key? key, this.bodyMap})
      : super(key: key);
  final PopupSearchType type;
  final Map<String, dynamic>? bodyMap;
  @override
  _PopupSearchThreeRowContentsState createState() =>
      _PopupSearchThreeRowContentsState();
}

class _PopupSearchThreeRowContentsState
    extends State<PopupSearchThreeRowContents> {
  TextEditingController? _plantCodeController;
  @override
  void initState() {
    super.initState();
    _plantCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _plantCodeController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BasePopupSearchProvider(),
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(AppSize.radius8))),
          width: AppSize.updatePopupWidth,
          height: widget.type.height,
          child: Stack(
            children: [
              Container(
                  height: widget.type.height - AppSize.buttonHeight,
                  child: Column(
                    children: [
                      // buildPlantSearchBar(context),
                      Expanded(
                          child:

                              // buildPlantListViewContents(context)
                              Container() // ?????
                          )
                    ],
                  )),
              Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: AppSize.defaultContentsWidth,
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: .7, color: AppColors.textGrey))),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: AppText.text(widget.type.buttonText,
                              style: AppTextStyle.color_16(AppColors.primary)),
                        )),
                  ))
            ],
          ),
        );
      },
    );
  }
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
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _personInputController = TextEditingController();
    _customerInputController = TextEditingController();
  }

  @override
  void dispose() {
    _personInputController.dispose();
    _customerInputController.dispose();
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
                  hintTextStyleCallBack: personInputText != null
                      ? null
                      : () => AppTextStyle.hint_16,
                  iconType: personInputText != null
                      ? InputIconType.DELETE_AND_SEARCH
                      : InputIconType.SEARCH,
                  onChangeCallBack: (e) => p.setPersonInputText(e),
                  iconColor: personInputText == null
                      ? AppColors.textFieldUnfoucsColor
                      : null,
                  defaultIconCallback: () {
                    hideKeyboard(context);
                    p.refresh();
                  },
                  textEditingController: _personInputController,
                  otherIconcallback: () {
                    p.setPersonInputText(null);
                    _personInputController.text = '';
                  },
                  hintText: personInputText != null
                      ? null
                      : '${tr('plz_enter_search_key_for_something', args: [
                              '${tr('name')}'
                            ])}');
            })
      ],
    );
  }

  Widget _buildCustomerSearchBar(BuildContext context) {
    final p = context.read<BasePopupSearchProvider>();

    return Expanded(
        child: Column(
      children: [
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
                      iconColor: selectedProductCategory == null
                          ? AppColors.textFieldUnfoucsColor
                          : null,
                      commononeCellDataCallback: p.getProductCategory,
                      oneCellType: OneCellType.SEARCH_PRODUCTS_CATEGORY,
                      isSelectedStrCallBack: (str) =>
                          p.setProductsCategory(str),
                      hintText: selectedProductCategory != null
                          ? selectedProductCategory
                          : '${tr('plz_select_something', args: [
                                  tr('products_category')
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
                      iconColor: selectedProductFamily == null
                          ? AppColors.textFieldUnfoucsColor
                          : null,
                      commononeCellDataCallback: p.getProductFamily,
                      oneCellType: OneCellType.SEARCH_PRODUCT_FAMILY,
                      isSelectedStrCallBack: (str) => p.setProductsFamily(str),
                      hintText: selectedProductFamily != null
                          ? selectedProductFamily
                          : '${tr('plz_select_something', args: [
                                  tr('product_family')
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
                      hintTextStyleCallBack: customerInputText != null
                          ? null
                          : () => AppTextStyle.hint_16,
                      iconType: customerInputText != null
                          ? InputIconType.DELETE
                          : null,
                      onChangeCallBack: (e) => p.setCustomerInputText(e),
                      iconColor: customerInputText == null
                          ? AppColors.textFieldUnfoucsColor
                          : null,
                      defaultIconCallback: () {
                        p.setCustomerInputText(null);
                        _customerInputController.text = '';
                      },
                      textEditingController: _customerInputController,
                      hintText: customerInputText != null
                          ? null
                          : '${tr('plz_enter_search_key_for_something', args: [
                                  '${tr('customer_name')}',
                                  '*'
                                ])}');
                }),
          ],
        ),
        defaultSpacing(),
        AppStyles.buildSearchButton(context, tr('search'), () {
          final p = context.read<BasePopupSearchProvider>();
          if (p.customerInputText == null || p.customerInputText!.length < 2) {
            AppToast().show(context, tr('keyword_must_greater_than_two'));
          } else {
            p.refresh();
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
                  iconColor: selectedProductFamily == null
                      ? AppColors.textFieldUnfoucsColor
                      : null,
                  commononeCellDataCallback: p.getProductFamily,
                  oneCellType: OneCellType.SEARCH_PRODUCT_FAMILY,
                  isSelectedStrCallBack: (str) => p.setProductsFamily(str),
                  hintText: selectedProductFamily != null
                      ? selectedProductFamily
                      : '${tr('plz_select_something', args: [
                              tr('product_family')
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
                  // hintTextStyleCallBack: salesGroup != null
                  //     ? () => AppTextStyle.default_16
                  //     : () => AppTextStyle.hint_16,
                  hintTextStyleCallBack: () => AppTextStyle.hint_16,
                  // iconType: InputIconType.SELECT,
                  iconType: null,
                  iconColor: salesGroup == null
                      ? AppColors.textFieldUnfoucsColor
                      : null,
                  // commononeCellDataCallback: p.getSalesGroup,
                  // oneCellType: OneCellType.SEARCH_BUSINESS_GROUP,
                  oneCellType: OneCellType.DO_NOTHING,
                  // isSelectedStrCallBack: (str) => p.setSalesGroup(str),
                  hintText: salesGroup != null
                      ? salesGroup
                      : '${tr('plz_select_something', args: [
                              tr('salse_group')
                            ])}');
            }),
        defaultSpacing(),
        Selector<BasePopupSearchProvider, Tuple2<bool, String?>>(
            selector: (context, provider) =>
                Tuple2(provider.isTeamLeader, provider.staffName),
            builder: (context, tuple, _) {
              return BaseInputWidget(
                context: context,
                width: (AppSize.defaultContentsWidth - AppSize.padding * 2),
                iconType: tuple.item1 ? InputIconType.SEARCH : null,
                iconColor: tuple.item2 != null
                    ? AppColors.defaultText
                    : AppColors.textFieldUnfoucsColor,
                hintText: tuple.item2 ?? tr('plz_select'),
                // 팀장 일때 만 팀원선택후 삭제가능.
                isShowDeleteForHintText: tuple.item1 &&
                        tuple.item2 != null &&
                        tuple.item2 != tr('all')
                    ? true
                    : false,
                deleteIconCallback: () => tuple.item1
                    ? p.setStaffName(tr('all'))
                    : p.setStaffName(null),
                hintTextStyleCallBack: () => tuple.item1 && tuple.item2 != null
                    ? AppTextStyle.default_16
                    : AppTextStyle.hint_16,
                popupSearchType:
                    tuple.item1 ? PopupSearchType.SEARCH_SALSE_PERSON : null,
                isSelectedStrCallBack: (persion) {
                  return p.setSalesPerson(persion);
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
                  hintTextStyleCallBack: customerInputText != null
                      ? null
                      : () => AppTextStyle.hint_16,
                  iconType:
                      customerInputText != null ? InputIconType.DELETE : null,
                  onChangeCallBack: (e) => p.setCustomerInputText(e),
                  iconColor: customerInputText == null
                      ? AppColors.textFieldUnfoucsColor
                      : null,
                  defaultIconCallback: () {
                    p.setCustomerInputText(null);
                    _customerInputController.text = '';
                  },
                  textEditingController: _customerInputController,
                  hintText: customerInputText != null
                      ? null
                      : '${tr('plz_enter_search_key_for_something', args: [
                              '${tr('customer_name')}',
                              '*'
                            ])}');
            }),
        defaultSpacing(),
        AppStyles.buildSearchButton(context, tr('search'), () {
          final p = context.read<BasePopupSearchProvider>();
          if (p.customerInputText == null || p.customerInputText!.length < 2) {
            AppToast().show(context, tr('keyword_must_greater_than_two'));
          } else {
            p.refresh();
          }
        }, doNotWithPadding: true),
      ],
    ));
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: widget.type.appBarHeight,
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
          widget.type == PopupSearchType.SEARCH_CUSTOMER ||
                  widget.type == PopupSearchType.SEARCH_SALLER
              ? defaultSpacing()
              : Container(),
          // Padding(
          //     padding: EdgeInsets.only(top: AppSize.searchBarTitleSidePadding)),
          widget.type == PopupSearchType.SEARCH_SALSE_PERSON
              ? _buildPersonSearchBar(context)
              : widget.type == PopupSearchType.SEARCH_CUSTOMER
                  ? _buildCustomerSearchBar(context)
                  : widget.type == PopupSearchType.SEARCH_SALLER
                      ? _buildSallerSearchBar(context)
                      : Container(),
        ],
      ),
    );
  }

  Widget _buildListViewContents(BuildContext context) {
    final p = context.read<BasePopupSearchProvider>();

    return FutureBuilder<BasePoupSearchResult>(
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
                            .etCustomerResponseModel!.etCustomer!.isNotEmpty)
                ? Padding(
                    padding: AppSize.defaultSearchPopupSidePadding,
                    child: Container(
                        child: RefreshIndicator(
                            child: ListView.builder(
                              controller: _scrollController
                                ..addListener(() {
                                  if (_scrollController.offset ==
                                          _scrollController
                                              .position.maxScrollExtent &&
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
                              padding:
                                  EdgeInsets.only(bottom: AppSize.appBarHeight),
                              itemCount: widget.type ==
                                      PopupSearchType.SEARCH_SALSE_PERSON
                                  ? provider.staList!.staffList!.length
                                  : widget.type ==
                                          PopupSearchType.SEARCH_CUSTOMER
                                      ? provider
                                          .etKunnrResponseModel!.etKunnr!.length
                                      : widget.type ==
                                              PopupSearchType.SEARCH_SALLER
                                          ? provider.etCustomerResponseModel!
                                              .etCustomer!.length
                                          : 0,
                              itemBuilder: (BuildContext context, int index) {
                                return widget.type ==
                                        PopupSearchType.SEARCH_SALSE_PERSON
                                    ? _buildPersonContentsItem(
                                        context,
                                        provider.staList!.staffList![index],
                                        index,
                                        !provider.hasMore &&
                                            index ==
                                                provider.staList!.staffList!
                                                        .length -
                                                    1)
                                    : widget.type ==
                                            PopupSearchType.SEARCH_CUSTOMER
                                        ? _buildCustomerContentsItem(
                                            context,
                                            provider.etKunnrResponseModel!
                                                .etKunnr![index],
                                            index,
                                            !provider.hasMore &&
                                                index ==
                                                    provider.etKunnrResponseModel!
                                                            .etKunnr!.length -
                                                        1)
                                        : widget.type ==
                                                PopupSearchType.SEARCH_SALLER
                                            ? _buildSallerContentsItem(
                                                context,
                                                provider
                                                    .etCustomerResponseModel!
                                                    .etCustomer![index],
                                                index,
                                                !provider.hasMore &&
                                                    index ==
                                                        provider
                                                                .etCustomerResponseModel!
                                                                .etCustomer!
                                                                .length -
                                                            1)
                                            : Container();
                              },
                            ),
                            // 수정 ! nextPage ->  refresh
                            onRefresh: () => provider.refresh())),
                  )
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
                    : Column(
                        children: [BaseNullDataWidget.build()],
                      );
          });
        });
  }

  Widget _horizontalRow(Widget w) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: w),
    );
  }

  Widget _buildPersonContentsItem(BuildContext context, EtStaffListModel model,
      int index, bool isShowLastPageText) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, model);
      },
      child: Padding(
          padding: index == 0
              ? EdgeInsets.only(bottom: AppSize.defaultListItemSpacing)
              : AppSize.searchPopupListPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _horizontalRow(
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.text(
                            '${model.sname} (${model.levelcdnm ?? ''})',
                            style: AppTextStyle.h3),
                        AppText.text('${model.dptnm}', style: AppTextStyle.h5)
                      ],
                    ),
                  ],
                ),
              ),
              isShowLastPageText ? lastPageText() : Container()
            ],
          )),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _horizontalRow(
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<List<String>?>(
                            future: HiveService.getCustomerType(model.zstatus!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return AppText.text(
                                    '${model.name} (${snapshot.data!.single})',
                                    style: AppTextStyle.h3);
                              }
                              return AppText.text('${model.name} ()',
                                  style: AppTextStyle.h3);
                            }),
                        AppText.text('${model.zaddName1}',
                            style: AppTextStyle.h5),
                        AppText.text('${model.telf1}', style: AppTextStyle.h5),
                      ],
                    ),
                  ],
                ),
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
      onTap: () {
        Navigator.pop(
          context,
          widget.type == PopupSearchType.SEARCH_SALLER
              ? {
                  'model': model,
                  'staff': p.staffName,
                  'product_family': p.selectedProductFamily ?? ''
                }
              : null,
        );
      },
      child: Padding(
          padding:
              index == 0 ? EdgeInsets.all(0) : AppSize.searchPopupListPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _horizontalRow(
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.listViewText('${model.kunnrNm ?? ''} '),
                        AppText.listViewText('${model.ort01} ${model.stras}',
                            isSubTitle: true),
                        Row(
                          children: [
                            AppText.listViewText('${model.telf1}',
                                isSubTitle: true),
                            AppStyles.buildPipe(),
                            AppText.listViewText('${model.j1kfrepre}',
                                isSubTitle: true),
                            AppStyles.buildPipe(),
                            AppText.listViewText('${model.stcd2}',
                                isSubTitle: true),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
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
                      Navigator.pop(
                          context,
                          widget.type == PopupSearchType.SEARCH_SALLER
                              ? {
                                  'staff': context
                                      .read<BasePopupSearchProvider>()
                                      .staffName,
                                  'product_family': context
                                          .read<BasePopupSearchProvider>()
                                          .selectedProductFamily ??
                                      context
                                          .read<BasePopupSearchProvider>()
                                          .bodyMap?['product_family']
                                }
                              : null);
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(AppSize.radius8),
                            bottomRight: Radius.circular(AppSize.radius8)),
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
