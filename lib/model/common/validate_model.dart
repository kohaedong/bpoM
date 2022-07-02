/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/model/common/validate_model.dart
 * Created Date: 2021-11-23 04:29:08
 * Last Modified: 2022-07-02 14:06:04
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:medsalesportal/enums/validate_type.dart';

class ValidateModel {
  dynamic data;
  List<ValidateType> type;
  int? length;
  ValidateModel(this.data, this.type, {this.length});
}
