import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 각종 사이즈 데이터 사전 등록.
class AppSize {
  static double fontSize(double size) => size;
  static double bottomSafeAreaHeight(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;
  static double get defaultContentsWidth => realWidth - padding * 2;
  static double get zero => 0;
  static double get realWidth => 1.sw;
  static double get realHeight => 1.sh;
  static double get progressTopPadding => 350.h;
  static double get itemExtent => 40;
  static double get consultationTypePopupHeight => 500;
  static double get progressWidth => 250.w;
  static double get doPopupHeight => AppSize.defaultContentsWidth;
  static double get doInputHeight => 126;
  static double get scenarioBoxHeight => 80;
  static double get smallIconWidth => 12;

  static double get defaultPopupHeight => 200.h;
  static double get approvalInputHeight => 200.w;
  static double get serverErrorPopupHeight => 300;
  static double get approvalPopupHeight => 350;
  static double get networkErrorPopupHeight => 380;
  static double get addressPopupHeight => 350;
  static double get padding => 16.w;
  static double get boxWidth => 328.w;
  static double get popHeight => 430.h;
  static double get defaultCheckBoxHeight => 20.w;
  static double get dangerPopHeight => 157.h;
  static double get appBarHeight => 56.h;
  static double get bottomSheetHeight => 300;
  static double get bottomSheetWidth => 380;
  static double get smallButtonWidth => 70;
  static double get downLoadPopupHeight => 100.w;
  static double get statusBarHeight => 24.h;
  static double get splashIconWidth => 56.h;
  static double get splashIconBottomSpacing => 32.h;
  static double get splashLogoWidth => 50.w;
  static double get splashLogoHeight => 10.h;
  static double get splashIconHeight => 60.h;
  static double get defaultBorderWidth => 1.w;
  static double get smallButtonHeight => 32;
  static double get weekDayHeight => 80.h;
  static double get calendarWidth => AppSize.realWidth;
  static double get weekDayNumberBoxHeight => 30;

  static double get defaultSpacingForTitleAndTextField => 5.w;
  static double get buttomPaddingForTitleAndTextField => 18.w;
  static double get homeSubmmitButtonPadding => 50.w;
  static double get consultationContentsBoxHeight => 100.w;
  static EdgeInsets get signinLogoPadding =>
      EdgeInsets.fromLTRB(0, 114.h, 0, 72.h);
  static double buildWidth(BuildContext context, double multiple) =>
      MediaQuery.of(context).size.width * multiple;
  static double get updatePopupWidth => 328.w;
  static double get smallPopupHeight => 238.w;
  static double get singlePopupHeight => 150.w;
  static double get menuPopupHeight =>
      buttonHeight * 3 + AppSize.dividerHeight * 2;
  static double get buttonHeight => 55;
  static double get bottomButtonHeight => 65;
  static double get dividerHeight => 2;
  static double get strokeWidth => 2;
  static double get noticeHeight => 430.h;
  static double get choosePopupHeightForUpdate => 220;
  static double get enForcePopupHeightForUpdate => 260;
  static double get radius5 => 5.r;
  static double get radius4 => 4.r;
  static double get progressHeight => 3.h;
  static double get radius8 => 8.r;
  static double get radius15 => 14.0;
  static double get radius25 => 25.r;
  static double get cellPadding => 10.w;
  static EdgeInsets get popupPadding =>
      EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 20.h);
  static EdgeInsets get searchPopupListPadding =>
      EdgeInsets.only(top: 12.w, bottom: 12.w);
  static EdgeInsets get nullValueWidgetPadding =>
      EdgeInsets.only(left: padding, top: 50.w, bottom: 50.w, right: padding);
  static EdgeInsets get updatePopupPadding =>
      EdgeInsets.only(left: padding, top: 40.w, bottom: 10.w, right: padding);
  //   ------  settingPage--------
  static double get secondButtonHeight => 44;
  static double get secondButtonWidth => 110.w;
  static double get listFontSpacing => 4.w;
  static double get defaultListItemSpacing => 9.w;
  static double get versionInfoSpacing1 => 12.w;
  static double get versionInfoSpacing2 => 67.w;
  static double get timeBoxHeight => 42.h;
  static double get shimmerHeight => 44.w;
  static double get buttonShimmerHeight => 30.w;
  static double get versionShimmerSpacing => 20.w;
  static double get timeBoxWidth => 156.w;
  static double get suggestionsBoxHeight => 205.h;
  static double get timePickerBoxHeight => 230.h;
  static EdgeInsets get settingPageTopWidgetPadding =>
      EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0.h);
  static EdgeInsets get defaultSidePadding =>
      EdgeInsets.only(left: padding, right: padding);
  static EdgeInsets get defaultSearchPopupSidePadding => EdgeInsets.only(
      left: 45.w - padding, top: 0, bottom: 0, right: 45.w - padding);
  static double get searchPopupSideSize => 45.w;
  static EdgeInsets get listPadding =>
      EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h);
  static EdgeInsets get versionRowPadding =>
      EdgeInsets.fromLTRB(16.w, 14.w, 16.w, 14.w);
  static EdgeInsets get noticePageTopWidgetPadding =>
      EdgeInsets.fromLTRB(16.w, 5.h, 16.w, 5.h);
  static EdgeInsets get noticePageEndWidgetPadding =>
      EdgeInsets.fromLTRB(16.w, 5.h, 16.w, 0.h);
  static EdgeInsets get fontSizePagePadding =>
      EdgeInsets.fromLTRB(16.w, 5.h, 0.w, 5.h);
  static EdgeInsets get fontSizePageTopWidgetPadding =>
      EdgeInsets.fromLTRB(padding, 25.h, padding, 5.h);
  static EdgeInsets get sendSuggestionsCenterPadding =>
      EdgeInsets.fromLTRB(16.w, 60.h, 16.w, 10.h);
  // --------- home ------------
  static double get homeTopPadding => 25.h;
  static double get homeAppBarSettingIconHeight => 24.w;
  static double get homeIconsBoxHeight => 348.h;
  static double get homeIconsBoxAndAppbarStatusBarHeight => 428.h;
  static double get homeIconTextBottomPaddingTotal => 10.h;
  static double get homeIconHeight => 60.w;
  static double get homeIconTextHeight => 55.w;
  static double get homeIconTextWidth => 75.w;
  static double get defaultIconWidth => 18.w;
  static double get homeSidePadding => 14.5.w;
  static double get homeNoticeListItemHeight => 90.h;
  static double get noticeTitleTextSpacing => 2.w;
  static double get sendSuggestionBoxHeight => 42.h;
  static double get secondPopupHeight => 346;
  static double get homeNoticeBoxTopPadding => 20.h;
  static double get homeNoticeItemSpacing => 5.h;
  static double get defaultShimmorSpacing => 4.w;
  static EdgeInsets get homeIconBoxSidePadding =>
      EdgeInsets.only(left: homeSidePadding, right: homeSidePadding);
  static EdgeInsets get homeNoticeBoxPadding =>
      EdgeInsets.only(left: 14.5.w, right: 14.5.w, top: 29.h);
  static EdgeInsets get homeNoticeContentsPadding =>
      EdgeInsets.only(top: 10.w, bottom: 10.w);
  static EdgeInsets get homeNoticeTageSidePadding =>
      EdgeInsets.only(left: 8.w, right: 8.w, top: 3.w, bottom: 3.w);
  static EdgeInsets get sendSuggestionPadding =>
      EdgeInsets.only(left: padding, top: 32.w, bottom: 32.w, right: padding);
  // --------- CustomerProfile ------------
  static double get customerTextFiledHeight => 42.w;
  static double get customerTopSearchBoxHeight => 74.w;
  static double get customerTopSearchBoxMaxHeight => 102.w;
  static double get customerListItemHeight => 60.w;
  static double get customerTextFiledIconMainWidth => 18.w;
  static double get customerTextFiledIconMaxWidth => 24.w;
  static double get customerTextFiledIconSidePadding => 12.w;
  static double get searchCustomerTopWidgetHeight => 76.w;
  static double get searchCustomerSubTitleHeight => 30.w;
  static double get iconSmallDefaultWidth => 12.w;
  static double get textRowTableHeight => 35.w;
  static double get textRowModelShowAllIconTopPadding => 8.w;
  static EdgeInsets get textRowModelLinePadding =>
      EdgeInsets.only(top: 8.h, bottom: 8.h);
  // --------- CustomerProfile   >>  Search customer ------------
  static double get textFiledDefaultSpacing => 10.w;
  static double get defaultTextFieldHeight => 42.w;
  static double get defaultLineHeight => 12.w;
  static double get searchCustomerListItemHeight => 30.w;
  static double get searchCustomerListTopPadding => 5.w;
  static double get popupListDefaultItemExtent => 40.w;
  static double get popupHeightWidthOneRowSearchBar => 420.w;
  static double get popupHeightWidthTwoRowsSearchBar => 530.w;
  // static double get titleHeightInOneRowsSearchBarPopup => 88.w;
  static double get popupAppbarHeight => 88.w;
  static double get titleHeightInTwoRowsSearchBarPopup => 199.w;
  static double get searchBarTitleSidePadding => 20.w;
  static EdgeInsets get defaultTextFieldPadding =>
      EdgeInsets.fromLTRB(12.w, 10.w, 12.w, 11.w);
  static EdgeInsets defaultTextFieldPaddingWidthSigninPage(double fontSize,
          {bool? isSmallButton}) =>
      EdgeInsets.fromLTRB(
          12.w,
          isSmallButton == null
              ? (buttonHeight - fontSize) / 2
              : (smallButtonHeight - fontSize) / 2,
          12.w,
          isSmallButton == null
              ? (buttonHeight - fontSize) / 2
              : (smallButtonHeight - fontSize) / 2);
  static EdgeInsets get zipCodeContentsPadding =>
      EdgeInsets.fromLTRB(16.w, 28.w, 16.w, 0.w);

  // --------- CustomerProfile   >>  sales opportunity ------------
  static double get listItemDateAndNameSpacing => 10.w;
  static EdgeInsets get customerManagerPageSearchButtonPadding =>
      EdgeInsets.fromLTRB(0.w, 10.w, 0.w, 30.w);

  // --------- consultation report page  ------------
  static double get webViewHeight => 110.w;
  static EdgeInsets get webViewContainerPadding =>
      EdgeInsets.fromLTRB(0.w, 18.w, 0.w, 24.w);
  static EdgeInsets get defaultTopAndBottomPadding =>
      EdgeInsets.fromLTRB(0.w, 12.w, 0.w, 12.w);

  // --------- address page  ------------
  static double get districtNumberSpaccing => 19.w;

  // ---------- business opp page ----------
  static double get infoBoxSpaccing => customerTextFiledIconSidePadding;

  // ---------- inventory -----------

  static double get plantLineSpacing => 15.w;
  static double get plantCheckBoxLineHeight => 25.w;
}
