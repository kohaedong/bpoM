/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/widget_of_select_location_widget.dart
 * Created Date: 2022-08-07 20:02:49
 * Last Modified: 2022-10-07 15:18:01
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/styles/app_style.dart';
import 'package:medsalesportal/view/common/function_of_pop_to_first.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/styles/app_text.dart';
import 'package:medsalesportal/styles/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/styles/app_text_style.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_loading_view.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/model/rfc/salse_activity_location_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/view/common/base_column_with_title_and_textfiled.dart';
import 'package:medsalesportal/view/salesActivityManager/provider/select_location_provider.dart';

class SelectLocationWidget extends StatefulWidget {
  const SelectLocationWidget({
    Key? key,
    required this.status,
    required this.locationList,
    required this.model,
  }) : super(key: key);
  final ActivityStatus? status;
  final SalesActivityDayResponseModel? model;
  final List<SalseActivityLocationModel> locationList;

  @override
  State<SelectLocationWidget> createState() => _SelectLocationWidgetState();
}

class _SelectLocationWidgetState extends State<SelectLocationWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.only(left: AppSize.padding),
      alignment: Alignment.centerLeft,
      height: AppSize.buttonHeight,
      child: AppText.text(
          widget.status == ActivityStatus.STARTED ||
                  widget.status == ActivityStatus.PREV_WORK_DAY_EN_STOPED
              ? tr('stop_sales_activity')
              : tr('start_sales_activity'),
          style: AppTextStyle.w500_18,
          textAlign: TextAlign.start),
    );
  }

  Widget _buildButton(BuildContext context, {required bool isLeft}) {
    final p = context.read<SelectLocationProvider>();
    var borderSide = BorderSide(width: .5, color: AppColors.textGrey);
    var decration = isLeft
        ? BoxDecoration(border: Border(top: borderSide, right: borderSide))
        : BoxDecoration(border: Border(top: borderSide));
    return Selector<SelectLocationProvider, String?>(
      selector: (context, provider) => provider.selectedAddress,
      builder: (context, address, _) {
        return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              if (p.isDifreentGoinTime) {
                AppToast().show(context, tr('stats_is_changed'));
                popToFirst(context);
              }
              if (isLeft) {
                Navigator.pop(context, null);
              } else {
                var index = p.selectedIndex;
                var doAction = () async {
                  await p.startOrStopActivity(index).then((result) {
                    if (result.isSuccessful) {
                      //!  table저장완료. 부모창으로 model전달.
                      Navigator.pop(
                          context,
                          isLeft
                              ? null
                              : ResultModel(true, data: p.editDayModel));
                    } else {
                      AppToast().show(context, result.errorMassage!);
                    }
                  });
                };
                switch (index) {
                  case 0:
                    if (p.homeAddress.isNotEmpty) {
                      p.setSelectedAddress(p.homeAddress);
                      doAction.call();
                    } else {
                      AppToast().show(context, tr('plz_set_address'));
                    }
                    break;
                  case 1:
                    if (p.officeAddres.isNotEmpty) {
                      if (p.selectedAddress != null &&
                          p.officeAddres
                              .where(
                                  (model) => model.zadd1 == p.selectedAddress)
                              .isNotEmpty) {
                        doAction.call();
                      } else {
                        AppToast().show(context, tr('plz_selected_address'));
                      }
                    } else {
                      AppToast().show(context, tr('plz_set_address'));
                    }
                    break;
                  case 2:
                    doAction.call();
                    break;
                  default:
                }
              }
            },
            child: Container(
                height: AppSize.buttonHeight,
                alignment: Alignment.center,
                decoration: decration,
                width: AppSize.defaultContentsWidth / 2,
                child: AppText.text(
                  isLeft
                      ? tr('cancel')
                      : p.activityStatus == ActivityStatus.STARTED ||
                              p.activityStatus ==
                                  ActivityStatus.PREV_WORK_DAY_EN_STOPED
                          ? tr('stop_sales_activity2')
                          : tr('start_sales_activity2'),
                  style: AppTextStyle.menu_18(
                      isLeft ? AppColors.defaultText : AppColors.primary),
                )));
      },
    );
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
          final p = context.read<SelectLocationProvider>();
          p.setSelectedIndex(index);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: AppSize.defaultTextFieldHeight,
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
    final p = context.read<SelectLocationProvider>();
    return Selector<SelectLocationProvider, String?>(
      selector: (context, provider) => provider.selectedAddress,
      builder: (context, selectedAddress, _) {
        return Padding(
            padding: AppSize.defaultSidePadding,
            child: BaseColumWithTitleAndTextFiled.build(
                tr('office'),
                BaseInputWidget(
                    context: context,
                    hintTextStyleCallBack: () => selectedAddress != null
                        ? AppTextStyle.default_16
                        : AppTextStyle.default_16
                            .copyWith(color: AppColors.subText),
                    oneCellType: OneCellType.SELECT_OFFICE_ADDRESS,
                    commononeCellDataCallback: () => p.getAddress(),
                    iconType: InputIconType.SELECT,
                    iconColor: AppColors.textFieldUnfoucsColor,
                    isNotInsertAll: true,
                    isShowDeleteForHintText:
                        selectedAddress != null && selectedAddress.isNotEmpty,
                    deleteIconCallback: () {
                      p.setSelectedAddress(null);
                    },
                    isSelectedStrCallBack: (str) => p.setSelectedAddress(str),
                    defaultIconCallback: () => p.setSelectedAddress(null),
                    hintText: selectedAddress ?? tr('plz_select'),
                    width: AppSize.defaultContentsWidth - AppSize.padding * 2,
                    enable: false)));
      },
    );
  }

  Widget _buildSelector(BuildContext context) {
    return Column(
      children: [
        defaultSpacing(),
        Selector<SelectLocationProvider, bool>(
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
        _buildAdressDiscription(context),
        defaultSpacing(),
        Selector<SelectLocationProvider, int>(
            selector: (context, provider) => provider.selectedIndex,
            builder: (context, isSelectedIndex, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBox(context, width,
                      index: 0, isSelected: isSelectedIndex == 0),
                  _buildBox(context, width,
                      index: 1, isSelected: isSelectedIndex == 1),
                  _buildBox(context, width,
                      index: 2, isSelected: isSelectedIndex == 2),
                ],
              );
            }),
        defaultSpacing(),
        Selector<SelectLocationProvider, bool>(
          selector: (context, provider) => provider.isShowSelector,
          builder: (context, isShowSelector, _) {
            return isShowSelector ? _buildSelector(context) : Container();
          },
        )
      ],
    );
  }

  Widget _buildAdressDiscription(BuildContext context) {
    final p = context.read<SelectLocationProvider>();
    return Padding(
      padding: AppSize.defaultSidePadding,
      child: AppStyles.buildTitleRow(
          p.activityStatus == ActivityStatus.STARTED ||
                  p.activityStatus == ActivityStatus.PREV_WORK_DAY_EN_STOPED
              ? tr('stop_adress')
              : tr('start_adress')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectLocationProvider(),
      builder: (context, _) {
        final p = context.read<SelectLocationProvider>();
        p.initData(widget.model!, widget.locationList, widget.status!);
        return Selector<SelectLocationProvider, double>(
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
                        child: Selector<SelectLocationProvider, bool>(
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
