/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_popup_list.dart
 * Created Date: 2021-09-10 09:48:38
 * Last Modified: 2022-10-13 04:23:25
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/view/common/base_date_picker_for_month.dart';
import 'package:medsalesportal/view/common/provider/base_one_cell_popup_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/enums/check_box_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/dialog_contents.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_flutter_source_code_calendar_pickerBody.dart'
    as calendar_body;

typedef CheckBoxCallBack = Function(List<bool>);
typedef DiscountListCallback = Future<List<String>> Function();
typedef InitDataCallback = String Function();
typedef AddressSeletedCallBack = Function(String);
typedef AddressSelectedCity = String Function();
typedef CheckBoxDefaultValue = Future<List<bool>> Function();

class BasePopupList {
  final OneCellType type;
  final InputIconType? iconType;
  final bool? isNotInsertAll;
  BasePopupList(this.type, this.iconType, {this.isNotInsertAll});
  Widget selectBoxContents(
      BuildContext context,
      List<String> contents,
      CheckBoxCallBack callBack,
      CheckBoxDefaultValue? defaultValue,
      CheckBoxType? checkBoxType) {
    return ChangeNotifierProvider(
      create: (context) => OneCellPopupProvider(),
      builder: (context, _) {
        final p = context.read<OneCellPopupProvider>();
        return FutureBuilder<bool>(
          future:
              p.initCheckBoxList(contents, checkBoxDefaultValue: defaultValue),
          builder: (context, snapshot) {
            return snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done &&
                    snapshot.data!
                ? ListView.builder(
                    shrinkWrap: true,
                    itemExtent: AppSize.itemExtent,
                    padding:
                        EdgeInsets.only(top: AppSize.defaultListItemSpacing),
                    physics: BouncingScrollPhysics(),
                    itemCount: p.checkBoxValueList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Consumer<OneCellPopupProvider>(
                          builder: (builder, provider, _) {
                        return Padding(
                            padding: EdgeInsets.only(left: AppSize.padding),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      height: AppSize.defaultIconWidth,
                                      width: AppSize.defaultIconWidth,
                                      child: Checkbox(
                                          fillColor: checkBoxType != null &&
                                                  checkBoxType ==
                                                      CheckBoxType.READ_ONLY &&
                                                  !provider
                                                      .checkBoxValueList[index]
                                              ? MaterialStateProperty.all(
                                                  AppColors.unReadyButton)
                                              : null,
                                          overlayColor: checkBoxType != null &&
                                                  checkBoxType ==
                                                      CheckBoxType.READ_ONLY &&
                                                  !provider
                                                      .checkBoxValueList[index]
                                              ? MaterialStateProperty.all(
                                                  AppColors.unReadyButton)
                                              : null,
                                          side: BorderSide(
                                              color:
                                                  checkBoxType != null && checkBoxType == CheckBoxType.READ_ONLY && !provider.checkBoxValueList[index]
                                                      ? AppColors.unReadyButton
                                                      : Colors.grey,
                                              width: checkBoxType != null &&
                                                      checkBoxType == CheckBoxType.READ_ONLY &&
                                                      !provider.checkBoxValueList[index]
                                                  ? AppSize.defaultIconWidth / 2.2
                                                  : 1.0),
                                          value: provider.checkBoxValueList[index],
                                          onChanged: (value) {
                                            if (checkBoxType != null) {
                                            } else {
                                              provider
                                                  .whenTheCheckBoxValueChanged(
                                                      index);
                                              callBack.call(
                                                  provider.checkBoxValueList);
                                            }
                                          })),
                                  Padding(padding: EdgeInsets.only(right: 2)),
                                  AppText.text(contents[index],
                                      style: AppTextStyle.default_16)
                                ],
                              ),
                            ));
                      });
                    },
                  )
                : Container();
          },
        );
      },
    );
  }

  Widget listContents(
      BuildContext ctx, Future<List<String>?> Function()? contentsCallback,
      {bool? isNotInsert}) {
    return FutureBuilder<List<String>?>(
        future: contentsCallback != null
            ? iconType == InputIconType.SELECT
                ? Future.delayed(Duration.zero, () async {
                    var temp = await contentsCallback.call();
                    if (isNotInsert == null) {
                      temp!.insert(0, '${tr('all')}');
                    }
                    return temp;
                  })
                : contentsCallback.call()
            : type.contents(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              padding: EdgeInsets.only(top: 10),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    if (snapshot.data![index] == '${tr('enter_in_order')}') {
                      return;
                    } else {
                      Navigator.pop(ctx, snapshot.data![index]);
                    }
                  },
                  child: Container(
                    height: AppSize.defaultTextFieldHeight,
                    alignment: Alignment.centerLeft,
                    child: AppText.text(snapshot.data![index],
                        style: AppTextStyle.default_16),
                  ),
                );
              },
            );
          }
          return DefaultShimmer.buildDefaultPopupShimmer();
        });
  }

  Future<String?> show(BuildContext context,
      {CommononeCellDataCallback? commononeCellDataCallback,
      CheckBoxCallBack? checkBoxCallback,
      DiscountListCallback? discountListCallback,
      TextEditingController? textEditingController,
      InitDataCallback? initDataCallback,
      AddressSelectedCity? selectedCity,
      bool? isWithTitle,
      CheckBoxDefaultValue? checkBoxDefaultValue,
      CheckBoxType? checkBoxType,
      String? selectedDateStr}) async {
    if (type == OneCellType.DATE_PICKER_FORMONTH) {
      DateTime? selectedDate = selectedDateStr != null
          ? DateUtil.getDate(selectedDateStr)
          : DateTime.now();
      var resultDate = '';
      final result = await AppDialog.showPopup(
          context,
          BaseDatePickerForMonth(
            initDate: selectedDate,
          ));
      if (result != null) {
        var date = DateUtil.getDate(result);
        resultDate =
            '${date.year}-${date.month < 10 ? '0${date.month}' : '${date.month}'}-${date.day < 10 ? '0${date.day}' : '${date.day}'}';
        return resultDate;
      }
      return null;
    }

    if (type == OneCellType.DATE_PICKER) {
      // DateTime? selectedDate = DateTime.now();
      DateTime? selectedDate = selectedDateStr != null
          ? DateUtil.getDate(selectedDateStr)
          : DateTime.now();
      final DateTime? picked = await calendar_body.showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDatePickerMode: DatePickerMode.day,
        selectableDayPredicate: (e) => true,
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: AppSize.secondPopupHeight,
                width: AppSize.defaultContentsWidth,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: child,
              ),
            ],
          );
        },
      );
      if (picked != null) {
        return '${picked.year}-${picked.month < 10 ? '0${picked.month}' : '${picked.month}'}-${picked.day < 10 ? '0${picked.day}' : '${picked.day}'}';
      }
    } else {
      var contents = await type.contents();
      final result = await AppDialog.showPopup(
          context,
          ChangeNotifierProvider(
            create: (context) => OneCellPopupProvider(),
            child: buildDialogContents(
                context,
                type == OneCellType.CONSULTATION_REPORT_TYPE
                    ? selectBoxContents(context, contents!, checkBoxCallback!,
                        checkBoxDefaultValue, checkBoxType)
                    : listContents(context, commononeCellDataCallback,
                        isNotInsert: isNotInsertAll),
                true,
                type.contentsHeight,
                signgleButtonText: type.buttonText,
                iswithTitle: isWithTitle != null ? null : true,
                titleText: type.title),
          ));
      if (result != null) {
        if (result.runtimeType == String) return result;
      }
    }
    return null;
  }
}
