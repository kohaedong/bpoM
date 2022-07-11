// ignore_for_file: use_build_context_synchronously

/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_input_widget.dart
 * Created Date: 2021-09-05 17:20:52
 * Last Modified: 2022-07-11 17:20:38
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:medsalesportal/view/common/function_of_print.dart';

import 'base_popup_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medsalesportal/enums/check_box_type.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/enums/popup_cell_type.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/model/commonCode/cell_model.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_popup_list.dart';
import 'package:medsalesportal/view/common/base_popup_search.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';

typedef OnChangeCallBack = Function(String);
typedef IsSelectedStrCallBack = Function(dynamic);
typedef IsSelectedCellCallBack = Function(CellModel);
typedef HintTextStyleCallBack = TextStyle Function();
typedef AddressSelectedCity = String Function();
typedef CheckBoxDefaultValue = Future<List<bool>> Function();

class BaseInputWidget extends StatefulWidget {
  final BuildContext context;
  final ThreeCellType? threeCellType;
  final OneCellType? oneCellType;
  final PopupSearchType? popupSearchType;
  final InputIconType? iconType;
  final String? hintText;
  final bool? isShowDeleteForHintText;
  final Function? deleteIconCallback;
  final double width;
  final Function? onTap;
  final FocusNode? focusNode;
  final bool enable;
  final IsSelectedStrCallBack? isSelectedStrCallBack;
  final IsSelectedCellCallBack? isSelectedCellCallBack;
  final double? height;
  final Function? defaultIconCallback;
  final Function? otherIconcallback;
  final OnChangeCallBack? onChangeCallBack;
  final HintTextStyleCallBack? hintTextStyleCallBack;
  final String? routeName;
  final TextEditingController? textEditingController;
  final CommononeCellDataCallback? commononeCellDataCallback;
  final CommonThreeCellDataCallback? commonThreeCellDataCallback;
  final Color? iconColor;
  final String? initText;
  final CheckBoxCallBack? checkBoxCallBack;
  final TextInputType? keybordType;
  final TextStyle? textStyle;
  final InitDataCallback? initDataCallback;
  final int? maxLine;
  final dynamic arguments;
  final Map<String, dynamic>? bodyMap;
  final DiscountListCallback? discountListCallback;
  final AddressSelectedCity? selectedCity;
  final CheckBoxDefaultValue? checkBoxDefaultValue;
  final CheckBoxType? checkBoxType;
  final String? dateStr;
  BaseInputWidget(
      {Key? key,
      required this.context,
      required this.width,
      required this.enable,
      this.iconType,
      this.deleteIconCallback,
      this.onTap,
      this.hintText,
      this.focusNode,
      this.isShowDeleteForHintText,
      this.isSelectedStrCallBack,
      this.isSelectedCellCallBack,
      this.defaultIconCallback,
      this.threeCellType,
      this.oneCellType,
      this.popupSearchType,
      this.height,
      this.otherIconcallback,
      this.onChangeCallBack,
      this.hintTextStyleCallBack,
      this.routeName,
      this.textEditingController,
      this.commononeCellDataCallback,
      this.commonThreeCellDataCallback,
      this.iconColor,
      this.initText,
      this.checkBoxCallBack,
      this.keybordType,
      this.textStyle,
      this.initDataCallback,
      this.maxLine,
      this.arguments,
      this.bodyMap,
      this.discountListCallback,
      this.selectedCity,
      this.checkBoxDefaultValue,
      this.checkBoxType,
      this.dateStr});
  OutlineInputBorder get _disabledBorder => OutlineInputBorder(
      gapPadding: 0,
      borderSide:
          BorderSide(color: AppColors.unReadyButtonBorderColor, width: 1),
      borderRadius: BorderRadius.circular(AppSize.radius5));
  OutlineInputBorder get _enabledBorder => OutlineInputBorder(
      gapPadding: 0,
      borderSide:
          BorderSide(color: AppColors.unReadyButtonBorderColor, width: 1),
      borderRadius: BorderRadius.circular(AppSize.radius5));
  OutlineInputBorder get _focusedBorder => OutlineInputBorder(
      gapPadding: 0,
      borderSide: BorderSide(color: AppColors.primary, width: 1),
      borderRadius: BorderRadius.circular(AppSize.radius5));
  @override
  _BaseInputWidgetState createState() => _BaseInputWidgetState();
}

