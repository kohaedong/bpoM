/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/view/home/home_notice_list_item.dart
 * Created Date: 2022-01-04 00:52:36
 * Last Modified: 2022-10-14 15:07:00
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/home/notice_detail_page.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/model/rfc/table_notice_T_ZLTSP0710_model.dart';

Widget homeNoticeListItem(BuildContext context, TableNoticeZLTSP0710Model model,
    int index, bool isHomeList, bool isShowLastPageText, bool isLastItem) {
  return InkWell(
      onTap: () async {
        Navigator.pushNamed(context, NoticeDetailPage.routeName,
            arguments: model.noticeNo);
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isHomeList
                  ? Container()
                  : DateUtil.equlse(
                          DateUtil.getDate(model.aedat!), DateTime.now())
                      ? Padding(
                          padding: EdgeInsets.only(
                              right: AppSize.defaultListItemSpacing),
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 3,
                          ))
                      : Container(),
              Expanded(
                  child: AppText.listViewText(model.nTitle!,
                      maxLines: 2,
                      style: isHomeList ? null : AppTextStyle.blod_16,
                      textAlign: TextAlign.start))
            ],
          ),
          defaultSpacing(),
          Row(
            children: [
              isHomeList
                  ? Container()
                  : Row(
                      children: [
                        AppText.listViewText(
                          '${model.nType == 'A' ? tr('notice') : model.nType == 'B' ? tr('sys_notice') : model.nType}',
                          style: AppTextStyle.h4.copyWith(
                              fontSize: AppTextStyle.h4.fontSize! - 2,
                              color: AppColors.primary),
                        ),
                        AppStyles.buildPipe(),
                      ],
                    ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: AppText.listViewText(
                      '${FormatUtil.addDashForMonth('${model.aedat}')} ${FormatUtil.addColonForTime('${model.aezet}')}',
                      isSubTitle: true)),
              AppStyles.buildPipe(),
              AppText.listViewText('${model.sanumNm}', isSubTitle: true)
            ],
          ),
          defaultSpacing(isHalf: true),
          isHomeList && index == 0
              ? isLastItem
                  ? Container()
                  : Column(
                      children: [Divider(), defaultSpacing()],
                    )
              : !isHomeList
                  ? Column(
                      children: [Divider(), defaultSpacing()],
                    )
                  : Container(),
        ],
      ));
}
