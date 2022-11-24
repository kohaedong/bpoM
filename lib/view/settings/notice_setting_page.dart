import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_settings/app_settings.dart';
import 'package:bpom/enums/swich_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bpom/styles/export_common.dart';
import 'package:bpom/service/cache_service.dart';
import 'package:bpom/view/common/base_layout.dart';
import 'package:bpom/view/common/base_app_bar.dart';
import 'package:bpom/view/common/base_app_dialog.dart';
import 'package:bpom/view/common/dialog_contents.dart';
import 'package:bpom/view/settings/provider/settings_provider.dart';

class NoticeSettingPage extends StatefulWidget {
  const NoticeSettingPage({Key? key}) : super(key: key);
  static const String routeName = '/noticeSettings';

  @override
  State<NoticeSettingPage> createState() => _NoticeSettingPageState();
}

class _NoticeSettingPageState extends State<NoticeSettingPage> {
  var noticeSwichValue = ValueNotifier(false);

  var notdisturbSwichValue = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    notdisturbSwichValue.dispose();
    noticeSwichValue.dispose();
    super.dispose();
  }

  Widget _buildSwich(BuildContext context, SwichType type, GlobalKey swichKey) {
    final provider = context.read<SettingsProvider>();
    noticeSwichValue.value = provider.noticeSwichValue!;
    notdisturbSwichValue.value = provider.notdisturbSwichValue!;
    return Container(
      child: ValueListenableBuilder<bool?>(
        valueListenable: type == SwichType.SWICH_IS_NOT_DISTURB
            ? notdisturbSwichValue
            : noticeSwichValue,
        builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.zero,
            child: Switch(
              key: swichKey,
              value: value ?? false,
              onChanged: (value) async {
                if (type == SwichType.SWICH_IS_NOT_DISTURB) {
                  await provider.setNoticeSettings(type, value);
                  notdisturbSwichValue.value = value;
                }
                if (type == SwichType.SWICH_IS_USE_NOTICE) {
                  noticeSwichValue.value = value;
                  await provider.setNoticeSettings(type, value);
                }
              },
              activeTrackColor: AppColors.primary,
              activeColor: AppColors.whiteText,
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, String text,
      {bool? isUseSubscription,
      String? subscription,
      required SwichType swichType}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText.text('$text', style: AppTextStyle.default_18),
            _buildSwich(
                context,
                swichType,
                swichType == SwichType.SWICH_IS_NOT_DISTURB
                    ? GlobalKey(debugLabel: 'SWICH_IS_NOT_DISTURB')
                    : GlobalKey(debugLabel: 'SWICH_IS_USE_NOTICE'))
          ],
        ),
        isUseSubscription != null
            ? Align(
                alignment: Alignment.centerLeft,
                child:
                    AppText.text('$subscription', style: AppTextStyle.sub_14))
            : Container()
      ],
    );
  }

  Widget _buildTimePickerItem(BuildContext context,
      {required bool isHour,
      required bool isStartTime,
      required GlobalKey pickerKey}) {
    final p = context.read<SettingsProvider>();
    return Container(
        height: 200,
        child: CupertinoPicker(
          key: pickerKey,
          scrollController: FixedExtentScrollController(
              initialItem: isStartTime
                  ? isHour
                      ? p.notDisturbStartHour != null &&
                              p.notDisturbStartHour != ''
                          ? int.parse(p.notDisturbStartHour!)
                          : 0
                      : p.notDisturbStartMinute != null &&
                              p.notDisturbStartMinute != ''
                          ? int.parse(p.notDisturbStartMinute!)
                          : 0
                  : isHour
                      ? p.notDisturbEndHour != null && p.notDisturbEndHour != ''
                          ? int.parse(p.notDisturbEndHour!)
                          : 0
                      : p.notDisturbEndMinute != null &&
                              p.notDisturbEndMinute != ''
                          ? int.parse(p.notDisturbEndMinute!)
                          : 0),
          itemExtent: 50,
          looping: true,
          selectionOverlay: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(width: .8, color: AppColors.textGrey),
                    bottom: BorderSide(width: .8, color: AppColors.textGrey))),
          ),
          onSelectedItemChanged: (int value) {
            if (isHour) {
              if (isStartTime) {
                p.setNotDisturbStartHourValue(
                    value < 10 ? '0$value' : '$value');
              } else {
                p.setNotDisturbEndHourValue(value < 10 ? '0$value' : '$value');
              }
            } else {
              if (isStartTime) {
                p.setNotDisturbStartMinuteValue(
                    value < 10 ? '0$value' : '$value');
              } else {
                p.setNotDisturbEndMinuteValue(
                    value < 10 ? '0$value' : '$value');
              }
            }
          },
          children: isHour
              ? [
                  ...p.timePickerHourList.map((data) => Center(
                        child: AppText.text('$data',
                            style: AppTextStyle.default_16),
                      ))
                ]
              : [
                  ...p.timePickerminuteList.map((data) => Center(
                      child: AppText.text('$data',
                          style: AppTextStyle.default_16))),
                ],
        ));
  }

  Widget _buildTimePickerContents(BuildContext context,
      {required bool isStartTime}) {
    return WillPopScope(
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Row(
            children: [
              Expanded(
                  child: _buildTimePickerItem(context,
                      isHour: true,
                      isStartTime: isStartTime,
                      pickerKey: GlobalKey(debugLabel: 'startTime'))),
              Expanded(
                  child: _buildTimePickerItem(context,
                      isHour: false,
                      isStartTime: isStartTime,
                      pickerKey: GlobalKey(debugLabel: 'endTime')))
            ],
          ),
        ),
        onWillPop: () async => false);
  }

  Widget buildTimeBox(BuildContext context, {required bool isStartTime}) {
    return InkWell(
      onTap: () async {
        await AppDialog.showPopup(
            context,
            buildDialogContents(
                context,
                _buildTimePickerContents(context, isStartTime: isStartTime),
                false,
                AppSize.timePickerBoxHeight,
                leftButtonText: '${tr('cancel')}',
                rightButtonText: '${tr('ok')}',
                isNotPadding: true));
      },
      child: Container(
        height: AppSize.timeBoxHeight,
        width: AppSize.timeBoxWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(AppSize.radius5)),
            border: Border.all(width: 1, color: AppColors.textGrey)),
        child: Center(
            child: Consumer<SettingsProvider>(builder: (context, provider, _) {
          return AppText.text(
              isStartTime
                  ? '${provider.notDisturbStartHour != null && provider.notDisturbStartHour != '' ? provider.notDisturbStartHour! : '23'}:${provider.notDisturbStartMinute != null && provider.notDisturbStartMinute!.isNotEmpty ? provider.notDisturbStartMinute! : '00'}'
                  : '${provider.notDisturbEndHour != null && provider.notDisturbEndHour != '' ? provider.notDisturbEndHour! : '07'}:${provider.notDisturbEndMinute != null && provider.notDisturbEndMinute != '' ? provider.notDisturbEndMinute : '00'}',
              style: AppTextStyle.default_18);
        })),
      ),
    );
  }

  Widget _buildWhenSetNotDisturb(BuildContext context) {
    final p = context.read<SettingsProvider>();
    noticeSwichValue.value = p.noticeSwichValue ?? false;
    notdisturbSwichValue.value = p.notdisturbSwichValue ?? false;

    return Column(
      children: [
        Padding(
            padding: AppSize.noticePageEndWidgetPadding,
            child: _buildItemRow(context, '${tr('set_not_disturb')}',
                isUseSubscription: true,
                swichType: SwichType.SWICH_IS_NOT_DISTURB,
                subscription: '${tr('set_not_disturb_discription')}')),
        ValueListenableBuilder<bool>(
            valueListenable: notdisturbSwichValue,
            builder: (context, isShow, _) {
              return isShow
                  ? Padding(
                      padding: AppSize.noticePageEndWidgetPadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildTimeBox(context, isStartTime: true),
                          Center(
                            child: Text('~'),
                          ),
                          buildTimeBox(context, isStartTime: false)
                        ],
                      ))
                  : Container();
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      builder: (context, _) {
        final p = context.read<SettingsProvider>();
        CacheService.setIsDisableUpdate(true);
        return BaseLayout(
            hasForm: false,
            isWithWillPopScope: true,
            willpopCallback: () {
              CacheService.setIsDisableUpdate(false);
              p.setNoticeSettings(SwichType.SWICH_IS_NOT_DISTURB,
                  p.notdisturbSwichValue ?? false);
              return true;
            },
            appBar: MainAppBar(
              context,
              titleText:
                  AppText.text('${tr('notice')}', style: AppTextStyle.bold_20),
            ),
            child: FutureBuilder<SettingsResult>(
                future: p.init(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    noticeSwichValue.value = p.noticeSwichValue ?? false;
                    return Column(
                      children: [
                        Padding(
                            padding: AppSize.noticePageTopWidgetPadding,
                            child: _buildItemRow(context, '${tr('use_notice')}',
                                swichType: SwichType.SWICH_IS_USE_NOTICE)),
                        Divider(
                            color: AppColors.textGrey,
                            height: AppSize.dividerHeight),
                        _buildWhenSetNotDisturb(context)
                      ],
                    );
                  }
                  return Container();
                }));
      },
    );
  }
}
