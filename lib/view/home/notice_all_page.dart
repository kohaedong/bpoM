/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/view/home/home_notice_all_page.dart
 * Created Date: 2022-01-04 00:52:52
 * Last Modified: 2022-07-05 15:08:12
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/home/notice_list_item.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/view/common/widget_of_null_data.dart';
import 'package:medsalesportal/view/home/provider/alarm_provider.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_next_page_loading.dart';
import 'package:medsalesportal/view/common/provider/next_page_loading_provider.dart';

class NoticeAllPage extends StatefulWidget {
  const NoticeAllPage({Key? key}) : super(key: key);
  static const String routeName = '/noticeAllPage';
  @override
  _NoticeAllPageState createState() => _NoticeAllPageState();
}

class _NoticeAllPageState extends State<NoticeAllPage> {
  late ScrollController? scrollController;
  bool upLock = true;
  bool downLock = true;
  var _scrollSwich = ValueNotifier<bool>(false);
  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  Widget _buildScrollToTop(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _scrollSwich,
        builder: (context, isCanScroll, _) {
          return isCanScroll
              ? Positioned(
                  right: 20,
                  bottom: 20,
                  child: FloatingActionButton(
                    backgroundColor: AppColors.whiteText,
                    foregroundColor: AppColors.primary,
                    onPressed: () {
                      scrollController!.animateTo(0,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeIn);
                    },
                    child: AppImage.getImage(ImageType.SCROLL_TO_TOP),
                  ))
              : Container();
        });
  }

  Widget _buildListView(BuildContext context) {
    return Consumer<AlarmProvider>(builder: (context, provider, _) {
      return provider.homeNoticeResponseModel != null &&
              provider.homeNoticeResponseModel!.tZltsp0710!.isNotEmpty
          ? RefreshIndicator(
              onRefresh: () => provider.refresh(),
              child: SingleChildScrollView(
                controller: scrollController!
                  ..addListener(() {
                    if (scrollController!.offset > AppSize.realHeight) {
                      if (downLock == true) {
                        pr('downLock');
                        downLock = false;
                        upLock = true;
                        _scrollSwich.value = true;
                      }
                    } else {
                      pr('upLock');
                      if (upLock == true) {
                        upLock = false;
                        downLock = true;
                        _scrollSwich.value = false;
                      }
                    }
                    if (scrollController!.offset ==
                            scrollController!.position.maxScrollExtent &&
                        !provider.isLoadData &&
                        provider.hasMore) {
                      final nextPageProvider =
                          context.read<NextPageLoadingProvider>();
                      nextPageProvider.show();
                      provider.nextPage().then((_) => nextPageProvider.stop());
                    }
                  }),
                child: Column(
                    children: provider.homeNoticeResponseModel!.tZltsp0710!
                        .asMap()
                        .entries
                        .map((map) => homeNoticeListItem(
                            context,
                            provider
                                .homeNoticeResponseModel!.tZltsp0710![map.key],
                            map.key,
                            false,
                            !provider.hasMore &&
                                map.key ==
                                    provider.homeNoticeResponseModel!
                                            .tZltsp0710!.length -
                                        1))
                        .toList()),
              ))
          : provider.isLoadData
              ? DefaultShimmer.buildDefaultPageShimmer(3,
                  isNotWithPadding: true, isWithSet: true, setLenght: 10)
              : provider.homeNoticeResponseModel != null &&
                      provider.homeNoticeResponseModel!.tZltsp0710!.isEmpty
                  ? ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                            padding: AppSize.nullValueWidgetPadding,
                            child: BaseNullDataWidget.build(
                                message: '${tr('notice_is_null')}'))
                      ],
                    )
                  : Container();
    });
  }

  Widget _buildNextPageLoading(BuildContext context) {
    return Positioned(
        left: 0,
        bottom: 0,
        child: Container(
            width: AppSize.defaultContentsWidth,
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSize.appBarHeight / 2),
              child: NextPageLoadingWdiget.build(
                context,
              ),
            )));
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

          if (p.homeNoticeResponseModel == null) {
            p.getAlarmList(false);
          }
          return BaseLayout(
              hasForm: false,
              appBar: MainAppBar(
                context,
                titleText: AppStyles.text(
                    '${tr('recent_notice')}', AppTextStyle.w500_20),
                callback: () {
                  Navigator.pop(context);
                },
              ),
              child: Padding(
                  padding: AppSize.defaultSidePadding,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildListView(context),
                      _buildScrollToTop(context),
                      _buildNextPageLoading(context)
                    ],
                  )));
        });
  }
}
