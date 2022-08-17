/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/add_activity_page.dart
 * Created Date: 2022-08-11 10:39:53
 * Last Modified: 2022-08-17 14:40:05
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/model/rfc/add_activity_distance_model.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/model/rfc/et_kunnr_model.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/model/rfc/add_activity_key_man_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/view/common/base_info_row_by_key_and_value.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/view/common/base_column_with_title_and_textfiled.dart';
import 'package:medsalesportal/view/salesActivityManager/provider/add_activity_page_provider.dart';
import 'package:tuple/tuple.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({Key? key}) : super(key: key);
  static const String routeName = '/addActivityPage';

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  late TextEditingController _textEditingController;
  late TextEditingController _interviewTextEditingController;
  late ScrollController _textFieldScrollController;
  late ScrollController _interviewTextFieldScrollController;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    _interviewTextEditingController = TextEditingController();
    _textFieldScrollController = ScrollController();
    _interviewTextFieldScrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _interviewTextEditingController.dispose();
    _textFieldScrollController.dispose();
    _interviewTextFieldScrollController.dispose();
    super.dispose();
  }

  Widget _buildSelectCustomer(BuildContext context) {
    final p = context.read<AddActivityPageProvider>();
    return Selector<AddActivityPageProvider, EtKunnrModel?>(
      selector: (context, provider) => provider.selectedKunnr,
      builder: (context, model, _) {
        return BaseColumWithTitleAndTextFiled.build(
          tr('customer_name'),
          BaseInputWidget(
              context: context,
              hintTextStyleCallBack: () => model != null
                  ? AppTextStyle.default_16
                  : AppTextStyle.hint_16,
              popupSearchType: PopupSearchType.SEARCH_CUSTOMER,
              isSelectedStrCallBack: (costomerModel) {
                return p.setCustomerModel(costomerModel);
              },
              isShowDeleteForHintText: model != null ? true : false,
              deleteIconCallback: () => p.setCustomerModel(null),
              iconType: InputIconType.SEARCH,
              iconColor: model != null ? null : AppColors.unReadyText,
              defaultIconCallback: () => p.setCustomerModel(null),
              hintText: model != null ? model.name : tr('plz_select'),
              width: AppSize.defaultContentsWidth,
              enable: false),
        );
      },
    );
  }

  Widget _buildCustomerDiscription(BuildContext context) {
    return Selector<AddActivityPageProvider, EtKunnrModel?>(
      selector: (context, provider) => provider.selectedKunnr,
      builder: (context, model, _) {
        return model == null
            ? Container()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FutureBuilder<List<String>?>(
                      future: HiveService.getCustomerType(model.zstatus!),
                      builder: (context, snapshot) {
                        return BaseInfoRowByKeyAndValue.build(
                            tr('customer_type_2'),
                            snapshot.hasData &&
                                    snapshot.connectionState ==
                                        ConnectionState.done
                                ? '${snapshot.data!.single}'
                                : '',
                            style: AppTextStyle.h5);
                      }),
                  BaseInfoRowByKeyAndValue.build(
                      tr('address'),
                      model.zaddName1 ??
                          model.zaddName2 ??
                          model.zadoName3 ??
                          '',
                      style: AppTextStyle.h5),
                  defaultSpacing()
                ],
              );
      },
    );
  }

  Widget _buildSelectKeyMan(BuildContext context) {
    final p = context.read<AddActivityPageProvider>();
    return Selector<AddActivityPageProvider, AddActivityKeyManModel?>(
      selector: (context, provider) => provider.selectedKeyMan,
      builder: (context, model, _) {
        return BaseColumWithTitleAndTextFiled.build(
          tr('key_man'),
          BaseInputWidget(
              context: context,
              hintTextStyleCallBack: () => model != null
                  ? AppTextStyle.default_16
                  : AppTextStyle.hint_16,
              popupSearchType: PopupSearchType.SEARCH_KEY_MAN,
              isSelectedStrCallBack: (keymanModel) {
                return p.setKeymanModel(keymanModel);
              },
              deleteIconCallback: () => p.setKeymanModel(null),
              iconType: InputIconType.SELECT,
              isShowDeleteForHintText: model != null ? true : false,
              iconColor: model != null ? null : AppColors.unReadyText,
              defaultIconCallback: () => p.setKeymanModel(null),
              hintText: model != null ? model.zkmnoNm : tr('plz_select'),
              width: AppSize.defaultContentsWidth,
              enable: false),
        );
      },
    );
  }

  Widget _buildIsVisitRow(BuildContext context) {
    final p = context.read<AddActivityPageProvider>();
    return Selector<AddActivityPageProvider, bool>(
        selector: (context, provider) => provider.isVisit,
        builder: (context, isVisit, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  width: (AppSize.defaultContentsWidth * .7) -
                      AppSize.defaultListItemSpacing / 2,
                  height: AppSize.defaultTextFieldHeight,
                  decoration: BoxDecoration(
                      color: AppColors.unReadyButton,
                      borderRadius:
                          BorderRadius.all(Radius.circular(AppSize.radius5)),
                      border: Border.all(
                          width: .5, color: AppColors.textFieldUnfoucsColor)),
                  child: Padding(
                    padding: EdgeInsets.only(left: AppSize.padding),
                    child: AppText.text(
                        isVisit ? tr('visit') : tr('not_visited'),
                        style: AppTextStyle.h4
                            .copyWith(color: AppColors.hintText)),
                  )),
              GestureDetector(
                onTap: () {
                  if (p.activityStatus == ActivityStatus.STOPED) {
                    AppToast().show(context, tr('activity_is_stoped'));
                  } else {
                    if ((p.selectedKunnr == null || p.selectedKeyMan == null) &&
                        !p.isVisit) {
                      AppToast()
                          .show(context, tr('plz_check_essential_option'));
                    } else if (!p.isVisit) {
                      p.getDistance();
                    }
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: (AppSize.defaultContentsWidth * .3) -
                      AppSize.defaultListItemSpacing / 2,
                  height: AppSize.defaultTextFieldHeight,
                  decoration: BoxDecoration(
                      color:
                          isVisit || p.activityStatus == ActivityStatus.STOPED
                              ? AppColors.unReadyButton
                              : AppColors.sendButtonColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(AppSize.radius5)),
                      border: Border.all(
                          width: .5,
                          color: isVisit ||
                                  p.activityStatus == ActivityStatus.STOPED
                              ? AppColors.textFieldUnfoucsColor
                              : AppColors.primary)),
                  child: AppText.text(tr('arrival'),
                      style: AppTextStyle.h4.copyWith(
                          color: isVisit
                              ? AppColors.hintText
                              : AppColors.primary)),
                ),
              )
            ],
          );
        });
  }

  Widget _buildTitleRow(String text) {
    return Row(children: [
      AppText.text(text, style: AppTextStyle.h4),
      SizedBox(width: AppSize.defaultListItemSpacing),
      AppText.text('*',
          style: AppTextStyle.h4.copyWith(color: AppColors.dangerColor))
    ]);
  }

  Widget _buildTextField(BuildContext context, {required bool isForInterview}) {
    final p = context.read<AddActivityPageProvider>();
    return TextFormField(
      controller: isForInterview
          ? _interviewTextEditingController
          : _textEditingController,
      scrollController: isForInterview
          ? _interviewTextFieldScrollController
          : _textFieldScrollController,
      onTap: () {
        if (isForInterview) {
          _interviewTextEditingController.text.isEmpty
              ? _interviewTextEditingController.text =
                  p.reasonForinterviewFailure ?? ''
              : DoNothingAction();
        } else {
          _textEditingController.text.isEmpty
              ? _textEditingController.text = p.reasonForNotVisit ?? ''
              : DoNothingAction();
        }
      },
      onChanged: (text) {
        if (isForInterview) {
          p.setReasonForInterviewFailure(text);
        } else {
          p.setReasonForNotVisit(text);
        }
      },
      autofocus: false,
      inputFormatters: [
        LengthLimitingTextInputFormatter(100),
      ],
      autocorrect: false,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      style: AppTextStyle.default_16,
      decoration: InputDecoration(
          fillColor: AppColors.whiteText,
          hintText: '${tr('suggestion_hint')}',
          hintStyle: AppTextStyle.hint_16,
          border: OutlineInputBorder(
              gapPadding: 0,
              borderSide:
                  BorderSide(color: AppColors.textFieldUnfoucsColor, width: .5),
              borderRadius: BorderRadius.circular(AppSize.radius5)),
          focusedBorder: OutlineInputBorder(
              gapPadding: 0,
              borderSide: BorderSide(color: AppColors.primary, width: .5),
              borderRadius: BorderRadius.circular(AppSize.radius5))),
    );
  }

  Widget _buildReasonForNotVisit(BuildContext context) {
    return Selector<AddActivityPageProvider, bool>(
        selector: (context, provider) => provider.isVisit,
        builder: (context, isVisit, _) {
          return isVisit
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    defaultSpacing(),
                    defaultSpacing(),
                    _buildTitleRow(tr('reason_for_not_visiting')),
                    defaultSpacing(),
                    _buildTextField(context, isForInterview: false)
                  ],
                );
        });
  }

  Widget _buildSubmmitButton(BuildContext context) {
    return Selector<AddActivityPageProvider, bool>(
      selector: (context, provider) => provider.index != null,
      builder: (context, isNewActivity, _) {
        return Positioned(
            bottom: 0,
            left: 0,
            child: AppStyles.buildButton(
                context,
                isNewActivity ? tr('submmit') : tr('order_save'),
                AppSize.realWidth,
                AppColors.primary,
                AppTextStyle.menu_18(AppColors.whiteText),
                0, () {
              final p = context.read<AddActivityPageProvider>();
              if ((p.selectedKunnr == null || p.selectedKeyMan == null)) {
                AppToast().show(context, tr('plz_check_essential_option'));
              } else {
                //임시저장.
                // 저장시간/면담여부/활동유형/팀장동행/영업사원 동행/제안품목/방문결과.

              }
            }));
      },
    );
  }

  Widget _buildDistanceDiscription(BuildContext context) {
    return Selector<AddActivityPageProvider,
            Tuple2<bool, AddActivityDistanceModel?>>(
        selector: (context, provider) =>
            Tuple2(provider.isVisit, provider.distanceModel),
        builder: (context, tuple, _) {
          return tuple.item1
              ? BaseInfoRowByKeyAndValue.build(tr('distance'),
                  tuple.item2 != null ? '${tuple.item2!.distance!}Km' : '',
                  style: AppTextStyle.h5)
              : Container();
        });
  }

  Widget _buildBox(BuildContext context, double width, String text,
      {required int index, required bool isSelected}) {
    var borderradius = index == 0
        ? BorderRadius.only(
            topLeft: Radius.circular(AppSize.radius5),
            bottomLeft: Radius.circular(AppSize.radius5),
          )
        : index == 1
            ? BorderRadius.only(
                topRight: Radius.circular(AppSize.radius5),
                bottomRight: Radius.circular(AppSize.radius5),
              )
            : BorderRadius.only();
    var border =
        isSelected ? null : Border.all(width: .5, color: AppColors.textGrey);
    return GestureDetector(
        onTap: () {
          final p = context.read<AddActivityPageProvider>();
          p.setIsInterviewIndex(index);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: AppSize.defaultTextFieldHeight,
          decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.whiteText,
              borderRadius: borderradius,
              border: border),
          child: AppText.text(
            text,
            style: AppTextStyle.default_14.copyWith(
                color:
                    isSelected ? AppColors.whiteText : AppColors.defaultText),
          ),
        ));
  }

  Widget _buildIsInterview(BuildContext context) {
    return Column(
      children: [
        _buildTitleRow(tr('is_interview')),
        defaultSpacing(),
        Selector<AddActivityPageProvider, int>(
            selector: (context, provider) => provider.isInterviewIndex,
            builder: (context, index, _) {
              pr('build');
              return Row(
                children: [
                  _buildBox(context, AppSize.defaultContentsWidth / 2,
                      tr('successful'),
                      index: 0, isSelected: index == 0 ? true : false),
                  _buildBox(
                      context, AppSize.defaultContentsWidth / 2, tr('faild'),
                      index: 1, isSelected: index == 1 ? true : false),
                ],
              );
            })
      ],
    );
  }

  Widget _buildReasonForInterviewFailure(BuildContext context) {
    return Selector<AddActivityPageProvider, int>(
        selector: (context, provider) => provider.isInterviewIndex,
        builder: (context, index, _) {
          return index == 0
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    defaultSpacing(),
                    defaultSpacing(),
                    _buildTitleRow(tr('reason_for_interview_failure')),
                    defaultSpacing(),
                    _buildTextField(context, isForInterview: true)
                  ],
                );
        });
  }

  Widget _buildActivityType(BuildContext context) {
    final p = context.read<AddActivityPageProvider>();
    return Selector<AddActivityPageProvider, String?>(
      selector: (context, provider) => provider.selectedActionType,
      builder: (context, type, _) {
        return Column(
          children: [
            defaultSpacing(),
            _buildTitleRow(tr('activity_type_2')),
            defaultSpacing(),
            BaseInputWidget(
                context: context,
                oneCellType: OneCellType.SEARCH_ACTIVITY_TYPE,
                hintText: type ?? tr('plz_select'),
                hintTextStyleCallBack: () => type == null
                    ? AppTextStyle.hint_16
                    : AppTextStyle.default_16,
                commononeCellDataCallback: () => p.getActivityType(),
                isSelectedStrCallBack: (type) => p.setSelectedActionType(type),
                width: AppSize.defaultContentsWidth,
                enable: false)
          ],
        );
      },
    );
  }

  Widget _buildCheckBox(BuildContext context, bool isChecked) {
    return SizedBox(
      height: AppSize.defaultCheckBoxHeight,
      width: AppSize.defaultCheckBoxHeight,
      child: Checkbox(
          activeColor: AppColors.primary,
          side: BorderSide(color: Colors.grey),
          value: isChecked,
          onChanged: (val) {
            final p = context.read<AddActivityPageProvider>();
            p.setIsWithTeamLeader(val);
          }),
    );
  }

  Widget _buildIsWithTeamLeader(BuildContext context) {
    return Selector<AddActivityPageProvider, bool>(
        selector: (context, provider) => provider.isWithTeamLeader,
        builder: (context, isWithTeamLeader, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.text(tr('with_team_leader'), style: AppTextStyle.h4),
              _buildCheckBox(context, isWithTeamLeader)
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var model = arguments['model'] as SalesActivityDayResponseModel;
    var activityStatus = arguments['status'] as ActivityStatus;
    var index = arguments['index'] as int?;

    return BaseLayout(
        hasForm: true,
        appBar: MainAppBar(
          context,
          titleText: AppText.text(tr('add_activity_page'),
              style: AppTextStyle.w500_22),
          callback: () {
            Navigator.pop(context, true);
          },
        ),
        child: ChangeNotifierProvider(
          create: (context) => AddActivityPageProvider(),
          builder: (context, _) {
            return FutureBuilder<ResultModel>(
                future: context
                    .read<AddActivityPageProvider>()
                    .initData(model, activityStatus, index),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              CustomerinfoWidget.buildSubTitle(
                                  context, '${tr('activity_report')}'),
                              Padding(
                                padding: AppSize.defaultSidePadding,
                                child: Column(
                                  children: [
                                    defaultSpacing(),
                                    defaultSpacing(),
                                    _buildSelectCustomer(context),
                                    _buildCustomerDiscription(context),
                                    _buildSelectKeyMan(context),
                                    defaultSpacing(),
                                    _buildIsVisitRow(context),
                                    defaultSpacing(
                                        height:
                                            AppSize.defaultListItemSpacing / 2),
                                    _buildReasonForNotVisit(context),
                                    defaultSpacing(),
                                    _buildDistanceDiscription(context),
                                    defaultSpacing(),
                                    _buildIsInterview(context),
                                    _buildReasonForInterviewFailure(context),
                                    defaultSpacing(),
                                    _buildActivityType(context),
                                    defaultSpacing(),
                                    defaultSpacing(),
                                    _buildIsWithTeamLeader(context),
                                    defaultSpacing(
                                        height: AppSize.realHeight * .3),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildSubmmitButton(context)
                      ],
                    );
                  }
                  return Container();
                });
          },
        ));
  }
}
