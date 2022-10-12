/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderSearch/order_detail_page.dart
 * Created Date: 2022-07-12 15:20:28
 * Last Modified: 2022-10-12 22:32:22
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/dialog_contents.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/model/rfc/t_list_search_order_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/view/common/base_info_row_by_key_and_value.dart';
import 'package:medsalesportal/view/orderSearch/provider/order_detail_page_provider.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({Key? key}) : super(key: key);
  static const String routeName = '/orderDetailPage';

  Widget _buildContentsItem(
      BuildContext context, TlistSearchOrderModel model, int index) {
    pr(model.toJson());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomerinfoWidget.buildSubTitle(
            context, '${tr('order_info')} ${index + 1}'),
        Padding(
          padding: AppSize.defaultSidePadding,
          child: Column(
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
              BaseInfoRowByKeyAndValue.build(tr('salse_surcharge_quantity'),
                  model.zfreeQty!.toInt().toString()),
              BaseInfoRowByKeyAndValue.build(
                  tr('salse_surcharge_quantity_option'),
                  model.zfreeQtyIn!.toInt().toString()),
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
              BaseInfoRowByKeyAndValue.build(
                  tr('discount_rate'), '${model.zdisRate}'), //할인율
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
                  tr('massage'), '${model.zmessage}'), // 메시지
              defaultSpacing()
            ],
          ),
        )
      ],
    );
  }

  Widget _buildContents(BuildContext context,
      List<TlistSearchOrderModel> modelList, double totalPrice) {
    return ListView(
      children: [
        defaultSpacing(),
        CustomerinfoWidget.buildCustomerTopRow(
            context,
            '${tr('order_detail_description', args: [
                  '${modelList.length}',
                  '${FormatUtil.addComma('$totalPrice')}'
                ])}'),
        defaultSpacing(times: 2),
        ...modelList
            .asMap()
            .entries
            .map((map) => _buildContentsItem(context, map.value, map.key))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final modelList = ModalRoute.of(context)?.settings.arguments
        as List<TlistSearchOrderModel>;
    var totalPrice = 0.0;
    var isShowCancel = false;
    modelList.forEach((model) {
      totalPrice += (model.netpr! * model.kwmeng!);
      if (model.zstatus == 'A') {
        isShowCancel = true;
      }
    });
    pr(modelList.length);
    return ChangeNotifierProvider(
      create: (context) => OrderDetailPageProvider(),
      builder: (context, _) {
        return BaseLayout(
            hasForm: false,
            appBar: MainAppBar(
              context,
              titleText: AppText.text('${tr('order_detail')}',
                  style: AppTextStyle.w500_22),
              action: isShowCancel
                  ? InkWell(
                      onTap: () async {
                        final dialogResult = await AppDialog.showPopup(
                            context,
                            buildTowButtonTextContents(
                                context, tr('is_realy_cancel_order'),
                                successButtonText: tr('order_cancel'),
                                faildButtonText: tr('close')));
                        if (dialogResult != null && dialogResult) {
                          final p = context.read<OrderDetailPageProvider>();
                          final result =
                              await p.orderCancel(modelList.first.vbeln!);
                          if (result.isSuccessful) {
                            AppToast().show(context, result.message!);
                            Navigator.pop(context, modelList);
                          } else {
                            AppToast().show(
                                context,
                                tr('faild_for_something',
                                    args: ['${tr('order_cancel')}']));
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: AppSize.padding),
                        alignment: Alignment.center,
                        height: AppSize.appBarHeight,
                        child: AppText.text('${tr('order_cancel')}',
                            style: AppTextStyle.default_14
                                .copyWith(color: AppColors.primary)),
                      ),
                    )
                  : null,
            ),
            child: _buildContents(context, modelList, totalPrice));
      },
    );
  }
}
