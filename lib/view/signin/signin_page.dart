import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/styles/app_colors.dart';
import 'package:medsalesportal/styles/app_image.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/styles/app_style.dart';
import 'package:medsalesportal/styles/app_text_style.dart';
import 'package:medsalesportal/util/hiden_keybord.dart';
import 'package:medsalesportal/view/common/app_dialog.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_loading_view_on_stack_widget.dart';
import 'package:medsalesportal/view/home/home_page.dart';
import 'package:medsalesportal/view/signin/provider/signin_provider.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _passwordController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _idController!.dispose();
    _passwordController!.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildTextFormForId(BuildContext context) {
    final p = context.read<SigninProvider>();

    return Padding(
        padding: AppSize.defaultSidePadding,
        child: Selector<SigninProvider, String?>(
            selector: (context, provider) => provider.userAccount,
            builder: (context, account, _) {
              return BaseInputWidget(
                  onTap: () {
                    Future.delayed(Duration(milliseconds: 400), () {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    });
                  },
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

  Widget buildTextFormForPassword(BuildContext context) {
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
                      Future.delayed(Duration(milliseconds: 400), () {
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      });
                    },
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

  Widget buildIdSaveCheckBox(BuildContext context) {
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

  Widget buildAutoSigninCheckBox(BuildContext context) {
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

  Widget buildCheckBoxRow(BuildContext context) {
    return Padding(
        padding: AppSize.defaultSidePadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildIdSaveCheckBox(context),
            buildAutoSigninCheckBox(context)
          ],
        ));
  }

  Widget buildSubmmitButton(BuildContext context) {
    final p = context.read<SigninProvider>();
    return Selector<SigninProvider, Tuple3<bool, bool, bool>>(
        selector: (context, provider) => Tuple3(provider.isCheckedAutoSigninBox,
            provider.isCheckedSaveIdBox, provider.isValueNotNull),
        builder: (context, tuple, _) {
          return AppStyles.buildButton(
              context,
              '${tr('signin')}',
              AppSize.defaultContentsWidth,
              tuple.item3 ? AppColors.primary : AppColors.unReadyButton,
              AppTextStyle.color_18(
                  tuple.item3 ? AppColors.whiteText : AppColors.unReadyText),
              AppSize.radius8,
              tuple.item3
                  ? () async {
                      p.startErrorMessage('');
                      Platform.isAndroid
                          ? hideKeyboardForAndroid(context)
                          : hideKeyboard(context);
                      final result = await p.signIn();
                      if (result.isSuccessful) {
                        Navigator.popAndPushNamed(context, HomePage.routeName);
                      } else {
                        if (result.isShowPopup != null && result.isShowPopup!) {
                          switch (result.message) {
                            case 'serverError':
                              AppDialog.showServerErrorDialog(context);
                              break;
                            case 'networkError':
                              AppDialog.showNetworkErrorDialog(context);
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
        });
  }

  Widget buildErrorMessage(BuildContext context) {
    return Selector<SigninProvider, String>(
      selector: (context, provider) => provider.errorMessage,
      builder: (context, errorMessage, _) {
        return Column(
          children: [
            errorMessage.isNotEmpty
                ? Padding(
                    padding:
                        EdgeInsets.only(top: AppSize.defaultListItemSpacing))
                : Container(),
            Container(
              alignment: Alignment.centerLeft,
              child: AppStyles.text('$errorMessage', AppTextStyle.danger_14),
            ),
            errorMessage.isNotEmpty
                ? Padding(
                    padding:
                        EdgeInsets.only(top: AppSize.defaultListItemSpacing))
                : Container(),
          ],
        );
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
          String? id;
          String? pw;
          // ignore: unused_local_variable
          String? message;
          // ignore: unused_local_variable
          bool isShowPopup = false;
          if (arguments != null) {
            arguments as Map<String, dynamic>;
            id = arguments['id'];
            pw = arguments['pw'];
            message = arguments['message'];
            isShowPopup = arguments['isShowPopup'] ?? false;
          }

          return FutureBuilder<Map<String, dynamic>?>(
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
                          Padding(
                              padding: AppSize.signinLogoPadding,
                              child: Center(
                                  child: AppImage.getImage(
                                      ImageType.SPLASH_ICON))),
                          buildTextFormForId(context),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: AppSize.defaultListItemSpacing)),
                          buildTextFormForPassword(context),
                          Padding(
                              padding: AppSize.defaultSidePadding,
                              child: buildErrorMessage(context)),
                          buildCheckBoxRow(context),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: AppSize.homeSubmmitButtonPadding)),
                          Padding(
                              padding: AppSize.defaultSidePadding,
                              child: buildSubmmitButton(context))
                        ],
                      ),
                      Selector<SigninProvider, bool>(
                        selector: (context, provider) => provider.isLoadData,
                        builder: (context, isLoadData, _) {
                          return isLoadData
                              ? BaseLoadingViewOnStackWidget.build(
                                  context, isLoadData)
                              : Container();
                        },
                      ),
                    ],
                  );
                });
              }
              return Container();
            },
          );
        },
      ),
    );
  }
}
