/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/widget_of_select_location_widget.dart
 * Created Date: 2022-08-07 20:02:49
 * Last Modified: 2022-08-11 15:27:08
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/styles/app_colors.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/styles/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/app_text_style.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/view/common/provider/base_select_location_provider.dart';

typedef PopupCallBack = Function(bool);

class WidgetOfSelectLocation extends StatefulWidget {
  const WidgetOfSelectLocation({Key? key, required this.status, this.callback})
      : super(key: key);
  final ActivityStatus? status;
  final PopupCallBack? callback;

  @override
  State<WidgetOfSelectLocation> createState() => _WidgetOfSelectLocationState();
}

class _WidgetOfSelectLocationState extends State<WidgetOfSelectLocation> {
  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.only(left: AppSize.padding),
      alignment: Alignment.centerLeft,
      height: AppSize.buttonHeight,
      child: AppText.text(
          widget.status == ActivityStatus.STARTED
              ? tr('stop_sales_activity')
              : tr('start_sales_activity'),
          style: AppTextStyle.w500_18,
          textAlign: TextAlign.start),
    );
  }

  Widget _buildButton({required bool isLeft}) {
    var borderSide = BorderSide(width: .5, color: AppColors.textGrey);
    var decration = isLeft
        ? BoxDecoration(border: Border(top: borderSide, right: borderSide))
        : BoxDecoration(border: Border(top: borderSide));
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          widget.callback?.call(isLeft ? false : true);
          Navigator.pop(context, isLeft ? false : true);
        },
        child: Container(
            height: AppSize.buttonHeight,
            alignment: Alignment.center,
            decoration: decration,
            width: AppSize.defaultContentsWidth / 2,
            child: AppText.text(
              isLeft ? tr('cancel') : tr('ok'),
              style: AppTextStyle.menu_18(
                  isLeft ? AppColors.defaultText : AppColors.primary),
            )));
  }

  Widget _buildBox(BuildContext context, double width,
      {required int index, required bool isSelected}) {
    var borderradius = index == 0
        ? BorderRadius.only(
            topLeft: Radius.circular(AppSize.radius5),
            bottomLeft: Radius.circular(AppSize.radius5),
          )
        : index == 2
            ? BorderRadius.only(
                topRight: Radius.circular(AppSize.radius5),
                bottomRight: Radius.circular(AppSize.radius5),
              )
            : BorderRadius.only();

    var border =
        isSelected ? null : Border.all(width: .5, color: AppColors.textGrey);
    return GestureDetector(
        onTap: () {
          final p = context.read<BaseSelectLocationProvider>();
          p.setSelectedIndex(index);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: AppSize.smallButtonHeight,
          decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.whiteText,
              borderRadius: borderradius,
              border: border),
          child: AppText.text(
            index == 0
                ? tr('home')
                : index == 1
                    ? tr('office')
                    : tr('client'),
            style: AppTextStyle.default_14.copyWith(
                color:
                    isSelected ? AppColors.whiteText : AppColors.defaultText),
          ),
        ));
  }

  Widget _buildSelectorButtons(BuildContext context) {
    var contextsWidth = AppSize.defaultContentsWidth - AppSize.padding * 2;
    var width = contextsWidth / 3;
    return Selector<BaseSelectLocationProvider, int>(
        selector: (context, provider) => provider.selectedIndex,
        builder: (context, isSelectedIndex, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBox(context, width,
                  index: 0, isSelected: isSelectedIndex == 0 ? true : false),
              _buildBox(context, width,
                  index: 1, isSelected: isSelectedIndex == 1 ? true : false),
              _buildBox(context, width,
                  index: 2, isSelected: isSelectedIndex == 2 ? true : false),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BaseSelectLocationProvider(),
      builder: (context, _) {
        final p = context.read<BaseSelectLocationProvider>();
        return FutureBuilder<ResultModel>(
            future: p.getOfficeAddress(),
            builder: (context, snapshot) {
              var isDone = snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done &&
                  snapshot.data!.isSuccessful;
              return Selector<BaseSelectLocationProvider, double>(
                selector: (context, provider) => provider.height,
                builder: (context, height, _) {
                  return Container(
                      height: height,
                      width: AppSize.defaultContentsWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTitle(),
                          Divider(thickness: 1, height: 0),
                          Expanded(
                              child: isDone
                                  ? _buildSelectorButtons(context)
                                  : Container()),
                          SizedBox(
                            height: AppSize.buttonHeight,
                            child: Row(
                              children: [
                                _buildButton(isLeft: true),
                                _buildButton(isLeft: false),
                              ],
                            ),
                          )
                        ],
                      ));
                },
              );
            });
      },
    );
  }
}
