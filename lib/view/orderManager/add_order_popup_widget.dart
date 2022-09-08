/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/add_order_popup_widget.dart
 * Created Date: 2022-09-04 17:55:15
 * Last Modified: 2022-09-08 15:24:04
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/model/rfc/order_manager_material_model.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/order_item_type.dart';
import 'package:medsalesportal/view/common/dialog_contents.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';
import 'package:medsalesportal/view/orderManager/text_controller_factory_widget.dart';
import 'package:medsalesportal/view/common/base_column_with_title_and_textfiled.dart';
import 'package:medsalesportal/view/orderManager/provider/add_order_popup_provider.dart';

class AddOrderPopupWidget extends StatefulWidget {
  const AddOrderPopupWidget(
      {Key? key,
      required this.type,
      required this.bodyMap,
      required this.productFamily})
      : super(key: key);
  final OrderItemType type;
  final String productFamily;
  final Map<String, dynamic> bodyMap;
  @override
  State<AddOrderPopupWidget> createState() => _AddOrderPopupWidgetState();
}

class _AddOrderPopupWidgetState extends State<AddOrderPopupWidget> {
  late TextEditingController _productQuantityInputController;
  late TextEditingController _surchargeQuantityInputController;
  @override
  void initState() {
    _productQuantityInputController = TextEditingController();
    _surchargeQuantityInputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _productQuantityInputController.dispose();
    _surchargeQuantityInputController.dispose();
    super.dispose();
  }

  Widget _buildMatSelector(BuildContext context) {
    final p = context.read<AddOrderPopupProvider>();
    return BaseColumWithTitleAndTextFiled.build(
        tr('mat_name'),
        Selector<AddOrderPopupProvider, OrderManagerMaterialModel?>(
          selector: (context, provider) => provider.selectedMateria,
          builder: (context, mate, _) {
            return BaseInputWidget(
              context: context,
              iconType: InputIconType.SELECT,
              iconColor: mate != null
                  ? AppColors.defaultText
                  : AppColors.textFieldUnfoucsColor,
              hintText: mate != null ? mate.maktx : tr('plz_select'),
              popupSearchType: PopupSearchType.SEARCH_MATERIAL,
              // 팀장 일때 만 팀원선택후 삭제가능.
              width: AppSize.defaultContentsWidth,
              hintTextStyleCallBack: () =>
                  mate != null ? AppTextStyle.default_16 : AppTextStyle.hint_16,
              isSelectedStrCallBack: (mat) {
                p.setMaterial(mat);
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
      return Selector<AddOrderPopupProvider, String?>(
        selector: (context, provider) => provider.quantity,
        builder: (context, quantity, _) {
          return Focus(
              onFocusChange: (focus) {
                if (!focus) {
                  pr('unfocus');
                }
              },
              child: BaseInputWidget(
                context: context,
                iconType: quantity != null ? InputIconType.DELETE : null,
                onChangeCallBack: (t) {},
                defaultIconCallback: () {
                  controller.text = '';
                },
                iconColor: quantity != null
                    ? AppColors.defaultText
                    : AppColors.textFieldUnfoucsColor,
                hintText: quantity ?? tr('plz_enter'),
                // 팀장 일때 만 팀원선택후 삭제가능.
                width: AppSize.defaultContentsWidth,
                hintTextStyleCallBack: () => quantity != null
                    ? AppTextStyle.default_16
                    : AppTextStyle.hint_16,
                isSelectedStrCallBack: (mate) {},
                enable: true,
              ));
        },
      );
    }));
  }

  Widget _buildSurChargeInput(BuildContext context) {
    return BaseColumWithTitleAndTextFiled.build(
        tr('salse_surcharge_quantity_option1'),
        Selector<AddOrderPopupProvider, String?>(
            selector: (context, provider) => provider.surcharge,
            builder: (context, surcharge, _) {
              return BaseInputWidget(
                context: context,
                iconType: InputIconType.SELECT,
                iconColor: surcharge != null
                    ? AppColors.defaultText
                    : AppColors.textFieldUnfoucsColor,
                hintText: surcharge ?? tr('plz_enter'),
                // 팀장 일때 만 팀원선택후 삭제가능.
                width: AppSize.defaultContentsWidth,
                hintTextStyleCallBack: () => surcharge != null
                    ? AppTextStyle.default_16
                    : AppTextStyle.hint_16,
                isSelectedStrCallBack: (mate) {},
                enable: true,
              );
            }),
        isNotShowStar: true);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddOrderPopupProvider(),
      builder: (context, _) {
        return FutureBuilder(
            future:
                context.read<AddOrderPopupProvider>().initData(widget.bodyMap),
            builder: (context, snapshot) {
              final p = context.read<AddOrderPopupProvider>();
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
                            child: Column(
                              children: [
                                defaultSpacing(),
                                _buildMatSelector(context),
                                _buildQuantityInput(context),
                                p.spart!.contains('비처방의약품') ||
                                        p.spart!.contains('건강식품') ||
                                        p.spart!.contains('처방의약품')
                                    ? _buildSurChargeInput(context)
                                    : Container(),
                              ],
                            )),
                      ),
                      false,
                      height,
                      iswithTitle: true,
                      titleText: tr('add_order'),
                      rightButtonText: tr('add'));
                },
              );
            });
      },
    );
  }
}
