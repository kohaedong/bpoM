/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/add_activity_page.dart
 * Created Date: 2022-08-11 10:39:53
 * Last Modified: 2022-08-24 17:27:40
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/enums/account_type.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/util/is_super_account.dart';
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
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/enums/add_activity_page_input_type.dart';
import 'package:medsalesportal/view/common/widget_of_loading_view.dart';
import 'package:medsalesportal/model/rfc/add_activity_key_man_model.dart';
import 'package:medsalesportal/model/rfc/add_activity_distance_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/view/common/base_info_row_by_key_and_value.dart';
import 'package:medsalesportal/model/rfc/add_activity_suggetion_item_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/view/common/base_column_with_title_and_textfiled.dart';
import 'package:medsalesportal/view/salesActivityManager/visit_result_history_page.dart';
import 'package:medsalesportal/view/salesActivityManager/current_month_scenario_page.dart';
import 'package:medsalesportal/view/salesActivityManager/provider/add_activity_page_provider.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({Key? key}) : super(key: key);
  static const String routeName = '/addActivityPage';

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  late TextEditingController _notVisitEditingController;
  late TextEditingController _amountEditingController;
  late TextEditingController _interviewTextEditingController;
  late TextEditingController _visitResultTextEditingController;
  late TextEditingController _leaderAdviceTextEditingController;
  late ScrollController _textFieldScrollController;
  late ScrollController _interviewTextFieldScrollController;
  late ScrollController _visitTextFieldScrollController;
  late ScrollController _leaderAdviceTextFieldScrollController;
  @override
  void initState() {
    _notVisitEditingController = TextEditingController();
    _amountEditingController = TextEditingController();
    _interviewTextEditingController = TextEditingController();
    _visitResultTextEditingController = TextEditingController();
    _leaderAdviceTextEditingController = TextEditingController();
    _textFieldScrollController = ScrollController();
    _interviewTextFieldScrollController = ScrollController();
    _visitTextFieldScrollController = ScrollController();
    _leaderAdviceTextFieldScrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _notVisitEditingController.dispose();
    _amountEditingController.dispose();
    _interviewTextEditingController.dispose();
    _visitResultTextEditingController.dispose();
    _leaderAdviceTextEditingController.dispose();
    _textFieldScrollController.dispose();
    _interviewTextFieldScrollController.dispose();
    _visitTextFieldScrollController.dispose();
    _leaderAdviceTextFieldScrollController.dispose();
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
                      future: HiveService.getCustomerType(
                          model.zstatus?.length == 1 &&
                                  int.tryParse(model.zstatus!) != null
                              ? '0${model.zstatus}'
                              : '${model.zstatus}'),
                      builder: (context, snapshot) {
                        return BaseInfoRowByKeyAndValue.build(
                            tr('customer_type_2'),
                            snapshot.hasData &&
                                    snapshot.connectionState ==
                                        ConnectionState.done
                                ? '${snapshot.data!.isEmpty ? '' : '${snapshot.data!.single}'}'
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
    return Selector<AddActivityPageProvider,
        Tuple2<AddActivityKeyManModel?, EtKunnrModel?>>(
      selector: (context, provider) =>
          Tuple2(provider.selectedKeyMan, provider.selectedKunnr),
      builder: (context, tuple, _) {
        return BaseColumWithTitleAndTextFiled.build(
          tr('key_man'),
          BaseInputWidget(
            context: context,
            onTap: () {
              if (tuple.item2 == null) {
                AppDialog.showSignglePopup(context, tr('select_customer'));
              }
            },
            hintTextStyleCallBack: () =>
                tuple.item1 != null && tuple.item1!.zkmnoNm != null
                    ? AppTextStyle.default_16
                    : AppTextStyle.hint_16,
            popupSearchType:
                tuple.item2 == null ? null : PopupSearchType.SEARCH_KEY_MAN,
            isSelectedStrCallBack: (keymanModel) {
              return p.setKeymanModel(keymanModel);
            },
            deleteIconCallback: () => p.setKeymanModel(null),
            iconType: InputIconType.SELECT,
            isShowDeleteForHintText:
                tuple.item1 != null && tuple.item1!.zkmnoNm != null
                    ? true
                    : false,
            iconColor: tuple.item1 != null ? null : AppColors.unReadyText,
            defaultIconCallback: () => p.setKeymanModel(null),
            hintText: tuple.item1 != null && tuple.item1!.zkmnoNm != null
                ? tuple.item1!.zkmnoNm
                : tr('plz_select'),
            width: AppSize.defaultContentsWidth,
            enable: false,
            bodyMap: {'zskunnr': tuple.item2?.zskunnr},
          ),
        );
      },
    );
  }

  Widget _buildIsVisitRow(BuildContext context) {
    final p = context.read<AddActivityPageProvider>();
    return BaseColumWithTitleAndTextFiled.build(
        tr('is_visit'),
        Selector<AddActivityPageProvider, bool>(
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
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppSize.radius5)),
                          border: Border.all(
                              width: .5,
                              color: AppColors.textFieldUnfoucsColor)),
                      child: Padding(
                        padding: EdgeInsets.only(left: AppSize.padding),
                        child: AppText.text(
                            isVisit ? tr('visit') : tr('not_visited'),
                            style: AppTextStyle.h4
                                .copyWith(color: AppColors.hintText)),
                      )),
                  GestureDetector(
                    onTap: () {
                      if (p.activityStatus == ActivityStatus.NONE) {
                        return;
                      }
                      if (p.activityStatus == ActivityStatus.STOPED) {
                        AppToast().show(context, tr('activity_is_stoped'));
                      } else {
                        if ((p.selectedKunnr == null ||
                                p.selectedKeyMan == null) &&
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
                          color: isVisit ||
                                  p.activityStatus == ActivityStatus.STOPED ||
                                  p.activityStatus == ActivityStatus.NONE
                              ? AppColors.unReadyButton
                              : AppColors.sendButtonColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppSize.radius5)),
                          border: Border.all(
                              width: .5,
                              color: isVisit ||
                                      p.activityStatus ==
                                          ActivityStatus.STOPED ||
                                      p.activityStatus == ActivityStatus.NONE
                                  ? AppColors.textFieldUnfoucsColor
                                  : AppColors.primary)),
                      child: AppText.text(tr('arrival'),
                          style: AppTextStyle.h4.copyWith(
                              color: isVisit ||
                                      p.activityStatus ==
                                          ActivityStatus.STOPED ||
                                      p.activityStatus == ActivityStatus.NONE
                                  ? AppColors.hintText
                                  : AppColors.primary)),
                    ),
                  )
                ],
              );
            }),
        isNotShowStar: true);
  }

  Widget _buildTitleRow(String text, {bool? isNotwithStart}) {
    return Row(children: [
      AppText.text(text, style: AppTextStyle.h4),
      SizedBox(width: AppSize.defaultListItemSpacing),
      isNotwithStart != null && isNotwithStart
          ? Container()
          : AppText.text('*',
              style: AppTextStyle.h4.copyWith(color: AppColors.dangerColor))
    ]);
  }

  Widget _buildTextField(BuildContext context,
      {required AddActivityPageInputType type}) {
    final p = context.read<AddActivityPageProvider>();
    var accountType = CacheService.getAccountType();
    var defaultBorder = OutlineInputBorder(
        gapPadding: 0,
        borderSide:
            BorderSide(color: AppColors.textFieldUnfoucsColor, width: .5),
        borderRadius: BorderRadius.circular(AppSize.radius5));
    var focusedBorder = OutlineInputBorder(
        gapPadding: 0,
        borderSide: BorderSide(color: AppColors.primary, width: .5),
        borderRadius: BorderRadius.circular(AppSize.radius5));
    return TextFormField(
      readOnly: type == AddActivityPageInputType.LEADER_ADVICE
          ? accountType == AccountType.MULTI ||
                  accountType == AccountType.LEADER
              ? false
              : true
          : false,
      controller: type == AddActivityPageInputType.INTERVIEW
          ? _interviewTextEditingController
          : type == AddActivityPageInputType.NOT_VISIT
              ? _notVisitEditingController
              : type == AddActivityPageInputType.VISIT_RESULT
                  ? _visitResultTextEditingController
                  : _leaderAdviceTextEditingController,
      scrollController: type == AddActivityPageInputType.INTERVIEW
          ? _interviewTextFieldScrollController
          : type == AddActivityPageInputType.NOT_VISIT
              ? _textFieldScrollController
              : type == AddActivityPageInputType.VISIT_RESULT
                  ? _visitTextFieldScrollController
                  : _leaderAdviceTextFieldScrollController,
      onChanged: (text) {
        switch (type) {
          case AddActivityPageInputType.INTERVIEW:
            p.setReasonForInterviewFailure(text);
            break;
          case AddActivityPageInputType.NOT_VISIT:
            p.setReasonForNotVisit(text);
            break;
          case AddActivityPageInputType.VISIT_RESULT:
            p.setVisitResultInputText(text);
            break;
          case AddActivityPageInputType.LEADER_ADVICE:
            p.setLeaderAdviceInputText(text);
            break;
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
          border: defaultBorder,
          focusedBorder: type == AddActivityPageInputType.LEADER_ADVICE
              ? accountType == AccountType.MULTI ||
                      accountType == AccountType.LEADER
                  ? focusedBorder
                  : defaultBorder
              : focusedBorder),
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
                    _buildTitleRow(tr('reason_for_not_visiting'),
                        isNotwithStart: true),
                    defaultSpacing(isHalf: true),
                    _buildTextField(context,
                        type: AddActivityPageInputType.NOT_VISIT)
                  ],
                );
        });
  }

  Widget _buildSubmmitButton(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var model = arguments['model'] as SalesActivityDayResponseModel;
    var index = arguments['index'] as int?;
    var isNewActivity = (index == null);
    var isToday = DateUtil.equlse(
        DateUtil.getDate(model.table250!.first.adate!), DateTime.now());
    return Positioned(
        bottom: 0,
        left: 0,
        child: Selector<AddActivityPageProvider, Tuple2<bool, bool>>(
          selector: (context, provider) => Tuple2(
              provider.selectedKunnr != null, provider.selectedKeyMan != null),
          builder: (context, tuple, _) {
            var canShow =
                (isNewActivity || isToday) && tuple.item1 && tuple.item2;
            return AppStyles.buildButton(
                context,
                isNewActivity ? tr('submmit') : tr('order_save'),
                AppSize.realWidth,
                canShow ? AppColors.primary : AppColors.unReadyButton,
                AppTextStyle.menu_18(
                    canShow ? AppColors.whiteText : AppColors.hintText),
                0,
                selfHeight: AppSize.buttonHeight * 1.3, () {
              final p = context.read<AddActivityPageProvider>();
              if (p.activityStatus == ActivityStatus.STOPED ||
                  p.activityStatus == ActivityStatus.NONE) {
                return;
              } else {
                if (isToday && canShow) {
                  p.saveTable().then((result) {
                    if (result.isSuccessful) {
                      AppToast().show(context, tr('success'));
                    }
                  });
                  //임시저장.
                  // 저장시간/면담여부/활동유형/팀장동행/영업사원 동행/제안품목/방문결과.
                }
              }
            });
          },
        ));
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
        _buildTitleRow(tr('is_interview'), isNotwithStart: true),
        defaultSpacing(isHalf: true),
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
                    defaultSpacing(times: 2),
                    _buildTitleRow(tr('reason_for_interview_failure')),
                    defaultSpacing(),
                    _buildTextField(context,
                        type: AddActivityPageInputType.INTERVIEW)
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
            _buildTitleRow(tr('activity_type_2'), isNotwithStart: true),
            defaultSpacing(isHalf: true),
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

  Widget _buildCheckBox(BuildContext context, bool isChecked,
      {bool? isWithSuggetedItem, int? index}) {
    return SizedBox(
      height: AppSize.defaultCheckBoxHeight,
      width: AppSize.defaultCheckBoxHeight,
      child: Checkbox(
          activeColor: AppColors.primary,
          side: BorderSide(color: Colors.grey),
          value: isChecked,
          onChanged: (val) {
            final p = context.read<AddActivityPageProvider>();
            if (isWithSuggetedItem != null && isWithSuggetedItem) {
              p.updateSuggestedList(index!);
            } else {
              p.setIsWithTeamLeader(val);
            }
          }),
    );
  }

  Widget _buildIsWithTeamLeader(BuildContext context) {
    return Selector<AddActivityPageProvider, bool>(
        selector: (context, provider) => provider.isWithTeamLeader,
        builder: (context, isWithTeamLeader, _) {
          return Row(
            children: [
              _buildCheckBox(context, isWithTeamLeader),
              Padding(
                  padding:
                      EdgeInsets.only(right: AppSize.defaultListItemSpacing)),
              AppText.text(tr('with_team_leader'), style: AppTextStyle.h4),
            ],
          );
        });
  }

  Widget _buildIsWithAnotherSales(BuildContext context) {
    final p = context.read<AddActivityPageProvider>();

    return Column(
      children: [
        _buildTitleRow(tr('with_another_saler'), isNotwithStart: true),
        defaultSpacing(height: AppSize.defaultListItemSpacing / 2),
        Selector<AddActivityPageProvider, EtStaffListModel?>(
            selector: (context, provider) => provider.anotherSaller,
            builder: (context, anotherSaler, _) {
              return BaseInputWidget(
                context: context,
                iconType: InputIconType.SEARCH,
                iconColor: anotherSaler != null
                    ? AppColors.defaultText
                    : AppColors.textFieldUnfoucsColor,
                hintText: anotherSaler != null
                    ? anotherSaler.sname
                    : '${tr('plz_select_something_1', args: [tr('manager')])}',
                // 팀장 일때 만 팀원선택후 삭제가능.
                isShowDeleteForHintText: anotherSaler != null ? true : false,
                deleteIconCallback: () => p.setAnotherSaler(null),
                width: AppSize.defaultContentsWidth,
                hintTextStyleCallBack: () => anotherSaler != null
                    ? AppTextStyle.default_16
                    : AppTextStyle.hint_16,
                popupSearchType: PopupSearchType.SEARCH_SALSE_PERSON,
                isSelectedStrCallBack: (persion) {
                  return p.setAnotherSaler(persion);
                },
                // 멀티계정 전부 조회.
                // 팀장계정 조속팀 조회.
                bodyMap: CheckSuperAccount.isMultiAccount()
                    ? {'dptnm': ''}
                    : CheckSuperAccount.isLeaderAccount()
                        ? {'dptnm': p.dptnm}
                        : null,
                enable: false,
              );
            })
      ],
    );
  }

  Widget _buildItemSet(BuildContext context,
      AddActivitySuggetionItemModel model, int index, String actionType) {
    final p = context.read<AddActivityPageProvider>();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTitleRow('${tr('suggested_item')}${index + 1}',
                isNotwithStart: true),
            GestureDetector(
                onTap: () {
                  final p = context.read<AddActivityPageProvider>();
                  p.removeAtSuggestedList(index);
                  if (index == 0) {
                    p.setAmount(null);
                    _amountEditingController.clear();
                  }
                  pr('close');
                },
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                    height: AppSize.defaultCheckBoxHeight,
                    width: AppSize.defaultCheckBoxHeight,
                    child: Icon(
                      Icons.close,
                      color: AppColors.hintText,
                    )))
          ],
        ),
        BaseInputWidget(
            context: context,
            hintText: model.maktx == null ? tr('plz_select') : model.maktx,
            hintTextStyleCallBack: () => model.maktx == null
                ? AppTextStyle.hint_16
                : AppTextStyle.default_16,
            popupSearchType: PopupSearchType.SEARCH_SUGGETION_ITEM,
            isSelectedStrCallBack: (model) =>
                p.updateSuggestedList(index, updateModel: model),
            width: AppSize.defaultContentsWidth,
            enable: false),
        actionType.trim() == '제품신규' && index == 0
            ? Column(
                children: [
                  defaultSpacing(),
                  _buildTitleRow(tr('month_amount_price'),
                      isNotwithStart: true),
                  Selector<AddActivityPageProvider, String?>(
                    selector: (context, provider) => provider.seletedAmount,
                    builder: (context, amount, _) {
                      return BaseInputWidget(
                          context: context,
                          keybordType: TextInputType.number,
                          hintText: amount == null || amount.isEmpty
                              ? tr('plz_enter_search_key_for_something_1',
                                  args: [tr('expected_amount')])
                              : amount,
                          hintTextStyleCallBack: () =>
                              amount == null || amount.isEmpty
                                  ? AppTextStyle.hint_16
                                  : AppTextStyle.default_16,
                          onChangeCallBack: (str) => p.setAmount(str),
                          textEditingController: _amountEditingController,
                          width: AppSize.defaultContentsWidth,
                          enable: true);
                    },
                  )
                ],
              )
            : Container(),
        defaultSpacing(),
        Row(
          children: [
            _buildCheckBox(context, model.isChecked ?? false,
                index: index, isWithSuggetedItem: true),
            Padding(
                padding:
                    EdgeInsets.only(right: AppSize.defaultListItemSpacing)),
            AppText.text(tr('give_sample'), style: AppTextStyle.h4),
          ],
        ),
        defaultSpacing()
      ],
    );
  }

  Widget _buildSuggestedItems(BuildContext context) {
    return Selector<AddActivityPageProvider,
        Tuple2<List<AddActivitySuggetionItemModel>?, String?>>(
      selector: (context, provider) =>
          Tuple2(provider.suggestedList, provider.selectedActionType),
      builder: (context, tuple, _) {
        return tuple.item1 == null
            ? Container()
            : Column(children: [
                defaultSpacing(),
                ...tuple.item1!
                    .asMap()
                    .entries
                    .map((map) => _buildItemSet(
                        context, map.value, map.key, tuple.item2!))
                    .toList(),
              ]);
      },
    );
  }

  Widget _buildAddSuggestedItemButton(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            final p = context.read<AddActivityPageProvider>();
            if (p.selectedActionType != null) {
              if (p.suggestedList!.length < 3) {
                p.insertToSuggestedList();
              } else {
                AppToast().show(context, tr('only_three_can_be_added'));
              }
            } else {
              AppToast().show(context,
                  tr('plz_select_something_1', args: [tr('activity_type_2')]));
            }
          },
          child: Container(
            alignment: Alignment.centerLeft,
            height: AppSize.smallButtonHeight,
            width: AppSize.smallButtonWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.radius4),
                border: Border.all(
                    width: .5, color: AppColors.textFieldUnfoucsColor)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: AppColors.textFieldUnfoucsColor,
                ),
                AppText.text(tr('add'),
                    style:
                        AppTextStyle.h5.copyWith(color: AppColors.defaultText))
              ],
            ),
          ),
        ),
        Spacer()
      ],
    );
  }

  Widget _buildLinkedText(BuildContext context, String text,
      {required bool isCurrentMonthScenario}) {
    final p = context.read<AddActivityPageProvider>();
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (p.selectedKunnr != null) {
              if (isCurrentMonthScenario) {
                Navigator.pushNamed(context, CurruntMonthScenarioPage.routeName,
                    arguments: {
                      'model': p.editModel!.table430,
                      'zskunnr': p.selectedKunnr != null
                          ? p.selectedKunnr!.zskunnr
                          : '',
                      'zkmon': p.selectedKeyMan != null
                          ? p.selectedKeyMan!.zkmno
                          : ''
                    });
                return;
              } else {
                Navigator.pushNamed(context, VisitResultHistoryPage.routeName,
                    arguments: {
                      'date': p.index != null
                          ? p.editModel!.table260![p.index!].adate
                          : DateUtil.getDateStr('', dt: DateTime.now()),
                      'zskunnr': p.selectedKunnr != null
                          ? p.selectedKunnr!.zskunnr
                          : '',
                      'customerName':
                          p.selectedKunnr != null ? p.selectedKunnr!.name : '',
                      'keyMan': p.selectedKeyMan != null
                          ? p.selectedKeyMan!.zkmnoNm
                          : ''
                    });
                return;
              }
            } else {
              AppDialog.showSignglePopup(context, tr('select_customer'));
            }
          },
          child: AppText.text(text,
              style: AppTextStyle.sub_14.copyWith(color: AppColors.primary)),
        ),
        SizedBox(
            height: AppSize.iconSmallDefaultWidth,
            child: Icon(
              Icons.arrow_forward_ios_sharp,
              color: AppColors.showAllTextColor,
              size: AppSize.iconSmallDefaultWidth,
            ))
      ],
    );
  }

  Widget _buildVisitResult(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTitleRow(tr('visit_result'), isNotwithStart: true),
            _buildLinkedText(context, '${tr('visit_result_history')} 보기',
                isCurrentMonthScenario: false)
          ],
        ),
        defaultSpacing(),
        _buildTextField(context, type: AddActivityPageInputType.VISIT_RESULT)
      ],
    );
  }

  Widget _buildTeamLeaderAdvice(BuildContext context) {
    return Column(
      children: [
        _buildTitleRow(tr('leader_advice'), isNotwithStart: true),
        defaultSpacing(),
        _buildTextField(context, type: AddActivityPageInputType.LEADER_ADVICE)
      ],
    );
  }

  Widget _buildCurrentMonthScenario(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTitleRow(tr('curren_month_scenario'), isNotwithStart: true),
        _buildLinkedText(context, '${tr('curren_month_scenario')} 보기',
            isCurrentMonthScenario: true)
      ],
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return Selector<AddActivityPageProvider, bool>(
      selector: (context, provider) => provider.isLoadData,
      builder: (context, isLoadData, _) {
        return BaseLoadingViewOnStackWidget.build(context, isLoadData);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var model = arguments['model'] as SalesActivityDayResponseModel;
    var activityStatus = arguments['status'] as ActivityStatus;
    var index = arguments['index'] as int?;
    if (index != null) {
      _interviewTextEditingController.text = model.table260![index].meetRmk!;
      _notVisitEditingController.text = model.table260![index].visitRmk!;
      _visitResultTextEditingController.text = model.table260![index].rslt!;
      _leaderAdviceTextEditingController.text =
          model.table260![index].comnt!; //! m??
      _amountEditingController.text = model.table280!.isNotEmpty
          ? '${model.table280![index].amount1 ?? ''}'
          : '';
    }

    pr(model.toJson());
    return ChangeNotifierProvider(
      create: (context) => AddActivityPageProvider(),
      builder: (context, _) {
        final p = context.read<AddActivityPageProvider>();
        return BaseLayout(
            hasForm: true,
            appBar: MainAppBar(
              context,
              titleText: AppText.text(tr('add_activity_page'),
                  style: AppTextStyle.w500_22),
              callback: () {
                Navigator.pop(context, p.isUpdate);
              },
            ),
            child: FutureBuilder<ResultModel>(
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
                                    defaultSpacing(times: 2),
                                    _buildSelectCustomer(context),
                                    _buildCustomerDiscription(context),
                                    _buildSelectKeyMan(context),
                                    defaultSpacing(),
                                    _buildIsVisitRow(context),
                                    defaultSpacing(),
                                    _buildIsWithTeamLeader(context),
                                    defaultSpacing(times: 2),
                                    _buildIsWithAnotherSales(context),
                                    defaultSpacing(times: 2),
                                    _buildReasonForNotVisit(context),
                                    defaultSpacing(times: 2),
                                    _buildDistanceDiscription(context),
                                    defaultSpacing(),
                                    Selector<AddActivityPageProvider, bool>(
                                      selector: (context, provider) =>
                                          provider.isVisit,
                                      builder: (context, isVisit, _) {
                                        return isVisit
                                            ? Column(
                                                children: [
                                                  _buildIsInterview(context),
                                                  _buildReasonForInterviewFailure(
                                                      context),
                                                  defaultSpacing(times: 2),
                                                  _buildActivityType(context),
                                                  defaultSpacing()
                                                ],
                                              )
                                            : Container();
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Selector<AddActivityPageProvider, bool>(
                                selector: (context, provider) =>
                                    provider.isVisit,
                                builder: (context, isVisit, _) {
                                  return isVisit
                                      ? Column(
                                          children: [
                                            CustomerinfoWidget.buildSubTitle(
                                                context,
                                                '${tr('activity_type_2')}'),
                                            Padding(
                                                padding:
                                                    AppSize.defaultSidePadding,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    _buildSuggestedItems(
                                                        context),
                                                    defaultSpacing(),
                                                    _buildAddSuggestedItemButton(
                                                        context),
                                                    defaultSpacing(times: 2)
                                                  ],
                                                )),
                                            CustomerinfoWidget.buildSubTitle(
                                                context,
                                                '${tr('result_and_future')}'),
                                            Padding(
                                                padding:
                                                    AppSize.defaultSidePadding,
                                                child: Column(
                                                  children: [
                                                    defaultSpacing(),
                                                    _buildVisitResult(context),
                                                    defaultSpacing(times: 2),
                                                    _buildTeamLeaderAdvice(
                                                        context),
                                                    defaultSpacing(times: 2),
                                                    _buildCurrentMonthScenario(
                                                        context),
                                                    defaultSpacing(times: 2),
                                                  ],
                                                )),
                                          ],
                                        )
                                      : Container();
                                },
                              ),
                              defaultSpacing(height: AppSize.realHeight * .3),
                            ],
                          ),
                        ),
                        _buildSubmmitButton(context),
                        _buildLoadingWidget(context),
                      ],
                    );
                  }
                  return Container();
                }));
      },
    );
  }
}
