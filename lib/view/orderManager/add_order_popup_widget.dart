/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/add_order_popup_widget.dart
 * Created Date: 2022-09-04 17:55:15
 * Last Modified: 2022-11-03 17:31:33
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/order_item_type.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/dialog_contents.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_loading_view.dart';
import 'package:medsalesportal/model/rfc/recent_order_t_item_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/model/rfc/order_manager_material_model.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';
import 'package:medsalesportal/view/orderManager/text_controller_factory_widget.dart';
import 'package:medsalesportal/view/common/base_column_with_title_and_textfiled.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_search_meta_price_model.dart';
import 'package:medsalesportal/view/orderManager/provider/add_order_popup_provider.dart';
import 'package:tuple/tuple.dart';

class AddOrderPopupWidget extends StatefulWidget {
  const AddOrderPopupWidget(
      {Key? key,
      required this.type,
      required this.bodyMap,
      required this.productFamily,
      this.editModel,
      this.priceModel})
      : super(key: key);
  final OrderItemType type;
  final String productFamily;
  final Map<String, dynamic> bodyMap;
  final RecentOrderTItemModel? editModel;
  final BulkOrderDetailSearchMetaPriceModel? priceModel;
  @override
  State<AddOrderPopupWidget> createState() => _AddOrderPopupWidgetState();
}

class _AddOrderPopupWidgetState extends State<AddOrderPopupWidget> {
  late TextEditingController _productQuantityInputController;
  late TextEditingController _surchargeQuantityInputController;
  late FocusNode _focusNode;
  @override
  void initState() {
    _focusNode = FocusNode();
    _productQuantityInputController = TextEditingController();
    _surchargeQuantityInputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _productQuantityInputController.dispose();
    _surchargeQuantityInputController.dispose();
    super.dispose();
  }

  Widget _buildMatSelector(BuildContext context) {
    final p = context.read<AddOrderPopupProvider>();
    return BaseColumWithTitleAndTextFiled.build(
        tr('mat_name'),
        Selector<AddOrderPopupProvider,
            Tuple2<OrderManagerMaterialModel?, bool>>(
          selector: (context, provider) =>
              Tuple2(provider.selectedMateria, provider.isLoadData),
          builder: (context, tuple, _) {
            return BaseInputWidget(
              context: context,
              iconType: InputIconType.SEARCH,
              iconColor: AppColors.textFieldUnfoucsColor,
              hintText:
                  tuple.item1 != null ? tuple.item1!.maktx : tr('plz_select'),
              popupSearchType: tuple.item2
                  ? PopupSearchType.DO_NOTHING
                  : PopupSearchType.SEARCH_MATERIAL,
              // 팀장 일때 만 팀원선택후 삭제가능.
              width: AppSize.defaultContentsWidth,
              hintTextStyleCallBack: () => tuple.item1 != null
                  ? AppTextStyle.default_16
                  : AppTextStyle.hint_16,
              isSelectedStrCallBack: (mat) {
                p.setQuantity(null, isNotNotifier: true);
                p.setMaterial(mat);
                _productQuantityInputController.text = '';
              },
              enable: false,
              bodyMap: {'product_family': widget.productFamily},
            );
          },
        ));
  }

