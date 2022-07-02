/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/view/home/home_notice_all_page.dart
 * Created Date: 2022-01-04 00:52:52
 * Last Modified: 2022-07-02 14:33:08
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/styles/app_style.dart';
import 'package:medsalesportal/styles/app_text_style.dart';
import 'package:medsalesportal/view/common/app_bar.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_null_data_widget.dart';
import 'package:medsalesportal/view/common/default_shimmer.dart';
import 'package:medsalesportal/view/common/next_page_loading_widget.dart';
import 'package:medsalesportal/view/common/provider/next_page_loading_provider.dart';
import 'package:medsalesportal/view/home/notice_list_item.dart';
import 'package:medsalesportal/view/home/provider/alarm_provider.dart';
import 'package:provider/provider.dart';

class NoticeAllPage extends StatefulWidget {
  NoticeAllPage({Key? key}) : super(key: key);
  static const String routeName = '/noticeAllPage';
  @override
  _NoticeAllPageState createState() => _NoticeAllPageState();
}

class _NoticeAllPageState extends State<NoticeAllPage> {
  ScrollController? scrollController;
  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AlarmProvider()),
          ChangeNotifierProvider(create: (context) => NextPageLoadingProvider())
        ],
        builder: (context, _) {
          final p = context.read<AlarmProvider>();

          if (p.responseModel == null) {
            p.getAlarmList(false);
          }
          return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: BaseLayout(
                hasForm: false,
                appBar: MainAppBar(
                  context,
                  titleText: AppStyles.text(
                      '${tr('recent_notice')}', AppTextStyle.w500_20),
                  callback: () {
                    p.alarmConfirm().then((_) => Navigator.pop(context));
                  },
                ),
                child: Padding(
                    padding: AppSize.defaultSidePadding,
                    child: Stack(
                      children: [
                        Consumer<AlarmProvider>(
                            builder: (context, provider, _) {
                          return provider.responseModel != null &&
                                  provider.responseModel!.list!.isNotEmpty
                              ? RefreshIndicator(
                                  child: ListView.builder(
                                    controller: scrollController!
                                      ..addListener(() {
                                        if (scrollController!.offset ==
                                                scrollController!
                                                    .position.maxScrollExtent &&
                                            !provider.isLoadData &&
                                            provider.hasMore) {
                                          final nextPageProvider = context
                                              .read<NextPageLoadingProvider>();
                                          nextPageProvider.show();
                                          provider.nextPage().then(
                                              (_) => nextPageProvider.stop());
                                        }
                                      }),
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount:
                                        provider.responseModel!.list!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return homeNoticeListItem(
                                          context,
                                          provider.responseModel!.list![index],
                                          index,
                                          false,
                                          !provider.hasMore &&
                                              index ==
                                                  provider.responseModel!.list!
                                                          .length -
                                                      1);
                                    },
                                  ),
                                  onRefresh: () => provider.refresh())
                              : provider.isLoadData
                                  ? DefaultShimmer.buildDefaultPageShimmer(12,
                                      isNotWithPadding: true)
                                  : provider.responseModel != null &&
                                          provider.responseModel!.list!.isEmpty
                                      ? ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Padding(
                                                padding: AppSize
                                                    .nullValueWidgetPadding,
                                                child:
                                                    BaseNullDataWidget.build())
                                          ],
                                        )
                                      : Container();
                        }),
                        Positioned(
                            left: 0,
                            bottom: 0,
                            child: Container(
                                width: AppSize.defaultContentsWidth,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: AppSize.appBarHeight / 2),
                                  child: NextPageLoadingWdiget.build(
                                    context,
                                  ),
                                )))
                      ],
                    ))),
          );
        });
  }
}
