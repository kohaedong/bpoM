/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/add_activity_page.dart
 * Created Date: 2022-08-11 10:39:53
 * Last Modified: 2022-08-15 11:01:34
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
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
                      ? AppTextStyle.default_14
                      : AppTextStyle.default_14
                          .copyWith(color: AppColors.subText),
                  textStyle: AppTextStyle.default_14,
                  popupSearchType: PopupSearchType.SEARCH_CUSTOMER,
                  isSelectedStrCallBack: (costomerModel) {
                    return p.setCustomerModel(costomerModel);
                  },
                  iconType: model != null
                      ? InputIconType.DELETE
                      : InputIconType.SEARCH,
                  iconColor: model != null ? null : AppColors.unReadyText,
                  defaultIconCallback: () => p.setCustomerModel(null),
                  hintText: model != null ? model.name : tr('plz_select'),
                  width: AppSize.defaultContentsWidth,
                  enable: model != null ? true : false),
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
                          .copyWith(color: AppColors.subText),
                  textStyle: AppTextStyle.default_14,
                  popupSearchType: PopupSearchType.SEARCH_KEY_MAN,
                  isSelectedStrCallBack: (keymanModel) {
                    return p.setKeymanModel(keymanModel);
                  },
                  iconType: model != null
                      ? InputIconType.DELETE
                      : InputIconType.SELECT,
                  iconColor: model != null ? null : AppColors.unReadyText,
                  defaultIconCallback: () => p.setCustomerModel(null),
                  hintText: model != null ? model.zkmnoNm : tr('plz_select'),
                  width: AppSize.defaultContentsWidth,
                  enable: model != null ? true : false),
            ));
      },
    );
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
                  _buildSelectKeyMan(context)
                ],
              ),
            );
          },
        ));
  }
}
