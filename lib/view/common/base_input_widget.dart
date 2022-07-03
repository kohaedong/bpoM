// ignore_for_file: use_build_context_synchronously

/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_input_widget.dart
 * Created Date: 2021-09-05 17:20:52
 * Last Modified: 2022-07-03 13:26:07
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medsalesportal/enums/check_box_type.dart';
import 'package:medsalesportal/enums/popup_cell_type.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/model/commonCode/cell_model.dart';
import 'package:medsalesportal/styles/app_colors.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/styles/app_text_style.dart';
import 'package:medsalesportal/util/hiden_keybord.dart';
import 'base_popup_cell.dart';

/// 사용 패턴 설명:
/// [BaseInputWidget]은 Provider와 함께 사용함으로서 State가 변동시 증시 재build 한다.
/// 때문에 한page에 여러개의 input가 있을경우 provider + selector 사용하여 최소한의 범위내에서 build 해야한다.
/// [BaseInputWidget]는 3가지의 사용 패턴을 같고 있다.
/// 1 tap 하여 팝업창 띄울경우:
///   - 팝업창 내부 contents 구조에 때라 [OneCellType].[ThreeCellType].[PopupSearchType]으로 구분 된다.
///   - [OneCellType]은 contents가 일반 list 일경우 사용 한다. 예: 영업사원 조회.
///   - [ThreeCellType]은 contents가 table 일 경우 사용 한다. 예: 잠재고객 국가선택.
///   - [PopupSearchType]은 contents가 검색페턴 일 경우 사용 한다. 예: 플랜트 조회.
///   - [OneCellType]유형 일경우 [BasePopupList]이란 widget으로 보내 contents를 그려준다.
///   - [ThreeCellType]유형 일경우 [BasePopupCell]이란 widget으로 보내 contents를 그려준다.
///   - [PopupSearchType]유형 일경우 [BasePopupSearch]란 widget으로 보내 contents를 그려준다.
///   - 팝업창 닫을 때 선택결과 혹은 처리결과를 pop 기능으로 부모창인 [BaseInputWidget]으로 넘겨 준다.
///   - 받은 data를 사전 선언한 각종 callback을 통해 혜당 provider로 넘겨줍니다.
///   - provider가 data를 받아 처리후  notifyListeners()를 통해 page provider에게 update지시한다.
///   - page에서 view를 update 해준다.
///
/// 2 tap하여 page 띄우 경우:
///   - [routeName]을 지정해준다.
///   - [bodyMap]통해 page에 필요한 arguments를 추가 한다.
///   - page 닫을 때 or back 할때 선택결과 혹은 처리결과를 pop 기능으로 부모창인 [BaseInputWidget]으로 넘겨 준다
///   - 결과를 callback으로 혜당페이지 provider로 보낸다. 현재는 고객조회에서 [IsSelectedStrCallBack]으로 받고 있음.
///
/// 3 tap하여 text input로 사용 할경우:
///   -  [TextEditingController]를 이용해 입력된 내용[OnChangeCallBack]통해 provider로 보낸다.
///
///
/// 위 3가지 패턴을 자유롭게 전화 할수 있는 포인트는 input Aciton [onTap] callback 이다.
/// onTap 은 [BaseInputWidget]의 첫번째 widget인 [InkWell]의 callback이다.
/// 때문에 우선 순의가 가장 높다.
/// [TextField]의 enable 속성은 활성화 여부를 결정한다.
/// [onTap]를 통해 enable 변수에 관련된 값을 제어하여 input 활성화/비활성화 를 컨트롤 할수 있다.
/// 비활성화시 보여지는 내용은 사실상 HintText다.
///

typedef OnChangeCallBack = Function(String);
typedef IsSelectedStrCallBack = Function(dynamic);
typedef IsSelectedCellCallBack = Function(CellModel);
typedef HintTextStyleCallBack = TextStyle Function();
typedef AddressSelectedCity = String Function();
typedef CheckBoxDefaultValue = Future<List<bool>> Function();

class BaseInputWidget extends StatefulWidget {
  final BuildContext context;
  final InputIconType? iconType;
  final String? hintText;
  final double width;
  final Function? onTap;
  final bool enable;
  final FocusNode? focusNode;
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
  final TextInputType? keybordType;
  final TextStyle? textStyle;
  final int? maxLine;
  final dynamic arguments;
  final Map<String, dynamic>? bodyMap;
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
      this.onTap,
      this.hintText,
      this.isSelectedStrCallBack,
      this.isSelectedCellCallBack,
      this.defaultIconCallback,
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
      this.keybordType,
      this.textStyle,
      this.maxLine,
      this.arguments,
      this.bodyMap,
      this.focusNode,
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
        }
        if (result.runtimeType != CellModel) {
          if (widget.isSelectedStrCallBack != null) {
            widget.isSelectedStrCallBack!.call(result);
          }
        }
      }
    } else {}
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
    return InkWell(
        onTap: () async {
          Platform.isIOS
              ? hideKeyboard(context)
              : hideKeyboardForAndroid(context);
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
            textInputAction: widget.iconType == InputIconType.DELETE_AND_SEARCH
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
            focusNode: widget.focusNode,
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
                                  right:
                                      AppSize.customerTextFiledIconSidePadding),
                              child: SizedBox(
                                  height: AppSize.iconSmallDefaultWidth,
                                  child: widget.iconType!
                                      .icon(color: widget.iconColor))))
                      : Padding(
                          padding: EdgeInsets.only(
                              right: AppSize.customerTextFiledIconSidePadding),
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
        ));
  }
}
