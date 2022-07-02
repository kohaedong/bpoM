// ignore_for_file: deprecated_member_use

/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/text_row_model_by_key_value.dart
 * Created Date: 2021-09-06 11:46:11
 * Last Modified: 2022-07-02 15:21:37
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:flutter/material.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/styles/app_colors.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/styles/app_style.dart';
import 'package:medsalesportal/styles/app_text_style.dart';
import 'package:medsalesportal/util/regular.dart';
import 'package:medsalesportal/view/common/base_shimmer.dart';
import 'package:medsalesportal/view/common/provider/app_theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class TextRowModelByKeyValue extends StatelessWidget {
  const TextRowModelByKeyValue(this.title, this.discription,
      this.isWithShowAllButton, this.isWithEndShowAllButton,
      {Key? key,
      this.callback,
      this.showAllButtonText,
      this.icon,
      this.exceptionColor,
      this.isWithShimmer,
      this.shimmerRow,
      this.isWithStar,
      this.isTitleTwoRow,
      this.discription2,
      this.contentsTextWidth,
      this.leadingTextWidth})
      : super(key: key);
  final String title;
  final String discription;
  final String? discription2;
  final bool isWithShowAllButton;
  final bool isWithEndShowAllButton;
  final Function? callback;
  final String? showAllButtonText;
  final Widget? icon;
  final Color? exceptionColor;
  final bool? isWithShimmer;
  final bool? isWithStar;
  final int? shimmerRow;
  final bool? isTitleTwoRow;
  final double? leadingTextWidth;
  final double? contentsTextWidth;

  Widget buildShowAllButton() {
    return Padding(
      padding: EdgeInsets.only(top: AppSize.textRowModelShowAllIconTopPadding),
      child: Container(
        width: isWithShowAllButton
            ? contentsTextWidth != null
                ? contentsTextWidth! * .25
                : (AppSize.realWith - AppSize.padding * 2) * .3
            : isWithStar != null
                ? (AppSize.realWith - AppSize.padding * 2) * .35
                : (AppSize.realWith - AppSize.padding * 2) * .3,
        child: InkWell(
          onTap: () => callback != null ? callback!.call() : DoNothingAction(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppStyles.text('${showAllButtonText ?? ''}',
                  AppTextStyle.color14(AppColors.showAllTextColor),
                  maxLines: isWithShowAllButton ? 2 : null,
                  overflow: TextOverflow.ellipsis),
              Padding(
                  padding: EdgeInsets.only(left: 3),
                  child: SizedBox(
                      height: AppSize.iconSmallDefaultWidth,
                      child: icon ??
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: AppColors.showAllTextColor,
                            size: AppSize.iconSmallDefaultWidth,
                          )))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEndShowAllButton() {
    return InkWell(
        onTap: () => callback != null ? callback!.call() : DoNothingAction(),
        child: Container(
          width: contentsTextWidth != null
              ? contentsTextWidth! * .25
              : (AppSize.realWith - AppSize.padding * 2) * .25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppStyles.text('${showAllButtonText ?? ''}',
                  AppTextStyle.color14(AppColors.blueTextColor)),
              Padding(
                padding: EdgeInsets.only(left: 3),
                child: icon!,
              )
            ],
          ),
        ));
  }

  Widget buildRowLeadingText(BuildContext context) {
    final p = context.read<AppThemeProvider>();
    return Container(
        width: leadingTextWidth != null
            ? leadingTextWidth
            : isWithStar != null
                ? (AppSize.realWith - AppSize.padding * 2) * .35
                : (AppSize.realWith - AppSize.padding * 2) * .3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                child: AppStyles.text(
                  '$title',
                  p.themeData.textTheme.headline6!,
                  maxLines: isTitleTwoRow != null ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            isWithStar != null
                ? AppStyles.text(
                    ' *', AppTextStyle.color14(AppColors.dangerColor))
                : Container()
          ],
        ));
  }

  Widget buildRowContents(BuildContext context) {
    final p = context.read<AppThemeProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: isWithEndShowAllButton
                ? contentsTextWidth != null
                    ? contentsTextWidth! * .75
                    : (AppSize.realWith - AppSize.padding * 2) * .45
                : contentsTextWidth != null
                    ? contentsTextWidth
                    : isWithStar != null
                        ? (AppSize.realWith - AppSize.padding * 2) * .65
                        : (AppSize.realWith - AppSize.padding * 2) * .7,
            child: InkWell(
                onTap: () {
                  // 전화번호 클릭 -> 벡그라운드 진입 -> 포그라운드로 돌아올때 업데이트 체크안함.
                  if (exceptionColor != null) {
                    CacheService.setIsDisableUpdate(true);
                    launch(
                        "tel://${discription.replaceAll(RegExpUtil.matchNumber, '')}");
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    discription2 != null
                        ? AppStyles.text(
                            '$discription2  ', p.themeData.textTheme.headline4!)
                        : Container(),
                    Expanded(
                        child: Container(
                            child: AppStyles.text(
                                '$discription',
                                exceptionColor != null
                                    ? p.themeData.textTheme.headline4!
                                        .copyWith(color: exceptionColor)
                                    : p.themeData.textTheme.headline4!,
                                maxLines: isWithEndShowAllButton ? 1 : 2,
                                overflow: TextOverflow.ellipsis)))
                  ],
                ))),
        isWithEndShowAllButton ? buildEndShowAllButton() : Container()
      ],
    );
  }

  Widget shimmerBox(bool isRowLeadingText) {
    return Container(
      height: AppTextStyle.default_14.fontSize,
      width: isRowLeadingText
          ? (AppSize.defaultContentsWidth - AppSize.defaultShimmorSpacing) * .3
          : (AppSize.defaultContentsWidth - AppSize.defaultShimmorSpacing) * .7,
      color: AppColors.whiteText,
    );
  }

  Widget buildShimmerContainer() {
    return BaseShimmer(
        child: shimmerRow != null && shimmerRow! > 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(true),
                  Padding(
                      padding: EdgeInsets.only(
                          right: AppSize.defaultShimmorSpacing)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmerBox(false),
                      Padding(
                          padding: EdgeInsets.only(
                              top: AppSize.defaultShimmorSpacing)),
                      shimmerBox(true)
                    ],
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(true),
                  Padding(
                      padding: EdgeInsets.only(
                          right: AppSize.defaultShimmorSpacing)),
                  shimmerBox(false)
                ],
              ));
  }

  @override
  Widget build(BuildContext context) {
    return isWithShimmer != null && isWithShimmer!
        ? buildShimmerContainer()
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildRowLeadingText(context),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildRowContents(context),
                  isWithShowAllButton
                      ? buildShowAllButton()
                      : Container(
                          height: AppSize.zero,
                        )
                ],
              )
            ],
          );
  }
}
