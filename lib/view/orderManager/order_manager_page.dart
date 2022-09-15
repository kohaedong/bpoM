/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/order_manager_page.dart
 * Created Date: 2022-07-05 09:57:28
 * Last Modified: 2022-09-16 00:27:52
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/services.dart';
import 'package:medsalesportal/globalProvider/timer_provider.dart';
import 'package:medsalesportal/view/common/fountion_of_hidden_key_borad.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/view/orderSearch/order_search_page.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/order_item_type.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/util/is_super_account.dart';
import 'package:medsalesportal/enums/input_icon_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/enums/popup_search_type.dart';
import 'package:medsalesportal/view/common/base_layout.dart';
import 'package:medsalesportal/view/common/base_app_bar.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/base_app_toast.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/model/rfc/et_customer_model.dart';
import 'package:medsalesportal/model/rfc/et_cust_list_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';
import 'package:medsalesportal/view/common/widget_of_loading_view.dart';
import 'package:medsalesportal/model/rfc/recent_order_t_item_model.dart';
import 'package:medsalesportal/view/common/widget_of_default_shimmer.dart';
import 'package:medsalesportal/view/common/widget_of_default_spacing.dart';
import 'package:medsalesportal/view/common/widget_of_customer_info_top.dart';
import 'package:medsalesportal/view/orderManager/add_order_popup_widget.dart';
import 'package:medsalesportal/view/common/base_info_row_by_key_and_value.dart';
import 'package:medsalesportal/view/orderManager/text_controller_factory_widget.dart';
import 'package:medsalesportal/model/rfc/bulk_order_detail_search_meta_price_model.dart';
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
    return CheckSuperAccount.isMultiAccount()
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
                                    tr('salse_group'),
                                    ''
                                  ])}');
                  }),
              defaultSpacing()
            ],
          )
        : Container();
  }

  Widget _buildStaffSelector(BuildContext context) {
    final p = context.read<OrderManagerPageProvider>();
    return CheckSuperAccount.isMultiAccountOrLeaderAccount()
        ? Column(
            children: [
              AppStyles.buildTitleRow(tr('manager')),
              defaultSpacing(isHalf: true),
              Selector<OrderManagerPageProvider,
                      Tuple2<EtStaffListModel?, String?>>(
                  selector: (context, provider) => Tuple2(
                      provider.selectedSalsePerson,
                      provider.selectedSalseGroup),
                  builder: (context, tuple, _) {
                    return BaseInputWidget(
                      context: context,
                      width: AppSize.defaultContentsWidth,
                      iconType: InputIconType.SEARCH,
                      iconColor: tuple.item1 != null
                          ? AppColors.defaultText
                          : AppColors.textFieldUnfoucsColor,
                      hintText: tuple.item1 != null
                          ? tuple.item1!.sname!
                          : tr('plz_select'),
                      // 팀장 일때 만 팀원선택후 삭제가능.
                      isShowDeleteForHintText:
                          tuple.item1 != null ? true : false,
                      deleteIconCallback: () => p.setSalsePerson(null),
                      hintTextStyleCallBack: () => tuple.item1 != null
                          ? AppTextStyle.default_16
                          : AppTextStyle.hint_16,
                      popupSearchType: PopupSearchType.SEARCH_SALSE_PERSON,
                      isSelectedStrCallBack: (person) {
                        return p.setSalsePerson(person);
                      },
                      bodyMap: CheckSuperAccount.isMultiAccount()
                          ? {'dptnm': tuple.item2 ?? ''}
                          : {'dptnm': CacheService.getEsLogin()!.dptnm},
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
            AppStyles.buildTitleRow(tr('channel')),
            BaseInputWidget(
              context: context,
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
              isNotInsertAll: CheckSuperAccount.isMultiAccountOrLeaderAccount()
                  ? true
                  : false,
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
                              args: [tr('product_family'), '']));
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
                          tr('sales_office'),
                          ''
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
                'dptnm': CheckSuperAccount.isMultiAccountOrLeaderAccount()
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
                                    tr('supplier'),
                                    ''
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
      onTap: () async {
        final p = context.read<OrderManagerPageProvider>();
        if (p.selectedCustomerModel != null) {
          final result = await AppDialog.showPopup(
              context,
              AddOrderPopupWidget(
                type: OrderItemType.NEW,
                productFamily: p.selectedProductFamily!,
                //!
                bodyMap: p.commonBodyMap!,
              ));
          if (result != null) {
            if (result is Map<String, dynamic>) {
              var itemModel = result['orderItemModel'] as RecentOrderTItemModel;
              var priceModel = result['priceModel'];
              p.getAmountAvailableForOrderEntry(isNotifier: false).then((_) {
                var sum = p.totalPrice + itemModel.netwr!;
                if (p.amountAvalible! > sum) {
                  if (p.items == null) {
                    p.insertItem(itemModel, priceModel: priceModel);
                  } else {
                    var isSameModelExists = p.items!
                        .where((item) => item.matnr == itemModel.matnr)
                        .toList()
                        .isNotEmpty;
                    if (isSameModelExists) {
                      AppToast().show(
                          context,
                          tr('item_exits',
                              args: ['${itemModel.matnr}-${itemModel.maktx}']));
                    } else {
                      p.insertItem(itemModel, priceModel: priceModel);
                    }
                  }
                } else {
                  AppDialog.showSignglePopup(
                      context, tr('insufficient_balance'));
                }
              });
            }
          }
        } else {
          AppToast().show(context,
              tr('plz_select_something_2', args: [tr('sales_office'), '']));
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
    return Row(
      children: [
        InkWell(
            onTap: () {
              final p = context.read<OrderManagerPageProvider>();
              if (p.selectedCustomerModel != null) {
                p.checkRecentOrders().then((result) {
                  if (result.isSuccessful) {
                    var map = result.data as Map<String, dynamic>;
                    var isExits = map['isExits'] as bool;
                    var isEmpty = map['isEmpty'] as bool;
                    var model = map['model'] as RecentOrderTItemModel?;
                    if (isEmpty) {
                      AppToast().show(context, tr('not_recent_order'));
                    }
                    if (isExits) {
                      AppToast().show(
                          context,
                          tr('recent_order_is_getted',
                              args: [model!.matnr!, model.maktx!]));
                    }
                  }
                });
              } else {
                AppToast().show(
                    context,
                    tr('plz_select_something_2',
                        args: [tr('sales_office'), '']));
              }
            },
            child: AppText.text(tr('get_recent_order'),
                style: AppTextStyle.sub_12.copyWith(color: AppColors.primary))),
        Icon(Icons.arrow_forward_ios_rounded,
            size: AppSize.smallIconWidth, color: AppColors.primary),
      ],
    );
  }

  Widget _buildTextAndInputWidget(
    String text,
    Widget widgetUi,
  ) {
    return Row(
      children: [
        SizedBox(
          width: AppSize.defaultContentsWidth * .3,
          child: AppText.text(text,
              style: AppTextStyle.sub_14, textAlign: TextAlign.left),
        ),
        widgetUi
      ],
    );
  }

  Widget _buildOrderItem(
      BuildContext context, int index, RecentOrderTItemModel model) {
    final p = context.read<OrderManagerPageProvider>();
    var family = p.selectedProductFamily!;
    return Column(
      children: [
        Row(
          children: [
            _buildTextAndInputWidget(
              '${tr('mat_name')}${index + 1}',
              BaseInputWidget(
                  context: context,
                  onTap: () async {
                    var currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasFocus) {
                      final result = await AppDialog.showPopup(
                          context,
                          AddOrderPopupWidget(
                            type: OrderItemType.EDIT,
                            productFamily: p.selectedProductFamily!,
                            //!
                            bodyMap: p.commonBodyMap!,
                            editModel: p.items![index],
                            priceModel: p.priceModelList[index],
                          ));
                      if (result != null) {
                        if (result is Map<String, dynamic>) {
                          var itemModel =
                              result['orderItemModel'] as RecentOrderTItemModel;
                          pr(itemModel.toJson());
                          var priceModel = result['priceModel']
                              as BulkOrderDetailSearchMetaPriceModel;
                          p
                              .getAmountAvailableForOrderEntry(
                                  isNotifier: false)
                              .then((_) {
                            p.updateItem(
                                index,
                                RecentOrderTItemModel.fromJson(
                                    itemModel.toJson()));
                            p.updatePriceList(
                                index,
                                BulkOrderDetailSearchMetaPriceModel.fromJson(
                                    priceModel.toJson()));
                            p.updateQuantityList(
                              index,
                              itemModel.kwmeng!,
                            );
                            p.setTableQuantity(index, itemModel.kwmeng!);
                            p.updateSurchargeQuantityList(
                                index, itemModel.zfreeQty!,
                                isNotifier: true);
                            p.setTableSurchargeQuantity(
                                index, itemModel.zfreeQty!);
                          });
                        }
                      }
                    }
                  },
                  hintTextStyleCallBack: () => AppTextStyle.default_16,
                  iconType: InputIconType.SELECT_RIGHT,
                  hintText: model.maktx,
                  width: (AppSize.defaultContentsWidth * .7) * .85,
                  enable: false),
            ),
            InkWell(
              onTap: () => p.removeItem(index),
              child: Container(
                  alignment: Alignment.centerRight,
                  width: (AppSize.defaultContentsWidth * .7) * .15,
                  height: AppSize.defaultTextFieldHeight,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.radius5),
                        border: Border.all(
                            color: AppColors.textFieldUnfoucsColor, width: .5)),
                    child: Icon(
                      Icons.close,
                      size: 15,
                      color: AppColors.textFieldUnfoucsColor,
                    ),
                  )),
            )
          ],
        ),
        defaultSpacing(isHalf: true),
        _buildTextAndInputWidget(
          tr('quantity'),
          TextControllerFactoryWidget(
              giveTextEditControllerWidget: (controller) {
            return Selector<OrderManagerPageProvider, List<double>>(
              selector: (context, provider) => provider.selectedQuantityList,
              builder: (context, quantityList, _) {
                pr('build quantity');
                if (controller.text != '${quantityList[index].toInt()}') {
                  if (quantityList[index].toInt() != 0) {
                    controller.text = '${quantityList[index].toInt()}';
                  }
                }
                var isNotEmpty =
                    quantityList.isNotEmpty && quantityList[index] != 0.0;
                return BaseInputWidget(
                    context: context,
                    onTap: () {
                      if (isNotEmpty) {
                        controller.text = '${quantityList[index].toInt()}';
                      }
                    },
                    textEditingController: controller,
                    unfoucsCallback: () async {
                      final result =
                          await p.checkPrice(index, isNotifier: true);
                      if (result.isSuccessful) {
                        p.setTableQuantity(
                            index, p.selectedQuantityList[index]);
                      } else {
                        AppDialog.showSignglePopup(context, result.message!);
                        p.updateQuantityList(index, 0);
                        p.setTableQuantity(index, 0);
                        controller.clear();
                      }
                    },
                    hintText: isNotEmpty
                        ? '${quantityList[index].toInt()}'
                        : tr('plz_enter'),
                    keybordType: TextInputType.number,
                    hintTextStyleCallBack: () => isNotEmpty
                        ? AppTextStyle.default_16
                        : AppTextStyle.hint_16,
                    defaultIconCallback: () {
                      controller.text = '';
                      p.updateQuantityList(index, 0);
                      p.setTableQuantity(index, 0, isResetTotal: true);
                      p.checkPrice(index, isNotifier: true);
                    },
                    iconType: isNotEmpty ? InputIconType.DELETE : null,
                    width: AppSize.defaultContentsWidth * .7,
                    onChangeCallBack: (t) async {
                      if (double.tryParse(t) != null) {
                        p.updateQuantityList(index, double.parse(t));
                        p.setTableQuantity(index, double.parse(t));
                      } else if (t.isEmpty) {
                        p.updateQuantityList(index, 0);
                      }
                    },
                    enable: true);
              },
            );
          }),
        ),
        defaultSpacing(isHalf: true),
        family.contains('비처방의약품') ||
                family.contains('건강식품') ||
                family.contains('처방의약품')
            ? _buildTextAndInputWidget(tr('salse_surcharge_quantity'),
                TextControllerFactoryWidget(
                    giveTextEditControllerWidget: (controller) {
                return Selector<OrderManagerPageProvider, List<double>>(
                  selector: (context, provider) =>
                      provider.selectedSurchargeList,
                  builder: (context, surchargeList, _) {
                    if (controller.text != '${surchargeList[index].toInt()}') {
                      if (surchargeList[index].toInt() != 0) {
                        controller.text = '${surchargeList[index].toInt()}';
                      }
                    }
                    var isNotEmpty =
                        surchargeList.isNotEmpty && surchargeList[index] != 0.0;
                    return BaseInputWidget(
                        context: context,
                        textEditingController: controller,
                        keybordType: TextInputType.number,
                        onTap: () {
                          if (isNotEmpty) {
                            controller.text = '${surchargeList[index].toInt()}';
                          }
                        },
                        hintText: isNotEmpty ? '' : tr('plz_enter'),
                        defaultIconCallback: () {
                          controller.text = '';
                          p.updateSurchargeQuantityList(index, 0);
                          p.setTableSurchargeQuantity(index, 0);
                        },
                        hintTextStyleCallBack: () => isNotEmpty
                            ? AppTextStyle.default_16
                            : AppTextStyle.hint_16,
                        iconType: isNotEmpty ? InputIconType.DELETE : null,
                        width: AppSize.defaultContentsWidth * .7,
                        onChangeCallBack: (t) async {
                          if (double.tryParse(t) != null) {
                            p.updateSurchargeQuantityList(
                                index, double.parse(t));
                            p.setTableSurchargeQuantity(index, double.parse(t));
                          } else if (t.isEmpty) {
                            p.updateSurchargeQuantityList(index, 0);
                            p.setTableSurchargeQuantity(index, 0);
                          }
                        },
                        enable: true);
                  },
                );
              }))
            : Container(),
        defaultSpacing(),
        _buildTextAndInputWidget(
          '${tr('supply_price')}/${tr('vat')}',
          Selector<OrderManagerPageProvider,
              List<BulkOrderDetailSearchMetaPriceModel?>>(
            selector: (context, provider) => provider.priceModelList,
            builder: (context, priceList, _) {
              return priceList.isNotEmpty &&
                      priceList[index] != null &&
                      priceList[index]!.netpr != 0.0 &&
                      priceList[index]!.mwsbp != 0.0 &&
                      model.kwmeng != 0.0
                  ? Container(
                      child: AppText.text(
                          '${FormatUtil.addComma('${priceList[index]!.netwr ?? 0.0}')} / ${FormatUtil.addComma('${priceList[index]!.mwsbp ?? 0.0}')} ',
                          style: AppTextStyle.h4),
                    )
                  : Container();
            },
          ),
        ),
        defaultSpacing(),
      ],
    );
  }

  Widget _buildTotalInfo(BuildContext context) {
    // priceList?.removeWhere((item) => item == null);
    return Selector<OrderManagerPageProvider,
        List<BulkOrderDetailSearchMetaPriceModel?>>(
      selector: (context, provider) => provider.priceModelList,
      builder: (context, priceList, _) {
        var totalSupply = priceList.isNotEmpty
            ? '${priceList.reduce((model, other) => BulkOrderDetailSearchMetaPriceModel(netwr: double.parse('${model != null ? model.netwr ?? 0.0 : 0.0}') + double.parse('${other != null ? other.netwr ?? 0.0 : 0.0}')))?.netwr ?? ''}'
            : '';
        var vatTotal = priceList.isNotEmpty
            ? '${priceList.reduce((model, other) => BulkOrderDetailSearchMetaPriceModel(mwsbp: double.parse('${model != null ? model.mwsbp ?? 0.0 : 0.0}') + double.parse('${other != null ? other.mwsbp ?? 0.0 : 0.0}')))?.mwsbp ?? ''}'
            : '';
        var supplyAndVat = priceList.isNotEmpty &&
                totalSupply.isNotEmpty &&
                totalSupply != 'null' &&
                vatTotal.isNotEmpty &&
                vatTotal != 'null'
            ? '${double.parse('$totalSupply') + double.parse('$vatTotal')}'
            : '';
        return Column(
          children: [
            _buildTextAndInputWidget(tr('total_supply'),
                AppText.text(FormatUtil.addComma(totalSupply))),
            defaultSpacing(),
            _buildTextAndInputWidget(
                tr('vat_total'), AppText.text(FormatUtil.addComma(vatTotal))),
            defaultSpacing(),
            _buildTextAndInputWidget(tr('supply_and_vat'),
                AppText.text(FormatUtil.addComma(supplyAndVat))),
            defaultSpacing(),
            Selector<OrderManagerPageProvider, double?>(
              selector: (context, provider) => provider.amountAvalible,
              builder: (context, amountAvalible, _) {
                return _buildTextAndInputWidget(
                    tr('amount_available_for_order_entry_1'),
                    AppText.text(
                        '${FormatUtil.addComma('${amountAvalible ?? ''}', isReturnZero: true)}'));
              },
            ),
            defaultSpacing(),
          ],
        );
      },
    );
  }

  Widget _buildOrderItemList(BuildContext context) {
    return Selector<OrderManagerPageProvider, List<RecentOrderTItemModel>?>(
      selector: (context, provider) => provider.items,
      builder: (context, items, _) {
        print('build ????');
        return items != null && items.isNotEmpty
            ? Column(
                children: [
                  ...items.asMap().entries.map(
                      (map) => _buildOrderItem(context, map.key, map.value)),
                  defaultSpacing(),
                  Divider(height: .5, color: AppColors.textFieldUnfoucsColor),
                  defaultSpacing(),
                  _buildTotalInfo(context)
                ],
              )
            : Container();
      },
    );
  }

  Widget _buildTextFieldInput(BuildContext context, int type, String title) {
    return Selector<OrderManagerPageProvider, String?>(
      selector: (context, provider) => type == 1
          ? provider.deliveryConditionInputText
          : provider.orderDescriptionDetailInputText,
      builder: (context, input, _) {
        return Column(
          children: [
            AppStyles.buildTitleRow(title, isNotwithStart: true),
            defaultSpacing(isHalf: true),
            TextFormField(
              controller: type == 1
                  ? _deliveryConditionInputController
                  : _orderDescriptionInputController,
              onChanged: (text) {
                final p = context.read<OrderManagerPageProvider>();
                type == 1
                    ? p.setDeliveryCondition(text)
                    : p.setOrderDescriptionDetai(text);
              },
              autofocus: false,
              inputFormatters: [
                LengthLimitingTextInputFormatter(200),
              ],
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              maxLines: 8,
              style: AppTextStyle.default_16,
              decoration: InputDecoration(
                  fillColor: AppColors.whiteText,
                  hintText: '${tr('suggestion_hint')}',
                  hintStyle: AppTextStyle.hint_16,
                  border: OutlineInputBorder(
                      gapPadding: 0,
                      borderSide: BorderSide(
                          color: AppColors.unReadyButtonBorderColor, width: 1),
                      borderRadius: BorderRadius.circular(AppSize.radius5)),
                  focusedBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 1),
                      borderRadius: BorderRadius.circular(AppSize.radius5))),
            )
          ],
        );
      },
    );
  }

  Widget _buildDeliveryConditionInput(
      BuildContext context, int type, String title) {
    return _buildTextFieldInput(context, type, title);
  }

  Widget _buildOrderDescriptionDetail(
      BuildContext context, int type, String title) {
    return _buildTextFieldInput(context, type, title);
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return Selector<OrderManagerPageProvider, bool>(
      selector: (context, provider) => provider.isLoadData,
      builder: (context, isLoadData, _) {
        return BaseLoadingViewOnStackWidget.build(context, isLoadData);
      },
    );
  }

  Widget _buildSubmmitButton(BuildContext context) {
    return Selector<OrderManagerPageProvider, bool>(
      selector: (context, provider) => provider.isValidate,
      builder: (context, isValidate, _) {
        return Positioned(
            left: 0,
            bottom: 0,
            child: AppStyles.buildButton(
                context,
                tr('register'),
                AppSize.realWidth,
                isValidate ? AppColors.primary : AppColors.unReadyButton,
                AppTextStyle.menu_18(
                    isValidate ? AppColors.whiteText : AppColors.hintText),
                0, () {
              if (isValidate) {
                final p = context.read<OrderManagerPageProvider>();
                final tp = context.read<TimerProvider>();
                if (tp.getTimer == null ||
                    (tp.isRunning != null && !tp.isRunning!)) {
                  tp.perdict(p.onSubmmit().then((result) {
                    if (result.isSuccessful) {
                      Navigator.popAndPushNamed(
                          context, OrderSearchPage.routeName);
                    }
                  }));
                }
              }
            }, isBottomButton: true));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderManagerPageProvider(),
      builder: (context, _) {
        return BaseLayout(
            hasForm: true,
            appBar: MainAppBar(context,
                titleText: AppText.text('${tr('salse_order_manager')}',
                    style: AppTextStyle.w500_22)),
            child: FutureBuilder<ResultModel>(
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
                                    _buildOrderItemList(context),
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
                                    _buildDeliveryConditionInput(context, 1,
                                        tr('special_delivery_condition')),
                                    defaultSpacing(),
                                    _buildOrderDescriptionDetail(context, 2,
                                        tr('order_reason_discription')),
                                    defaultSpacing(),
                                  ],
                                ),
                              ),
                              defaultSpacing(height: AppSize.appBarHeight * 1.5)
                            ],
                          ),
                        ),
                        _buildSubmmitButton(context),
                        _buildLoadingWidget(context)
                      ],
                    );
                  }
                  return DefaultShimmer.buildDefaultPageShimmer(5,
                      isWithSet: true, setLenght: 10);
                }));
      },
    );
  }
}
