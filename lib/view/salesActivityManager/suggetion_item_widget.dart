/*
 * Project Name:  [koreaJob]
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/suggetion_item_widget.dart
 * Created Date: 2022-11-03 14:12:17
 * Last Modified: 2022-11-03 15:47:38
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  MOMONETWORK ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/model/rfc/add_activity_suggetion_item_model.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/base_popup_search.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';

class SuggetionItemWidget extends StatefulWidget {
  const SuggetionItemWidget(
      {this.suggetionItemModel,
      this.index,
      this.isDoNothing,
      this.initAmount,
      this.isNotToday,
      Key? key})
      : super(key: key);
  final AddActivitySuggetionItemModel? suggetionItemModel;
  final int? index;
  final bool? isDoNothing;
  final String? initAmount;
  final bool? isNotToday;
  @override
  State<SuggetionItemWidget> createState() => _SuggetionItemWidgetState();
}

class _SuggetionItemWidgetState extends State<SuggetionItemWidget> {
  late TextEditingController _amountEditingController;
  @override
  void initState() {
    _amountEditingController = TextEditingController();
    if (widget.initAmount != null) {
      _amountEditingController.text = widget.initAmount!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _amountEditingController.dispose();
    super.dispose();
  }

  Widget _buildTitleRow(String text, {bool? isNotwithStart}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText.text(text,
                style: AppTextStyle.h4, textAlign: TextAlign.start),
            SizedBox(width: AppSize.defaultListItemSpacing),
            isNotwithStart != null && isNotwithStart
                ? Container()
                : AppText.text('*',
                    style:
                        AppTextStyle.h4.copyWith(color: AppColors.dangerColor))
          ]),
    );
  }

  Widget _buildCheckBox(BuildContext context, bool isChecked,
      {bool? isWithSuggetedItem, int? index}) {
    var isNotSuggetedItem = isWithSuggetedItem == null;
    var isNotToday = widget.isNotToday!;
    return Container(
      height: AppSize.defaultCheckBoxHeight - 5,
      width: AppSize.defaultCheckBoxHeight - 5,
      decoration: BoxDecoration(
        color: isNotToday && isNotSuggetedItem ? AppColors.unReadyButton : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Checkbox(
          activeColor: !isNotToday || !isNotSuggetedItem
              ? AppColors.primary
              : AppColors.unReadyButton,
          checkColor: isNotToday && isNotSuggetedItem
              ? AppColors.unReadyText.withOpacity(.2)
              : null,
          side: !isNotToday || !isNotSuggetedItem
              ? BorderSide(color: Colors.grey)
              : BorderSide.none,
          value: isChecked,
          onChanged: (val) {
            if (isWithSuggetedItem ?? false) {
              // if (p.suggestedItemList![index!].matnr != null) {
              //   p.updateSuggestedList(index);
              // } else {
              //   AppToast().show(
              //       context,
              //       index + 1 == 2
              //           ? tr('plz_check_item2',
              //               args: ['${tr('suggested_item')}${index + 1}'])
              //           : tr('plz_check_item',
              //               args: ['${tr('suggested_item')}${index + 1}']));
              // }
            } else {
              // if (isNotToday)
              //   return;
              // else
              //   p.setIsWithTeamLeader(val);
            }
          }),
    );
  }

  Widget _buildItemSet(AddActivitySuggetionItemModel model, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSize.defaultContentsWidth * .3,
          child: _buildTitleRow('${tr('suggested_item2')}${index + 1}',
              isNotwithStart: true),
        ),
        defaultSpacing(isHalf: true),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: BaseInputWidget(
                  context: context,
                  onTap: () async {
                    final result = await BasePopupSearch(
                        type: PopupSearchType.SEARCH_SUGGETION_ITEM,
                        bodyMap: {}).show(context);

                    if (result != null && result.runtimeType != bool) {
                      pr('????');
                    }
                  },
                  hintText:
                      model.maktx == null ? tr('plz_select') : model.maktx,
                  hintTextStyleCallBack: () => model.maktx == null
                      ? AppTextStyle.hint_16
                      : AppTextStyle.default_16,
                  iconType: widget.isDoNothing! ? null : InputIconType.SEARCH,
                  iconColor: AppColors.textFieldUnfoucsColor,
                  // popupSearchType: widget.isDoNothing!
                  //     ? PopupSearchType.DO_NOTHING
                  //     : PopupSearchType.SEARCH_SUGGETION_ITEM,
                  // isSelectedStrCallBack: (model) =>
                  //     p.updateSuggestedList(index, updateModel: model),
                  width: AppSize.defaultContentsWidth,
                  enable: false),
            ),
            index == 0
                ? Container()
                : Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              right: AppSize.defaultListItemSpacing)),
                      GestureDetector(
                          onTap: () {
                            // final p = context.read<AddActivityPageProvider>();
                            // if (!p.isDoNothing) {
                            //   p.removeAtSuggestedList(index);
                            //   if (index == 0) {
                            //     p.setAmount(null);
                            //     _amountEditingController.clear();
                            //   }
                            //   pr('close');
                            // }
                          },
                          behavior: HitTestBehavior.opaque,
                          child: AppImage.getImage(ImageType.DELETE_BOX))
                    ],
                  )
          ],
        ),
        index == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  defaultSpacing(),
                  SizedBox(
                    width: AppSize.defaultContentsWidth * .3,
                    child: _buildTitleRow(tr('month_amount_price'),
                        isNotwithStart: true),
                  ),
                  defaultSpacing(isHalf: true),
                  BaseInputWidget(
                      context: context,
                      keybordType: TextInputType.number,
                      hintText: tr('plz_select'),
                      hintTextStyleCallBack: () =>
                          _amountEditingController.text.isNotEmpty
                              ? AppTextStyle.hint_16
                              : AppTextStyle.default_16,
                      // onChangeCallBack: (str) => p.setAmount(str),
                      textEditingController: _amountEditingController,
                      width: AppSize.defaultContentsWidth,
                      enable: widget.isDoNothing! ? false : true)
                ],
              )
            : Container(),
        defaultSpacing(),
        Row(
          children: [
            _buildCheckBox(context, model.isChecked ?? false,
                index: index, isWithSuggetedItem: true),
            Padding(
                padding:
                    EdgeInsets.only(right: AppSize.defaultListItemSpacing)),
            InkWell(
              onTap: () {
                // if (p.suggestedItemList![index].matnr != null) {
                //   p.updateSuggestedList(index);
                // } else {
                //   AppToast().show(
                //       context,
                //       index + 1 == 2
                //           ? tr('plz_check_item2',
                //               args: ['${tr('suggested_item')}${index + 1}'])
                //           : tr('plz_check_item',
                //               args: ['${tr('suggested_item')}${index + 1}']));
                // }
              },
              child: AppText.text(tr('give_sample'), style: AppTextStyle.h4),
            ),
          ],
        ),
        defaultSpacing(times: 3)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildItemSet(widget.suggetionItemModel!, widget.index!);
  }
}
