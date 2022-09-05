/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/add_order_popup_widget.dart
 * Created Date: 2022-09-04 17:55:15
 * Last Modified: 2022-09-05 09:35:52
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/order_item_type.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/dialog_contents.dart';
import 'package:medsalesportal/view/orderManager/provider/add_order_popup_provider.dart';

class AddOrderPopupWidget extends StatefulWidget {
  const AddOrderPopupWidget({Key? key, required this.type}) : super(key: key);
  final OrderItemType type;
  @override
  State<AddOrderPopupWidget> createState() => _AddOrderPopupWidgetState();
}

class _AddOrderPopupWidgetState extends State<AddOrderPopupWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddOrderPopupProvider(),
      builder: (context, _) {
        return Selector<AddOrderPopupProvider, double>(
          selector: (context, provider) => provider.height,
          builder: (context, height, _) {
            return buildDialogContents(
                context,
                Container(
                  alignment: Alignment.center,
                  height: height - AppSize.buttonHeight * 2,
                  child: SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        final p = context.read<AddOrderPopupProvider>();
                        var temp = 10.0;
                        p.setHeight(height - AppSize.buttonHeight - temp);
                      },
                      child:
                          AppText.text(tr('ok'), textAlign: TextAlign.center),
                    ),
                  ),
                ),
                false,
                height,
                iswithTitle: true,
                titleText: tr('add_order'),
                rightButtonText: tr('add'));
          },
        );
      },
    );
  }
}
