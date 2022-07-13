/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivitySearch/salse_activity_detail_page.dart
 * Created Date: 2022-07-07 13:41:48
 * Last Modified: 2022-07-13 11:15:07
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:medsalesportal/model/rfc/t_list_model.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_info_row_by_key_and_value.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';

class SalseActivityDetailPage extends StatelessWidget {
  const SalseActivityDetailPage({Key? key}) : super(key: key);
  static const String routeName = '/salseActivityDetailPage';

  Widget _buildContents(BuildContext context) {
    final model = ModalRoute.of(context)?.settings.arguments as TlistModel;
    pr(model.rslt?.length);
    return ListView(
      children: [
        CustomerinfoWidget.buildSubTitle(context, '${tr('activity_report')}'),
        Padding(
          padding: AppSize.defaultSidePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseInfoRowByKeyAndValue.build(
                  tr('salse_person'), model.sanumNm!),
              BaseInfoRowByKeyAndValue.build(tr('activity_date'),
                  FormatUtil.addDashForDateStr(model.adate!)),
              BaseInfoRowByKeyAndValue.build(
                  tr('customer_name'), model.zskunnrNm ?? ''),
              FutureBuilder<List<String>?>(
                  future: HiveService.getCustomerType(model.zstatus!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      return BaseInfoRowByKeyAndValue.build(
                          tr('customer_type_2'), snapshot.data!.single);
                    }
                    return BaseInfoRowByKeyAndValue.build(
                        tr('customer_type_2'), '');
                  }),
              BaseInfoRowByKeyAndValue.build(tr('address'), model.zaddr ?? ''),
              BaseInfoRowByKeyAndValue.build(
                  tr('key_man'), model.zkmnoNm ?? ''),
              BaseInfoRowByKeyAndValue.build(
                tr('is_visited'),
                model.xvisit != null && model.xvisit == 'Y'
                    ? '${tr('visited')}'
                    : '${tr('not_visited')}',
              ),
              // BaseInfoRowByKeyAndValue.build(
              //     tr('leader_together'), FormatUtil.addDashForDateStr('-')),
              // BaseInfoRowByKeyAndValue.build(
              //     tr('colleague_together'), FormatUtil.addDashForDateStr('-')),
              BaseInfoRowByKeyAndValue.build(
                  tr('distance'),
                  FormatUtil.getDistance(
                      model.dist != null ? model.dist! : '')),
              BaseInfoRowByKeyAndValue.build(
                  tr('reason_for_not_visiting'),
                  model.visitRmk != null && model.visitRmk!.isNotEmpty
                      ? model.visitRmk!
                      : '-'),
              BaseInfoRowByKeyAndValue.build(
                  tr('is_interview'),
                  model.xmeet != null && model.xmeet!.isNotEmpty
                      ? model.xmeet == 'S'
                          ? '${tr('success_lable')}'
                          : '${tr('faild')}'
                      : '${tr('faild')}'),
              BaseInfoRowByKeyAndValue.build(
                  tr('reason_for_interview_faild'),
                  model.meetRmk != null && model.meetRmk!.isNotEmpty
                      ? model.meetRmk!
                      : '-'),
              BaseInfoRowByKeyAndValue.build(
                  tr('activity_type_2'),
                  model.actcat1Nm != null && model.actcat1Nm!.isNotEmpty
                      ? model.actcat1Nm!
                      : '-'),
              BaseInfoRowByKeyAndValue.build(
                  tr('activity_detail'),
                  model.actDtl != null && model.actDtl!.isNotEmpty
                      ? model.actDtl!
                      : '-'),
              BaseInfoRowByKeyAndValue.build(
                  tr('result'),
                  model.rslt != null && model.rslt!.isNotEmpty
                      ? model.rslt!
                      : '-',
                  maxLine: 50)
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: false,
        appBar: MainAppBar(context,
            titleText: AppText.text('${tr('salse_activity_detail')}',
                style: AppTextStyle.w500_22)),
        child: _buildContents(context));
  }
}
