/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/view/home/home_notice_list_item.dart
 * Created Date: 2022-01-04 00:52:36
 * Last Modified: 2022-07-03 15:12:54
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/model/rfc/t_alarm_model.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/widget_of_tag_button.dart';
import 'package:medsalesportal/view/common/widget_of_last_page_text.dart';
import 'package:medsalesportal/view/home/provider/alarm_provider.dart';
import 'package:provider/provider.dart';

Widget homeNoticeListItem(BuildContext context, TAlarmModel model, int index,
    bool isHomeList, bool isShowLastPageText) {
  final p = context.read<AlarmProvider>();
  return InkWell(
      onTap: () async {
        var result = await AppDialog.showSignglePopup(
            context, '${model.message}',
            height: AppSize.secondPopupHeight);
        if (result != null) {
          if (isHomeList) {
            p.homeAlarmConfirm(model).then((value) async {
              p.removeHomeAlarmList(model);
              p.decrementAlarmCount(model);
            });
          } else {
            p.addToConfirmList(model);
          }
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: isHomeList
                    ? (AppSize.defaultContentsWidth - AppSize.padding * 2) * .7
                    : AppSize.defaultContentsWidth * .7,
                child: BaseTagButton.build('${model.ttext!.trim()}'),
              ),
              Container(
                  alignment: Alignment.centerRight,
                  width: isHomeList
                      ? (AppSize.defaultContentsWidth - AppSize.padding * 2) *
                          .3
                      : AppSize.defaultContentsWidth * .3,
                  child: AppStyles.text(
                      isHomeList
                          ? '${tr('not_check')}'
                          : model.redck != 'X'
                              ? '${tr('not_check')}'
                              : '',
                      AppTextStyle.color14(AppColors.subText)))
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: AppSize.defaultListItemSpacing)),
          Container(
              alignment: Alignment.centerLeft,
              child:
                  AppStyles.text(model.message!, AppTextStyle.h3, maxLines: 1)),
          Padding(
              padding: EdgeInsets.only(top: AppSize.defaultListItemSpacing)),
          Align(
              alignment: Alignment.centerLeft,
              child: AppStyles.text(
                  FormatUtil.addDashForMonth('${model.aedat}'),
                  AppTextStyle.h4.copyWith(color: AppColors.subText))),
          Padding(
              padding:
                  EdgeInsets.only(bottom: AppSize.defaultListItemSpacing / 2)),
          Divider(),
          isShowLastPageText ? lastPageText() : Container()
        ],
      ));
}
