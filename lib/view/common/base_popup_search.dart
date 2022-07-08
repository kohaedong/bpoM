/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_popup_search.dart
 * Created Date: 2021-09-11 00:27:49
 * Last Modified: 2022-07-08 10:18:19
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---  --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 *                        Discription                         
 * ---  --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/view/common/base_shimmer.dart';
import 'package:medsalesportal/model/rfc/et_customer_model.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_null_data.dart';
import 'package:medsalesportal/view/common/widget_of_last_page_text.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_next_page_loading.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';
import 'package:medsalesportal/globalProvider/next_page_loading_provider.dart';
import 'package:medsalesportal/globalProvider/base_popup_search_provider.dart';

class BasePopupSearch {
  final PopupSearchType? type;
  final Map<String, dynamic>? bodyMap;
  BasePopupSearch({required this.type, this.bodyMap});

  Future<dynamic> show(BuildContext context) async {
    final result = await AppDialog.showPopup(
        context,
        type == PopupSearchType.SEARCH_SALSE_PERSON ||
                type == PopupSearchType.SEARCH_CUSTOMER
            // 이페이지는 2개의 StatefulWidget이 있습니다.
            // [PopupSearchOneRowContents] 와 [PopupSearchThreeRowContents]
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

    return Expanded(
        child: Selector<BasePopupSearchProvider, String?>(
            selector: (context, provider) => provider.personInputText,
            builder: (context, personInputText, _) {
              return Builder(builder: (context) {
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
                    hintText:
                        personInputText != null ? null : '${tr('plz_enter')}');
              });
            }));
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
                  return Builder(builder: (context) {
                    return BaseInputWidget(
                        context: context,
                        width: (AppSize.defaultContentsWidth -
                            AppSize.padding * 2),
                        enable: false,
                        hintTextStyleCallBack: selectedProductCategory != null
                            ? () => AppTextStyle.default_16
                            : () => AppTextStyle.hint_16,
                        iconType: InputIconType.SELECT,
                        iconColor: selectedProductCategory == null
                            ? AppColors.textFieldUnfoucsColor
                            : null,
                        isShowDeleteForHintText:
                            selectedProductCategory != null ? true : false,
                        defaultIconCallback: () => p.setProductsCategory(null),
                        oneCellType: OneCellType.SEARCH_PRODUCTS_CATEGORY,
                        isSelectedStrCallBack: (str) =>
                            p.setProductsCategory(str),
                        hintText: selectedProductCategory != null
                            ? null
                            : '${tr('plz_enter_products_category')}');
                  });
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
                  return Builder(builder: (context) {
                    return BaseInputWidget(
                        context: context,
                        width: (AppSize.defaultContentsWidth -
                            AppSize.padding * 2),
                        enable: false,
                        hintTextStyleCallBack: selectedProductFamily != null
                            ? () => AppTextStyle.default_16
                            : () => AppTextStyle.hint_16,
                        iconType: InputIconType.SELECT,
                        iconColor: selectedProductFamily == null
                            ? AppColors.textFieldUnfoucsColor
                            : null,
                        isShowDeleteForHintText:
                            selectedProductFamily != null ? true : false,
                        defaultIconCallback: () => p.setProductsFamily(null),
                        oneCellType: OneCellType.SEARCH_PRODUCTS_CATEGORY,
                        isSelectedStrCallBack: (str) =>
                            p.setProductsFamily(str),
                        hintText: selectedProductFamily != null
                            ? null
                            : '${tr('plz_enter_products_family')}');
                  });
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
                  return Builder(builder: (context) {
                    return BaseInputWidget(
                        context: context,
                        width: (AppSize.defaultContentsWidth -
                            AppSize.padding * 2),
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
                            : '${tr('plz_enter')}');
                  });
                }),
          ],
        ),
        defaultSpacing(),
        AppStyles.buildSearchButton(context, tr('search'), () {},
            doNotWithPadding: true),
      ],
    ));
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: widget.type.appBarHeight,
      child: Column(
        children: [
          Container(
              height: AppSize.buttonHeight,
              width: AppSize.updatePopupWidth,
              child: Padding(
                  padding: EdgeInsets.only(left: AppSize.padding),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AppText.text('Title', style: AppTextStyle.w500_18),
                  ))),
          Divider(
            height: AppSize.dividerHeight,
            color: AppColors.textGrey,
          ),
          defaultSpacing(),
          // Padding(
          //     padding: EdgeInsets.only(top: AppSize.searchBarTitleSidePadding)),
          widget.type == PopupSearchType.SEARCH_SALSE_PERSON
              ? _buildPersonSearchBar(context)
              : widget.type == PopupSearchType.SEARCH_CUSTOMER
                  ? _buildCustomerSearchBar(context)
                  : Container(),
          Divider(
            color: AppColors.textGrey,
          )
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
                    (provider.etCustomerResponseModel != null &&
                        provider.etCustomerResponseModel!.etKunnr != null &&
                        provider.etCustomerResponseModel!.etKunnr!.isNotEmpty)
                ? Padding(
                    padding: AppSize.defaultSearchPopupSidePadding,
                    child: Container(
                        height: widget.type.height -
                            AppSize.buttonHeight -
                            widget.type.appBarHeight,
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
                              padding: EdgeInsets.zero,
                              itemCount: widget.type ==
                                      PopupSearchType.SEARCH_SALSE_PERSON
                                  ? provider.staList!.staffList!.length
                                  : widget.type ==
                                          PopupSearchType.SEARCH_CUSTOMER
                                      ? provider.etCustomerResponseModel!
                                          .etKunnr!.length
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
                                            provider.etCustomerResponseModel!
                                                .etKunnr![index],
                                            index,
                                            !provider.hasMore &&
                                                index ==
                                                    provider.etCustomerResponseModel!
                                                            .etKunnr!.length -
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
                    : Padding(
                        padding: AppSize.nullValueWidgetPadding,
                        child: BaseNullDataWidget.build());
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

  Widget _buildCustomerContentsItem(BuildContext context, EtCustomerModel model,
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
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSearchBar(context),
                  _buildListViewContents(context),
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
