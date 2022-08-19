/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/visit_result_history_page.dart
 * Created Date: 2022-08-17 23:31:14
 * Last Modified: 2022-08-20 01:54:10
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/widget_of_null_data.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/model/rfc/visit_result_history_page_model.dart';
import 'package:medsalesportal/view/common/base_info_row_by_key_and_value.dart';
import 'package:medsalesportal/view/salesActivityManager/provider/visit_result_history_page_provider.dart';

class VisitResultHistoryPage extends StatelessWidget {
  const VisitResultHistoryPage({Key? key}) : super(key: key);
  static const String routeName = '/visitResultHistoryPage';

  Widget _buildCompanyInfo(
      BuildContext context, String customerName, String keyMan) {
    return Padding(
      padding: AppSize.defaultSidePadding,
      child: Column(
        children: [
          BaseInfoRowByKeyAndValue.build(tr('customer_name'), customerName,
              leadingTextWidth: AppSize.defaultContentsWidth * .3,
              contentsTextWidth: AppSize.defaultContentsWidth * .7),
          BaseInfoRowByKeyAndValue.build(tr('key_man'), keyMan,
              leadingTextWidth: AppSize.defaultContentsWidth * .3,
              contentsTextWidth: AppSize.defaultContentsWidth * .7),
        ],
      ),
    );
  }

  Widget _buildItem(
      BuildContext context, int index, VisitResultHistoryPageModel model) {
    return Column(
      children: [
        CustomerinfoWidget.buildSubTitle(
            context, DateUtil.getDateWithWeek(DateUtil.getDate(model.adate!))),
        defaultSpacing(),
        Padding(
            padding: AppSize.defaultSidePadding,
            child: BaseInfoRowByKeyAndValue.build(
                model.xvisit == 'Y'
                    ? model.xmeet == 'Y'
                        ? tr('visit_result')
                        : tr('reason_for_interview_faild')
                    : tr('reason_for_not_visiting'),
                model.xvisit == 'Y'
                    ? model.xmeet == 'Y'
                        ? model.rslt!
                        : model.meetRmk!
                    : model.visitRmk!,
                leadingTextWidth: AppSize.defaultContentsWidth * .3,
                contentsTextWidth: AppSize.defaultContentsWidth * .7,
                maxLine: 3)),
        defaultSpacing()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var date = arguments['date'] as String;
    var zskunnr = arguments['zskunnr'] as String;
    var customerName = arguments['customerName'] as String;
    var keyman = arguments['keyMan'] as String;
    return BaseLayout(
        hasForm: false,
        appBar: MainAppBar(
          context,
          titleText: AppText.text(tr('visit_result_history'),
              style: AppTextStyle.w500_22),
        ),
        child: ChangeNotifierProvider(
          create: (context) => VisitResultHistoryPageProvider(),
          builder: (context, _) {
            final p = context.read<VisitResultHistoryPageProvider>();
            return FutureBuilder(
                future: p.getVisitHistory(date, zskunnr),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildCompanyInfo(context, customerName, keyman),
                              defaultSpacing(),
                              p.visitResponseModel != null &&
                                      p.visitResponseModel!.tList != null &&
                                      p.visitResponseModel!.tList!.isNotEmpty
                                  ? Column(
                                      children: [
                                        ...p.visitResponseModel!.tList!
                                            .asMap()
                                            .entries
                                            .map((map) => _buildItem(
                                                context, map.key, map.value))
                                            .toList()
                                      ],
                                    )
                                  : BaseNullDataWidget.build()
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  return DefaultShimmer.buildDefaultResultShimmer();
                });
          },
        ));
  }
}
