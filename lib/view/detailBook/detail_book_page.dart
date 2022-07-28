/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/detailBook/detail_book_page.dart
 * Created Date: 2022-07-05 09:55:57
 * Last Modified: 2022-07-28 19:06:38
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
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
  Widget _buildPannelTitle(DetailBookTListModel model) {
    return Container(
      alignment: Alignment.centerLeft,
      child:
          AppText.text(model.iclsnm!, maxLines: 2, textAlign: TextAlign.start),
    );
  }

  Widget _buildPannelBody(List<DetailBookTListModel> model) {
    return Column(
      children: [
        ...model
            .asMap()
            .entries
            .map(
              (map) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppText.text('A. ',
                      textAlign: TextAlign.start,
                      style: AppTextStyle.bold_18
                          .copyWith(color: AppColors.primary)),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: AppSize.padding * 2),
                      child: AppText.text(map.value.itemnm!,
                          maxLines: 200, textAlign: TextAlign.start),
                    ),
                  )
                ],
              ),
            )
            .toList(),
        defaultSpacing()
      ],
    );
  }

  Widget _buildPannel(BuildContext context) {
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
                      children: [
                        _buildPannel(context),
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
