import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bpom/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bpom/view/common/base_layout.dart';
import 'package:bpom/view/common/base_app_bar.dart';
import 'package:bpom/view/common/base_app_toast.dart';
import 'package:bpom/view/common/base_app_dialog.dart';
import 'package:bpom/view/common/dialog_contents.dart';
import 'package:bpom/view/common/fountion_of_hidden_key_borad.dart';
import 'package:bpom/view/settings/provider/settings_provider.dart';

class SendSuggestionPage extends StatefulWidget {
  const SendSuggestionPage({Key? key}) : super(key: key);
  static const String routeName = '/sendSuggestion';

  @override
  _SendSuggestionPageState createState() => _SendSuggestionPageState();
}

class _SendSuggestionPageState extends State<SendSuggestionPage> {
  late ScrollController _textFieldScrollController;
  late ScrollController _pageScrollController;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textFieldScrollController = ScrollController();
    _pageScrollController = ScrollController();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textFieldScrollController.dispose();
    _pageScrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  Widget buildDiscription() {
    return Padding(
        padding: AppSize.fontSizePageTopWidgetPadding,
        child: Align(
          alignment: Alignment.centerLeft,
          child: AppText.text('${tr('send_suggestions_discription')}',
              style: AppTextStyle.default_16,
              maxLines: 20,
              textAlign: TextAlign.start),
        ));
  }

  Widget buildSuggetionCenterPadding() {
    return Padding(
      padding: AppSize.sendSuggestionsCenterPadding,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: AppText.text('${tr('write_some_suggestions')}',
                style: AppTextStyle.w500_16),
          ),
        ],
      ),
    );
  }

  Widget buildTextFieldBox(BuildContext context) {
    return Container(
        height: AppSize.suggestionsBoxHeight,
        width: AppSize.boxWidth,
        child: TextField(
          controller: _textEditingController,
          scrollController: _textFieldScrollController,
          onTap: () {
            final maxScrollValue =
                _pageScrollController.position.maxScrollExtent;
            _pageScrollController.animateTo(maxScrollValue,
                duration: Duration(microseconds: 800),
                curve: Curves.slowMiddle);
          },
          onChanged: (text) {
            final p = context.read<SettingsProvider>();
            p.setSuggestion(text.trim());
          },
          autofocus: false,
          inputFormatters: [
            LengthLimitingTextInputFormatter(200),
          ],
          autocorrect: false,
          keyboardType: TextInputType.multiline,
          maxLines: 8,
          style: AppTextStyle.default_16,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(AppSize.defaultListItemSpacing),
              fillColor: AppColors.whiteText,
              hintText: '${tr('suggestion_hint')}',
              hintStyle: AppTextStyle.hint_16,
              border: AppStyles.defaultBorder,
              focusedBorder: AppStyles.focusedBorder),
        ));
  }

  Widget buildSubmmitButton() {
    return Container(
        height: AppSize.buttonHeight,
        child: Consumer<SettingsProvider>(builder: (context, provider, _) {
          return TextButton(
              style: provider.suggetionText == null ||
                      provider.suggetionText!.trim().isEmpty
                  ? AppStyles.getButtonStyle(AppColors.unReadyButton,
                      AppColors.unReadyText, AppTextStyle.default_18, 0)
                  : AppStyles.getButtonStyle(AppColors.primary,
                      AppColors.whiteText, AppTextStyle.default_18, 0),
              onPressed: () async {
                hideKeyboard(context);
                if (_textEditingController.text.trim().isNotEmpty) {
                  final isSended = await provider.sendSuggestion();
                  if (isSended) {
                    AppToast().show(context, '${tr('send_success')}');
                    _textEditingController.clear();
                    provider.setSuggestion(null);
                  }
                }
              },
              child: Container(
                width: AppSize.buildWidth(context, 1),
                height: AppSize.buttonHeight,
                child: Center(child: Text('${tr('submmit')}')),
              ));
        }));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      builder: (context, _) {
        return BaseLayout(
            hasForm: true,
            isWithWillPopScope: true,
            isResizeToAvoidBottomInset: true,
            appBar: MainAppBar(
              context,
              titleText: AppText.text('${tr('send_suggestion')}',
                  style: AppTextStyle.w500_22),
              icon: Icon(Icons.close_rounded),
              cachePageTypeCallBack: () =>
                  _textEditingController.text.trim().isNotEmpty,
            ),
            child: WillPopScope(
              onWillPop: () async {
                if (_textEditingController.text.trim().isNotEmpty) {
                  var popupResult = await AppDialog.showPopup(
                      context,
                      buildTowButtonTextContents(
                        context,
                        '${tr('is_exit_current_page')}',
                      ));
                  if (popupResult != null) {
                    popupResult as bool;
                    if (popupResult) {
                      Navigator.pop(context, true);
                    }
                  }
                }
                return false;
              },
              child: LayoutBuilder(
                builder: (context, constraint) {
                  return SingleChildScrollView(
                    controller: _pageScrollController,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: <Widget>[
                            buildDiscription(),
                            buildSuggetionCenterPadding(),
                            buildTextFieldBox(context),
                            Spacer(),
                            buildSubmmitButton()
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ));
      },
    );
  }
}
