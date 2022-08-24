/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/order_manager_page.dart
 * Created Date: 2022-07-05 09:57:28
 * Last Modified: 2022-08-24 17:37:54
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:tuple/tuple.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/util/is_super_account.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/view/orderManager/provider/order_manager_page_provider.dart';

class OrderManagerPage extends StatefulWidget {
  const OrderManagerPage({Key? key}) : super(key: key);
  static const String routeName = '/orderManagerPage';
  @override
  State<OrderManagerPage> createState() => _OrderManagerPageState();
}

class _OrderManagerPageState extends State<OrderManagerPage> {
  late TextEditingController _deliveryConditionInputController;
  late TextEditingController _orderDescriptionInputController;
  late TextEditingController _productQuantityInputController;
  late TextEditingController _surchargeQuantityInputController;
  @override
  void initState() {
    _deliveryConditionInputController = TextEditingController();
    _orderDescriptionInputController = TextEditingController();
    _productQuantityInputController = TextEditingController();
    _surchargeQuantityInputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deliveryConditionInputController.dispose();
    _orderDescriptionInputController.dispose();
    _productQuantityInputController.dispose();
    _surchargeQuantityInputController.dispose();
    super.dispose();
  }

  Widget _buildGroupSelector(BuildContext context) {
    final p = context.read<OrderManagerPageProvider>();
    return CheckSuperAccount.isMultiAccountOrLeaderAccount()
        ? Column(
            children: [
              AppStyles.buildTitleRow(tr('salse_group')),
              defaultSpacing(isHalf: true),
              Selector<OrderManagerPageProvider, String?>(
                  selector: (context, provider) => provider.selectedSalseGroup,
                  builder: (context, salesGroup, _) {
                    return BaseInputWidget(
                        context: context,
                        width: AppSize.defaultContentsWidth,
                        enable: false,
                        hintTextStyleCallBack: salesGroup != null
                            ? () => AppTextStyle.default_16
                            : () => AppTextStyle
                                .hint_16, // hintTextStyleCallBack: () => AppTextStyle.hint_16,
                        iconType: InputIconType.SELECT,
                        // iconType: null,
                        iconColor: salesGroup == null
                            ? AppColors.textFieldUnfoucsColor
                            : null,
                        commononeCellDataCallback: p.getSalesGroup,
                        oneCellType: OneCellType.SEARCH_BUSINESS_GROUP,
                        // oneCellType: OneCellType.DO_NOTHING,
                        isSelectedStrCallBack: (str) => p.setSalseGroup(str),
                        hintText: salesGroup != null
                            ? salesGroup
                            : '${tr('plz_select_something_1', args: [
                                    tr('salse_group')
                                  ])}');
                  })
            ],
          )
        : Container();
  }

  Widget _buildStaffSelector(BuildContext context) {
    final p = context.read<OrderManagerPageProvider>();
    return CheckSuperAccount.isMultiAccountOrLeaderAccount()
        ? Column(
            children: [
              defaultSpacing(),
              AppStyles.buildTitleRow(tr('manager')),
              defaultSpacing(isHalf: true),
              Selector<OrderManagerPageProvider, Tuple2<String?, String?>>(
                  selector: (context, provider) => Tuple2(
                      provider.selectedStaffName, provider.selectedSalseGroup),
                  builder: (context, tuple, _) {
                    return BaseInputWidget(
                      context: context,
                      width: AppSize.defaultContentsWidth,
                      iconType: InputIconType.SEARCH,
                      iconColor: tuple.item1 != null
                          ? AppColors.defaultText
                          : AppColors.textFieldUnfoucsColor,
                      hintText: tuple.item1 ?? tr('plz_select'),
                      // 팀장 일때 만 팀원선택후 삭제가능.
                      isShowDeleteForHintText:
                          tuple.item1 != null ? true : false,
                      deleteIconCallback: () => p.setStaffName(null),
                      hintTextStyleCallBack: () => tuple.item1 != null
                          ? AppTextStyle.default_16
                          : AppTextStyle.hint_16,
                      popupSearchType: PopupSearchType.SEARCH_SALSE_PERSON,
                      isSelectedStrCallBack: (persion) {
                        return p.setSalsePerson(persion);
                      },
                      bodyMap: {
                        'dptnm': tuple.item2 != null ? tuple.item2 : ''
                      },
                      enable: false,
                    );
                  })
            ],
          )
        : Container();
  }

  Widget _buildChannelSelector(BuildContext context) {
    final p = context.read<OrderManagerPageProvider>();

    return Selector<OrderManagerPageProvider, Tuple2<String?, String?>>(
      selector: (context, provider) =>
          Tuple2(provider.selectedSalseChannel, provider.selectedSalseGroup),
      builder: (context, tuple, _) {
        return BaseInputWidget(
          context: context,
          onTap: () {
            if (tuple.item2 == null) {
              AppToast().show(
                  context,
                  tr('plz_enter_search_key_for_something_1',
                      args: [tr('salse_group')]));
            }
          },
          iconType: InputIconType.SELECT,
          hintText: tuple.item1 != null ? tuple.item1 : '${tr('plz_select')}',
          width: AppSize.defaultContentsWidth,
          hintTextStyleCallBack: tuple.item1 != null
              ? () => AppTextStyle.default_16
              : () => AppTextStyle.hint_16,
          commononeCellDataCallback: p.getChannelFromDB,
          oneCellType: tuple.item2 == null
              ? OneCellType.DO_NOTHING
              : OneCellType.SEARCH_CIRCULATION_CHANNEL,
          isSelectedStrCallBack: (channel) {
            p.setSalseChannel(channel);
          },
          enable: false,
        );
      },
    );
  }

  Widget _buildProductFamilySelector(BuildContext context) {
    return Selector<OrderManagerPageProvider, String?>(
      selector: (context, provider) => provider.selectedProductFamily,
      builder: (context, productFamily, _) {
        return Container();
      },
    );
  }

  Widget _buildSalseOfficeSelector(BuildContext context) {
    return Selector<OrderManagerPageProvider, String?>(
      selector: (context, provider) => provider.selectedSalseOffice,
      builder: (context, salseOffice, _) {
        return Container();
      },
    );
  }

  Widget _buildSupplierSelector(BuildContext context) {
    return Selector<OrderManagerPageProvider, String?>(
      selector: (context, provider) => provider.selectedSupplier,
      builder: (context, supplier, _) {
        return Container();
      },
    );
  }

  Widget _buildEndCustomerTextRow(BuildContext context) {
    return Selector<OrderManagerPageProvider, String?>(
      selector: (context, provider) => provider.selectedEndCustomer,
      builder: (context, endCustomer, _) {
        return Container();
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container();
  }

  Widget _buildAddProductTitleRow(BuildContext context) {
    return Row(
      children: [Container(), _buildAddButton(context)],
    );
  }

  Widget _buildRecentOrderTextButton(BuildContext context) {
    return Container();
  }

  Widget _buildProductItems(BuildContext context) {
    return Selector<OrderManagerPageProvider, String?>(
      selector: (context, provider) => provider.selectedEndCustomer,
      builder: (context, endCustomer, _) {
        return Container();
      },
    );
  }

  Widget _buildDeliveryConditionInput(BuildContext context) {
    return Selector<OrderManagerPageProvider, String?>(
      selector: (context, provider) => provider.deliveryConditionInputText,
      builder: (context, input, _) {
        return Container();
      },
    );
  }

  Widget _buildOrderDescriptionDetail(BuildContext context) {
    return Selector<OrderManagerPageProvider, String?>(
      selector: (context, provider) => provider.orderDescriptionDetailInputText,
      builder: (context, input, _) {
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        hasForm: true,
        appBar: MainAppBar(context,
            titleText: AppText.text('${tr('salse_order_manager')}',
                style: AppTextStyle.w500_22)),
        child: ChangeNotifierProvider(
          create: (context) => OrderManagerPageProvider(),
          builder: (context, _) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomerinfoWidget.buildSubTitle(
                          context, '${tr('default_info')}'),
                      Padding(
                        padding: AppSize.defaultSidePadding,
                        child: Column(
                          children: [
                            defaultSpacing(),
                            _buildGroupSelector(context),
                            defaultSpacing(),
                            _buildStaffSelector(context),
                            defaultSpacing(),
                            _buildChannelSelector(context),
                            defaultSpacing(),
                            _buildProductFamilySelector(context),
                            defaultSpacing(),
                            _buildSalseOfficeSelector(context),
                            defaultSpacing(),
                            _buildSupplierSelector(context),
                            defaultSpacing(),
                            _buildEndCustomerTextRow(context),
                            defaultSpacing(),
                          ],
                        ),
                      ),
                      CustomerinfoWidget.buildSubTitle(
                          context, '${tr('order_product_info')}'),
                      Padding(
                        padding: AppSize.defaultSidePadding,
                        child: Column(
                          children: [
                            defaultSpacing(),
                            _buildAddProductTitleRow(context),
                            defaultSpacing(),
                            _buildRecentOrderTextButton(context),
                            defaultSpacing(),
                            _buildProductItems(context),
                            defaultSpacing(),
                          ],
                        ),
                      ),
                      CustomerinfoWidget.buildSubTitle(
                          context, '${tr('other_info')}'),
                      Padding(
                        padding: AppSize.defaultSidePadding,
                        child: Column(
                          children: [
                            defaultSpacing(),
                            _buildDeliveryConditionInput(context),
                            defaultSpacing(),
                            _buildOrderDescriptionDetail(context),
                            defaultSpacing(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }
}
