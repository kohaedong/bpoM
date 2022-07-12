/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderSearch/order_detail_page.dart
 * Created Date: 2022-07-12 15:20:28
 * Last Modified: 2022-07-12 18:04:38
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/view/common/base_info_row_by_key_and_value.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/model/rfc/t_list_search_order_model.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({Key? key}) : super(key: key);
  static const String routeName = '/orderDetailPage';
  Widget _buildContents(BuildContext context) {
    final model =
        ModalRoute.of(context)?.settings.arguments as TlistSearchOrderModel;
    return ListView(
      children: [
        CustomerinfoWidget.buildSubTitle(context, '${tr('activity_report')}'),
        Padding(
          padding: AppSize.defaultSidePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseInfoRowByKeyAndValue.build(
                  tr('request_number'), model.zreqno!),
              BaseInfoRowByKeyAndValue.build(tr('reqtuset_date'),
                  FormatUtil.addDashForDateStr(model.zreqDate!)),
              BaseInfoRowByKeyAndValue.build(
                  tr('processing_status'), model.zstatusNm ?? '-'),
              BaseInfoRowByKeyAndValue.build(
                  tr('reason_for_not_request_order'),
                  model.zmessage == null || model.zmessage!.isEmpty
                      ? '-'
                      : model.zmessage!,
                  isTitleTowRow: true),
              BaseInfoRowByKeyAndValue.build(
                  tr('mat_code'), model.matnr ?? '-'),
              BaseInfoRowByKeyAndValue.build(
                  tr('mat_name'), model.maktx ?? '-'),
              BaseInfoRowByKeyAndValue.build(
                  tr('quantity'), model.kwmeng!.toInt().toString()),
              BaseInfoRowByKeyAndValue.build(tr('salse_reason_quantity'),
                  model.zfreeQty!.toInt().toString()),
              FutureBuilder<String?>(
                  future: Future.delayed(Duration.zero, () async {
                    final result = await HiveService.getSalesGroup();
                    final data = result
                        ?.where((str) => str.contains(model.vkgrp!))
                        .toList();
                    return data?.first.substring(0, data.first.indexOf('-'));
                  }),
                  builder: (context, snapshot) {
                    return BaseInfoRowByKeyAndValue.build(
                        tr('salse_group'),
                        snapshot.hasData &&
                                snapshot.connectionState == ConnectionState.done
                            ? snapshot.data!
                            : '');
                  }),
              BaseInfoRowByKeyAndValue.build(tr('manager'), model.sname!),
              BaseInfoRowByKeyAndValue.build(
                  tr('sales_office'), model.kunnrNm!),
              BaseInfoRowByKeyAndValue.build(
                  tr('end_customer'), model.zzkunnrEndNm ?? ''),
              BaseInfoRowByKeyAndValue.build(tr('supply_price'),
                  '${FormatUtil.addComma('${model.netpr! * model.kwmeng!.toInt()}')}'), // 공급가.
              BaseInfoRowByKeyAndValue.build(tr('vat'),
                  '${FormatUtil.addComma('${model.mwsbp}')}'), // 부가세.
              BaseInfoRowByKeyAndValue.build(tr('standard_price_'),
                  '${FormatUtil.addComma('${model.znetpr}')}'), // 기준판가.
              BaseInfoRowByKeyAndValue.build(tr('unit_price'),
                  '${FormatUtil.addComma('${model.netpr}')}'), // 단가.
              BaseInfoRowByKeyAndValue.build(tr('discount_rate'),
                  '${FormatUtil.addPercent('${model.zdisRate}')}'), //할인율
              BaseInfoRowByKeyAndValue.build(
                  tr('discount_price'), '${model.zdisPrice}'), // 할인가격
              BaseInfoRowByKeyAndValue.build(
                  tr('unit'), '${model.vrkme}'), // 단위
              BaseInfoRowByKeyAndValue.build(
                  tr('currency_unit_2'), '${model.waerk}'), // 통화
              BaseInfoRowByKeyAndValue.build(
                  tr('order_number_2'), '${model.vbeln}'), // 주문번호.
              BaseInfoRowByKeyAndValue.build(
                  tr('posnr_number'), '${model.posnr}'), // 품목번호
              BaseInfoRowByKeyAndValue.build(
                  tr('massage'), '${model.zreqmsg}'), // 메시지
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final model =
        ModalRoute.of(context)?.settings.arguments as TlistSearchOrderModel;
    pr(model.toJson());
    return BaseLayout(
        hasForm: false,
        appBar: MainAppBar(context,
            titleText: AppText.text('${tr('order_detail')}',
                style: AppTextStyle.w500_20)),
        child: _buildContents(context));
  }
}
