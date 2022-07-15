/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/widget_of_animation_components.dart
 * Created Date: 2022-07-14 21:54:05
 * Last Modified: 2022-07-15 14:38:29
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:flutter/widgets.dart';
import 'package:medsalesportal/styles/export_common.dart';

typedef AnimationCallBack = bool Function();

class WidgetOfOffSetAnimationWidget extends StatefulWidget {
  const WidgetOfOffSetAnimationWidget(
      {Key? key, this.body, this.height, this.animationCallBack})
      : super(key: key);
  final Widget? body;
  final double? height;
  final AnimationCallBack? animationCallBack;
  @override
  State<WidgetOfOffSetAnimationWidget> createState() =>
      _WidgetOfOffSetAnimationWidgetState();
}

class _WidgetOfOffSetAnimationWidgetState
    extends State<WidgetOfOffSetAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  double? startPoint;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted && widget.animationCallBack!.call()) {
      animationController.forward();
    } else if (mounted && !widget.animationCallBack!.call()) {
      animationController.reverse();
    }
    return Positioned(
        bottom: 0,
        child: AnimatedBuilder(
            animation: animationController,
            builder: (context, _) {
              return Transform.translate(
                  offset: Offset(
                      0, (AppSize.realHeight * .4 * animationController.value)),
                  child: Container(
                      height: widget.height,
                      decoration: animationController.status ==
                              AnimationStatus.completed
                          ? BoxDecoration(
                              boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textGrey.withOpacity(0.5),
                                    blurRadius: AppSize.radius5,
                                    offset: Offset(0, -3),
                                  ),
                                ],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(AppSize.radius15),
                                bottomRight: Radius.circular(AppSize.radius15),
                              ),
                              color: AppColors.whiteText)
                          : BoxDecoration(
                              boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textGrey.withOpacity(0.5),
                                    blurRadius: AppSize.radius5,
                                    offset: Offset(0, -3),
                                  ),
                                ],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(AppSize.radius15),
                                bottomRight: Radius.circular(AppSize.radius15),
                              ),
                              color: AppColors.whiteText),
                      alignment: Alignment.bottomCenter,
                      width: AppSize.realWidth,
                      child: widget.body));
            }));
  }
}
