/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/bpom/lib/view/common/fountion_of_hidden_key_borad.dart
 * Created Date: 2022-07-06 10:50:08
 * Last Modified: 2022-07-06 10:52:01
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';

Future<void> hideKeyboard(BuildContext context) async {
  var currentFocus = FocusScope.of(context);
  currentFocus.unfocus();
}
