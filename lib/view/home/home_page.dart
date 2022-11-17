import 'dart:io';
import 'dart:async';
import '../common/base_web_view.dart';
import './home_icon_map.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:bpom/enums/image_type.dart';
import 'package:bpom/service/key_service.dart';
import 'package:bpom/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bpom/service/cache_service.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:bpom/service/connect_service.dart';
import 'package:bpom/view/common/base_layout.dart';
import 'package:bpom/view/common/base_app_toast.dart';
import 'package:bpom/view/settings/settings_page.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:bpom/globalProvider/timer_provider.dart';
import 'package:bpom/globalProvider/login_provider.dart';
import 'package:bpom/view/common/function_of_print.dart';
import 'package:bpom/view/home/provider/notice_provider.dart';
import 'package:bpom/enums/update_and_notice_check_type.dart';
import 'package:bpom/view/settings/send_suggestions_page.dart';
import 'package:bpom/view/commonLogin/update_and_notice_dialog.dart';
import 'package:bpom/view/common/fuction_of_check_working_time.dart';
import 'package:bpom/view/common/function_of_stop_or_start_listener.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = '/home';


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var _isNoticeCheckDone = false;
  Timer? exitAppTimer;

  var showToast = true;
  final String? url = 'http://naver.com';

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      disableCapture();
    }
    ConnectService.startListener();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    if (exitAppTimer != null) {
      exitAppTimer!.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future disableCapture() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifeCycle) async {
    super.didChangeAppLifecycleState(lifeCycle);
    var _paused = (lifeCycle == AppLifecycleState.paused);
    var _detached = (lifeCycle == AppLifecycleState.detached);
    var _isForeground = (lifeCycle == AppLifecycleState.resumed);
    if (_paused || _detached) return;
    if (_detached) {
      pr('stop all listener !!!!!!!!!!!!!');
      await stopAllListener();
      await FlutterAppBadger.removeBadge();
      return;
    }
    if (_isForeground) {
      pr('start all listener  !!!!!!!!!!');
      startAllListener();
      if (isOverTime()) {
        showOverTimePopup();
      }
    }
    final arguments = ModalRoute.of(context)!.settings.arguments;
    // update or notice 확인 완료 여부.
    final isCheckDone = CacheService.isUpdateAndNoticeCheckDone();
    final isLandSpace = CacheService.getIsLandSpaceMode();
    var isLocked = false;
    pr(_isForeground);
    pr((isLandSpace == null || !isLandSpace));
    pr(arguments == null);
    pr(!isLocked);
    pr('isCheckDone $isCheckDone');
    if (_isForeground) {
      FlutterAppBadger.removeBadge();
    }
    if (_isForeground &&
        (isLandSpace == null || !isLandSpace) &&
        arguments == null &&
        !isLocked &&
        isCheckDone) {
      isLocked = true;
      // 다이얼로그 호출시 업데이트 체크 재외 처리.
      final isDisable = CacheService.getIsDisableUpdate();
      print('is isDisable ${isDisable}');
      if (isDisable == false) {
        // chack update and alarm
        pr('???!!');
        CheckUpdateAndNoticeService.check(
            KeyService.baseAppKey.currentContext!, CheckType.UPDATE_ONLY, true);
        isLocked = false;
      } else {
        // 엡데이트 체크 리셋.
        CacheService.setIsDisableUpdate(false);
      }
    }
  }

  Widget buildIconRow(List<ImageType> list, List<String> testList) {
    return Padding(
        padding: AppSize.homeIconBoxSidePadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...list.asMap().entries.map((map) {
              return InkWell(
                onTap: () async {
                  setActionTime();
                  if (map.value == ImageType.EMPTY) {
                    // homeIconsListOne == icon 첫번째 줄.
                    // homeIconsListTow == icon 2번째 줄.
                    // 현재는 모두 ImageType.EMPTY , ImageType 등록후 혜당page로 route 하세요.
                    AppToast().show(context, 'this is ImageType.EMPTY');
                  } else {
                    if (map.value.routeName == '') {
                      if (isNotWoringTime()) {
                        showWorkingTimePopup(contextt: context);
                      } else {
                        final lp = context.read<LoginProvider>();
                        if (!lp.isPermidedSalseGroup) {
                          AppToast()
                              .show(context, '${tr('permission_denied')}');
                        } else {
                          Navigator.pushNamed(context, map.value.routeName);
                        }
                      }
                    } else {
                      Navigator.pushNamed(context, map.value.routeName);
                    }
                  }
                },
                child: Column(
                  children: [
                    Container(
                      height: AppSize.homeIconHeight,
                      width: AppSize.homeIconHeight,
                      child: AppImage.getImage(list[map.key]),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: AppSize.homeIconTextHeight,
                      width: AppSize.homeIconTextWidth,
                      child: map.value == ImageType.EMPTY
                          ? Container()
                          : AppText.text('${testList[map.key]}',
                              style: AppTextStyle.sub_14),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ));
  }

  Widget buildIcons() {
    return Container(
        height: (AppSize.homeIconHeight * 2) +
            (AppSize.homeIconTextHeight) * 2 +
            AppSize.homeTopPadding * 2,
        color: AppColors.whiteText,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: AppSize.homeTopPadding),
              child: buildIconRow(homeIconsListOne, homeIconsListOneText),
            ),
            buildIconRow(homeIconsListTow, homeIconsListTowText),
          ],
        ));
  }

  AppBar buildHomeAppBar() {
    return AppBar(
      backgroundColor: AppColors.whiteText,
      titleSpacing: 0,
      toolbarHeight: AppSize.appBarHeight,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: AppSize.padding),
            child: Align(
              alignment: Alignment.centerLeft,
              // 빌드옵션
              child: AppText.text('BPO', style: AppTextStyle.blod30),
            ),
          ),
          InkWell(
              onTap: () async {
                Navigator.pushNamed(context, SettingsPage.routeName);
              },
              child: Padding(
                padding: EdgeInsets.only(right: AppSize.padding),
                child: SizedBox(
                    height: AppSize.homeAppBarSettingIconHeight,
                    child: AppImage.getImage(ImageType.SETTINGS_ICON)),
              ))
        ],
      ),
    );
  }

  Widget buildNoticeTitleBar(BuildContext context) {
    final p = context.read<NoticeProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: EdgeInsets.only(right: AppSize.noticeTitleTextSpacing),
              child: AppText.text('${tr('recent_notice')}',
                  style: AppTextStyle.bold_20)),
        ])),
        InkWell(
          child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  SizedBox(width: 50),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: AppSize.defaultIconWidth,
                  ),
                ],
              )),
        )
      ],
    );
  }

  Widget buildSendSuggestion() {
    return Padding(
        padding: AppSize.sendSuggestionPadding,
        child: AppStyles.buildButton(
            context,
            // 빌드옵션
            tr('send_suggestion2', args: ['kolonLogin']),
            AppSize.realWidth - AppSize.padding * 2,
            AppColors.lightBlueColor,
            AppTextStyle.color_16(AppColors.blueTextColor),
            AppSize.radius8, () {
          Navigator.pushNamed(context, SendSuggestionPage.routeName);
        },
            selfHeight: AppSize.sendSuggestionBoxHeight,
            isWithBorder: true,
            borderColor: AppColors.blueTextColor));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {  },
      // create: (context) => NoticeProvider(),
      builder: (context, _) {
        /*
        final p = context.read<NoticeProvider>();
        if (!_isNoticeCheckDone) {
          checkNoticeWhenLogedin().then((value) {
            p.homeNoticeResponseModel == null
                ? p.getNoticeList(true)
                : DoNothingAction();
          });
        } else {
          p.homeNoticeResponseModel == null
              ? p.getNoticeList(true)
              : DoNothingAction();
        }
        */

        return WillPopScope(
            onWillPop: () async {
              if (exitAppTimer == null) {
                exitAppTimer = Timer(Duration(seconds: 3), () {});
                AppToast().show(context, '${tr('ext_app_when_tap_again')}');
              } else {
                if (exitAppTimer!.isActive) {
                  exit(0);
                } else {
                  exitAppTimer = Timer(Duration(seconds: 3), () {});
                  AppToast().show(context, '${tr('ext_app_when_tap_again')}');
                }
              }
              return false;
            },
            child: BaseLayout(
                hasForm: false,
                bgColog: AppColors.homeBgColor,
                appBar: buildHomeAppBar(),
                child: BaseWebView(url),

                /*
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      // buildIcons(),
                      // buildNoticeBox(context),
                      // buildSendSuggestion()
                    ],
                  ),
                )

                 */
            ));

      },
    );
  }
}
