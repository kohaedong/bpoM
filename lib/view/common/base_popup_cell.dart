/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/popup_cell.dart
 * Created Date: 2021-08-19 10:00:29
 * Last Modified: 2022-07-03 15:12:54
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/enums/popup_cell_type.dart';
import 'package:medsalesportal/model/commonCode/cell_model.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/widget_of_null_data.dart';

class BasePopupCell {
  BasePopupCell({
    required this.groupType,
  });
  final ThreeCellType groupType;
  Widget buildCellDitail(BuildContext context, List<String> titles,
      CommonThreeCellDataCallback callback, String title) {
    return Container(
        height: groupType.height,
        width: AppSize.defaultContentsWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                    height: AppSize.buttonHeight,
                    child: Padding(
                        padding: EdgeInsets.only(left: AppSize.padding),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AppStyles.text('$title', AppTextStyle.w500_18),
                        ))),
                Divider(
                    height: AppSize.dividerHeight, color: AppColors.textGrey),
              ],
            ),
            Expanded(
                child: Container(
              width: AppSize.defaultContentsWidth,
              height: groupType.height - AppSize.buttonHeight * 2,
              child: Padding(
                padding: EdgeInsets.only(
                    left: AppSize.cellPadding, right: AppSize.cellPadding),
                child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: FutureBuilder<List<CellModel>>(
                        future: callback.call(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.data!.isEmpty) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(top: AppSize.padding * 2),
                              child: Padding(
                                  padding: AppSize.nullValueWidgetPadding,
                                  child: BaseNullDataWidget.build()),
                            );
                          }
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.data!.isNotEmpty) {
                            return DataTable(
                              showCheckboxColumn: false,
                              checkboxHorizontalMargin: 0,
                              horizontalMargin: 0,
                              headingRowHeight:
                                  AppSize.popupListDefaultItemExtent,
                              dataRowHeight: AppSize.popupListDefaultItemExtent,
                              sortColumnIndex: 0,
                              columnSpacing: 0,
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.grey[100]!),
                              columns: titles.asMap().entries.map((data) {
                                return DataColumn(
                                    label: Container(
                                  alignment: data.key == 1 || data.key == 0
                                      ? Alignment.center
                                      : Alignment.centerLeft,
                                  width: data.key == 0
                                      ? groupType ==
                                              ThreeCellType.DISCOUNT_SURCHARGE
                                          ? (AppSize.defaultContentsWidth -
                                                  AppSize.cellPadding * 2) *
                                              .2
                                          : (AppSize.defaultContentsWidth -
                                                  AppSize.cellPadding * 2) *
                                              .15
                                      : data.key == 1
                                          ? groupType ==
                                                  ThreeCellType
                                                      .DISCOUNT_SURCHARGE
                                              ? (AppSize.defaultContentsWidth -
                                                      AppSize.cellPadding * 2) *
                                                  .25
                                              : (AppSize.defaultContentsWidth -
                                                      AppSize.cellPadding * 2) *
                                                  .4
                                          : groupType ==
                                                  ThreeCellType
                                                      .DISCOUNT_SURCHARGE
                                              ? (AppSize.defaultContentsWidth -
                                                      AppSize.cellPadding * 2) *
                                                  .45
                                              : (AppSize.defaultContentsWidth -
                                                      AppSize.cellPadding * 2) *
                                                  .45,
                                  child: AppStyles.text(
                                      data.value, AppTextStyle.w700_14),
                                ));
                              }).toList(),
                              rows: snapshot.data!
                                  .map(
                                    (data) => DataRow(
                                        onSelectChanged: (e) {
                                          Navigator.pop(context, data);
                                        },
                                        cells: [
                                          DataCell(Container(
                                            width: groupType ==
                                                    ThreeCellType
                                                        .DISCOUNT_SURCHARGE
                                                ? (AppSize.defaultContentsWidth -
                                                        AppSize.cellPadding *
                                                            2) *
                                                    .2
                                                : (AppSize.defaultContentsWidth -
                                                        AppSize.cellPadding *
                                                            2) *
                                                    .15,
                                            alignment: Alignment.center,
                                            child: AppStyles.text(data.column1!,
                                                AppTextStyle.default_14),
                                          )),
                                          DataCell(Container(
                                            width: groupType ==
                                                    ThreeCellType
                                                        .DISCOUNT_SURCHARGE
                                                ? (AppSize.defaultContentsWidth -
                                                        AppSize.cellPadding *
                                                            2) *
                                                    .25
                                                : (AppSize.defaultContentsWidth -
                                                        AppSize.cellPadding *
                                                            2) *
                                                    .4,
                                            alignment: Alignment.center,
                                            child: AppStyles.text(data.column2!,
                                                AppTextStyle.default_14),
                                          )),
                                          DataCell(Container(
                                            width: groupType ==
                                                    ThreeCellType
                                                        .DISCOUNT_SURCHARGE
                                                ? (AppSize.defaultContentsWidth -
                                                        AppSize.cellPadding *
                                                            2) *
                                                    .55
                                                : (AppSize.defaultContentsWidth -
                                                        AppSize.cellPadding *
                                                            2) *
                                                    .45,
                                            alignment: Alignment.centerLeft,
                                            child: AppStyles.text(data.column3!,
                                                AppTextStyle.default_14),
                                          )),
                                        ]),
                                  )
                                  .toList(),
                            );
                          }

                          return DataTable(
                              showCheckboxColumn: false,
                              checkboxHorizontalMargin: 0,
                              horizontalMargin: 0,
                              headingRowHeight:
                                  AppSize.popupListDefaultItemExtent,
                              dataRowHeight: AppSize.popupListDefaultItemExtent,
                              sortColumnIndex: 0,
                              columnSpacing: 0,
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.grey[100]!),
                              columns: titles.asMap().entries.map((data) {
                                return DataColumn(
                                    label: Container(
                                  alignment: data.key == 1 || data.key == 0
                                      ? Alignment.center
                                      : Alignment.centerLeft,
                                  width: data.key == 0
                                      ? (AppSize.defaultContentsWidth -
                                              AppSize.cellPadding * 2) *
                                          .15
                                      : data.key == 1
                                          ? (AppSize.defaultContentsWidth -
                                                  AppSize.cellPadding * 2) *
                                              .4
                                          : (AppSize.defaultContentsWidth -
                                                  AppSize.cellPadding * 2) *
                                              .45,
                                  child: AppStyles.text(
                                      data.value, AppTextStyle.w700_14),
                                ));
                              }).toList(),
                              rows: []);
                        })),
              ),
            )),
            Column(
              children: [
                Divider(
                  color: AppColors.textGrey,
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: AppStyles.buildButton(
                        context,
                        groupType.buttonText,
                        AppSize.defaultContentsWidth,
                        AppColors.whiteText,
                        AppTextStyle.color_18(AppColors.primary),
                        AppSize.radius8, () {
                      Navigator.pop(context);
                    }, isWithBottomRadius: true))
              ],
            )
          ],
        ));
  }

  Future<CellModel?> show(BuildContext context,
      {CommonThreeCellDataCallback? commonThreeCellDataCallback}) async {
    final title = await groupType.title;
    final result = await AppDialog.showPopup(
        context,
        buildCellDitail(
            context, groupType.cellTitle, commonThreeCellDataCallback!, title));
    if (result != null) {
      result as CellModel?;
    }
    return result;
  }
}
