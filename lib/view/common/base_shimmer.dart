/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_shimmer.dart
 * Created Date: 2021-09-18 18:29:48
 * Last Modified: 2022-10-18 04:19:30
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:bpom/styles/app_colors.dart';

class BaseShimmer extends StatefulWidget {
  BaseShimmer({Key? key, this.child}) : super(key: key);
  final Widget? child;
  static shimmerBox(double height, double width) {
    return Container(
      width: width,
      height: height,
      color: AppColors.whiteText,
    );
  }

  @override
  _BaseShimmerState createState() => _BaseShimmerState();
}

class _BaseShimmerState extends State<BaseShimmer> {
  Timer? timer;
  var shimmerSwich = ValueNotifier(true);
  @override
  void initState() {
    super.initState();
    timer = Timer(Duration(seconds: 5), () {
      shimmerSwich.value = false;
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    shimmerSwich.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: shimmerSwich,
        builder: (context, swich, _) {
          return Shimmer.fromColors(
              enabled: swich,
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: widget.child!);
        });
  }
}
