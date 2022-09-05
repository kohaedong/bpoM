/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/order_manager_page.dart
 * Created Date: 2022-07-05 09:57:28
 * Last Modified: 2022-09-05 10:26:13
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/order_item_type.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/et_cust_list_model.dart';
import 'package:medsalesportal/model/rfc/et_customer_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/view/common/base_info_row_by_key_and_value.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_loading_view.dart';
import 'package:medsalesportal/view/orderManager/add_order_popup_widget.dart';
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
                  }),
              defaultSpacing()
            ],
          )
        : Container();
  }

  Widget _buildStaffSelector(BuildContext context) {
    final p = context.read<OrderManagerPageProvider>();
    return CheckSuperAccount.isLeaderAccount()
        ? Column(
            children: [
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
                  }),
              defaultSpacing(),
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
        return Column(
          children: [
            AppStyles.buildTitleRow(tr('cannel')),
            BaseInputWidget(
              context: context,
              onTap: () {},
              iconType: InputIconType.SELECT,
              hintText:
                  tuple.item1 != null ? tuple.item1 : '${tr('plz_select')}',
              width: AppSize.defaultContentsWidth,
              hintTextStyleCallBack: tuple.item1 != null
                  ? () => AppTextStyle.default_16
                  : () => AppTextStyle.hint_16,
              commononeCellDataCallback: () async => p.getChannelFromDB(),
              oneCellType: OneCellType.SEARCH_CIRCULATION_CHANNEL,
              isSelectedStrCallBack: (channel) {
                p.setSalseChannel(channel);
              },
              enable: false,
            ),
            defaultSpacing()
          ],
        );
      },
    );
  }

  Widget _buildProductFamilySelector(BuildContext context) {
    final p = context.read<OrderManagerPageProvider>();

    return Selector<OrderManagerPageProvider, Tuple2<String?, String?>>(
      selector: (context, provider) =>
          Tuple2(provider.selectedProductFamily, provider.selectedSalseChannel),
      builder: (context, tuple, _) {
        return Column(
          children: [
            AppStyles.buildTitleRow(tr('product_family')),
            BaseInputWidget(
              context: context,
              onTap: () {},
              iconType: InputIconType.SELECT,
              hintText:
                  tuple.item1 != null ? tuple.item1 : '${tr('plz_select')}',
              width: AppSize.defaultContentsWidth,
              hintTextStyleCallBack: tuple.item1 != null
                  ? () => AppTextStyle.default_16
                  : () => AppTextStyle.hint_16,
              commononeCellDataCallback: () async => p.getProductFamilyFromDB(),
              oneCellType: OneCellType.SEARCH_PRODUCT_FAMILY,
              isSelectedStrCallBack: (family) {
                p.setProductFamily(family);
              },
              enable: false,
            ),
            defaultSpacing()
          ],
        );
      },
    );
  }

  Widget _buildSalseOfficeSelector(BuildContext context) {
    final p = context.read<OrderManagerPageProvider>();
    return Selector<OrderManagerPageProvider,
        Tuple4<String?, EtCustomerModel?, EtStaffListModel?, String?>>(
      selector: (context, provider) => Tuple4(
          provider.selectedProductFamily,
          provider.selectedCustomerModel,
          provider.selectedSalsePerson,
          provider.selectedSalseChannel),
      builder: (context, tuple, _) {
        return Column(
          children: [
            AppStyles.buildTitleRow(tr('sales_office')),
            BaseInputWidget(
              context: context,
              onTap: tuple.item1 == null
                  ? () {
                      AppToast().show(
                          context,
                          tr('plz_select_something_1',
                              args: [tr('product_family')]));
                      return 'continue';
                    }
                  : null,
              iconType: InputIconType.SEARCH,
              iconColor: tuple.item1 != null
                  ? AppColors.defaultText
                  : AppColors.textFieldUnfoucsColor,
              deleteIconCallback: () => p.setCustomerModel(null),
              hintText: tuple.item2 != null
                  ? tuple.item2!.kunnrNm
                  : '${tr('plz_select_something_2', args: [
                          tr('sales_office')
                        ])}',
              // 팀장 일때 만 팀원선택후 삭제가능.
              isShowDeleteForHintText: tuple.item2 != null ? true : false,
              width: AppSize.defaultContentsWidth,
              hintTextStyleCallBack: () => tuple.item2 != null
                  ? AppTextStyle.default_16
                  : AppTextStyle.hint_16,
              popupSearchType: PopupSearchType.SEARCH_SALLER,
              isSelectedStrCallBack: (customer) {
                return p.setCustomerModel(customer);
              },
              bodyMap: {
                'vtweg': p.channelCode,
                'product_family': tuple.item1,
                'staff': CheckSuperAccount.isMultiAccountOrLeaderAccount()
                    ? tuple.item3 != null
                        ? tuple.item3!.sname
                        : tr('all')
                    : CacheService.getEsLogin()!.ename,
                'dptnm': CheckSuperAccount.isMultiAccount()
                    ? tuple.item3 != null
                        ? tuple.item3!.dptnm
                        : CacheService.getEsLogin()!.dptnm
                    : CacheService.getEsLogin()!.dptnm
              },
              enable: false,
            ),
            defaultSpacing()
          ],
        );
      },
    );
  }

  Widget _buildSupplierAndEndCustomerInfoRow() {
    return Selector<OrderManagerPageProvider,
        Tuple3<bool?, EtCustListModel?, EtCustListModel?>>(
      selector: (context, provider) => Tuple3(provider.isSingleData,
          provider.selectedSupplierModel, provider.selectedEndCustomerModel),
      builder: (context, tuple, _) {
        return tuple.item1 != null && tuple.item1!
            ? Column(
                children: [
                  BaseInfoRowByKeyAndValue.build(
                      tr('supplier'), tuple.item2!.kunnrNm!),
                  BaseInfoRowByKeyAndValue.build(
                      tr('end_user'), tuple.item3!.kunnrNm!),
                  defaultSpacing(),
                ],
              )
            : Container();
      },
    );
  }

  Widget _buildSupplierSelector(BuildContext context) {
    final p = context.read<OrderManagerPageProvider>();
    return Selector<OrderManagerPageProvider,
        Tuple3<EtCustListModel?, bool?, EtCustomerModel?>>(
      selector: (context, provider) => Tuple3(provider.selectedSupplierModel,
          provider.isSingleData, provider.selectedCustomerModel),
      builder: (context, tuple, _) {
        return tuple.item2 == null
            ? Container()
            : tuple.item2!
                ? Container()
                : Column(
                    children: [
                      AppStyles.buildTitleRow(tr('supplier')),
                      BaseInputWidget(
                        context: context,
                        iconType: InputIconType.SEARCH,
                        iconColor: tuple.item1 != null
                            ? AppColors.defaultText
                            : AppColors.textFieldUnfoucsColor,
                        deleteIconCallback: () => p.setSupplier(null),
                        hintText: tuple.item1 != null
                            ? tuple.item1!.kunnrNm
                            : '${tr('plz_select_something_1', args: [
                                    tr('supplier')
                                  ])}',
                        // 팀장 일때 만 팀원선택후 삭제가능.
                        isShowDeleteForHintText:
                            tuple.item1 != null ? true : false,
                        width: AppSize.defaultContentsWidth,
                        hintTextStyleCallBack: () => tuple.item1 != null
                            ? AppTextStyle.default_16
                            : AppTextStyle.hint_16,
                        popupSearchType: PopupSearchType.SEARCH_SUPPLIER,
                        isSelectedStrCallBack: (supplier) {
                          return p.setSupplier(supplier);
                        },
                        bodyMap: {'kunnr': tuple.item3?.kunnr},
                        enable: false,
                      ),
                    ],
                  );
      },
    );
  }

  Widget _buildEndCustomerTextRow(BuildContext context) {
    return Selector<OrderManagerPageProvider, Tuple2<bool?, EtCustomerModel?>>(
      selector: (context, provider) =>
          Tuple2(provider.isSingleData, provider.selectedCustomerModel),
      builder: (context, tuple, _) {
        return tuple.item1 != null && !tuple.item1!
            ? BaseInfoRowByKeyAndValue.build(
                tr('end_user'), tuple.item2!.kunnrNm!)
            : Container();
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return InkWell(
      onTap: () {
        final result = AppDialog.showPopup(
            context, AddOrderPopupWidget(type: OrderItemType.NEW));
        if (result != null) {
          pr('tap');
        }
      },
      child: Container(
        alignment: Alignment.centerLeft,
        height: AppSize.smallButtonHeight,
        width: AppSize.smallButtonWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.radius4),
            border:
                Border.all(width: .5, color: AppColors.textFieldUnfoucsColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: AppColors.textFieldUnfoucsColor,
            ),
            AppText.text(tr('add'),
                style: AppTextStyle.h5.copyWith(color: AppColors.defaultText))
          ],
        ),
      ),
    );
  }

  Widget _buildAddProductTitleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppStyles.buildTitleRow(tr('order_items')),
        _buildAddButton(context)
      ],
    );
  }

  Widget _buildRecentOrderTextButton(BuildContext context) {
    return InkWell(
        onTap: () {
          final p = context.read<OrderManagerPageProvider>();
          p.checkRecentOrders();
        },
        child: Row(
          children: [
            AppText.text(tr('get_recent_order'),
                style: AppTextStyle.sub_12.copyWith(color: AppColors.primary)),
            Icon(Icons.arrow_forward_ios_rounded,
                size: AppSize.smallIconWidth, color: AppColors.primary),
          ],
        ));
  }

  Widget _buildProductItems(BuildContext context) {
    return Selector<OrderManagerPageProvider, String?>(
      selector: (context, provider) => '',
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

  Widget _buildLoadingWidget(BuildContext context) {
    return Selector<OrderManagerPageProvider, bool>(
      selector: (context, provider) => provider.isLoadData,
      builder: (context, isLoadData, _) {
        return BaseLoadingViewOnStackWidget.build(context, isLoadData);
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
            return FutureBuilder<ResultModel>(
                future: context.read<OrderManagerPageProvider>().initData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
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
                                    _buildSupplierAndEndCustomerInfoRow(),
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
                        ),
                        _buildLoadingWidget(context)
                      ],
                    );
                  }
                  return DefaultShimmer.buildDefaultPageShimmer(5,
                      isWithSet: true, setLenght: 10);
                });
          },
        ));
  }
}
