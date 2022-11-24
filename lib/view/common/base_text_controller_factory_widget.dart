/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/view/orderManager/text_controller_factory.dart
 * Created Date: 2022-09-06 18:26:48
 * Last Modified: 2022-11-11 20:45:37
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';

typedef GiveTextEditControllerWidget = Widget Function(
    TextEditingController, FocusNode);

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
  late FocusNode focusNode;
  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.giveTextEditControllerWidget!(
        textEditingController, focusNode);
  }
}
