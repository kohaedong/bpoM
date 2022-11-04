/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/currunt_month_scenario_page.dart
 * Created Date: 2022-08-17 23:33:31
 * Last Modified: 2022-11-04 16:20:48
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
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

  Widget _buildBox(
      BuildContext context, int index, SalesActivityDayTable430 model) {
    return Padding(
        padding: AppSize.defaultSidePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            defaultSpacing(),
            Container(
                constraints: BoxConstraints(
                  maxWidth: AppSize.defaultContentsWidth,
                  minWidth: AppSize.defaultContentsWidth,
                  minHeight: AppSize.scenarioBoxHeight,
                ),
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
                    Expanded(
                        child: SingleChildScrollView(
                      padding: EdgeInsets.all(AppSize.padding),
                      child: AppText.text(model.pdesc!,
                          maxLines: 20, textAlign: TextAlign.left),
                    )),
                    // AppText.listViewText(model.pdesc!, maxLines: 3)
                  ],
                )),
            defaultSpacing()
          ],
        ));
  }

  Widget _buildListContents(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SingleChildScrollView(
          child: Selector<CurrentMonthScenarioProvider,
              List<SalesActivityDayTable430>?>(
            selector: (context, provider) => provider.table430,
            builder: (context, table430, _) {
              return table430 != null && table430.isNotEmpty
                  ? SizedBox(
                      height: AppSize.realHeight * .8,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...table430
                                .asMap()
                                .entries
                                .map((e) => _buildBox(context, e.key, e.value)),
                          ],
                        ),
                      ))
                  : Padding(
                      padding: EdgeInsets.only(top: AppSize.appBarHeight),
                      child: BaseNullDataWidget.build(context,
                          isForSearchResult: true),
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
