import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/enums/update_and_notice_check_type.dart';
import 'package:medsalesportal/model/rfc/et_alarm_count_response_model.dart';
import 'package:medsalesportal/model/rfc/t_alarm_model.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/widget_of_null_data.dart';
import 'package:medsalesportal/view/commonLogin/update_and_notice_dialog.dart';
import 'package:medsalesportal/view/home/notice_all_page.dart';
import 'package:medsalesportal/view/home/notice_list_item.dart';
import 'package:medsalesportal/view/home/provider/alarm_provider.dart';
import 'package:medsalesportal/view/settings/send_suggestions_page.dart';
import 'package:medsalesportal/view/settings/settings_page.dart';
import 'package:provider/provider.dart';
import './home_icon_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var _isPaused = false;
  var _isNoticeCheckDone = false;
  ScrollController? _scrollController;
  Timer? exitAppTimer;

  var showToast = true;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    if (Platform.isAndroid) {
      disableCapture();
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    if (exitAppTimer != null) {
      exitAppTimer!.cancel();
    }
    _scrollController!.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> checkNoticeWhenLogedin() async {
    await Future.delayed(Duration.zero, () async {
      CheckUpdateAndNoticeService.check(context, CheckType.NOTICE_ONLY, true);
    }).then((value) => _isNoticeCheckDone = true);
  }

  Future disableCapture() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifeCycle) async {
    super.didChangeAppLifecycleState(lifeCycle);

    var _isForeground = (lifeCycle == AppLifecycleState.resumed);
    var paused = (lifeCycle == AppLifecycleState.paused);
    final arguments = ModalRoute.of(context)!.settings.arguments;
    // update or notice 확인 완료 여부.
    final isCheckDone = CacheService.isUpdateAndNoticeCheckDone();
    var isLocked = false;
    print('checkDone???$isCheckDone');
    if (paused) {
      _isPaused = true;
    }

    if (_isForeground && _isPaused && arguments == null && !isLocked) {
      isLocked = true;
      // 다이얼로그 호출시 업데이트 체크 재외 처리.
      final isDisable = CacheService.getIsDisableUpdate();
      if (isDisable == false && isCheckDone) {
        // chack update and alarm
        await Future.delayed(
            Duration.zero,
            () => CheckUpdateAndNoticeService.check(
                KeyService.baseAppKey.currentContext!,
                CheckType.UPDATE_ONLY,
                true)).then((value) {
          _isPaused = false;
          isLocked = false;
        });
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
                  if (map.value == ImageType.EMPTY) {
                    DoNothingAction();
                  } else {
                    Navigator.pushNamed(context, map.value.routeName);
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
                          : AppStyles.text(
                              '${testList[map.key]}', AppTextStyle.sub_14),
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
              child: AppStyles.text(
                  '${tr('med_sales_portal')}', AppTextStyle.blod30),
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
    final p = context.read<AlarmProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: EdgeInsets.only(right: AppSize.noticeTitleTextSpacing),
              child: AppStyles.text(
                  '${tr('recent_notice')}', AppTextStyle.bold_20)),
        ])),
        InkWell(
          onTap: () async {
            final result =
                await Navigator.pushNamed(context, NoticeAllPage.routeName);
            if (result != null) {
              p.refresh();
            }
          },
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

  Widget buildNoticeBody() {
    return Padding(
        padding: AppSize.homeNoticeContentsPadding,
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(AppSize.radius8)),
                color: AppColors.whiteText),
            child: Consumer<AlarmProvider>(builder: (context, provider, _) {
              return provider.homeNoticeResponseModel != null &&
                      provider.homeNoticeResponseModel!.tZltsp0710!.isNotEmpty
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(AppSize.padding),
                      shrinkWrap: true,
                      itemCount: provider.homeNoticeResponseModel!.tZltsp0710!
                          .take(2)
                          .toList()
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        var model = provider
                            .homeNoticeResponseModel!.tZltsp0710!
                            .take(2)
                            .toList()[index];
                        // home cache 된 알림, 다른 페이지로 이동하거나 앱이 종료 되면 확인처리 함.
                        return homeNoticeListItem(
                            context,
                            model,
                            index,
                            true,
                            !provider.hasMore &&
                                index ==
                                    provider.homeNoticeResponseModel!
                                            .tZltsp0710!
                                            .take(2)
                                            .toList()
                                            .length -
                                        1);
                      })
                  : provider.isLoadData
                      ? Container(
                          alignment: Alignment.center,
                          height: 200,
                          child: Container(
                              height: AppSize.defaultIconWidth * 1.5,
                              width: AppSize.defaultIconWidth * 1.5,
                              child: CircularProgressIndicator(
                                strokeWidth: AppSize.strokeWidth,
                              )),
                        )
                      : provider.homeNoticeResponseModel != null &&
                              provider.homeNoticeResponseModel!.tZltsp0710 !=
                                  null &&
                              provider
                                  .homeNoticeResponseModel!.tZltsp0710!.isEmpty
                          ? Container(
                              height: 200,
                              child: BaseNullDataWidget.build(
                                  message: '${tr('notice_is_null')}'))
                          : Container(height: 200);
            })));
  }

  Widget buildNoticeBox(BuildContext context) {
    return Padding(
      padding: AppSize.homeNoticeBoxPadding,
      child: Column(
        children: [buildNoticeTitleBar(context), buildNoticeBody()],
      ),
    );
  }

  Widget buildSendSuggestion() {
    return Padding(
        padding: AppSize.sendSuggestionPadding,
        child: AppStyles.buildButton(
            context,
            '${tr('home_send_suggestion')}',
            AppSize.realWith - AppSize.padding * 2,
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
    // print('in');

    return ChangeNotifierProvider(
      create: (context) => AlarmProvider(),
      builder: (context, _) {
        final p = context.read<AlarmProvider>();
        if (!_isNoticeCheckDone) {
          checkNoticeWhenLogedin().then((value) {
            p.getAlarmList(true);
          });
        } else {
          p.getAlarmList(true);
        }

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
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      buildIcons(),
                      buildNoticeBox(context),
                      buildSendSuggestion()
                    ],
                  ),
                )));
      },
    );
  }
}
