/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/common/widget_of_animation_components.dart
 * Created Date: 2022-07-14 21:54:05
 * Last Modified: 2022-07-16 12:38:11
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:flutter/widgets.dart';
import 'package:medsalesportal/enums/offset_direction_type.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

typedef AnimationCallBack = bool Function();

//        [OffsetDirectionType] 설명.
//                            |
//                       y   ++ (UP == (x=0,y++))
//                            |
//                            |
// --x ++( LEFT== x++,y=0) -------- x--  (RIGHT == (x--, y=0))----------
//                            |
//                            |
//                   y  --  (DOWN == (x=0, y--))
//                            |
//
// 애니메이션  =  이동하려는 방향의 축의 값 * animationController.value
class WidgetOfOffSetAnimationWidget2 extends StatefulWidget {
  const WidgetOfOffSetAnimationWidget2(
      {Key? key,
      this.body,
      this.height,
      this.animationSwich,
      this.offset,
      this.width,
      this.offsetType})
      : super(key: key);
  final Widget? body;
  final Offset? offset;
  final double? width;
  final double? height;
  final AnimationCallBack?
      animationSwich; // true = animationController.forward()   false = animationController.reverse()
  final OffsetDirectionType? offsetType;
  @override
  State<WidgetOfOffSetAnimationWidget2> createState() =>
      _WidgetOfOffSetAnimationWidgetState();
}

class _WidgetOfOffSetAnimationWidgetState
    extends State<WidgetOfOffSetAnimationWidget2>
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
    if (mounted &&
        widget.animationSwich != null &&
        widget.animationSwich!.call()) {
      pr('forward2');
      animationController.forward();
    } else if (mounted &&
        widget.animationSwich != null &&
        !widget.animationSwich!.call()) {
      // log가 2번 찍히는 것은 animation 이 SetState() 를 작동 하였기 때문입니다.
      pr('reverse2');
      animationController.reverse();
    }
    return Positioned(
        bottom: widget.offsetType == OffsetDirectionType.UP ||
                widget.offsetType == OffsetDirectionType.DOWN
            ? 0
            : null,
        right: widget.offsetType == OffsetDirectionType.LEFT ||
                widget.offsetType == OffsetDirectionType.RIGHT
            ? 0
            : null,
        child: AnimatedBuilder(
            animation: animationController,
            builder: (context, _) {
              return Transform.translate(
                  offset: widget.offsetType == OffsetDirectionType.UP
                      ? Offset(widget.offset!.dx,
                          widget.offset!.dy * animationController.value)
                      : widget.offsetType == OffsetDirectionType.DOWN
                          ? Offset(widget.offset!.dx,
                              -(widget.offset!.dy) * animationController.value)
                          : widget.offsetType == OffsetDirectionType.LEFT
                              ? Offset(widget.offset!.dx,
                                  widget.offset!.dy * animationController.value)
                              : Offset(
                                  -(widget.offset!.dx) *
                                      animationController.value,
                                  widget.offset!.dy),
                  child: Container(
                      height: widget.height,
                      width: widget.width ?? AppSize.realWidth,
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
                      child: widget.body));
            }));
  }
}
