/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/widget_of_select_location_widget.dart
 * Created Date: 2022-08-07 20:02:49
 * Last Modified: 2022-08-13 12:42:08
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/styles/app_text.dart';
import 'package:medsalesportal/styles/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/styles/app_text_style.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_loading_view.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/model/rfc/salse_activity_location_model.dart';
import 'package:medsalesportal/view/common/base_column_with_title_and_textfiled.dart';
import 'package:medsalesportal/view/common/provider/base_select_location_provider.dart';

class WidgetOfSelectLocation extends StatefulWidget {
  const WidgetOfSelectLocation({
    Key? key,
    required this.status,
    required this.locationList,
    required this.model,
  }) : super(key: key);
  final ActivityStatus? status;
  final SalesActivityDayResponseModel? model;
  final List<SalseActivityLocationModel> locationList;

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

  Widget _buildButton(BuildContext context, {required bool isLeft}) {
    var borderSide = BorderSide(width: .5, color: AppColors.textGrey);
    var decration = isLeft
        ? BoxDecoration(border: Border(top: borderSide, right: borderSide))
        : BoxDecoration(border: Border(top: borderSide));
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          if (isLeft) {
            Navigator.pop(context, false);
          } else {
            final p = context.read<BaseSelectLocationProvider>();
            var index = p.selectedIndex;
            switch (index) {
              case 0:
                p.setSelectedAddress(p.homeAddress);
                break;
              case 1:
                if (p.selectedAddress == null && p.isShowSelector) {
                  AppToast().show(context, tr('plz_select_office'));
                } else {
                  p.setSelectedAddress(p.officeAddress);
                }
                break;
            }
            if (p.editDayModel!.table250!.isEmpty) {
              await p.saveBaseTable().then((result) {
                if (result.isSuccessful) {
                  //!  table저장완료. 부모창으로 model전달.
                  Navigator.pop(context,
                      isLeft ? null : ResultModel(true, data: p.editDayModel));
                } else {
                  AppToast().show(context, result.errorMassage!);
                }
              });
            } else {
              Navigator.pop(context,
                  isLeft ? null : ResultModel(true, data: p.editDayModel));
            }
          }
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
          if (index == 1 && p.isShowSelector) {
            p.setIsShowSelector(true);
            p.setHeight(250);
          } else {
            p.setIsShowSelector(false);
            p.setHeight(200);
          }
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

  Widget _buildOfficePopup(BuildContext context) {
    final p = context.read<BaseSelectLocationProvider>();
    return Selector<BaseSelectLocationProvider, String?>(
      selector: (context, provider) => provider.selectedAddress,
      builder: (context, selectedAddress, _) {
        return Padding(
            padding: AppSize.defaultSidePadding,
            child: BaseColumWithTitleAndTextFiled.build(
                tr('office'),
                BaseInputWidget(
                    context: context,
                    height: AppSize.smallButtonHeight,
                    hintTextStyleCallBack: () => selectedAddress != null
                        ? AppTextStyle.default_14
                        : AppTextStyle.default_14
                            .copyWith(color: AppColors.subText),
                    textStyle: AppTextStyle.default_14,
                    oneCellType: OneCellType.SELECT_OFFICE_ADDRESS,
                    commononeCellDataCallback: () =>
                        p.getAddress(widget.locationList),
                    isSelectedStrCallBack: (str) => p.setSelectedAddress(str),
                    iconType:
                        selectedAddress != null ? InputIconType.DELETE : null,
                    defaultIconCallback: () => p.setSelectedAddress(null),
                    hintText: selectedAddress ?? tr('plz_select'),
                    width: AppSize.defaultContentsWidth - AppSize.padding * 2,
                    enable: selectedAddress != null ? true : false)));
      },
    );
  }

  Widget _buildSelector(BuildContext context) {
    return Column(
      children: [
        defaultSpacing(),
        Selector<BaseSelectLocationProvider, bool>(
            selector: (context, provider) => provider.isShowSelector,
            builder: (context, isShow, _) {
              return isShow ? _buildOfficePopup(context) : Container();
            })
      ],
    );
  }

  Widget _buildSelectorButtons(BuildContext context) {
    var contextsWidth = AppSize.defaultContentsWidth - AppSize.padding * 2;
    var width = contextsWidth / 3;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Selector<BaseSelectLocationProvider, int>(
            selector: (context, provider) => provider.selectedIndex,
            builder: (context, isSelectedIndex, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBox(context, width,
                      index: 0,
                      isSelected: isSelectedIndex == 0 ? true : false),
                  _buildBox(context, width,
                      index: 1,
                      isSelected: isSelectedIndex == 1 ? true : false),
                  _buildBox(context, width,
                      index: 2,
                      isSelected: isSelectedIndex == 2 ? true : false),
                ],
              );
            }),
        Selector<BaseSelectLocationProvider, bool>(
          selector: (context, provider) => provider.isShowSelector,
          builder: (context, isShowSelector, _) {
            return isShowSelector ? _buildSelector(context) : Container();
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BaseSelectLocationProvider(),
      builder: (context, _) {
        final p = context.read<BaseSelectLocationProvider>();
        p.initData(widget.model!, widget.locationList);
        return Selector<BaseSelectLocationProvider, double>(
          selector: (context, provider) => provider.height,
          builder: (context, height, _) {
            return Container(
                height: height,
                width: AppSize.defaultContentsWidth,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTitle(),
                        Divider(thickness: 1, height: 0),
                        Expanded(child: _buildSelectorButtons(context)),
                        SizedBox(
                          height: AppSize.buttonHeight,
                          child: Row(
                            children: [
                              _buildButton(context, isLeft: true),
                              _buildButton(context, isLeft: false),
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                        child: Selector<BaseSelectLocationProvider, bool>(
                      selector: (context, provider) => provider.isLoadData,
                      builder: (context, isLoadData, d) {
                        return BaseLoadingViewOnStackWidget.build(
                            context, isLoadData);
                      },
                    ))
                  ],
                ));
          },
        );
      },
    );
  }
}
