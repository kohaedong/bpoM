/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/default_shimmer.dart
 * Created Date: 2021-10-13 10:00:13
 * Last Modified: 2022-08-03 17:54:19
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:medsalesportal/styles/app_colors.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/styles/app_style.dart';
import 'package:medsalesportal/styles/app_text_style.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_divider_line.dart';

import 'base_info_row_by_key_and_value.dart';
import 'base_shimmer.dart';

class DefaultShimmer {
  static Widget buildDefaultPageShimmer(int length,
      {bool? isNotWithPadding,
      bool? isWithSet,
      int? setLenght,
      bool? isWithBlodDiveder}) {
    return isWithSet != null
        ? ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    setLenght!,
                    (index) => Padding(
                      padding: EdgeInsets.all(isNotWithPadding != null
                          ? AppSize.zero
                          : AppSize.padding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(
                              length,
                              (index) => BaseInfoRowByKeyAndValue.build('', '',
                                  isWithShimmer: true)),
                          Divider()
                        ],
                      ),
                    ),
                  ),
                  isWithBlodDiveder != null ? buildDividingLine() : Container()
                ],
              )
            ],
          )
        : ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(isNotWithPadding != null
                        ? AppSize.zero
                        : AppSize.padding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                            length,
                            (index) => BaseInfoRowByKeyAndValue.build('', '',
                                isWithShimmer: true))
                      ],
                    ),
                  ),
                  buildDividingLine(),
                ],
              )
            ],
          );
  }

  static buildDefaultResultShimmer({bool? isNotPadding}) {
    return BaseShimmer(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: AppSize.padding)),
              BaseShimmer.shimmerBox(AppTextStyle.default_16.fontSize!,
                  AppSize.defaultContentsWidth * .5),
              Padding(
                  padding: EdgeInsets.only(top: AppSize.defaultShimmorSpacing)),
              Row(
                children: [
                  BaseShimmer.shimmerBox(AppTextStyle.sub_14.fontSize!,
                      AppSize.defaultContentsWidth * .2),
                  AppStyles.buildPipe(),
                  BaseShimmer.shimmerBox(
                      AppTextStyle.sub_14.fontSize!,
                      isNotPadding != null
                          ? AppSize.defaultContentsWidth * .6
                          : AppSize.defaultContentsWidth * .7),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: AppSize.padding)),
              Divider(color: AppColors.textGrey)
            ],
          );
        },
      ),
    );
  }

  static buildCalindaShimmer({bool? isNotPadding}) {
    return BaseShimmer(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  index == 0
                      ? Container(width: 30, height: 30)
                      : BaseShimmer.shimmerBox(30, 30),
                  index == 0
                      ? Container(width: 30, height: 30)
                      : BaseShimmer.shimmerBox(30, 30),
                  BaseShimmer.shimmerBox(30, 30),
                  BaseShimmer.shimmerBox(30, 30),
                  BaseShimmer.shimmerBox(30, 30),
                  index == 5
                      ? Container(width: 30, height: 30)
                      : BaseShimmer.shimmerBox(30, 30),
                  index == 5
                      ? Container(width: 30, height: 30)
                      : BaseShimmer.shimmerBox(30, 30),
                ],
              ),
              defaultSpacing(height: 40)
            ],
          );
        },
      ),
    );
  }

  static buildDefaultPopupShimmer({int? length}) {
    var width = AppSize.defaultContentsWidth;
    var contentsWidth = width - AppSize.padding * 2;
    return BaseShimmer(
        child: Container(
      alignment: Alignment.topLeft,
      width: width,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: AppSize.defaultListItemSpacing * 2),
        itemCount: length ?? 12,
        itemExtent: AppSize.defaultTextFieldHeight,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.topLeft,
            child: BaseShimmer.shimmerBox(
                AppTextStyle.default_16.fontSize!,
                Random().nextDouble() < 0.3
                    ? contentsWidth * .3
                    : contentsWidth * .5),
          );
        },
      ),
    ));
  }
}
