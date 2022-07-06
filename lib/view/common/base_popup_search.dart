/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_popup_search.dart
 * Created Date: 2021-09-11 00:27:49
 * Last Modified: 2022-07-06 16:23:10
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---  --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 *                        Discription                         
 * ---  --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/globalProvider/next_page_loading_provider.dart';
import 'package:medsalesportal/globalProvider/base_popup_search_provider.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/view/common/base_shimmer.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_null_data.dart';
import 'package:medsalesportal/view/common/widget_of_last_page_text.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_next_page_loading.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';

class BasePopupSearch {
  final PopupSearchType? type;
  final Map<String, dynamic>? bodyMap;
  BasePopupSearch({required this.type, this.bodyMap});

  Future<dynamic> show(BuildContext context) async {
    final result = await AppDialog.showPopup(
        context,
        type == PopupSearchType.SEARCH_SALSE_PERSON ||
                type == PopupSearchType.SEARCH_MATERIALS

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

  Widget buildPlantSearchBar(BuildContext context) {
    final p = context.read<BasePopupSearchProvider>();

    var width = AppSize.defaultContentsWidth -
        AppSize.textFiledDefaultSpacing * 2 -
        AppSize.padding;

    return Container(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: AppSize.searchBarTitleSidePadding)),
          Selector<BasePopupSearchProvider, String?>(
            selector: (context, provider) => provider.selectedThreeRowValue1,
            builder: (context, org, _) {
              return Builder(builder: (context) {
                return BaseInputWidget(
                  context: context,
                  iconType: InputIconType.SELECT,
                  hintText: org != null ? org : '${tr('plz_select')}',
                  width: width,
                  hintTextStyleCallBack: org != null
                      ? () => AppTextStyle.default_16
                      : () => AppTextStyle.hint_16,
                  commononeCellDataCallback: p.getOrganizationFromDB,
                  oneCellType: widget.type.popupStrListType[0],
                  isSelectedStrCallBack: (str) {
                    p.setThreeRowValue1(str);
                    if (_plantCodeController != null) {
                      _plantCodeController!.text = '';
                    }
                  },
                  enable: false,
                );
              });
            },
          ),
          Padding(
              padding: EdgeInsets.only(top: AppSize.defaultListItemSpacing)),
          Selector<BasePopupSearchProvider, String?>(
            selector: (context, provider) => provider.selectedThreeRowValue2,
            builder: (context, cannel, _) {
              return Builder(builder: (context) {
                return BaseInputWidget(
                  context: context,
                  iconType: InputIconType.SELECT,
                  hintText: cannel != null ? cannel : '${tr('plz_select')}',
                  width: width,
                  hintTextStyleCallBack: cannel != null
                      ? () => AppTextStyle.default_16
                      : () => AppTextStyle.hint_16,
                  commononeCellDataCallback: p.getCirculationFromDB,
                  oneCellType: widget.type.popupStrListType[1],
                  isSelectedStrCallBack: (str) {
                    p.setThreeRowValue2(str);
                  },
                  enable: false,
                );
              });
            },
          ),
          Padding(
              padding: EdgeInsets.only(top: AppSize.defaultListItemSpacing)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Selector<BasePopupSearchProvider, String?>(
                  selector: (context, provider) =>
                      provider.selectedThreeRowValue3,
                  builder: (context, value3, _) {
                    return Builder(builder: (context) {
                      return BaseInputWidget(
                          context: context,
                          width:
                              (width - AppSize.textFiledDefaultSpacing) * .43,
                          oneCellType: widget.type.popupStrListType[2],
                          enable: false,
                          iconType: InputIconType.SELECT,
                          hintTextStyleCallBack: () => AppTextStyle.default_16,
                          isSelectedStrCallBack: (str) =>
                              p.setThreeRowValue3(str),
                          hintText: value3 != null
                              ? value3
                              : widget.type.hintText![2]);
                    });
                  }),
              SizedBox(width: AppSize.textFiledDefaultSpacing),
              Selector<BasePopupSearchProvider, String?>(
                  selector: (context, provider) =>
                      provider.selectedThreeRowValue4,
                  builder: (context, searchCondition, _) {
                    return Builder(builder: (context) {
                      return BaseInputWidget(
                          context: context,
                          width:
                              (width - AppSize.textFiledDefaultSpacing) * .57,
                          enable: true,
                          hintTextStyleCallBack: searchCondition != null
                              ? null
                              : () => AppTextStyle.hint_16,
                          iconType: searchCondition != null
                              ? InputIconType.DELETE_AND_SEARCH
                              : InputIconType.SEARCH,
                          onChangeCallBack: (e) =>
                              p.setThreeRowValue4(e == '' ? null : e),
                          iconColor: searchCondition == null
                              ? AppColors.textFieldUnfoucsColor
                              : null,
                          defaultIconCallback: () {
                            hideKeyboard(context);
                            // p.searchForKeyWord();
                          },
                          textEditingController: _plantCodeController,
                          otherIconcallback: () {
                            p.setThreeRowValue4(null);
                            _plantCodeController!.text = '';
                          },
                          hintText: searchCondition != null
                              ? null
                              : '${tr('plz_enter')}');
                    });
                  }),
            ],
          ),
          Divider(
            color: AppColors.textGrey,
          )
        ],
      ),
    );
  }

  // Widget buildPlantListViewContents(BuildContext context) {
  //   final p = context.read<BasePopupSearchProvider>();
  //   return FutureBuilder<BasePoupSearchResult>(
  //       future: p.searchPlant(),
  //       builder: (context, snapshot) {
  //         return Selector<BasePopupSearchProvider, List<PlantResultModel>?>(
  //           selector: (context, provider) => provider.plantList,
  //           builder: (context, plantList, _) {
  //             return plantList != null && plantList.isNotEmpty
  //                 ? ListView.builder(
  //                     shrinkWrap: true,
  //                     itemExtent: AppSize.defaultTextFieldHeight,
  //                     padding: EdgeInsets.only(
  //                         top: AppSize.padding,
  //                         bottom: AppSize.padding,
  //                         left: AppSize.padding * 2,
  //                         right: AppSize.padding * 2),
  //                     physics: BouncingScrollPhysics(),
  //                     itemCount: plantList.length,
  //                     itemBuilder: (context, index) {
  //                       return InkWell(
  //                         onTap: () {
  //                           Navigator.pop(context, plantList[index]);
  //                         },
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             AppStyles.text(
  //                                 '${plantList[index].pName!}(${plantList[index].pNumber})',
  //                                 AppTextStyle.default_16,
  //                                 maxLines: 2,
  //                                 overflow: TextOverflow.ellipsis),
  //                             Padding(
  //                                 padding: EdgeInsets.only(
  //                                     top: AppSize.defaultListItemSpacing))
  //                           ],
  //                         ),
  //                       );
  //                     })
  //                 : shimmer();
  //           },
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BasePopupSearchProvider(),
      builder: (context, _) {
        final p = context.read<BasePopupSearchProvider>();
        p.setDefaultOrganization(bodyMaps: widget.bodyMap);
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(AppSize.radius8))),
          width: AppSize.updatePopupWidth,
          height: AppSize.popupHeightWidthOneRowSearchBar,
          child: Stack(
            children: [
              Container(
                  height: AppSize.popupHeightWidthOneRowSearchBar -
                      AppSize.buttonHeight,
                  child: Column(
                    children: [
                      buildPlantSearchBar(context),
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
  TextEditingController? _controller;
  ScrollController? scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller!.dispose();
    scrollController!.dispose();
    super.dispose();
  }

  Widget buildSearchBar(BuildContext context) {
    final p = context.read<BasePopupSearchProvider>();

    return Container(
      height: AppSize.titleHeightInOneRowsSearchBarPopup,
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: AppSize.searchBarTitleSidePadding)),
          Expanded(
              child: Selector<BasePopupSearchProvider, String?>(
                  selector: (context, provider) =>
                      provider.selectedOneRowValue2,
                  builder: (context, selectedOneRowValue2, _) {
                    return Builder(builder: (context) {
                      return BaseInputWidget(
                          context: context,
                          width: AppSize.defaultContentsWidth -
                              AppSize.padding * 2,
                          enable: true,
                          hintTextStyleCallBack: selectedOneRowValue2 != null
                              ? null
                              : () => AppTextStyle.hint_16,
                          iconType: selectedOneRowValue2 != null
                              ? InputIconType.DELETE_AND_SEARCH
                              : InputIconType.SEARCH,
                          onChangeCallBack: (e) => p.setOneRowValue2(e),
                          iconColor: selectedOneRowValue2 == null
                              ? AppColors.textFieldUnfoucsColor
                              : null,
                          defaultIconCallback: () {
                            hideKeyboard(context);
                            p.refresh();
                          },
                          textEditingController: _controller,
                          otherIconcallback: () {
                            p.setOneRowValue2(null);
                            _controller!.text = '';
                          },
                          hintText: selectedOneRowValue2 != null
                              ? null
                              : '${tr('plz_enter')}');
                    });
                  })),
          Divider(
            color: AppColors.textGrey,
          )
        ],
      ),
    );
  }

  Widget buildListViewContents(BuildContext context) {
    final p = context.read<BasePopupSearchProvider>();
    return FutureBuilder<BasePoupSearchResult>(
        future: p.onSearch(widget.type.popupStrListType[0], false,
            bodyMaps: widget.bodyMap),
        builder: (context, snapshot) {
          return Consumer<BasePopupSearchProvider>(
              builder: (context, provider, _) {
            return (provider.staList != null &&
                    provider.staList!.staffList != null &&
                    provider.staList!.staffList!.isNotEmpty)
                ? Padding(
                    padding: AppSize.defaultSearchPopupSidePadding,
                    child: Container(
                        height: AppSize.popupHeightWidthOneRowSearchBar -
                            AppSize.buttonHeight -
                            AppSize.titleHeightInOneRowsSearchBarPopup,
                        child: RefreshIndicator(
                            child: ListView.builder(
                              controller: scrollController!
                                ..addListener(() {
                                  if (scrollController!.offset ==
                                          scrollController!
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
                                  : 10,
                              itemBuilder: (BuildContext context, int index) {
                                return widget.type ==
                                        PopupSearchType.SEARCH_SALSE_PERSON
                                    ? buildPersonContentsItem(
                                        context,
                                        provider.staList!.staffList![index],
                                        index,
                                        !provider.hasMore &&
                                            index ==
                                                provider.staList!.staffList!
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
                        height: AppSize.popupHeightWidthOneRowSearchBar -
                            AppSize.buttonHeight -
                            AppSize.titleHeightInOneRowsSearchBarPopup,
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

  Widget buildPersonContentsItem(
      BuildContext context, dynamic model, int index, bool isShowLastPageText) {
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
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.text('${model!.sname} (${model.levelcdnm ?? ''})',
                          style: AppTextStyle.h3),
                      AppText.text('${model.dptnm}', style: AppTextStyle.h5)
                    ],
                  ),
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
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(AppSize.radius8))),
          width: AppSize.updatePopupWidth,
          height: AppSize.popupHeightWidthOneRowSearchBar,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildSearchBar(context),
                  buildListViewContents(context),
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