class _BaseInputWidgetState extends State<BaseInputWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  notEnableLogic() async {
    if (widget.onTap != null) {
      final result = await widget.onTap!.call();
      if (result == 'continue') {
        return;
      }
    }
    if (widget.routeName != null) {
      final result = await Navigator.pushNamed(context, widget.routeName!,
          arguments: widget.arguments);
      if (result != null) {
        if (result.runtimeType == CellModel) {
          result as CellModel;
          widget.isSelectedCellCallBack!.call(result);
          return;
        } else {
          if (widget.isSelectedStrCallBack != null) {
            widget.isSelectedStrCallBack!.call(result);
          }
        }
      }
    } else {
      if (widget.threeCellType != null) {
        final result = widget.commonThreeCellDataCallback != null
            ? await BasePopupCell(groupType: widget.threeCellType!).show(
                context,
                commonThreeCellDataCallback: widget.commonThreeCellDataCallback)
            : await BasePopupCell(groupType: widget.threeCellType!)
                .show(context);
        if (result != null) {
          widget.isSelectedCellCallBack!.call(result);
        }
      }
      if (widget.oneCellType != null) {
        if (widget.oneCellType == OneCellType.DO_NOTHING) {
          return;
        }
        if (widget.oneCellType == OneCellType.CONSULTATION_REPORT_TYPE) {
          print(widget.checkBoxCallBack.runtimeType);
          final result =
              await BasePopupList(widget.oneCellType!, widget.iconType).show(
                  context,
                  checkBoxCallback: widget.checkBoxCallBack,
                  checkBoxDefaultValue: widget.checkBoxDefaultValue,
                  checkBoxType: widget.checkBoxType);
          if (result != null) {
            return;
          }
        } else if (widget.oneCellType == OneCellType.ADDRESS_CITY ||
            widget.oneCellType == OneCellType.ADDRESS_CITY_AREA) {
          final result =
              await BasePopupList(widget.oneCellType!, widget.iconType).show(
            context,
            selectedCity: widget.selectedCity,
          );
          if (result != null && result.runtimeType != bool) {
            widget.isSelectedStrCallBack!.call(result);
          }
        } else {
          final result = widget.commononeCellDataCallback != null
              ? await BasePopupList(widget.oneCellType!, widget.iconType).show(
                  context,
                  commononeCellDataCallback: widget.commononeCellDataCallback,
                  textEditingController: widget.textEditingController,
                  selectedDateStr: widget.dateStr)
              : await BasePopupList(widget.oneCellType!, widget.iconType).show(
                  context,
                  discountListCallback: widget.discountListCallback,
                  selectedDateStr: widget.dateStr);
          if (result != null) {
            widget.isSelectedStrCallBack!.call(result);
          }
        }
      }
      if (widget.popupSearchType != null) {
        if (widget.threeCellType == ThreeCellType.DO_NOTHING) {
          return;
        }
        final result = await BasePopupSearch(
                type: widget.popupSearchType, bodyMap: widget.bodyMap)
            .show(context);
        if (result != null && result.runtimeType != bool) {
          widget.isSelectedStrCallBack!.call(result);
        }
      }
    }
  }

  enableLogic() {
    if (widget.onTap != null) {
      widget.onTap!.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconMaxWidth = AppSize.customerTextFiledIconMaxWidth +
        AppSize.customerTextFiledIconSidePadding / 2;
    final iconMinWidth = AppSize.customerTextFiledIconMainWidth +
        AppSize.customerTextFiledIconSidePadding / 2;
    return Stack(
      alignment: Alignment.center,
      children: [
        InkWell(
          onTap: () async {
            hideKeyboard(context);
            // 비 활성화
            if (!widget.enable) {
              notEnableLogic();
            } else {
              enableLogic();
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: widget.height ?? AppSize.defaultTextFieldHeight,
            width: widget.width,
            child: TextField(
              focusNode: widget.focusNode,
              textInputAction:
                  widget.iconType == InputIconType.DELETE_AND_SEARCH
                      ? TextInputAction.search
                      : null,
              onSubmitted: (str) {
                if (widget.iconType == InputIconType.DELETE_AND_SEARCH &&
                    widget.defaultIconCallback != null) {
                  return widget.defaultIconCallback!.call();
                } else {
                  return;
                }
              },
              inputFormatters: [LengthLimitingTextInputFormatter(200)],
              keyboardType: widget.keybordType,
              obscureText: widget.keybordType != null &&
                      widget.keybordType == TextInputType.visiblePassword
                  ? true
                  : false,
              enableSuggestions: widget.keybordType != null &&
                      widget.keybordType == TextInputType.visiblePassword
                  ? false
                  : true,
              autocorrect: widget.keybordType != null &&
                      widget.keybordType == TextInputType.visiblePassword
                  ? false
                  : true,
              style: widget.textStyle ?? AppTextStyle.default_16,
              controller: widget.textEditingController,
              onTap: () {
                widget.onTap != null ? widget.onTap!.call() : DoNothingAction();
                widget.initText != null
                    ? widget.textEditingController!.text = widget.initText!
                    : DoNothingAction();
              },
              onChanged: (text) {
                if (widget.onChangeCallBack != null) {
                  widget.onChangeCallBack!.call(text);
                }
              },
              enabled: widget.enable,
              maxLines: widget.maxLine ?? 1,
              decoration: InputDecoration(
                fillColor: AppColors.whiteText,
                hintMaxLines: 1,
                errorMaxLines: 1,
                filled: true,
                contentPadding: widget.height != null
                    ? AppSize.defaultTextFieldPaddingWidthSigninPage(
                        widget.textStyle != null
                            ? widget.textStyle!.fontSize!
                            : AppTextStyle.default_16.fontSize!)
                    : AppSize.defaultTextFieldPadding,
                border: widget._disabledBorder,
                enabledBorder: widget._enabledBorder,
                disabledBorder: widget.enable ? null : widget._disabledBorder,
                focusedBorder: widget._focusedBorder,
                suffixIconConstraints: BoxConstraints(
                  maxHeight: widget.iconType != InputIconType.DELETE_AND_SEARCH
                      ? iconMaxWidth
                      : iconMaxWidth * 2,
                  maxWidth: widget.iconType != InputIconType.DELETE_AND_SEARCH
                      ? iconMaxWidth
                      : iconMaxWidth * 2,
                  minHeight: widget.iconType != InputIconType.DELETE_AND_SEARCH
                      ? iconMinWidth
                      : iconMinWidth * 2,
                  minWidth: widget.iconType != InputIconType.DELETE_AND_SEARCH
                      ? iconMinWidth
                      : iconMinWidth * 2,
                ),
                suffixIcon: widget.iconType != null
                    ? widget.iconType != InputIconType.DELETE_AND_SEARCH
                        ? InkWell(
                            onTap: () => widget.defaultIconCallback!.call(),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    right: AppSize
                                        .customerTextFiledIconSidePadding),
                                child: SizedBox(
                                    height: AppSize.iconSmallDefaultWidth,
                                    child: widget.iconType!
                                        .icon(color: widget.iconColor))))
                        : Padding(
                            padding: EdgeInsets.only(
                                right:
                                    AppSize.customerTextFiledIconSidePadding),
                            child: widget.iconType!.icon(
                                callback1: widget.defaultIconCallback,
                                callback2: widget.otherIconcallback,
                                color: widget.iconColor),
                          )
                    : null,
                hintText: widget.hintText,
                hintStyle: widget.hintTextStyleCallBack != null
                    ? widget.hintTextStyleCallBack!.call()
                    : AppTextStyle.hint_16,
                isDense: true,
              ),
            ),
          ),
        ),
        widget.isShowDeleteForHintText != null &&
                widget.isShowDeleteForHintText!
            ? Positioned(
                right: AppSize.padding +
                    AppSize.iconSmallDefaultWidth +
                    AppSize.defaultListItemSpacing,
                child: InkWell(
                  onTap: () {
                    widget.deleteIconCallback?.call();
                  },
                  child: AppImage.getImage(ImageType.DELETE),
                ))
            : Container()
      ],
    );
  }
}
