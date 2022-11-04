/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/orderManager/text_controller_factory.dart
 * Created Date: 2022-09-06 18:26:48
 * Last Modified: 2022-11-03 12:23:47
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';

typedef GiveTextEditControllerWidget = Widget Function(TextEditingController);

class BaseTextControllerFactoryWidget extends StatefulWidget {
  const BaseTextControllerFactoryWidget(
      {required this.giveTextEditControllerWidget, Key? key})
      : super(key: key);
  final GiveTextEditControllerWidget? giveTextEditControllerWidget;

  @override
  State<BaseTextControllerFactoryWidget> createState() =>
      _BaseTextControllerFactoryWidgetState();
}

class _BaseTextControllerFactoryWidgetState
    extends State<BaseTextControllerFactoryWidget> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.giveTextEditControllerWidget!(textEditingController);
  }
}