/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/order_manager_page.dart
 * Created Date: 2022-07-05 09:57:28
 * Last Modified: 2022-08-21 11:56:15
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/util/is_super_account.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/orderManager/provider/order_manager_page_provider.dart';
import 'package:provider/provider.dart';

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
    return CheckSuperAccount.isMultiAccount() ||
            CheckSuperAccount.isLeaderAccount()
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
    return Selector<OrderManagerPageProvider, String?>(
      selector: (context, provider) => provider.selectedStaffName,
      builder: (context, staffName, _) {
        return Container();
      },
    );
  }

  Widget _buildChannelSelector(BuildContext context) {
    return Selector<OrderManagerPageProvider, String?>(
      selector: (context, provider) => provider.selectedSalseChannel,
      builder: (context, channel, _) {
        return Container();
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
                            _buildGroupSelector(context),
                            _buildStaffSelector(context),
                            _buildChannelSelector(context),
                            _buildProductFamilySelector(context),
                            _buildSalseOfficeSelector(context),
                            _buildSupplierSelector(context),
                            _buildEndCustomerTextRow(context),
                          ],
                        ),
                      ),
                      CustomerinfoWidget.buildSubTitle(
                          context, '${tr('order_product_info')}'),
                      Padding(
                        padding: AppSize.defaultSidePadding,
                        child: Column(
                          children: [
                            _buildAddProductTitleRow(context),
                            _buildRecentOrderTextButton(context),
                            _buildProductItems(context),
                          ],
                        ),
                      ),
                      CustomerinfoWidget.buildSubTitle(
                          context, '${tr('other_info')}'),
                      Padding(
                        padding: AppSize.defaultSidePadding,
                        child: Column(
                          children: [
                            _buildDeliveryConditionInput(context),
                            _buildOrderDescriptionDetail(context),
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
