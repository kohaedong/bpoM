// /*
//  * Project Name:  [mKolon3.0] - SalesPortal
//  * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_commbo_box_widget.dart
//  * Created Date: 2021-09-12 18:12:41
//  * Last Modified: 2022-10-18 13:49:41
//  * Author: bakbeom
//  * Modified By: bakbeom
//  * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
//  * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
//  * 												Discription													
//  * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
//  */

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:bpom/enums/input_icon_type.dart';
// import 'package:bpom/styles/app_colors.dart';
// import 'package:bpom/styles/app_size.dart';
// import 'package:bpom/styles/app_style.dart';
// import 'package:bpom/styles/app_text_style.dart';

// typedef SelectCallback = Function(int);

// class BaseCommboBoxWidget {
//   final BuildContext context;
//   final double? height;
//   final double width;
//   final InputIconType iconType;
//   final SelectCallback callback;
//   final List<String> data;
//   final int index;
//   BaseCommboBoxWidget(this.context, this.width, this.iconType, this.callback,
//       this.data, this.index,
//       {this.height});
//   build() {
//     return Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(AppSize.radius5),
//             border: Border.all(color: AppColors.textFieldUnfoucsColor)),
//         alignment: Alignment.center,
//         height: height ?? AppSize.defaultTextFieldHeight,
//         width: width,
//         child: Padding(
//             padding: AppSize.defaultSidePadding,
//             child: DropdownButton<String>(
//               isDense: true,
//               isExpanded: true,
//               hint: AppStyles.text('${tr('plz_select')}', AppTextStyle.hint_16),
//               underline: SizedBox(),
//               icon: iconType.icon(),
//               iconSize: AppSize.iconSmallDefaultWidth,
//               value: data[index],
//               items: data
//                   .asMap()
//                   .entries
//                   .map((value) => DropdownMenuItem<String>(
//                       value: value.value,
//                       child: value.key == 0
//                           ? AppStyles.text(value.value, AppTextStyle.hint_16)
//                           : AppStyles.text(
//                               value.value, AppTextStyle.default_16)))
//                   .toList(),

//               // data.map((String value) {
//               //   return DropdownMenuItem<String>(
//               //       value: value,
//               //       child: isSelected
//               //           ? AppStyles.text(value, AppTextStyle.default_16)
//               //           : AppStyles.text(value, AppTextStyle.hint_16));
//               // }).toList(),
//               onChanged: (str) async {
//                 callback.call(data.indexOf(str!));
//               },
//             )));
//   }
// }
