/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/util/is_super_account.dart
 * Created Date: 2022-07-19 10:51:06
 * Last Modified: 2022-07-19 15:14:17
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:bpom/enums/account_type.dart';
import 'package:bpom/service/cache_service.dart';

class CheckSuperAccount {
  static bool isMultiAccountOrLeaderAccount() {
    return CacheService.getAccountType() == AccountType.MULTI ||
        CacheService.getAccountType() == AccountType.LEADER;
  }

  static bool isMultiAccount() {
    return CacheService.getAccountType() == AccountType.MULTI;
  }

  static bool isLeaderAccount() {
    return CacheService.getAccountType() == AccountType.LEADER;
  }
}
