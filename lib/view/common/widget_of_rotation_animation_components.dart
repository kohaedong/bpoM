/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/widget_of_rotation_animation_components.dart
 * Created Date: 2022-07-14 23:02:16
 * Last Modified: 2022-07-15 14:34:52
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:medsalesportal/enums/image_type.dart';
import 'package:medsalesportal/styles/export_common.dart';

typedef AnimationCallBack = bool Function();

class WidgetOfRotationAnimationComponents extends StatefulWidget {
  const WidgetOfRotationAnimationComponents({Key? key, this.animationCallBack})
      : super(key: key);
  final AnimationCallBack? animationCallBack;
  @override
  State<WidgetOfRotationAnimationComponents> createState() =>
      _WidgetOfRotationAnimationComponentsState();
}

class _WidgetOfRotationAnimationComponentsState
    extends State<WidgetOfRotationAnimationComponents>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isStartTrain = false;
  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted && widget.animationCallBack!.call()) {
      _animationController.forward();
    } else if (mounted && !widget.animationCallBack!.call()) {
      _animationController.reverse();
    }
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Transform.rotate(
              angle: math.pi * _animationController.value,
              child: Container(
                height: AppSize.defaultIconWidth,
                width: AppSize.defaultIconWidth,
                child: AppImage.getImage(ImageType.SELECT,
                    color: AppColors.subText),
              ));
        });
  }
}
