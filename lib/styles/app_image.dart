import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medsalesportal/enums/image_type.dart';

/// [ImageType] 에 지정된 SVG 이미지 파일을 [SvgPicture]로 보여주기.
class AppImage {
  static getImage(ImageType imageType, {Color? color}) => SvgPicture.asset(
        imageType.path,
        color: color,
      );
}
