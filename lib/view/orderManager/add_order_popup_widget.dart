/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/add_order_popup_widget.dart
 * Created Date: 2022-09-04 17:55:15
 * Last Modified: 2022-09-14 11:23:21
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/model/rfc/recent_order_t_item_model.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/order_item_type.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/dialog_contents.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
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
              iconType: InputIconType.SELECT,
              iconColor: tuple.item1 != null
                  ? AppColors.defaultText
                  : AppColors.textFieldUnfoucsColor,
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
              bodyMap: {'productFamily': widget.productFamily},
            );
          },
        ));
  }

  Widget _buildQuantityInput(BuildContext context) {
    return BaseColumWithTitleAndTextFiled.build(tr('quantity'),
        TextControllerFactoryWidget(giveTextEditControllerWidget: (controller) {
      return Selector<AddOrderPopupProvider, Tuple2<String?, bool>>(
        selector: (context, provider) =>
            Tuple2(provider.quantity, provider.isLoadData),
        builder: (context, tuple, _) {
          final p = context.read<AddOrderPopupProvider>();
          return Stack(
            children: [
              Focus(
                  focusNode: _focusNode,
                  onFocusChange: (focus) async {
                    if (!focus) {
                      if (p.selectedMateria != null) {
                        await p.checkPrice().then((result) {
                          if (!result.isSuccessful) {
                            p.setQuantity(null);
                            _productQuantityInputController.text = '';
                            AppDialog.showSignglePopup(
                                context, result.message!);
                          } else {
                            p.setHeight(AppSize.realHeight * .8);
                          }
                        });
                      }
                    }
                  },
                  child: BaseInputWidget(
                    context: context,
                    iconType: tuple.item1 != null ? InputIconType.DELETE : null,
                    onChangeCallBack: (t) => p.setQuantity(t),
                    defaultIconCallback: () {
                      p.setQuantity(null);
                      _productQuantityInputController.text = '';
                    },
                    textEditingController: _productQuantityInputController,
                    keybordType: TextInputType.number,
                    iconColor: tuple.item1 != null
                        ? AppColors.defaultText
                        : AppColors.textFieldUnfoucsColor,
                    hintText: tuple.item1 ?? tr('plz_enter'),
                    // 팀장 일때 만 팀원선택후 삭제가능.
                    width: AppSize.defaultContentsWidth,
                    hintTextStyleCallBack: () => tuple.item1 != null
                        ? AppTextStyle.default_16
                        : AppTextStyle.hint_16,
                    enable: true,
                  )),
              _buildLoadingWidget(context)
            ],
          );
        },
      );
    }));
  }

  Widget _buildSurChargeInput(BuildContext context) {
    var isMatch = widget.productFamily.contains('비처방의약품') ||
        widget.productFamily.contains('건강식품') ||
        widget.productFamily.contains('처방의약품');

    return !isMatch
        ? Container()
        : BaseColumWithTitleAndTextFiled.build(
            tr('salse_surcharge_quantity_option1'),
            Selector<AddOrderPopupProvider, String?>(
                selector: (context, provider) => provider.surcharge,
                builder: (context, surcharge, _) {
                  return BaseInputWidget(
                    context: context,
                    iconType: InputIconType.SELECT,
                    textEditingController: _surchargeQuantityInputController,
                    iconColor: surcharge != null
                        ? AppColors.defaultText
                        : AppColors.textFieldUnfoucsColor,
                    hintText: surcharge ?? tr('plz_enter'),
                    keybordType: TextInputType.number,
                    // 팀장 일때 만 팀원선택후 삭제가능.
                    width: AppSize.defaultContentsWidth,
                    hintTextStyleCallBack: () => surcharge != null
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
        Tuple2<BulkOrderDetailSearchMetaPriceModel?, String?>>(
      selector: (context, provider) =>
          Tuple2(provider.priceModel, provider.quantity),
      builder: (context, tuple, _) {
        return tuple.item1 != null && tuple.item2 != null
            ? Column(
                children: [
                  orderInfoRow(context, tr('add_quantity'), tuple.item2!),
                  defaultSpacing(),
                  orderInfoRow(context, tr('supply_and_vat_2'),
                      '${FormatUtil.addComma('${tuple.item1!.netwr}')}/${FormatUtil.addComma('${tuple.item1!.mwsbp}')}'),
                  defaultSpacing(),
                  orderInfoRow(context, tr('unit_and_standart_price'),
                      '${FormatUtil.addComma('${tuple.item1!.znetpr}')}/${FormatUtil.addComma('${tuple.item1!.netpr}')}'),
                  defaultSpacing(),
                  orderInfoRow(context, tr('discount_rate_and_price'),
                      '${FormatUtil.addComma('${tuple.item1!.zdisRate}', isReturnZero: true)}/${FormatUtil.addComma('${tuple.item1!.zdisPrice}', isReturnZero: true)}'),
                  defaultSpacing(),
                  orderInfoRow(context, tr('unit'), '${tuple.item1!.vrkme}'),
                  defaultSpacing(),
                  orderInfoRow(
                      context, tr('currency_unit_2'), '${tuple.item1!.waerk}'),
                  defaultSpacing(),
                  orderInfoRow(
                      context, tr('plant_'), '${tuple.item1!.werksNm}'),
                ],
              )
            : Container();
      },
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return Selector<AddOrderPopupProvider, bool>(
      selector: (context, provider) => provider.isLoadData,
      builder: (context, isLoadData, _) {
        return isLoadData
            ? SizedBox(
                width: AppSize.defaultContentsWidth,
                height: AppSize.defaultTextFieldHeight,
                child: Align(
                    alignment: Alignment.center,
                    child: SizedBox.fromSize(
                        size: Size(20, 20),
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: AppColors.primary,
                        ))),
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddOrderPopupProvider(),
      builder: (context, _) {
        final p = context.read<AddOrderPopupProvider>();
        return FutureBuilder(
            future: p.initData(widget.bodyMap, editModell: widget.editModel),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return Selector<AddOrderPopupProvider, double>(
                  selector: (context, provider) => provider.height,
                  builder: (context, height, _) {
                    return buildDialogContents(
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                      if (p.selectedMateria == null || p.quantity == null) {
                        AppToast()
                            .show(context, tr('plz_check_essential_option'));
                        return null;
                      } else {
                        var orderItemModel = await p.createOrderItemModel();
                        var priceModel = p.priceModel;
                        return {
                          'orderItemModel': orderItemModel,
                          'priceModel': priceModel
                        };
                      }
                    }, canPopCallBackk: () async {
                      if (p.selectedMateria == null || p.quantity == null) {
                        AppToast()
                            .show(context, tr('plz_check_essential_option'));
                        return false;
                      }
                      if (p.selectedMateria != null && p.quantity != null) {
                        return true;
                      }
                      return false;
                    });
                  },
                );
              }
              return Container();
            });
      },
    );
  }
}
