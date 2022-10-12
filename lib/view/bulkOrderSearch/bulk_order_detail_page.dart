/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/bulkOrderSearch/bulk_order_detail_page.dart
 * Created Date: 2022-07-21 14:20:27
 * Last Modified: 2022-10-12 22:42:24
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'dart:math' as math;
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/view/common/dialog_contents.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/enums/offset_direction_type.dart';
import 'package:medsalesportal/view/common/widget_of_loading_view.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/model/rfc/bulk_order_et_t_list_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_t_item_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_t_header_model.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_response_model.dart';
import 'package:medsalesportal/view/common/base_info_row_by_key_and_value.dart';
import 'package:medsalesportal/view/bulkOrderSearch/order_item_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_offset_animation_components.dart';
import 'package:medsalesportal/view/common/widget_of_rotation_animation_components.dart';
import 'package:medsalesportal/view/bulkOrderSearch/provider/bulk_order_deatil_provider.dart';

class BulkOrderDetailPage extends StatefulWidget {
  const BulkOrderDetailPage({Key? key}) : super(key: key);
  static const String routeName = '/bulkOrderDetailPage';
  @override
  State<BulkOrderDetailPage> createState() => _BulkOrderDetailPageState();
}

class _BulkOrderDetailPageState extends State<BulkOrderDetailPage> {
  var _animationSwich = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationSwich.dispose();
    super.dispose();
  }

  Widget _buildAnimationTitleBar(BuildContext context) {
    return Selector<BulkOrderDetailProvider, Tuple2<bool, double>>(
      selector: (context, provider) =>
          Tuple2(provider.isShowShadow, provider.orderTotal),
      builder: (context, tuple, _) {
        return InkWell(
          onTap: () {
            final p = context.read<BulkOrderDetailProvider>();
            p.setIsOpenBottomSheet();
            _animationSwich.value = !_animationSwich.value;
          },
          child: Container(
            width: AppSize.realWidth,
            height: AppSize.buttonHeight,
            decoration: BoxDecoration(
                color: AppColors.whiteText,
                boxShadow: tuple.item1
                    ? [
                        BoxShadow(
                          color: AppColors.textGrey.withOpacity(0.5),
                          blurRadius: AppSize.radius5,
                          offset: Offset(0, -3),
                        ),
                      ]
                    : []),
            child: Padding(
              padding: AppSize.defaultSidePadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.text('${tr('order_total')}',
                      style: AppTextStyle.blod_16),
                  Row(
                    children: [
                      AppText.text('${FormatUtil.addComma('${tuple.item2}')}',
                          style: AppTextStyle.blod_16
                              .copyWith(color: AppColors.primary)),
                      Padding(
                          padding: EdgeInsets.only(
                              right: AppSize.defaultListItemSpacing)),
                      ValueListenableBuilder<bool>(
                          valueListenable: _animationSwich,
                          builder: (context, swich, _) {
                            return WidgetOfRotationAnimationComponents(
                              animationSwich: () => swich,
                              rotationValue: math.pi,
                              body: Container(
                                height: AppSize.defaultIconWidth,
                                width: AppSize.defaultIconWidth,
                                child: AppImage.getImage(ImageType.SELECT,
                                    color: AppColors.subText),
                              ),
                            );
                          })
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCancelButtonAndSaveButton(BuildContext context) {
    return Row(
      children: [
        AppStyles.buildButton(
            context,
            '${tr('order_cancel')}',
            AppSize.realWidth / 2,
            AppColors.lightBlueColor,
            AppTextStyle.default_18.copyWith(color: AppColors.primary),
            AppSize.zero, () async {
          final p = context.read<BulkOrderDetailProvider>();
          final dialogResult = await AppDialog.showPopup(
              context,
              buildTowButtonTextContents(context, tr('is_realy_cancel_order'),
                  successButtonText: tr('order_cancel'),
                  faildButtonText: tr('close')));
          if (dialogResult != null && dialogResult) {
            await p.orderCancelOrSave(true).then((result) {
              AppToast().show(context,
                  result.isSuccessful ? result.message! : result.errorMassage!);
              if (result.isSuccessful) {
                Navigator.pop(context, true);
              }
            });
          }
        }),
        AppStyles.buildButton(
            context,
            '${tr('order_save')}',
            AppSize.realWidth / 2,
            AppColors.primary,
            AppTextStyle.default_18.copyWith(color: AppColors.whiteText),
            AppSize.zero, () async {
          final p = context.read<BulkOrderDetailProvider>();
          var overThan = p.amountAvailable.isNotEmpty &&
              double.parse(p.amountAvailable) > p.orderTotal;

          if (overThan) {
            await p.checkIsItemInStock().then((isInStockAll) async {
              if (isInStockAll) {
                await p.orderCancelOrSave(false).then((result) {
                  AppToast().show(
                      context,
                      result.isSuccessful
                          ? result.message!
                          : result.errorMassage!);
                });
              } else {
                var message = p.editItemList
                    .where((item) => item.zmsg != '정상')
                    .toList()
                    .first
                    .zmsg;
                AppToast().show(context, message!);
              }
            });
          } else {
            AppToast()
                .show(context, tr('amount_available_for_order_entry_is_fail'));
          }
        })
      ],
    );
  }

  Widget _buildAnimationBody(BuildContext context) {
    return Selector<BulkOrderDetailProvider, String>(
      selector: (context, provider) => provider.amountAvailable,
      builder: (context, amountAvailable, _) {
        return Container(
            padding: AppSize.defaultSidePadding,
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                defaultSpacing(times: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.text('${tr('amount_available_for_order_entry')}',
                        style: AppTextStyle.blod_16),
                    Padding(
                      padding: EdgeInsets.only(right: AppSize.padding * 2),
                      child: AppText.text(
                          '${FormatUtil.addComma('$amountAvailable', isReturnZero: true)}',
                          style: AppTextStyle.blod_16),
                    )
                  ],
                ),
                defaultSpacing()
              ],
            ));
      },
    );
  }

  Widget _buildBottomAnimationBox(BuildContext context) {
    return Selector<BulkOrderDetailProvider, Tuple2<bool, bool>>(
      selector: (context, provider) =>
          Tuple2(provider.isOpenBottomSheet, provider.isAnimationNotReady),
      builder: (context, tuple, _) {
        return WidgetOfOffSetAnimationWidget(
            key: Key('first'),
            animationSwich: tuple.item2 ? null : () => tuple.item1,
            body: _buildAnimationBody(context),
            height: AppSize.buttonHeight * 3,
            offset: Offset(0, (AppSize.buttonHeight * 3)),
            offsetType: OffsetDirectionType.UP);
      },
    );
  }

  Widget _buildBottomAnimationStatusBar(BuildContext context) {
    return Positioned(
        bottom: 0,
        left: 0,
        child: Column(
          children: [
            _buildAnimationTitleBar(context),
            _buildCancelButtonAndSaveButton(context)
          ],
        ));
  }

  Widget _buildOrderInfo(BulkOrderDetailResponseModel? model) {
    final argumentsModel =
        ModalRoute.of(context)!.settings.arguments as BulkOrderEtTListModel;
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
                        '${FormatUtil.addDashForDateStr(model.tHead!.single.zreqDate!)}'),
                    BaseInfoRowByKeyAndValue.build(tr('salse_order_number'),
                        '${model.tHead!.single.zreqno}'),
                    BaseInfoRowByKeyAndValue.build(tr('request_order_number'),
                        '${model.tHead!.single.vbeln!.isEmpty ? '-' : model.tHead!.single.vbeln!}'),
                    BaseInfoRowByKeyAndValue.build(tr('processing_status'),
                        '${model.tHead!.single.zdmstatusNm}'),
                    BaseInfoRowByKeyAndValue.build(tr('saller_name_and_code'),
                        '${argumentsModel.kunnrNm!}/${argumentsModel.kunnr}',
                        maxLine: 2),
                    BaseInfoRowByKeyAndValue.build(
                        tr('end_saller_name_and_code'),
                        '${argumentsModel.zzkunnrEndNm}/${argumentsModel.zzkunnrEnd}',
                        maxLine: 2),
                    defaultSpacing()
                  ],
                ),
              )
            ],
          )
        : Container();
  }

  Widget _buildContents(BuildContext context) {
    return Selector<BulkOrderDetailProvider, BulkOrderDetailResponseModel?>(
        selector: (context, provider) => provider.bulkOrderDetailResponseModel,
        builder: (context, model, _) {
          var isStatusA = model?.tHead?.single.zdmstatus == 'A';
          return Stack(
            children: [
              model != null &&
                      model.tItem != null &&
                      model.tItem!.isNotEmpty &&
                      model.tHead != null
                  ? ListView(
                      children: [
                        _buildOrderInfo(model),
                        ...model.tItem!
                            .asMap()
                            .entries
                            .map((map) => _buildItem(context, map.value,
                                map.key, model.tHead!.single))
                            .toList(),
                        isStatusA ? defaultSpacing(times: 3) : defaultSpacing()
                      ],
                    )
                  : Container(),
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: Selector<BulkOrderDetailProvider, bool>(
                    selector: (context, provider) => provider.isShowLoading,
                    builder: (context, isShowLoading, _) {
                      return isShowLoading
                          ? BaseLoadingViewOnStackWidget.build(
                              context, isShowLoading,
                              height: AppSize.realHeight - AppSize.appBarHeight,
                              width: AppSize.realWidth)
                          : Container();
                    },
                  )),
              isStatusA ? _buildBottomAnimationBox(context) : Container(),
              isStatusA ? _buildBottomAnimationStatusBar(context) : Container()
            ],
          );
        });
  }

  Widget _buildItem(BuildContext context, BulkOrderDetailTItemModel model,
      int index, BulkOrderDetailTHeaderModel head) {
    var isStatusA = head.zdmstatus == 'A';
    final p = context.read<BulkOrderDetailProvider>();
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
              isStatusA
                  ? Row(
                      children: [
                        SizedBox(
                          width: AppSize.defaultContentsWidth * .3,
                          child: AppText.text(tr('processing_quantity'),
                              style: AppTextStyle.h6,
                              textAlign: TextAlign.left),
                        ),
                        OrderItemInputWidget(
                          onSubmittedCallBack: (str) =>
                              p.setQuantityAndCheckPrice(str, index),
                          defaultValue: model.kwmeng!.toInt().toString(),
                        )
                      ],
                    )
                  : BaseInfoRowByKeyAndValue.build(tr('processing_quantity'),
                      model.kwmeng!.toInt().toString()),
              isStatusA
                  ? Selector<BulkOrderDetailProvider, Tuple2<String?, bool?>>(
                      selector: (context, provider) => Tuple2(
                          provider.editItemList[index].zmsg,
                          provider.editItemList[index].isShowLoading),
                      builder: (context, tuple, _) {
                        return Row(
                          children: [
                            SizedBox(
                              width: AppSize.defaultContentsWidth * .3,
                              child: AppText.text(tr('massage'),
                                  style: AppTextStyle.h6,
                                  textAlign: TextAlign.left),
                            ),
                            Expanded(
                                child: Container(
                              alignment: Alignment.centerLeft,
                              height: AppSize.defaultTextFieldHeight,
                              child: tuple.item2 == null
                                  ? AppText.text(tuple.item1!,
                                      style: AppTextStyle.h4,
                                      maxLines: 2,
                                      textAlign: TextAlign.left)
                                  : tuple.item2!
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left:
                                                  AppSize.defaultContentsWidth *
                                                      .2),
                                          child: SizedBox(
                                              height:
                                                  AppSize.iconSmallDefaultWidth,
                                              width:
                                                  AppSize.iconSmallDefaultWidth,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 1.0)),
                                        )
                                      : AppText.text(tuple.item1!,
                                          style: AppTextStyle.h4,
                                          maxLines: 2,
                                          textAlign: TextAlign.left),
                            ))
                          ],
                        );
                      },
                    )
                  : BaseInfoRowByKeyAndValue.build(
                      tr('massage'), '${model.zmsg}'),

              // 메시지
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
    return ChangeNotifierProvider(
        create: (context) => BulkOrderDetailProvider(),
        builder: (context, _) {
          return BaseLayout(
              hasForm: true,
              appBar: MainAppBar(
                context,
                titleText: AppText.text('${tr('bulk_order_detail')}',
                    style: AppTextStyle.w500_22),
                callback: () {
                  final p = context.read<BulkOrderDetailProvider>();
                  Navigator.pop(context, p.isOrderSaved ? true : null);
                },
              ),
              child: WillPopScope(
                onWillPop: () async {
                  final p = context.read<BulkOrderDetailProvider>();
                  Navigator.pop(context, p.isOrderSaved ? true : null);
                  return false;
                },
                child: FutureBuilder<ResultModel>(
                    future: context
                        .read<BulkOrderDetailProvider>()
                        .getOrderDetail(model),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        return _buildContents(context);
                      }
                      return DefaultShimmer.buildDefaultPageShimmer(5,
                          isWithSet: true, setLenght: 5);
                    }),
              ));
        });
  }
}
