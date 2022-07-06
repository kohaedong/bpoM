/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/base_date_picker.dart
 * Created Date: 2022-07-06 10:30:16
 * Last Modified: 2022-07-06 10:33:19
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/provider/base_date_picker_provider.dart';
import 'package:provider/provider.dart';

typedef DateCallback = Function(DateTime?);

class BaseDatePicker extends StatefulWidget {
  const BaseDatePicker({
    Key? key,
    this.dateCallback,
  }) : super(key: key);
  final DateCallback? dateCallback;
  @override
  State<BaseDatePicker> createState() => _BaseDatePickerState();
}

class _BaseDatePickerState extends State<BaseDatePicker> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DatePickerProvider(),
      builder: (context, _) {
        final p = context.read<DatePickerProvider>();
        return FutureBuilder<ResultModel>(
            future: p.initYearList(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return Container(
                    height: 300,
                    child: Column(
                      children: [
                        Padding(
                            padding: AppSize.defaultSidePadding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      widget.dateCallback?.call(null);
                                    },
                                    child: AppText.text(tr('cancel'))),
                                TextButton(
                                    onPressed: () {
                                      final p =
                                          context.read<DatePickerProvider>();
                                      Navigator.pop(context);
                                      widget.dateCallback?.call(p.currentDate);
                                    },
                                    child: AppText.text(tr('done'),
                                        style: AppTextStyle.default_14.copyWith(
                                            color: AppColors.primary))),
                              ],
                            )),
                        Expanded(
                            child: Padding(
                          padding: AppSize.defaultSidePadding,
                          child: Row(
                            children: [
                              Selector<DatePickerProvider, int?>(
                                selector: (context, provider) =>
                                    provider.currenYear,
                                builder: (context, year, _) {
                                  return Container(
                                    width: (AppSize.realWidth -
                                            AppSize.padding * 2) *
                                        .33,
                                    child: CupertinoPicker(
                                        scrollController:
                                            FixedExtentScrollController(
                                                initialItem: 0),
                                        itemExtent: 50,
                                        looping: true,
                                        selectionOverlay: Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      width: .8,
                                                      color:
                                                          AppColors.textGrey),
                                                  bottom: BorderSide(
                                                      width: .8,
                                                      color:
                                                          AppColors.textGrey))),
                                        ),
                                        onSelectedItemChanged: (int value) {
                                          p.setCurrenYear(value);
                                        },
                                        children: p.yearList
                                            .asMap()
                                            .entries
                                            .map((map) => Center(
                                                  child: AppText.text(
                                                    '${map.value}',
                                                  ),
                                                ))
                                            .toList()),
                                  );
                                },
                              ),
                              Selector<DatePickerProvider, int?>(
                                selector: (context, provider) =>
                                    provider.currenMonth,
                                builder: (context, month, _) {
                                  return Container(
                                    width: (AppSize.realWidth -
                                            AppSize.padding * 2) *
                                        .33,
                                    child: CupertinoPicker(
                                        scrollController:
                                            FixedExtentScrollController(
                                                initialItem: 0),
                                        itemExtent: 50,
                                        looping: true,
                                        selectionOverlay: Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      width: .8,
                                                      color:
                                                          AppColors.textGrey),
                                                  bottom: BorderSide(
                                                      width: .8,
                                                      color:
                                                          AppColors.textGrey))),
                                        ),
                                        onSelectedItemChanged: (int value) {
                                          p.setCurrenMonth(value);
                                        },
                                        children: p.monthList
                                            .asMap()
                                            .entries
                                            .map((map) => Center(
                                                  child: AppText.text(
                                                    '${map.value}',
                                                  ),
                                                ))
                                            .toList()),
                                  );
                                },
                              ),
                              Selector<DatePickerProvider, int?>(
                                selector: (context, provider) =>
                                    provider.currenDay,
                                builder: (context, day, _) {
                                  return Container(
                                    width: (AppSize.realWidth -
                                            AppSize.padding * 2) *
                                        .33,
                                    child: CupertinoPicker(
                                        scrollController:
                                            FixedExtentScrollController(
                                                initialItem: 0),
                                        itemExtent: 50,
                                        looping: true,
                                        selectionOverlay: Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      width: .8,
                                                      color:
                                                          AppColors.textGrey),
                                                  bottom: BorderSide(
                                                      width: .8,
                                                      color:
                                                          AppColors.textGrey))),
                                        ),
                                        onSelectedItemChanged: (int value) {
                                          p.setCurrenDay(value);
                                        },
                                        children: p.dayList
                                            .asMap()
                                            .entries
                                            .map((map) => Center(
                                                  child: AppText.text(
                                                    '${map.value}',
                                                  ),
                                                ))
                                            .toList()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ))
                      ],
                    ));
              } else {
                return Container();
              }
            });
      },
    );
  }
}
