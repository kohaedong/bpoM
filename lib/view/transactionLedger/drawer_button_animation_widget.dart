/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/transactionLedger/drawer_button_animation_widget.dart
 * Created Date: 2022-07-16 13:32:45
 * Last Modified: 2022-07-17 18:22:51
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

typedef AnimationCallBack = bool Function();

//  가로세로모드가 지원되는 page에서 animationController을 과다 사용시 성능적 우려되 각각 분리하였음.
class DrawerButtonAnimationWidget extends StatefulWidget {
  const DrawerButtonAnimationWidget({Key? key, this.body, this.animationSwich})
      : super(key: key);
  final Widget? body;
  final AnimationCallBack? animationSwich;
  @override
  State<DrawerButtonAnimationWidget> createState() =>
      _DrawerButtonAnimationWidgetState();
}

class _DrawerButtonAnimationWidgetState
    extends State<DrawerButtonAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted &&
        widget.animationSwich != null &&
        widget.animationSwich!.call()) {
      pr('forward2');
      _animationController.forward();
    } else if (mounted &&
        widget.animationSwich != null &&
        !widget.animationSwich!.call()) {
      pr('reverse2');
      _animationController.reverse();
    }
    _animationController.status == AnimationStatus.completed
        ? _animationController.reverse()
        : _animationController.status == AnimationStatus.dismissed
            ? _animationController.forward()
            : DoNothingAction();
    return Positioned(
      bottom: AppSize.padding / 4,
      right: AppSize.bottomSheetWidth + AppSize.padding / 1.5,
      child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            return Transform.translate(
                offset: Offset(
                    AppSize.bottomSheetWidth * _animationController.value, 0),
                child: widget.body);
          }),
    );
  }
}
