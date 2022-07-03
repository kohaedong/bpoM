import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/app_theme_type.dart';
import 'package:medsalesportal/styles/app_colors.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/styles/app_style.dart';
import 'package:medsalesportal/styles/app_text_style.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/provider/app_theme_provider.dart';
import 'package:medsalesportal/view/settings/provider/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return InkWell(
      onTap: () {
        provider.setThemeType(type);
        context.read<SettingsProvider>().setSettingsScale(type.textScale);
        themeTypeNotiffier.value = provider.themeType;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              alignment: Alignment.centerLeft,
              width: AppSize.defaultContentsWidth * .38,
              child: AppStyles.text('$text1', AppTextStyle.default_16)),
          Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppStyles.text(
                      '$text2',
                      type == AppThemeType.TEXT_SMALL
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
    final settingsProvider = context.read<SettingsProvider>();
    themeTypeNotiffier.value = provider.themeType;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        await settingsProvider.saveUserEvn();
        return true;
      },
      child: BaseLayout(
        hasForm: false,
        appBar: MainAppBar(
          context,
          titleText: AppStyles.text('${tr('font_size')}', AppTextStyle.w500_20),
          callback: () async {
            Navigator.pop(context);
            await settingsProvider.saveUserEvn();
          },
        ),
        child: Column(
          children: [
            Padding(
                padding: AppSize.fontSizePageTopWidgetPadding,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppStyles.text(
                      '${tr('font_size_description')}', AppTextStyle.sub_14),
                )),
            Divider(color: AppColors.textGrey, height: AppSize.dividerHeight),
            Padding(
                padding: AppSize.fontSizePagePadding,
                child: buildItemRow(context, provider, AppThemeType.TEXT_SMALL,
                    '${tr('small')}', '${tr('hello')}')),
            Divider(color: AppColors.textGrey, height: AppSize.dividerHeight),
            Padding(
                padding: AppSize.fontSizePagePadding,
                child: buildItemRow(context, provider, AppThemeType.TEXT_MEDIUM,
                    '${tr('medium')}', '${tr('hello')}')),
            Divider(color: AppColors.textGrey, height: AppSize.dividerHeight),
            Padding(
                padding: AppSize.fontSizePagePadding,
                child: buildItemRow(context, provider, AppThemeType.TEXT_BIG,
                    '${tr('big')}', '${tr('hello')}')),
            Divider(color: AppColors.textGrey, height: AppSize.dividerHeight),
            Padding(
                padding: AppSize.fontSizePagePadding,
                child: buildItemRow(
                    context,
                    provider,
                    AppThemeType.TEXT_BIGGEST,
                    '${tr('biggest')}',
                    '${tr('hello')}')),
            Divider(color: AppColors.textGrey, height: AppSize.dividerHeight),
          ],
        ),
      ),
    );
  }
}
