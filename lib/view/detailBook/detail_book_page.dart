/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/detailBook/detail_book_page.dart
 * Created Date: 2022-07-05 09:55:57
 * Last Modified: 2022-09-05 11:15:27
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
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_null_data.dart';
import 'package:medsalesportal/view/common/widget_of_loading_view.dart';
import 'package:medsalesportal/model/rfc/detail_book_t_list_model.dart';
import 'package:medsalesportal/view/detailBook/detail_book_web_view.dart';
import 'package:medsalesportal/model/rfc/detail_book_response_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';
import 'package:medsalesportal/view/detailBook/provider/detail_book_page_provider.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({Key? key}) : super(key: key);
  static const String routeName = '/detailBookPage';
  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  late TextEditingController _textEditingController;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Widget _buildPannelTitle(DetailBookTListModel model) {
    return Container(
      alignment: Alignment.centerLeft,
      child: AppText.text(model.iclsnm!,
          maxLines: 2, textAlign: TextAlign.start, style: AppTextStyle.blod_16),
    );
  }

  Widget _buildPannelBody(
      BuildContext context, List<DetailBookTListModel> model) {
    return Column(
      children: [
        ...model
            .asMap()
            .entries
            .map(
              (map) => GestureDetector(
                onTap: () {
                  final p = context.read<DetailBookPageProvider>();
                  p.searchDetailBookFile(map.value).then((result) async {
                    if (result.isSuccessful) {
                      final routeResult = await Navigator.pushNamed(
                          context, DetailBookWebView.routeName,
                          arguments: result.data);
                      if (routeResult != null) {
                        p.resetResultModel();
                      }
                    } else {
                      AppToast().show(context, result.errorMassage!);
                    }
                  });
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSize.padding,
                      vertical: AppSize.defaultListItemSpacing),
                  child: AppText.text(map.value.itemnm!,
                      textAlign: TextAlign.start,
                      style: AppTextStyle.default_16),
                ),
              ),
            )
            .toList(),
        defaultSpacing()
      ],
    );
  }

  Widget _buildPannelView(BuildContext context) {
    final p = context.read<DetailBookPageProvider>();
    return SingleChildScrollView(
      child: Column(
        children: [
          // _buildTitle(),
          Divider(height: AppSize.dividerHeight, indent: 0),
          Padding(
            padding: EdgeInsets.only(left: AppSize.padding),
            child: Column(
              children: p.pannelGroup
                  .asMap()
                  .entries
                  .map((map) => Column(
                        children: [
                          Selector<DetailBookPageProvider, bool>(
                            selector: (context, provider) =>
                                provider.isOpenList[map.key],
                            builder: (context, isOpen, _) {
                              return ExpansionPanelList(
                                elevation: 0,
                                expandedHeaderPadding: EdgeInsets.all(0),
                                expansionCallback: (_, __) {
                                  p.setIsOpen(map.key);
                                  hideKeyboard(context);
                                },
                                children: [
                                  ExpansionPanel(
                                      headerBuilder: (context, _) {
                                        return _buildPannelTitle(
                                            map.value!.first);
                                      },
                                      canTapOnHeader: true,
                                      isExpanded: isOpen,
                                      body:
                                          _buildPannelBody(context, map.value!))
                                ],
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: AppSize.padding),
                            child: Divider(
                              height: AppSize.dividerHeight,
                            ),
                          )
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCount(BuildContext context) {
    return Selector<DetailBookPageProvider, DetailBookResponseModel?>(
      selector: (context, provider) => provider.searchResultModel,
      builder: (context, model, _) {
        var listLength =
            model != null && model.tList != null ? model.tList!.length : '';
        return Padding(
          padding: AppSize.defaultSidePadding,
          child: Row(
            children: [
              AppText.text('총', style: AppTextStyle.default_14),
              AppText.text('$listLength', style: AppTextStyle.blod_16),
              AppText.text('건', style: AppTextStyle.default_14),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListViewItem(BuildContext context, int index) {
    final p = context.read<DetailBookPageProvider>();
    return Selector<DetailBookPageProvider, DetailBookResponseModel?>(
      selector: (context, provider) => provider.searchResultModel!,
      builder: (context, model, _) {
        return model != null && model.tList != null && model.tList!.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  p.searchDetailBookFile(model.tList![index]).then((result) {
                    if (result.isSuccessful) {
                      Navigator.pushNamed(context, DetailBookWebView.routeName,
                          arguments: result.data);
                    } else {
                      AppToast().show(context, result.errorMassage!);
                    }
                  });
                },
                child: Column(
                  children: [
                    Container(
                      width: AppSize.defaultContentsWidth,
                      padding: EdgeInsets.symmetric(
                          vertical: AppSize.defaultListItemSpacing),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppText.text(model.tList![index].iclsnm!,
                                style: AppTextStyle.blod_16),
                            Padding(
                                padding: EdgeInsets.only(
                                    right: AppSize.defaultListItemSpacing)),
                            AppText.text(
                                model.tList![index].itemnm!.substring(
                                            0,
                                            (model.tList![index].itemnm!
                                                .indexOf(
                                                    p.searchKeyStr ?? ''))) !=
                                        p.searchKeyStr
                                    ? model.tList![index].itemnm!.substring(
                                        0,
                                        (model.tList![index].itemnm!
                                            .indexOf(p.searchKeyStr ?? '')))
                                    : '',
                                style: AppTextStyle.default_14
                                    .copyWith(fontWeight: FontWeight.bold)),
                            AppText.text(p.searchKeyStr ?? '',
                                style: AppTextStyle.default_14.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold)),
                            AppText.text(
                                model.tList![index].itemnm!.substring((model
                                        .tList![index].itemnm!
                                        .indexOf(p.searchKeyStr ?? '') +
                                    int.parse(
                                        '${p.searchKeyStr == null ? '0' : p.searchKeyStr!.length}'))),
                                style: AppTextStyle.default_14
                                    .copyWith(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                    Divider()
                  ],
                ),
              )
            : Container();
      },
    );
  }

  Widget _buildResultListView(BuildContext context) {
    return Selector<DetailBookPageProvider, DetailBookResponseModel?>(
      selector: (context, provider) => provider.searchResultModel,
      builder: (context, model, _) {
        return model != null && model.tList != null && model.tList!.isNotEmpty
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ...model.tList!
                    .asMap()
                    .entries
                    .map((map) => _buildListViewItem(context, map.key))
                    .toList()
              ])
            : model!.tList != null && model.tList!.isEmpty
                ? BaseNullDataWidget.build()
                : Container();
      },
    );
  }

  Widget _buildSearchResult(BuildContext context) {
    return Column(
      children: [
        defaultSpacing(),
        _buildTotalCount(context),
        Divider(),
        _buildResultListView(context)
      ],
    );
  }

  Widget _buildContents(BuildContext context) {
    return Selector<DetailBookPageProvider,
        Tuple2<DetailBookResponseModel?, DetailBookResponseModel?>>(
      selector: (context, provider) =>
          Tuple2(provider.searchResultModel, provider.detailBookResponseModel),
      builder: (context, tuple, _) {
        return tuple.item1 != null && tuple.item1!.tList != null
            ? _buildSearchResult(context)
            : tuple.item2 != null &&
                    tuple.item2!.tList != null &&
                    tuple.item2!.tList!.isNotEmpty
                ? _buildPannelView(context)
                : Container();
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final p = context.read<DetailBookPageProvider>();
    return Selector<DetailBookPageProvider, String?>(
      selector: (context, provider) => provider.searchKeyStr,
      builder: (contetx, searchKeyStr, _) {
        return BaseInputWidget(
          context: context,
          textEditingController: _textEditingController,
          width: AppSize.defaultContentsWidth,
          hintText: searchKeyStr ?? '${tr('keyword_must_not_null')}',
          iconType: searchKeyStr != null && searchKeyStr.isNotEmpty
              ? InputIconType.DELETE_AND_SEARCH
              : null,
          onChangeCallBack: (str) => p.setSerachKeyStr(str),
          defaultIconCallback: () =>
              p.searchDetailBook(false, searchKey: searchKeyStr),
          otherIconcallback: () {
            _textEditingController.text = '';
            p.setSerachKeyStr(null);
            p.resetResultModel();
          },
          onSubmittedCallBack: (str) =>
              p.searchDetailBook(false, searchKey: str),
          enable: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: true,
        appBar: MainAppBar(context,
            titleText: AppText.text('${tr('detail_book')}',
                style: AppTextStyle.w500_22)),
        child: ChangeNotifierProvider(
          create: (context) => DetailBookPageProvider(),
          builder: (context, _) {
            return FutureBuilder(
                future: context
                    .read<DetailBookPageProvider>()
                    .searchDetailBook(true),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      children: [
                        ListView(
                          physics: ClampingScrollPhysics(),
                          children: [
                            _buildSearchBar(context),
                            _buildContents(context),
                          ],
                        ),
                        Selector<DetailBookPageProvider, bool>(
                          selector: (context, provider) => provider.isLoadData,
                          builder: (context, isLoadData, _) {
                            return BaseLoadingViewOnStackWidget.build(
                                context, isLoadData);
                          },
                        )
                      ],
                    );
                  }
                  return DefaultShimmer.buildDefaultPageShimmer(5,
                      isWithSet: true, setLenght: 5);
                });
          },
        ));
  }
}
