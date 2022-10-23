import 'package:medsalesportal/globalProvider/login_provider.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/view/home/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_loading_view.dart';
import 'package:medsalesportal/view/signin/provider/signin_page_provider.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);
  static const String routeName = '/signin';

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  late TextEditingController _idController;
  late TextEditingController _passwordController;
  late ScrollController _scrollController;
  String? id;
  String? pw;
  String? message;
  late FocusNode? idFocus;
  late FocusNode? pwFocus;
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
    _idController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildTextFormForId(BuildContext context) {
    final p = context.read<SigninPageProvider>();
    return Padding(
        padding: AppSize.defaultSidePadding,
        child: Selector<SigninPageProvider, String?>(
            selector: (context, provider) => provider.userAccount,
            builder: (context, account, _) {
              return BaseInputWidget(
                onTap: () {},
                focusNode: idFocus,
                height: AppSize.buttonHeight,
                textEditingController: _idController,
                keybordType: TextInputType.multiline,
                context: context,
                iconType: account != null ? InputIconType.DELETE : null,
                hintText: account != null ? null : '${tr('id')}',
                width: AppSize.defaultContentsWidth,
                defaultIconCallback: () {
                  p.setAccount(null);
                  _idController.text = '';
                },
                hintTextStyleCallBack:
                    account != null ? null : () => AppTextStyle.hint_16,
                onChangeCallBack: (str) => p.setAccount(str),
                enable: true,
              );
            }));
  }

  Widget _buildTextFormForPassword(BuildContext context) {
    final p = context.read<SigninPageProvider>();

    return Padding(
        padding: AppSize.defaultSidePadding,
        child: Selector<SigninPageProvider, String?>(
            selector: (context, provider) => provider.password,
            builder: (context, password, _) {
              return Builder(builder: (context) {
                return BaseInputWidget(
                  textEditingController: _passwordController,
                  onTap: () {},
                  focusNode: pwFocus,
                  context: context,
                  height: AppSize.buttonHeight,
                  iconType: password != null ? InputIconType.DELETE : null,
                  hintText: password != null ? null : '${tr('password')}',
                  width: AppSize.defaultContentsWidth,
                  keybordType: TextInputType.visiblePassword,
                  defaultIconCallback: () {
                    p.setPassword(null);
                    _passwordController.text = '';
                  },
                  hintTextStyleCallBack: () => AppTextStyle.hint_16,
                  onChangeCallBack: (str) => p.setPassword(str),
                  enable: true,
                );
              });
            }));
  }

  Widget _buildIdSaveCheckBox(BuildContext context) {
    final p = context.read<SigninPageProvider>();
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
              child: Selector<SigninPageProvider, bool>(
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
          AppText.text('${tr('save_id')}', style: AppTextStyle.sub_14)
        ],
      ),
    );
  }

  Widget _buildAutoSigninCheckBox(BuildContext context) {
    final p = context.read<SigninPageProvider>();
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
              child: Selector<SigninPageProvider, bool>(
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
          AppText.text('${tr('auto_signin')}', style: AppTextStyle.sub_14)
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
    final p = context.read<SigninPageProvider>();
    return Padding(
        padding: AppSize.defaultSidePadding,
        child: Selector<SigninPageProvider, Tuple3<bool, bool, bool>>(
            selector: (context, provider) => Tuple3(
                provider.isCheckedAutoSigninBox,
                provider.isCheckedSaveIdBox,
                _idController.text.trim().isNotEmpty &&
                    _passwordController.text.trim().isNotEmpty),
            builder: (context, tuple, _) {
              return AppStyles.buildButton(
                  context,
                  '${tr('signin')}',
                  AppSize.defaultContentsWidth,
                  tuple.item3 ? AppColors.primary : AppColors.unReadyButton,
                  AppTextStyle.color_18(tuple.item3
                      ? AppColors.whiteText
                      : AppColors.unReadyText),
                  AppSize.radius8, () async {
                if (tuple.item3) {
                  p.startLoading();
                  try {
                    p.setAccount(_idController.text.trim());
                    p.setPassword(_passwordController.text.trim());
                    p.startErrorMessage('');
                    hideKeyboard(context);
                    // p.setIsIdFocused(false);
                    // p.setIsPwFocused(false);
                    final lp = context.read<LoginProvider>();
                    final result = await lp.startSignin(
                        p.userAccount!, p.password!,
                        isAutoLogin: false);

                    if (result.isSuccessful) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomePage.routeName, (route) => false);
                    } else {
                      if (result.isNetworkError ?? false) {
                        AppDialog.showDangermessage(
                            context, tr('check_network'));
                      } else if (result.isServerError ?? false) {
                        AppDialog.showDangermessage(
                            context, tr('server_error'));
                      } else if (result.isShowErrorText ?? false) {
                        p.startErrorMessage(result.message ?? '');
                      } else {
                        AppDialog.showDangermessage(
                            context, '${result.message}');
                      }
                    }
                    p.setAutoLogin();
                    p.stopLoading();
                  } catch (e) {
                    p.stopLoading();
                  }
                }
              });
            }));
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Padding(
        padding: AppSize.defaultSidePadding,
        child: Selector<SigninPageProvider, String>(
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
                  child: AppText.text('$errorMessage',
                      style: AppTextStyle.danger_14),
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

  Widget _buildLogo() {
    return Padding(
      padding: AppSize.signinLogoPadding,
      child: Center(child: AppImage.getImage(ImageType.SPLASH_ICON)),
    );
  }

  _buildLoadingWidget(BuildContext context) {
    return Selector<SigninPageProvider, bool>(
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
        create: (context) => SigninPageProvider(),
        builder: (context, _) {
          final p = context.read<SigninPageProvider>();
          final arguments = ModalRoute.of(context)!.settings.arguments;
          if (arguments != null) {
            arguments as Map<String, dynamic>;
            id = arguments['id'];
            pw = arguments['pw'];
            var loginResult = arguments['loginResult'] as ResultModel;
            if (loginResult.isNetworkError ?? false) {
              AppDialog.showDangermessage(context, tr('check_network'));
            } else if (loginResult.isServerError ?? false) {
              AppDialog.showDangermessage(context, tr('server_error'));
            } else if (loginResult.isShowErrorText ?? false) {
              p.startErrorMessage(loginResult.message ?? '');
            } else {
              AppDialog.showDangermessage(context, '${loginResult.message}');
            }
          }

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              idFocus!.unfocus();
              pwFocus!.unfocus();
            },
            child: FutureBuilder<Map<String, dynamic>?>(
              future: p.setDefaultData(id: id, pw: pw),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Builder(builder: (context) {
                    if (snapshot.data!['id'] != null) {
                      _idController.text = snapshot.data!['id'];
                    }
                    if (snapshot.data!['pw'] != null) {
                      _passwordController.text = snapshot.data!['pw'];
                    }
                    if (message != null) {
                      Future.delayed(Duration.zero, () {
                        AppDialog.showDangermessage(context, message!);
                      });
                    }
                    return Stack(
                      children: [
                        SizedBox(
                            height: AppSize.realHeight,
                            child: ListView(
                              shrinkWrap: true,
                              controller: _scrollController,
                              children: [
                                _buildLogo(),
                                _buildTextFormForId(context),
                                defaultSpacing(),
                                _buildTextFormForPassword(context),
                                _buildErrorMessage(context),
                                _buildCheckBoxRow(context),
                                defaultSpacing(times: 4),
                                _buildSubmmitButton(context),
                              ],
                            )),
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
