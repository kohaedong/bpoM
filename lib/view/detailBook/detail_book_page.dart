/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/detailBook/detail_book_page.dart
 * Created Date: 2022-07-05 09:55:57
 * Last Modified: 2022-07-29 14:32:06
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/model/rfc/detail_book_response_model.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/model/rfc/detail_book_t_list_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
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

  Widget _buildPannelBody(List<DetailBookTListModel> model) {
    return Column(
      children: [
        ...model
            .asMap()
            .entries
            .map(
              (map) => Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                    horizontal: AppSize.padding,
                    vertical: AppSize.defaultListItemSpacing),
                child: AppText.text(map.value.itemnm!,
                    textAlign: TextAlign.start, style: AppTextStyle.default_16),
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
                                      body: _buildPannelBody(map.value!))
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

  Widget _buildTotalCount(DetailBookResponseModel? model) {
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
  }

  Widget _buildListViewItem(BuildContext context, DetailBookTListModel? model) {
    return Selector<DetailBookPageProvider, String?>(
      selector: (context, provider) => provider.searchKeyStr,
      builder: (context, searchKey, _) {
        return searchKey == null || searchKey.isEmpty || model == null
            ? Container()
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: AppSize.defaultListItemSpacing),
                    width: AppSize.defaultContentsWidth,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppText.text(model.iclsnm!,
                              style: AppTextStyle.blod_16),
                          Padding(
                              padding: EdgeInsets.only(
                                  right: AppSize.defaultListItemSpacing)),
                          AppText.text(
                              model.itemnm!.substring(0,
                                          (model.itemnm!.indexOf(searchKey))) !=
                                      searchKey
                                  ? model.itemnm!.substring(
                                      0, (model.itemnm!.indexOf(searchKey)))
                                  : '',
                              style: AppTextStyle.default_14
                                  .copyWith(fontWeight: FontWeight.bold)),
                          AppText.text(searchKey,
                              style: AppTextStyle.default_14.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold)),
                          AppText.text(
                              model.itemnm!.substring(
                                  (model.itemnm!.indexOf(searchKey) +
                                      searchKey.length)),
                              style: AppTextStyle.default_14
                                  .copyWith(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  ),
                  Divider()
                ],
              );
      },
    );
  }

  Widget _buildResultListView(
      BuildContext context, DetailBookResponseModel model) {
    return Padding(
        padding: AppSize.defaultSidePadding,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ...model.tList!
              .asMap()
              .entries
              .map((map) => _buildListViewItem(context, map.value))
              .toList()
        ]));
  }

  Widget _buildSearchResult(
      BuildContext context, DetailBookResponseModel model) {
    return Column(
      children: [
        defaultSpacing(),
        _buildTotalCount(model),
        Divider(),
        defaultSpacing(),
        _buildResultListView(context, model)
      ],
    );
  }

  Widget _buildContents(BuildContext context) {
    return Selector<DetailBookPageProvider, DetailBookResponseModel?>(
      selector: (context, provider) => provider.searchResultModel,
      builder: (context, searchResultModel, _) {
        return searchResultModel != null
            ? _buildSearchResult(context, searchResultModel)
            : _buildPannelView(context);
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
          iconType: searchKeyStr != null && searchKeyStr.isNotEmpty
              ? InputIconType.DELETE_AND_SEARCH
              : null,
          onChangeCallBack: (str) => p.setSerachKeyStr(str),
          defaultIconCallback: () =>
              p.searchDetailBook(searchKey: searchKeyStr),
          otherIconcallback: () {
            _textEditingController.text = '';
            p.setSerachKeyStr(null);
            p.resetResultModel();
          },
          onSubmittedCallBack: (str) => p.searchDetailBook(searchKey: str),
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
                future:
                    context.read<DetailBookPageProvider>().searchDetailBook(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return ListView(
                      physics: ClampingScrollPhysics(),
                      children: [
                        _buildSearchBar(context),
                        _buildContents(context),
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
