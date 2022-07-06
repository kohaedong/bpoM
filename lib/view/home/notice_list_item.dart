/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/view/home/home_notice_list_item.dart
 * Created Date: 2022-01-04 00:52:36
 * Last Modified: 2022-07-06 13:22:26
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/home/notice_detail_page.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/model/rfc/table_notice_T_ZLTSP0710_model.dart';

Widget homeNoticeListItem(BuildContext context, TableNoticeZLTSP0710Model model,
    int index, bool isHomeList, bool isShowLastPageText) {
  return InkWell(
      onTap: () async {
        Navigator.pushNamed(context, NoticeDetailPage.routeName,
            arguments: model.noticeNo);
      },
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: AppText.listViewText(model.nTitle!, maxLines: 2)),
          defaultSpacing(),
          Row(
            children: [
              isHomeList
                  ? Container()
                  : Row(
                      children: [
                        AppText.listViewText('${tr('notice')}',
                            isSubTitle: true),
                        Padding(
                            padding: EdgeInsets.only(
                                right: AppSize.defaultListItemSpacing))
                      ],
                    ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: AppText.listViewText(
                      '${FormatUtil.addDashForMonth('${model.aedat}')} ${FormatUtil.addColonForTime('${model.aezet}')}',
                      isSubTitle: true)),
              AppStyles.buildPipe(AppTextStyle.h4.fontSize! - 2),
              AppText.listViewText('${model.sanumNm}', isSubTitle: true)
            ],
          ),
          defaultSpacing(height: AppSize.defaultListItemSpacing / 2),
          isHomeList && index == 0
              ? Divider()
              : !isHomeList
                  ? Divider()
                  : Container(),
        ],
      ));
}
