import 'package:flutter/material.dart';
import 'package:medsalesportal/buildConfig/kolon_build_config.dart';
import 'package:medsalesportal/util/is_super_account.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/dialog_contents.dart';
import 'package:medsalesportal/model/update/check_update_model.dart';
import 'package:medsalesportal/view/settings/font_setting_page.dart';
import 'package:medsalesportal/view/settings/notice_setting_page.dart';
import 'package:medsalesportal/view/commonLogin/common_login_page.dart';
import 'package:medsalesportal/enums/update_and_notice_check_type.dart';
import 'package:medsalesportal/view/settings/send_suggestions_page.dart';
import 'package:medsalesportal/view/settings/provider/settings_provider.dart';
import 'package:medsalesportal/view/commonLogin/update_and_notice_dialog.dart';

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
                    AppText.text('${data.esLogin!.ename}',
                        style: AppTextStyle.w500_16),
                    Padding(
                        padding: EdgeInsets.only(top: AppSize.listFontSpacing)),
                    AppText.text('${data.esLogin!.logid!.toLowerCase()}',
                        style: AppTextStyle.default_16)
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
                              '${KolonBuildConfig.KOLON_APP_BUILD_TYPE == 'dev' ? '(개발)제약 영업포탈' : '제약 영업포탈'}${tr('is_ready_to_logout')}',
                            ));

                        if (result != null && result) {
                          CacheService.deleteUserInfoWhenSignOut();
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

  Widget _buildItemRow(BuildContext context, String text) {
    return Row(
      children: [AppText.text('$text', style: AppTextStyle.w500_16), Spacer()],
    );
  }

  Widget _buildVersionRow(BuildContext context, CheckUpdateModel versionInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSize.defaultContentsWidth * .25,
          child: AppText.text('${tr('version_info')}',
              style: AppTextStyle.w500_16, textAlign: TextAlign.start),
        ),
        Padding(padding: EdgeInsets.only(left: AppSize.versionInfoSpacing1)),
        SizedBox(
            width: AppSize.defaultContentsWidth * .25,
            child: AppText.text('${versionInfo.currentVersion}',
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
    final p = context.read<SettingsProvider>();
    return BaseLayout(
        hasForm: true,
        appBar: MainAppBar(context,
            titleText:
                AppText.text('${tr('settings')}', style: AppTextStyle.w500_22)),
        child: FutureBuilder<SettingsResult>(
            future: p.init(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done &&
                  snapshot.data!.isSuccessful) {
                return Column(
                  children: [
                    _buildNameRow(context, snapshot.data!),
                    _buildDividerLine(),
                    InkWell(
                        onTap: () => Navigator.pushNamed(
                            context, NoticeSettingPage.routeName),
                        child: Padding(
                            padding: AppSize.listPadding,
                            child: _buildItemRow(context, '${tr('notice')}'))),
                    Divider(
                        color: AppColors.textGrey,
                        height: AppSize.dividerHeight),
                    InkWell(
                        onTap: () => Navigator.pushNamed(
                            context, FontSettingsPage.routeName),
                        child: Padding(
                            padding: AppSize.listPadding,
                            child:
                                _buildItemRow(context, '${tr('font_size')}'))),
                    Divider(
                        color: AppColors.textGrey,
                        height: AppSize.dividerHeight),
                    InkWell(
                        onTap: () => Navigator.pushNamed(
                            context, SendSuggestionPage.routeName),
                        child: Padding(
                            padding: AppSize.listPadding,
                            child: _buildItemRow(
                                context, '${tr('send_suggestion')}'))),
                    Divider(
                        color: AppColors.textGrey,
                        height: AppSize.dividerHeight),
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
              return Container();
            }));
  }
}
