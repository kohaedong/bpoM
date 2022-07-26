/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/bulkOrderSearch/oder_item_input_widget.dart
 * Created Date: 2022-07-26 17:04:40
 * Last Modified: 2022-07-26 18:22:18
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/view/common/base_input_widget.dart';

class OrderItemInputWidget extends StatefulWidget {
  const OrderItemInputWidget(
      {Key? key,
      this.onSubmittedCallBack,
      this.defaultValue,
      this.showLoading,
      this.stopLoading})
      : super(key: key);
  final OnSubmittedCallBack? onSubmittedCallBack;
  final Function? showLoading;
  final Function? stopLoading;
  final String? defaultValue;
  @override
  State<OrderItemInputWidget> createState() => _OrderItemInputWidgetState();
}

class _OrderItemInputWidgetState extends State<OrderItemInputWidget> {
  late TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController();
    textEditingController.text = widget.defaultValue!;
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            widget.showLoading?.call();
            Future.delayed(Duration.zero, () async {
              await widget.onSubmittedCallBack
                  ?.call(textEditingController.text);
            }).whenComplete(() => widget.stopLoading?.call());
          }
        },
        child: BaseInputWidget(
            context: context,
            width: AppSize.defaultContentsWidth * .7,
            textEditingController: textEditingController,
            onSubmittedCallBack: widget.onSubmittedCallBack,
            enable: true));
  }
}