  Widget _buildQuantityInput(BuildContext context) {
    return BaseColumWithTitleAndTextFiled.build(tr('quantity'),
        TextControllerFactoryWidget(giveTextEditControllerWidget: (controller) {
      return Selector<AddOrderPopupProvider,
          Tuple3<String?, bool, BulkOrderDetailSearchMetaPriceModel?>>(
        selector: (context, provider) =>
            Tuple3(provider.quantity, provider.isLoadData, provider.priceModel),
        builder: (context, tuple, _) {
          final p = context.read<AddOrderPopupProvider>();
          var isQuantityNotEmpty = tuple.item1 != null &&
              tuple.item1!.isNotEmpty &&
              int.parse(tuple.item1!) != '0';
          var isPriceModelNotEmpty =
              tuple.item3 != null && tuple.item3!.zfreeQty != 0.0;
          return Row(
            children: [
              BaseInputWidget(
                context: context,
                iconType: tuple.item1 != null && tuple.item1!.isNotEmpty
                    ? InputIconType.DELETE
                    : null,
                onChangeCallBack: (t) => p.setQuantity(t),

                defaultIconCallback: () {
                  p.setQuantity(null);
                  _productQuantityInputController.clear();
                },
                textEditingController: _productQuantityInputController,
                keybordType: TextInputType.number,
                iconColor: AppColors.textFieldUnfoucsColor,
                hintText: tuple.item1 != null && tuple.item1!.isNotEmpty
                    ? tuple.item1
                    : tr('plz_enter'),
                // 팀장 일때 만 팀원선택후 삭제가능.
                width: (AppSize.defaultContentsWidth -
                        AppSize.padding * 2 -
                        AppSize.defaultListItemSpacing) *
                    .7,
                hintTextStyleCallBack: () =>
                    tuple.item1 != null && tuple.item1!.isNotEmpty
                        ? AppTextStyle.default_16
                        : AppTextStyle.hint_16,
                enable: true,
              ),
              Padding(
                  padding:
                      EdgeInsets.only(right: AppSize.defaultListItemSpacing)),
              GestureDetector(
                onTap: () async {
                  hideKeyboard(context);
                  if (p.selectedMateria != null && !isPriceModelNotEmpty) {
                    await p.checkPrice().then((result) {
                      if (!result.isSuccessful) {
                        p.setQuantity(null);
                        _productQuantityInputController.text = '';
                        AppDialog.showSignglePopup(context, result.message!);
                      } else {
                        if (p.quantity != null && p.quantity!.isNotEmpty) {
                          p.setHeight(AppSize.realHeight * .8);
                        } else {
                          p.setQuantity(null);
                          p.setHeight(AppSize.realHeight * .5);
                        }
                      }
                    });
                  } else {
                    if (int.parse(p.quantity!) == 0) {
                      AppToast().show(context, tr('plz_select_quantity'));
                    } else {
                      AppToast().show(context, tr('plz_select_material'));
                    }
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: (AppSize.defaultContentsWidth -
                          AppSize.padding * 2 -
                          AppSize.defaultListItemSpacing) *
                      .3,
                  height: AppSize.defaultTextFieldHeight,
                  decoration: BoxDecoration(
                      color: isQuantityNotEmpty && isPriceModelNotEmpty
                          ? AppColors.unReadyButton
                          : isQuantityNotEmpty
                              ? AppColors.sendButtonColor
                              : AppColors.unReadyButton,
                      borderRadius:
                          BorderRadius.all(Radius.circular(AppSize.radius5)),
                      border: Border.all(
                          width: .5,
                          color: isQuantityNotEmpty && isPriceModelNotEmpty
                              ? AppColors.textFieldUnfoucsColor
                              : isQuantityNotEmpty
                                  ? AppColors.primary
                                  : AppColors.textFieldUnfoucsColor)),
                  child: AppText.text(tr('search'),
                      style: AppTextStyle.h4.copyWith(
                          color: isQuantityNotEmpty && isPriceModelNotEmpty
                              ? AppColors.hintText
                              : isQuantityNotEmpty
                                  ? AppColors.primary
                                  : AppColors.hintText)),
                ),
              )
            ],
          );
        },
      );
    }));
  }

  Widget _buildSurChargeInput(BuildContext context) {
    var isMatch = widget.productFamily.contains('비처방의약품') ||
        widget.productFamily.contains('건강식품') ||
        widget.productFamily.contains('처방의약품') ||
        widget.productFamily.contains(tr('all'));
    final p = context.read<AddOrderPopupProvider>();
    return !isMatch
        ? Container()
        : BaseColumWithTitleAndTextFiled.build(
            tr('salse_surcharge_quantity_option1'),
            Selector<AddOrderPopupProvider, String?>(
                selector: (context, provider) => provider.surcharge,
                builder: (context, surcharge, _) {
                  return BaseInputWidget(
                    context: context,

                    textEditingController: _surchargeQuantityInputController,
                    iconColor: AppColors.textFieldUnfoucsColor,
                    hintText: surcharge != null && surcharge.isNotEmpty
                        ? surcharge
                        : tr('plz_enter'),
                    keybordType: TextInputType.number,
                    defaultIconCallback: () {
                      p.setSurcharge(null);
                      _surchargeQuantityInputController.clear();
                    },

                    iconType: surcharge != null && surcharge.isNotEmpty
                        ? InputIconType.DELETE
                        : null,
                    onChangeCallBack: (str) {
                      p.setSurcharge(str);
                    },
                    // 팀장 일때 만 팀원선택후 삭제가능.
                    width: AppSize.defaultContentsWidth,
                    hintTextStyleCallBack: () =>
                        surcharge != null && surcharge.isNotEmpty
                            ? AppTextStyle.default_16
                            : AppTextStyle.hint_16,
                    enable: true,
                  );
                }),
            isNotShowStar: true);
  }

  Widget orderInfoRow(BuildContext context, String title, String body) {
    var width = AppSize.defaultContentsWidth - AppSize.padding * 2;
    return Row(
      children: [
        SizedBox(
          width: width * .5,
          child: AppText.text(title,
              style: AppTextStyle.sub_14, textAlign: TextAlign.start),
        ),
        SizedBox(
          width: width * .5,
          child: AppText.text(body,
              style: AppTextStyle.default_14, textAlign: TextAlign.end),
        ),
      ],
    );
  }

  Widget _buildOrderInfo(BuildContext context) {
    return Selector<AddOrderPopupProvider,
        BulkOrderDetailSearchMetaPriceModel?>(
      selector: (context, provider) => provider.priceModel,
      builder: (context, model, _) {
        return model != null
            ? Column(
                children: [
                  orderInfoRow(context, tr('add_quantity'),
                      '${model.zfreeQty != null ? model.zfreeQty!.toInt() : 0}'),
                  defaultSpacing(),
                  orderInfoRow(context, tr('supply_and_vat_2'),
                      '${FormatUtil.addComma('${model.netwr}')}/${FormatUtil.addComma('${model.mwsbp}')}'),
                  defaultSpacing(),
                  orderInfoRow(context, tr('unit_and_standart_price'),
                      '${FormatUtil.addComma('${model.znetpr}')}/${FormatUtil.addComma('${model.netpr}')}'),
                  defaultSpacing(),
                  orderInfoRow(context, tr('discount_rate_and_price'),
                      '${FormatUtil.addComma('${model.zdisRate}', isReturnZero: true)}/${FormatUtil.addComma('${model.zdisPrice}', isReturnZero: true)}'),
                  defaultSpacing(),
                  orderInfoRow(context, tr('unit'), '${model.vrkme}'),
                  defaultSpacing(),
                  orderInfoRow(
                      context, tr('currency_unit_2'), '${model.waerk}'),
                  defaultSpacing(),
                  orderInfoRow(context, tr('plant_'), '${model.werksNm}'),
                ],
              )
            : Container();
      },
    );
  }

  Widget _buildLoadingWidget(BuildContext context, double height) {
    return Positioned(
        left: 0,
        bottom: 0,
        child: SizedBox(
          height: height,
          width: AppSize.defaultContentsWidth,
          child: Selector<AddOrderPopupProvider, bool>(
            selector: (context, provider) => provider.isLoadData,
            builder: (context, isLoadData, _) {
              return BaseLoadingViewOnStackWidget.build(context, isLoadData);
            },
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddOrderPopupProvider(),
      builder: (context, _) {
        final p = context.read<AddOrderPopupProvider>();
        return FutureBuilder(
            future: p.initData(
              widget.bodyMap,
              editModell: widget.editModel,
              priceModell: widget.priceModel,
            ),
            builder: (context, snapshot) {
              if (widget.type == OrderItemType.EDIT) {
                if (widget.editModel!.kwmeng != 0.0 &&
                    _productQuantityInputController.text == '') {
                  _productQuantityInputController.text =
                      '${widget.editModel!.kwmeng!.toInt()}';
                }
                if (widget.editModel!.zfreeQty != 0.0 &&
                    _surchargeQuantityInputController.text == '') {
                  _surchargeQuantityInputController.text =
                      '${widget.editModel!.zfreeQty!.toInt()}';
                }
              }
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return Selector<AddOrderPopupProvider, double>(
                  selector: (context, provider) => provider.height,
                  builder: (context, height, _) {
                    return Stack(
                      children: [
                        buildDialogContents(
                            context,
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                hideKeyboard(context);
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  height: height - AppSize.buttonHeight * 2,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        defaultSpacing(),
                                        _buildMatSelector(context),
                                        _buildQuantityInput(context),
                                        _buildSurChargeInput(context),
                                        _buildOrderInfo(context)
                                      ],
                                    ),
                                  )),
                            ),
                            false,
                            height,
                            iswithTitle: true,
                            titleText: tr('add_order'),
                            rightButtonText: widget.type == OrderItemType.NEW
                                ? tr('add')
                                : tr('save'), dataCallback: () async {
                          hideKeyboard(context);
                          if (p.selectedMateria == null || p.quantity == null) {
                            AppToast().show(
                                context, tr('plz_check_essential_option'));
                            return null;
                          } else {
                            if (!p.isLoadData && p.priceModel != null) {
                              var orderItemModel =
                                  await p.createOrderItemModel();
                              var priceModel = p.priceModel;
                              return {
                                'orderItemModel': orderItemModel,
                                'priceModel': priceModel
                              };
                            }
                          }
                        }, canPopCallBackk: () async {
                          if (p.selectedMateria == null || p.quantity == null) {
                            AppToast().show(
                                context, tr('plz_check_essential_option'));
                            return false;
                          }
                          if (p.selectedMateria != null &&
                              p.quantity != null &&
                              !p.isLoadData &&
                              p.priceModel != null) {
                            return true;
                          }
                          if (p.priceModel == null) {
                            AppToast().show(context, tr('plz_check_price'));
                          }
                          return false;
                        }),
                        _buildLoadingWidget(context, height)
                      ],
                    );
                  },
                );
              }
              return Container();
            });
      },
    );
  }
}
