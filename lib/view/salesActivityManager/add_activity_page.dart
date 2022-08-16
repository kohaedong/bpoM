/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/add_activity_page.dart
 * Created Date: 2022-08-11 10:39:53
 * Last Modified: 2022-08-16 09:04:11
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/model/rfc/add_activity_key_man_model.dart';
import 'package:medsalesportal/model/rfc/et_kunnr_model.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/view/common/base_info_row_by_key_and_value.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildSelectCustomer(BuildContext context) {
    final p = context.read<AddActivityPageProvider>();
    return Selector<AddActivityPageProvider, EtKunnrModel?>(
      selector: (context, provider) => provider.selectedKunnr,
      builder: (context, model, _) {
        return Padding(
            padding: AppSize.defaultSidePadding,
            child: BaseColumWithTitleAndTextFiled.build(
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
                  height: AppSize.defaultTextFieldHeight,
                  enable: false),
            ));
      },
    );
  }

  Widget _buildCustomerDiscription(BuildContext context) {
    return Padding(
      padding: AppSize.defaultSidePadding,
      child: Selector<AddActivityPageProvider, EtKunnrModel?>(
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
                  ],
                );
        },
      ),
    );
  }

  Widget _buildSelectKeyMan(BuildContext context) {
    final p = context.read<AddActivityPageProvider>();
    return Selector<AddActivityPageProvider, AddActivityKeyManModel?>(
      selector: (context, provider) => provider.selectedKeyMan,
      builder: (context, model, _) {
        return Padding(
            padding: AppSize.defaultSidePadding,
            child: BaseColumWithTitleAndTextFiled.build(
              tr('key_man'),
              BaseInputWidget(
                  context: context,
                  hintTextStyleCallBack: () => model != null
                      ? AppTextStyle.default_14
                      : AppTextStyle.default_14
                          .copyWith(color: AppColors.hintText),
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
                  height: AppSize.defaultTextFieldHeight,
                  enable: false),
            ));
      },
    );
  }

  Widget _buildIsVisitRow(BuildContext context) {
    return Selector<AddActivityPageProvider, bool>(
        selector: (context, provider) => provider.isVisit,
        builder: (context, isVisit, _) {
          return Padding(
            padding: AppSize.defaultSidePadding,
            child: Row(
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
                Container(
                  alignment: Alignment.center,
                  width: (AppSize.defaultContentsWidth * .3) -
                      AppSize.defaultListItemSpacing / 2,
                  height: AppSize.defaultTextFieldHeight,
                  decoration: BoxDecoration(
                      color: isVisit
                          ? AppColors.unReadyButton
                          : AppColors.sendButtonColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(AppSize.radius5)),
                      border: Border.all(
                          width: .5,
                          color: isVisit
                              ? AppColors.unReadyButton
                              : AppColors.primary)),
                  child: AppText.text(tr('arrival'),
                      style: AppTextStyle.h4.copyWith(
                          color: isVisit
                              ? AppColors.hintText
                              : AppColors.primary)),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var model = ModalRoute.of(context)!.settings.arguments
        as SalesActivityDayResponseModel;
    return BaseLayout(
        hasForm: false,
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  CustomerinfoWidget.buildSubTitle(
                      context, '${tr('activity_report')}'),
                  defaultSpacing(),
                  defaultSpacing(),
                  _buildSelectCustomer(context),
                  _buildCustomerDiscription(context),
                  _buildSelectKeyMan(context),
                  _buildIsVisitRow(context),
                ],
              ),
            );
          },
        ));
  }
}
