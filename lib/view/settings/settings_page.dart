import 'package:bpom/buildConfig/kolon_build_config.dart';
import 'package:bpom/enums/update_and_notice_check_type.dart';
import 'package:bpom/model/update/check_update_model.dart';
import 'package:bpom/styles/export_common.dart';
import 'package:bpom/view/common/base_app_bar.dart';
import 'package:bpom/view/common/base_app_dialog.dart';
import 'package:bpom/view/common/base_layout.dart';
import 'package:bpom/view/common/dialog_contents.dart';
import 'package:bpom/view/common/widget_of_default_shimmer.dart';
import 'package:bpom/view/commonLogin/common_login_page.dart';
import 'package:bpom/view/commonLogin/update_and_notice_dialog.dart';
import 'package:bpom/view/settings/provider/settings_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const String routeName = '/settings';

  Widget _buildNameRow(BuildContext context, SettingsResult data) {
    return Padding(
        padding: AppSize.settingPageTopWidgetPadding,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.listViewText('${data.user!.userName}', style: AppTextStyle.w500_16),
                    Padding(
                        padding: EdgeInsets.only(top: AppSize.listFontSpacing)),
                    AppText.listViewText(
                      '${data.user!.userAccount!.toLowerCase()}',
                    )
                  ],
                ),
                Container(
                  width: AppSize.secondButtonWidth,
                  child: TextButton(
                      onPressed: () async {
                        var result = await AppDialog.showPopup(
                            context,
                            buildTowButtonTextContents(
                              context,
                              // 빌드옵션
                              '${KolonBuildConfig.KOLON_APP_BUILD_TYPE == 'dev' ? '(개발)BPO' : 'BPO'}${tr('is_ready_to_logout')}',
                            ));

                        if (result != null && result) {
                          final p = context.read<SettingsProvider>();
                          await p.signOut();
                          Navigator.pushNamedAndRemoveUntil(context,
                              CommonLoginPage.routeName, (route) => false);
                        }
                      },
                      style: AppStyles.getButtonStyle(
                          AppColors.primary,
                          AppColors.whiteText,
                          AppTextStyle.default_14,
                          AppSize.radius4),
                      child: Text(
                        '${tr('signout')}',
                      )),
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: AppSize.defaultListItemSpacing))
          ],
        ));
  }

  Widget _buildVersionRow(BuildContext context, CheckUpdateModel versionInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSize.defaultContentsWidth * .25,
          child: AppText.listViewText('${tr('version_info')}',
              style: AppTextStyle.w500_16, textAlign: TextAlign.start),
        ),
        Padding(padding: EdgeInsets.only(left: AppSize.versionInfoSpacing1)),
        SizedBox(
            width: AppSize.defaultContentsWidth * .25,
            child: AppText.listViewText('${versionInfo.currentVersion}',
                style: AppTextStyle.hint_16, textAlign: TextAlign.start)),
        Padding(
            padding: EdgeInsets.only(right: AppSize.defaultListItemSpacing)),
        Expanded(
            child: versionInfo.result == 'OK'
                ? Row(
                    children: [
                      Spacer(),
                      Container(
                          width: AppSize.secondButtonWidth,
                          child: TextButton(
                              onPressed: () {
                                CheckUpdateAndNoticeService.check(
                                    context, CheckType.UPDATE_ONLY, false);
                              },
                              style: AppStyles.getButtonStyle(
                                  AppColors.primary,
                                  AppColors.whiteText,
                                  AppTextStyle.default_14,
                                  AppSize.radius4),
                              child: Text(
                                '${tr('do_update')}',
                              ))),
                    ],
                  )
                : SizedBox(
                    child: AppText.text('${tr('is_latest_version')}',
                        style: AppTextStyle.default_14,
                        textAlign: TextAlign.end),
                  ))
      ],
    );
  }

  Widget _buildDividerLine() {
    return Divider(color: AppColors.textGrey, height: AppSize.dividerHeight);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      builder: (context, _) {
        final p = context.read<SettingsProvider>();
        return BaseLayout(
            hasForm: true,
            isWithWillPopScope: true,
            willpopCallback: () {
              return true;
            },
            appBar: MainAppBar(
              context,
              titleText: AppText.text('${tr('settings')}',
                  style: AppTextStyle.w500_22),
              callback: () async {
                Navigator.pop(context);
              },
            ),
            child: FutureBuilder<SettingsResult>(
                future: p.init(isFromFontSettinsPage: true),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        _buildNameRow(context, snapshot.data!),
                        _buildDividerLine(),
                        Padding(
                            padding: snapshot.data!.updateInfo!.result != 'NG'
                                ? AppSize.versionRowPadding
                                : AppSize.listPadding,
                            child: _buildVersionRow(
                                context, snapshot.data!.updateInfo!)),
                        Divider(
                            color: AppColors.textGrey,
                            height: AppSize.dividerHeight),
                      ],
                    );
                  }
                  return DefaultShimmer.buildDefaultResultShimmer();
                }));
      },
    );
  }
}
