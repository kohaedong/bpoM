import 'package:flutter/material.dart';
import 'package:medsalesportal/globalProvider/login_provider.dart';
import 'package:medsalesportal/model/user/user_settings.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/enums/app_theme_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/globalProvider/app_theme_provider.dart';
import 'package:medsalesportal/view/settings/provider/settings_provider.dart';

class FontSettingsPage extends StatefulWidget {
  static const String routeName = '/fontSettings';

  const FontSettingsPage({Key? key}) : super(key: key);

  @override
  State<FontSettingsPage> createState() => _FontSettingsPageState();
}

class _FontSettingsPageState extends State<FontSettingsPage> {
  var themeTypeNotiffier =
      ValueNotifier<AppThemeType>(AppThemeType.TEXT_MEDIUM);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    themeTypeNotiffier.dispose();
  }

  Widget buildRadio(AppThemeProvider provider, AppThemeType type) {
    return ValueListenableBuilder(
      valueListenable: themeTypeNotiffier,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Transform.scale(
          scale: 1.1.w,
          child: Radio<AppThemeType>(
            materialTapTargetSize: MaterialTapTargetSize.padded,
            groupValue: value,
            onChanged: (typeValue) {
              provider.setThemeType(typeValue!);
              themeTypeNotiffier.value = provider.themeType;
            },
            value: type,
            activeColor: AppColors.primary,
          ),
        );
      },
    );
  }

  Widget buildItemRow(BuildContext context, AppThemeProvider provider,
      AppThemeType type, String text1, String text2) {
    final lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
    return InkWell(
      onTap: () {
        provider.setThemeType(type);
        var temp = UserSettings.fromJson(lp.userSettings!.toJson());
        temp.textScale = type.textScale;
        lp.setUserSettings(temp);
        pr(lp.userSettings!.toJson());
        themeTypeNotiffier.value = provider.themeType;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              alignment: Alignment.centerLeft,
              width: AppSize.defaultContentsWidth * .38,
              child: AppText.text('$text1', style: AppTextStyle.default_16)),
          Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppText.text('$text2',
                      style: type == AppThemeType.TEXT_SMALL
                          ? AppTextStyle.default_14
                          : type == AppThemeType.TEXT_MEDIUM
                              ? AppTextStyle.default_16
                              : type == AppThemeType.TEXT_BIG
                                  ? AppTextStyle.default_18
                                  : AppTextStyle.default_20))),
          buildRadio(provider, type),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppThemeProvider>();
    themeTypeNotiffier.value = provider.themeType;
    return ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      builder: (context, _) {
        final p = context.read<SettingsProvider>();
        return FutureBuilder(
            future: p.init(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return BaseLayout(
                  hasForm: false,
                  appBar: MainAppBar(
                    context,
                    titleText: AppText.text('${tr('font_size')}',
                        style: AppTextStyle.w500_22),
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: AppSize.fontSizePageTopWidgetPadding,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AppText.text(
                                '${tr('font_size_description')}',
                                style: AppTextStyle.sub_14),
                          )),
                      Divider(
                          color: AppColors.textGrey,
                          height: AppSize.dividerHeight),
                      Padding(
                          padding: AppSize.fontSizePagePadding,
                          child: buildItemRow(
                              context,
                              provider,
                              AppThemeType.TEXT_SMALL,
                              '${tr('small')}',
                              '${tr('hello')}')),
                      Divider(
                          color: AppColors.textGrey,
                          height: AppSize.dividerHeight),
                      Padding(
                          padding: AppSize.fontSizePagePadding,
                          child: buildItemRow(
                              context,
                              provider,
                              AppThemeType.TEXT_MEDIUM,
                              '${tr('medium')}',
                              '${tr('hello')}')),
                      Divider(
                          color: AppColors.textGrey,
                          height: AppSize.dividerHeight),
                      Padding(
                          padding: AppSize.fontSizePagePadding,
                          child: buildItemRow(
                              context,
                              provider,
                              AppThemeType.TEXT_BIG,
                              '${tr('big')}',
                              '${tr('hello')}')),
                      Divider(
                          color: AppColors.textGrey,
                          height: AppSize.dividerHeight),
                      Padding(
                          padding: AppSize.fontSizePagePadding,
                          child: buildItemRow(
                              context,
                              provider,
                              AppThemeType.TEXT_BIGGEST,
                              '${tr('biggest')}',
                              '${tr('hello')}')),
                      Divider(
                          color: AppColors.textGrey,
                          height: AppSize.dividerHeight),
                    ],
                  ),
                );
              }
              return DefaultShimmer.buildDefaultResultShimmer();
            });
      },
    );
  }
}
