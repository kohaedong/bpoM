/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/currunt_month_scenario_page.dart
 * Created Date: 2022-08-17 23:33:31
 * Last Modified: 2022-08-23 14:10:01
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/widget_of_null_data.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_430.dart';
import 'package:medsalesportal/view/salesActivityManager/provider/current_month_scenario_provider.dart';

class CurruntMonthScenarioPage extends StatefulWidget {
  const CurruntMonthScenarioPage({Key? key}) : super(key: key);
  static const String routeName = '/curruntMonthScenarioPage';

  @override
  State<CurruntMonthScenarioPage> createState() =>
      _CurruntMonthScenarioPageState();
}

class _CurruntMonthScenarioPageState extends State<CurruntMonthScenarioPage> {
  late TextEditingController textEditingController;
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  late TextEditingController textEditingController3;
  late TextEditingController textEditingController4;
  @override
  void initState() {
    textEditingController = TextEditingController();
    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
    textEditingController3 = TextEditingController();
    textEditingController4 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    textEditingController1.dispose();
    textEditingController2.dispose();
    textEditingController3.dispose();
    textEditingController4.dispose();
    super.dispose();
  }

  Widget _buildTextField(
      BuildContext context, int index, SalesActivityDayTable430 model) {
    final p = context.read<CurrentMonthScenarioProvider>();
    if (p.isFirstRun && p.table430 != null && p.table430!.isNotEmpty) {
      for (var i = 0; i < p.table430!.length; i++) {
        var temp = p.table430![i].pdesc ?? '';
        i == 0
            ? textEditingController.text = temp
            : i == 1
                ? textEditingController1.text = temp
                : i == 2
                    ? textEditingController2.text = temp
                    : i == 3
                        ? textEditingController3.text = temp
                        : i == 4
                            ? textEditingController4.text = temp
                            : DoNothingAction();
      }
      p.setIsFirstRun(false);
    }
    return TextFormField(
      readOnly: true,
      controller: index == 0
          ? textEditingController
          : index == 1
              ? textEditingController1
              : index == 2
                  ? textEditingController2
                  : index == 3
                      ? textEditingController3
                      : index == 4
                          ? textEditingController4
                          : null,
      onChanged: (str) {
        index == 0
            ? p.setIndex0Descriptiopn(str)
            : index == 1
                ? p.setIndex1Descriptiopn(str)
                : index == 2
                    ? p.setIndex2Descriptiopn(str)
                    : index == 3
                        ? p.setIndex3Descriptiopn(str)
                        : index == 4
                            ? p.setIndex4Descriptiopn(str)
                            : DoNothingAction();
      },
      autofocus: false,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      autocorrect: false,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      style: AppTextStyle.default_16,
      decoration: InputDecoration(
          fillColor: AppColors.whiteText,
          hintText: model.pdesc,
          hintStyle: AppTextStyle.hint_16,
          border: InputBorder.none,
          focusedBorder: InputBorder.none),
    );
  }

  Widget _buildBox(
      BuildContext context, int index, SalesActivityDayTable430 model) {
    return Padding(
        padding: AppSize.defaultSidePadding,
        child: Column(
          children: [
            defaultSpacing(),
            Container(
                width: AppSize.defaultContentsWidth,
                height: AppSize.scenarioBoxHeight,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.textFieldUnfoucsColor),
                    borderRadius: BorderRadius.circular(AppSize.radius4)),
                child: Row(
                  children: [
                    AppStyles.defultRowSpacing(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText.listViewText('${int.parse(model.pmonth!)}월',
                            style: AppTextStyle.h4
                                .copyWith(color: AppColors.subText)),
                        AppText.listViewText('${int.parse(model.mwnum!)}주차',
                            style: AppTextStyle.h4
                                .copyWith(color: AppColors.subText))
                      ],
                    ),
                    AppStyles.defultRowSpacing(),
                    AppText.listViewText('-'),
                    AppStyles.defultRowSpacing(),
                    Expanded(child: _buildTextField(context, index, model)),
                    // AppText.listViewText(model.pdesc!, maxLines: 3)
                  ],
                )),
            defaultSpacing()
          ],
        ));
  }

  Widget _buildListContents(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Selector<CurrentMonthScenarioProvider,
              List<SalesActivityDayTable430>?>(
            selector: (context, provider) => provider.table430,
            builder: (context, table430, _) {
              return table430 != null && table430.isNotEmpty
                  ? Column(
                      children: [
                        ...table430
                            .asMap()
                            .entries
                            .map((e) => _buildBox(context, e.key, e.value)),
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: AppSize.appBarHeight),
                      child: BaseNullDataWidget.build(),
                    );
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var model = arguments['model'] as List<SalesActivityDayTable430>;
    var zskunnr = arguments['zskunnr'] as String;
    var zkmon = arguments['zkmon'] as String;
    return BaseLayout(
        hasForm: true,
        appBar: MainAppBar(
          context,
          titleText: AppText.text(tr('curren_month_scenario'),
              style: AppTextStyle.w500_22),
        ),
        child: ChangeNotifierProvider(
          create: (context) => CurrentMonthScenarioProvider(),
          builder: (context, _) {
            final p = context.read<CurrentMonthScenarioProvider>();
            return FutureBuilder(
                future: p.getCurrentMonthScenario(model, zskunnr, zkmon),
                builder: (context, snapshot) {
                  return _buildListContents(context);
                });
          },
        ));
  }
}
