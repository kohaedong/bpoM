import 'dart:io';

import 'package:bpom/enums/notice_type.dart';
import 'package:bpom/enums/update_and_notice_check_type.dart';
import 'package:bpom/enums/update_type.dart';
import 'package:bpom/globalProvider/login_provider.dart';
import 'package:bpom/model/notice/notice_model.dart';
import 'package:bpom/service/cache_service.dart';
import 'package:bpom/styles/app_colors.dart';
import 'package:bpom/styles/app_size.dart';
import 'package:bpom/styles/app_style.dart';
import 'package:bpom/styles/app_text.dart';
import 'package:bpom/styles/app_text_style.dart';
import 'package:bpom/util/format_util.dart';
import 'package:bpom/view/common/base_app_dialog.dart';
import 'package:bpom/view/common/base_web_view.dart';
import 'package:bpom/view/common/widget_of_default_spacing.dart';
import 'package:bpom/view/commonLogin/common_login_page.dart';
import 'package:bpom/view/commonLogin/provider/notice_index_provider.dart';
import 'package:bpom/view/commonLogin/provider/update_and_notice_provider.dart';
import 'package:bpom/view/home/home_page.dart';
import 'package:bpom/view/signin/signin_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckUpdateAndNoticeService {
  factory CheckUpdateAndNoticeService() => _sharedInstance();
  static CheckUpdateAndNoticeService? _instance;
  CheckUpdateAndNoticeService._();
  static CheckUpdateAndNoticeService _sharedInstance() {
    if (_instance == null) {
      _instance = CheckUpdateAndNoticeService._();
    }
    return _instance!;
  }

  static Widget updateContents(BuildContext context, {UpdateData? updateData}) {
    final p = context.read<UpdateAndNoticeProvider>();
    return Selector<UpdateAndNoticeProvider, bool>(
        selector: (context, provider) => provider.isdownloadStart,
        builder: (context, isStart, _) {
          var updateDiscription = updateData!.type == UpdateType.LOCAL_CHOOSE ||
                  updateData.type == UpdateType.WEB_CHOOSE
              ? '${tr('update_text_choose')}'
              : '${tr('update_text_enforce')}';
          var updateContents = updateData.model!.appVerDscr!;
          var text = updateDiscription + '\n\n\n' + updateContents;
          var enterLength = FormatUtil.howManyLengthForString(text);

          var height = AppSize.buttonHeight * 1.5 +
              AppSize.defaultListItemSpacing * 4 +
              enterLength * 14;
          return isStart
              ? downLoadProgressContents(context)
              : Container(
                  height: height,
                  constraints:
                      BoxConstraints(maxHeight: AppSize.realHeight * .7),
                  width: AppSize.defaultContentsWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        padding: AppSize.defaultSidePadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            defaultSpacing(times: 2),
                            AppText.listViewText(updateDiscription,
                                textAlign: TextAlign.start),
                            defaultSpacing(),
                            AppText.listViewText(updateContents,
                                textAlign: TextAlign.start, maxLines: 100),
                            defaultSpacing(times: 2)
                          ],
                        ),
                      )),
                      Row(
                        children: [
                          Container(
                            width: AppSize.defaultContentsWidth / 2,
                            height: AppSize.buttonHeight,
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: AppColors
                                            .unReadyButtonBorderColor))),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: Center(
                                    child: AppText.text('${tr('cancel')}',
                                        style: AppTextStyle.color_18(
                                            AppColors.secondHintColor)))),
                          ),
                          Container(
                            width: AppSize.defaultContentsWidth / 2,
                            height: AppSize.buttonHeight,
                            decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        color:
                                            AppColors.unReadyButtonBorderColor),
                                    top: BorderSide(
                                        color: AppColors
                                            .unReadyButtonBorderColor))),
                            child: TextButton(
                                onPressed: () {
                                  // Navigator.pop(context, true);
                                  p.doUpdate(context, updateData);
                                },
                                child: Center(
                                    child: AppText.text('${tr('ok')}',
                                        style: AppTextStyle.color_18(
                                            AppColors.primary)))),
                          ),
                        ],
                      )
                    ],
                  ),
                );
        });
  }

  static Widget downLoadProgressContents(BuildContext context) => Container(
        child: Selector<UpdateAndNoticeProvider, double?>(
          selector: (context, provider) => provider.progress,
          builder: (context, value, _) {
            return Container(
              height: AppSize.downLoadPopupHeight,
              width: AppSize.defaultContentsWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.radius8),
                  color: AppColors.whiteText),
              child: Padding(
                padding: AppSize.defaultSidePadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText.text('${tr('downloading')}',
                        style: AppTextStyle.default_14),
                    Padding(
                        padding: EdgeInsets.only(
                            top: AppSize.defaultListItemSpacing)),
                    AppText.text('${((value)! * 100).toInt()}%',
                        style: AppTextStyle.default_14),
                    Padding(
                        padding: EdgeInsets.only(
                            top: AppSize.defaultListItemSpacing * 2)),
                    LinearProgressIndicator(
                        backgroundColor: AppColors.textGrey,
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        value: value),
                  ],
                ),
              ),
            );
          },
        ),
      );
  static Widget buildNotShowAgainButton(BuildContext context, NoticeModel model,
      {double? totalWidth}) {
    final p = context.read<UpdateAndNoticeProvider>();
    p.isNotShowAgain = false;
    return Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: totalWidth ?? AppSize.realWidth,
          child: Row(
            children: [
              model.recnfrmYn == 'y'
                  ? AppStyles.buildButton(
                      context,
                      '${tr('not_show_again')}',
                      totalWidth != null
                          ? totalWidth / 2
                          : AppSize.realWidth / 2,
                      AppColors.lightBlueColor,
                      AppTextStyle.color_18(AppColors.primary),
                      0, () {
                      p.dontShowAgain(model.id!);
                      Navigator.pop(context, true);
                    }, selfHeight: AppSize.bottomButtonHeight)
                  : Container(),
              AppStyles.buildButton(
                  context,
                  '${tr('close')}',
                  model.recnfrmYn == 'y'
                      ? totalWidth != null
                          ? totalWidth / 2
                          : AppSize.realWidth / 2
                      : AppSize.realWidth,
                  AppColors.primary,
                  AppTextStyle.color_18(AppColors.whiteText),
                  0, () {
                if (model.appCbgtYn != null && model.appCbgtYn == 'n') {
                  exit(0);
                } else {
                  Navigator.pop(context, true);
                }
              }, selfHeight: AppSize.bottomButtonHeight)
            ],
          ),
        ));
  }

  static Widget buildNotShowAgainButtonWidthCheckBox(
      BuildContext context, NoticeModel model, bool isBottom,
      {double? totalWidth}) {
    final p = context.read<UpdateAndNoticeProvider>();
    p.isNotShowAgain = false;
    return Positioned(
        bottom: isBottom ? 0 : AppSize.radius8,
        left: 0,
        child: Container(
          width: totalWidth != null ? totalWidth : AppSize.realWidth,
          child: Row(
            children: [
              model.recnfrmYn == 'y'
                  ? InkWell(
                      onTap: () => p.setNotShowAgainForPopupType(),
                      child: Container(
                        alignment: Alignment.center,
                        width: totalWidth != null
                            ? totalWidth * .65
                            : AppSize.realWidth * .65,
                        height: isBottom
                            ? AppSize.bottomButtonHeight
                            : AppSize.buttonHeight,
                        decoration: BoxDecoration(
                            border: Border(
                                right: isBottom
                                    ? BorderSide.none
                                    : BorderSide(
                                        color:
                                            AppColors.unReadyButtonBorderColor,
                                        width: AppSize.defaultBorderWidth),
                                top: BorderSide(
                                    color: AppColors.unReadyButtonBorderColor,
                                    width: AppSize.defaultBorderWidth)),
                            color: AppColors.whiteText),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // checkBox
                            Selector<UpdateAndNoticeProvider, bool>(
                                selector: (context, provider) =>
                                    provider.isPopupTypeNotShowAgain,
                                builder: (context, isCheckedBox, _) {
                                  return Container(
                                      width: AppSize.defaultIconWidth,
                                      height: isBottom
                                          ? AppSize.bottomButtonHeight
                                          : AppSize.buttonHeight,
                                      child: Checkbox(
                                          activeColor: AppColors.primary,
                                          side: BorderSide(color: Colors.grey),
                                          value: isCheckedBox,
                                          onChanged: (value) =>
                                              p.setNotShowAgainForPopupType()));
                                }),
                            Padding(
                                padding: EdgeInsets.only(
                                    right: AppSize.defaultListItemSpacing)),
                            AppText.text('${tr('not_show_again')}',
                                style: AppTextStyle.color_18(
                                    AppColors.defaultText))
                          ],
                        ),
                      ),
                    )
                  : Container(),
              InkWell(
                onTap: () async {
                  if (p.isPopupTypeNotShowAgain) {
                    await p.dontShowAgain(model.id!);
                  }
                  if (model.appCbgtYn != null && model.appCbgtYn == 'n') {
                    exit(0);
                  } else {
                    Navigator.pop(context, true);
                  }
                },
                child: Container(
                    alignment: Alignment.center,
                    height: isBottom
                        ? AppSize.bottomButtonHeight
                        : AppSize.buttonHeight,
                    width: model.recnfrmYn == 'y'
                        ? totalWidth != null
                            ? totalWidth * .35
                            : AppSize.realWidth * .35
                        : totalWidth != null
                            ? totalWidth
                            : AppSize.realWidth,
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: AppColors.unReadyButtonBorderColor,
                                width: AppSize.defaultBorderWidth)),
                        color: AppColors.whiteText),
                    child: AppText.text('${tr('close')}',
                        style: AppTextStyle.color_18(AppColors.defaultText))),
              )
            ],
          ),
        ));
  }

  static Widget buildWorkAndErrorNotice(
      BuildContext context, NoticeModel model) {
    return SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Container(
              height: AppSize.realHeight,
              width: AppSize.realWidth,
            ),
            Container(
                constraints: BoxConstraints(
                    maxHeight: AppSize.realHeight - AppSize.bottomButtonHeight),
                child: BaseWebView(model.ntcDscr)),
            buildNotShowAgainButton(context, model)
          ],
        ));
  }

  static Widget buildFullScreenNotice(BuildContext context, NoticeModel model) {
    print('??');
    return SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Container(
              height: AppSize.realHeight,
              width: AppSize.realWidth,
              color: AppColors.unReadySigninBg,
            ),
            Container(
                constraints: BoxConstraints(
                    maxHeight: AppSize.realHeight -
                        AppSize.buttonHeight -
                        AppSize.bottomSafeAreaHeight(context) / 2),
                child: Center(
                  child: BaseWebView(model.ntcDscr ?? model.ntcLnkAddr),
                )),
            buildNotShowAgainButton(context, model)
          ],
        ));
  }

  static Widget buildPopupNotice(BuildContext context, NoticeModel model) {
    print(model.toJson());
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: AppSize.secondPopupHeight,
          width: AppSize.defaultContentsWidth,
        ),
        Container(
          constraints: BoxConstraints(
              maxHeight: AppSize.secondPopupHeight - AppSize.buttonHeight - 30),
          child: BaseWebView(model.ntcDscr ?? model.ntcLnkAddr),
        ),
        buildNotShowAgainButtonWidthCheckBox(context, model, false,
            totalWidth: AppSize.defaultContentsWidth)
      ],
    );
  }

  static Widget buildSurveyAndUrlNotice(
      BuildContext context, NoticeModel model) {
    return Container(
        height: AppSize.realHeight,
        width: AppSize.realWidth,
        child: SafeArea(
            bottom: false,
            child: Scaffold(
                body: Stack(
              children: [
                BaseWebView('${model.ntcLnkAddr}'),
                buildNotShowAgainButtonWidthCheckBox(context, model, true)
              ],
            ))));
  }

  static void routeTo(BuildContext context) async {
    var routeName = ModalRoute.of(context)!.settings.name;
    print(routeName);
    if (routeName == '/' || routeName == CommonLoginPage.routeName) {
      var lp = context.read<LoginProvider>();
      final isAutoLogin = await lp.isAutoLogin();
      print('isAutoLogin From updateRoute  ::: $isAutoLogin');
      if (isAutoLogin) {
        print('with autoLogin');
        var loginResult = await lp.startSignin('', '', isAutoLogin: true);
        if (loginResult.isSuccessful) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomePage.routeName, (route) => false);
        } else {
          Navigator.pushReplacementNamed(context, SigninPage.routeName,
              arguments: {
                'id': lp.userId,
                'pw': lp.userPw,
                'loginResult': loginResult
              });
        }
      } else {
        print('FDSFDSFSDF&&*^&*^(*&^(&^*(');
        print(routeName);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushNamedAndRemoveUntil(
              context, SigninPage.routeName, (route) => false);
        });
      }
    }
  }

  static Widget popupContents(
      BuildContext context,
      List<Map<NoticeType, List<NoticeModel?>>>? noticeList,
      int categoryIndex,
      int noticeIndex) {
    switch (noticeList![categoryIndex].keys.single) {
      case NoticeType.ERROR_NOTICE:
        return buildWorkAndErrorNotice(context,
            noticeList[categoryIndex].values.elementAt(noticeIndex).single!);
      case NoticeType.WORK_NOTICE:
        return buildWorkAndErrorNotice(context,
            noticeList[categoryIndex].values.elementAt(noticeIndex).single!);
      case NoticeType.FULL_SCREEN_NOTICE:
        return buildFullScreenNotice(context,
            noticeList[categoryIndex].values.elementAt(noticeIndex).single!);
      case NoticeType.POP_UP_NOTICE:
        return buildPopupNotice(context,
            noticeList[categoryIndex].values.elementAt(noticeIndex).single!);
      case NoticeType.SURVEY_NOTICE:
        return buildSurveyAndUrlNotice(context,
            noticeList[categoryIndex].values.elementAt(noticeIndex).single!);
      case NoticeType.URL_NOTICE:
        return buildSurveyAndUrlNotice(context,
            noticeList[categoryIndex].values.elementAt(noticeIndex).single!);
    }
  }

  static Future<void> showNotice(BuildContext context, bool isHome) async {
    var noticeAndUpdateProvider = context.read<UpdateAndNoticeProvider>();
    final noticeResult = await noticeAndUpdateProvider.checkNotice(isHome);
    if (noticeResult.isSuccessful) {
      print('data length:: ${noticeResult.noticeData!.noticeList!.length}');
      noticeResult.noticeData!.noticeList!.forEach((notice) {
        print('${notice.keys.single}');
      });
      await Future.delayed(Duration.zero, () async {
        var p = context.read<NoticeIndexProvider>();
        while (p.categoryIndex <=
            noticeResult.noticeData!.noticeList!.length - 1) {
          p.resetNoticeIndex();
          print('first while index${p.categoryIndex}');
          while (p.noticeIndex <=
              noticeResult
                  .noticeData!.noticeList![p.categoryIndex].values.length -
                  1) {
            print('last while index${p.noticeIndex}');
            var isShowBorderRadio = noticeResult
                .noticeData!.noticeList![p.categoryIndex].keys.single ==
                NoticeType.POP_UP_NOTICE;
            var result = await AppDialog.showPopup(
                context,
                popupContents(context, noticeResult.noticeData!.noticeList,
                    p.categoryIndex, p.noticeIndex),
                isWithShapeBorder: isShowBorderRadio);
            if (result != null) {
              p.noticeIncrement();
            }
          }
          p.categoryIncrement();
        }
      }).whenComplete(() {
        context.read<NoticeIndexProvider>().resetAll();
        CacheService.saveIsUpdateAndNoticeCheckDone(true);
      });
    } else {
      CacheService.saveIsUpdateAndNoticeCheckDone(true);
    }
  }

  static void noticeAndUpdate(BuildContext context, bool isHome) async {
    // Andy.KO 2022.03.16 ??????, ???????????? ?????? ??????
    await showNotice(context, isHome);
    final up = context.read<UpdateAndNoticeProvider>();
    final updateResult = await up.checkUpdate();
    if (updateResult.isSuccessful &&
        updateResult.updateData!.model!.result != 'NG') {
      final isPressedTure = await AppDialog.showPopup(context,
          updateContents(context, updateData: updateResult.updateData));
      if (isPressedTure != null) {
        isPressedTure as bool;
        if (!isPressedTure) {
          if (updateResult.updateData!.type != UpdateType.LOCAL_CHOOSE &&
              updateResult.updateData!.type != UpdateType.WEB_CHOOSE) {
            exit(0);
          } else {
            if (!isHome) {
              CacheService.saveIsUpdateAndNoticeCheckDone(true);
              routeTo(context);
            }
          }
        }
      }
    } else {
      if (!isHome) {
        CacheService.saveIsUpdateAndNoticeCheckDone(true);
        routeTo(context);
      }
    }
  }

  static void noticeOnly(BuildContext context, bool isHome) async =>
      showNotice(context, isHome);

  static void check(
      BuildContext context, CheckType checkType, bool isHome) async {
    CacheService.saveIsUpdateAndNoticeCheckDone(false);
    switch (checkType) {
      case CheckType.NOTICE_AND_UPDATE:
        noticeAndUpdate(context, isHome);
        break;
      case CheckType.UPDATE_ONLY:
        noticeAndUpdate(context, isHome);
        break;
      case CheckType.NOTICE_ONLY:
        noticeOnly(context, isHome);
        break;
    }
  }
}
