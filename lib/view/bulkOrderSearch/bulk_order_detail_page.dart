/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/bulkOrderSearch/bulk_order_detail_page.dart
 * Created Date: 2022-07-21 14:20:27
 * Last Modified: 2022-07-21 18:10:11
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_t_header_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_t_item_model.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/model/rfc/bulk_order_et_t_list_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_response_model.dart';
import 'package:medsalesportal/view/common/base_info_row_by_key_and_value.dart';
import 'package:medsalesportal/view/bulkOrderSearch/provider/bulk_order_deatil_provider.dart';

class BulkOrderDetailPage extends StatefulWidget {
  const BulkOrderDetailPage({Key? key}) : super(key: key);
  static const String routeName = '/bulkOrderDetailPage';
  @override
  State<BulkOrderDetailPage> createState() => _BulkOrderDetailPageState();
}

class _BulkOrderDetailPageState extends State<BulkOrderDetailPage> {
  Widget _buildBottomAnimationStatusBar(BuildContext context) {
    return Container();
  }

  Widget _buildOrderInfo(BulkOrderDetailResponseModel? model) {
    return model != null && model.tHead != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomerinfoWidget.buildSubTitle(
                  context, '${tr('default_info')}'),
              Padding(
                padding: AppSize.defaultSidePadding,
                child: Column(
                  children: [
                    BaseInfoRowByKeyAndValue.build(tr('order_request_date'),
                        '${model.tHead!.single.mwsbpSum}'),
                    BaseInfoRowByKeyAndValue.build(tr('salse_order_number'),
                        '${model.tHead!.single.mwsbpSum}'),
                    BaseInfoRowByKeyAndValue.build(tr('request_order_number'),
                        '${model.tHead!.single.mwsbpSum}'),
                    BaseInfoRowByKeyAndValue.build(tr('processing_status'),
                        '${model.tHead!.single.mwsbpSum}'),
                    BaseInfoRowByKeyAndValue.build(tr('saller_name_and_code'),
                        '${model.tHead!.single.mwsbpSum}'),
                    BaseInfoRowByKeyAndValue.build(
                        tr('end_saller_name_and_code'),
                        '${model.tHead!.single.mwsbpSum}'),
                    defaultSpacing()
                  ],
                ),
              )
            ],
          )
        : Container();
  }

  Widget _buildContents(BuildContext context) {
    return Stack(
      children: [
        Selector<BulkOrderDetailProvider, BulkOrderDetailResponseModel?>(
          selector: (context, provider) =>
              provider.bulkOrderDetailResponseModel,
          builder: (context, model, _) {
            return model != null &&
                    model.tItem != null &&
                    model.tItem!.isNotEmpty &&
                    model.tHead != null
                ? ListView(
                    children: [
                      _buildOrderInfo(model),
                      ...model.tItem!
                          .asMap()
                          .entries
                          .map((map) => _buildItem(
                              map.value, map.key, model.tHead!.single))
                          .toList()
                    ],
                  )
                : Container();
          },
        ),
        _buildBottomAnimationStatusBar(context)
      ],
    );
  }

  Widget _buildItem(BulkOrderDetailTItemModel model, int index,
      BulkOrderDetailTHeaderModel head) {
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
                  tr('mat_code'), model.matnr ?? '-'),
              BaseInfoRowByKeyAndValue.build(
                  tr('mat_name'), model.maktx ?? '-'),
              BaseInfoRowByKeyAndValue.build(
                  tr('box_i_o'), '${model.setUmrez}/${model.boxUmrez}'),
              BaseInfoRowByKeyAndValue.build(
                  tr('request_quantity'), model.zkwmeng!.toInt().toString()),
              BaseInfoRowByKeyAndValue.build(
                  tr('processing_quantity'), model.kwmeng!.toInt().toString()),
              BaseInfoRowByKeyAndValue.build(
                  tr('massage'), '${model.zmsg}'), // 메시지
              defaultSpacing()
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final model =
        ModalRoute.of(context)!.settings.arguments as BulkOrderEtTListModel;
    return BaseLayout(
        hasForm: false,
        appBar: MainAppBar(context,
            titleText: AppText.text('${tr('bulk_order_detail')}',
                style: AppTextStyle.w500_22)),
        child: ChangeNotifierProvider(
          create: (context) => BulkOrderDetailProvider(),
          builder: (context, _) {
            return FutureBuilder<ResultModel>(
                future: context
                    .read<BulkOrderDetailProvider>()
                    .getOrderDetail(model),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return _buildContents(context);
                  }
                  return Container();
                });
          },
        ));
  }
}
