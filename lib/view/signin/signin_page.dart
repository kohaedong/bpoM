import 'dart:io';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/util/hiden_keybord.dart';
import 'package:medsalesportal/view/home/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/signin/provider/signin_provider.dart';
import 'package:medsalesportal/view/common/base_loading_view_on_stack_widget.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);
  static const String routeName = '/signin';

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController? _idController;
  TextEditingController? _passwordController;
  late ScrollController _scrollController;
  String? id;
  String? pw;
  String? message;
  bool isShowPopup = false;
  FocusNode? idFocus;
  FocusNode? pwFocus;
  @override
  void initState() {
    super.initState();
    idFocus = FocusNode();
    pwFocus = FocusNode();
    _idController = TextEditingController();
    _passwordController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    idFocus?.dispose();
    pwFocus?.dispose();
    _idController!.dispose();
    _passwordController!.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildTextFormForId(BuildContext context) {
    final p = context.read<SigninProvider>();
    return Padding(
        padding: AppSize.defaultSidePadding,
        child: Selector<SigninProvider, String?>(
            selector: (context, provider) => provider.userAccount,
            builder: (context, account, _) {
              return BaseInputWidget(
                  onTap: () {
                    p.setIsIdFocused(true);
                  },
                  focusNode: idFocus,
                  textEditingController: _idController,
                  keybordType: TextInputType.multiline,
                  context: context,
                  iconType: account != null ? InputIconType.DELETE : null,
                  hintText: account != null ? null : '${tr('id')}',
                  width: AppSize.defaultContentsWidth,
                  defaultIconCallback: () {
                    p.setAccount(null);
                    _idController!.text = '';
                  },
                  hintTextStyleCallBack:
                      account != null ? null : () => AppTextStyle.hint_16,
                  onChangeCallBack: (str) => p.setAccount(str),
                  enable: true,
                  height: AppSize.buttonHeight);
            }));
  }

  Widget _buildTextFormForPassword(BuildContext context) {
    final p = context.read<SigninProvider>();

    return Padding(
        padding: AppSize.defaultSidePadding,
        child: Selector<SigninProvider, String?>(
            selector: (context, provider) => provider.password,
            builder: (context, password, _) {
              return Builder(builder: (context) {
                return BaseInputWidget(
                    textEditingController: _passwordController,
                    onTap: () {
                      p.setIsPwFocused(true);
                    },
                    focusNode: pwFocus,
                    context: context,
                    iconType: password != null ? InputIconType.DELETE : null,
                    hintText: password != null ? null : '${tr('password')}',
                    width: AppSize.defaultContentsWidth,
                    keybordType: TextInputType.visiblePassword,
                    defaultIconCallback: () {
                      p.setPassword(null);
                      _passwordController!.text = '';
                    },
                    hintTextStyleCallBack: () => AppTextStyle.hint_16,
                    onChangeCallBack: (str) => p.setPassword(str),
                    enable: true,
                    height: AppSize.buttonHeight);
              });
            }));
  }

  Widget _buildIdSaveCheckBox(BuildContext context) {
    final p = context.read<SigninProvider>();
    return InkWell(
      onTap: () {
        p.setIdCheckBox();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: AppSize.defaultIconWidth,
              height: AppSize.defaultIconWidth,
              child: Selector<SigninProvider, bool>(
                selector: (context, provider) => provider.isCheckedSaveIdBox,
                builder: (context, isChecked, _) {
                  return Checkbox(
                      activeColor: AppColors.primary,
                      side: BorderSide(color: Colors.grey),
                      value: isChecked,
                      onChanged: (value) {
                        p.setIdCheckBox();
                      });
                },
              )),
          Padding(
              padding: EdgeInsets.only(right: AppSize.textFiledDefaultSpacing)),
          AppStyles.text('${tr('save_id')}', AppTextStyle.sub_14)
        ],
      ),
    );
  }

  Widget _buildAutoSigninCheckBox(BuildContext context) {
    final p = context.read<SigninProvider>();
    return InkWell(
      onTap: () {
        p.setAutoSigninCheckBox();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: AppSize.defaultIconWidth,
              height: AppSize.defaultIconWidth,
              child: Selector<SigninProvider, bool>(
                selector: (context, provider) =>
                    provider.isCheckedAutoSigninBox,
                builder: (context, isChecked, _) {
                  return Checkbox(
                      activeColor: AppColors.primary,
                      side: BorderSide(color: Colors.grey),
                      value: isChecked,
                      onChanged: (value) {
                        p.setAutoSigninCheckBox();
                      });
                },
              )),
          Padding(
              padding: EdgeInsets.only(right: AppSize.textFiledDefaultSpacing)),
          AppStyles.text('${tr('auto_signin')}', AppTextStyle.sub_14)
        ],
      ),
    );
  }

  Widget _buildCheckBoxRow(BuildContext context) {
    return Padding(
        padding: AppSize.defaultSidePadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildIdSaveCheckBox(context),
            _buildAutoSigninCheckBox(context)
          ],
        ));
  }

  Widget _buildSubmmitButton(BuildContext context) {
    final p = context.read<SigninProvider>();
    return Selector<SigninProvider, Tuple2<bool?, bool?>>(
      selector: (context, provider) =>
          Tuple2(provider.isIdFocused, provider.isPwFocused),
      builder: (context, tuple, _) {
        return Positioned(
            left: 0,
            bottom: (tuple.item1 != null && tuple.item1!) ||
                    (tuple.item2 != null && tuple.item2!)
                ? 0
                : AppSize.realHeight * .2,
            child: Padding(
                padding: AppSize.defaultSidePadding,
                child: Selector<SigninProvider, Tuple3<bool, bool, bool>>(
                    selector: (context, provider) => Tuple3(
                        provider.isCheckedAutoSigninBox,
                        provider.isCheckedSaveIdBox,
                        provider.isValueNotNull),
                    builder: (context, tuple, _) {
                      return AppStyles.buildButton(
                          context,
                          '${tr('signin')}',
                          AppSize.defaultContentsWidth,
                          tuple.item3
                              ? AppColors.primary
                              : AppColors.unReadyButton,
                          AppTextStyle.color_18(tuple.item3
                              ? AppColors.whiteText
                              : AppColors.unReadyText),
                          AppSize.radius8,
                          tuple.item3
                              ? () async {
                                  p.startErrorMessage('');
                                  Platform.isAndroid
                                      ? hideKeyboardForAndroid(context)
                                      : hideKeyboard(context);
                                  p.setIsIdFocused(false);
                                  p.setIsPwFocused(false);
                                  final result = await p.signIn();
                                  if (result.isSuccessful) {
                                    Navigator.popAndPushNamed(
                                        context, HomePage.routeName);
                                  } else {
                                    if (result.isShowPopup != null &&
                                        result.isShowPopup!) {
                                      switch (result.message) {
                                        case 'serverError':
                                          AppDialog.showServerErrorDialog(
                                              context);
                                          break;
                                        case 'networkError':
                                          AppDialog.showNetworkErrorDialog(
                                              context);
                                          break;
                                        default:
                                          AppDialog.showDangermessage(
                                              context, '${result.message}');
                                      }
                                    } else {
                                      p.startErrorMessage(result.message);
                                    }
                                  }
                                }
                              : () {});
                    })));
      },
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Padding(
        padding: AppSize.defaultSidePadding,
        child: Selector<SigninProvider, String>(
          selector: (context, provider) => provider.errorMessage,
          builder: (context, errorMessage, _) {
            return Column(
              children: [
                errorMessage.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: AppSize.defaultListItemSpacing))
                    : Container(),
                Container(
                  alignment: Alignment.centerLeft,
                  child:
                      AppStyles.text('$errorMessage', AppTextStyle.danger_14),
                ),
                errorMessage.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: AppSize.defaultListItemSpacing))
                    : Container(),
              ],
            );
          },
        ));
  }

  Widget _buildAutoSpacing(BuildContext context) {
    return Selector<SigninProvider, Tuple2<bool?, bool?>>(
      selector: (context, provider) =>
          Tuple2(provider.isIdFocused, provider.isPwFocused),
      builder: (context, tuple, _) {
        return Padding(
            padding: (tuple.item1 != null && tuple.item1!) ||
                    (tuple.item2 != null && tuple.item2!)
                ? EdgeInsets.only(top: 100)
                : EdgeInsets.zero);
      },
    );
  }

  Widget _buildLogo() {
    return Padding(
        padding: AppSize.signinLogoPadding,
        child: Center(child: AppImage.getImage(ImageType.SPLASH_ICON)));
  }

  _buildLoadingWidget(BuildContext context) {
    return Selector<SigninProvider, bool>(
      selector: (context, provider) => provider.isLoadData,
      builder: (context, isLoadData, _) {
        return isLoadData
            ? BaseLoadingViewOnStackWidget.build(context, isLoadData)
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      hasForm: true,
      isResizeToAvoidBottomInset: true,
      appBar: null,
      child: ChangeNotifierProvider(
        create: (context) => SigninProvider(),
        builder: (context, _) {
          final p = context.read<SigninProvider>();
          final arguments = ModalRoute.of(context)!.settings.arguments;
          if (arguments != null) {
            arguments as Map<String, dynamic>;
            id = arguments['id'];
            pw = arguments['pw'];
            message = arguments['message'];
            isShowPopup = arguments['isShowPopup'] ?? false;
          }
          return GestureDetector(
            onTap: () {
              idFocus!.unfocus();
              pwFocus!.unfocus();
              final p = context.read<SigninProvider>();
              p.setIsIdFocused(false);
              p.setIsPwFocused(false);
            },
            child: FutureBuilder<Map<String, dynamic>?>(
              future: p.setDefaultData(id: id, pw: pw),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Builder(builder: (context) {
                    if (snapshot.data!['id'] != null) {
                      p.userAccount = snapshot.data!['id'];
                      _idController!.text = snapshot.data!['id'];
                    }
                    if (snapshot.data!['pw'] != null) {
                      p.password = snapshot.data!['pw'];
                      _passwordController!.text = snapshot.data!['pw'];
                    }
                    return Stack(
                      children: [
                        ListView(
                          controller: _scrollController,
                          children: [
                            _buildLogo(),
                            _buildTextFormForId(context),
                            defaultSpacing(),
                            _buildTextFormForPassword(context),
                            _buildErrorMessage(context),
                            _buildCheckBoxRow(context),
                            _buildAutoSpacing(context)
                          ],
                        ),
                        _buildSubmmitButton(context),
                        _buildLoadingWidget(context)
                      ],
                    );
                  });
                }
                return Container();
              },
            ),
          );
        },
      ),
    );
  }
}
