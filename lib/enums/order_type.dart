/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/enums/order_type.dart
 * Created Date: 2021-11-26 13:04:02
 * Last Modified: 2022-01-28 10:09:38
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
// 오더유형 하드코딩용.
//* RANDOM은 빈값 구분 하기 위해 추가 됨.
enum OrderType { ZOR1, ZFD1, ZFD2, RANDOM }

// 오더유형 코드.
extension OrderTypeExtension on OrderType {
  String get code {
    switch (this) {
      case OrderType.ZOR1:
        return 'ZOR1';
      case OrderType.ZFD1:
        return 'ZFD1';
      case OrderType.ZFD2:
        return 'ZFD2';
      case OrderType.RANDOM:
        return '';
    }
  }

  String get name {
    switch (this) {
      case OrderType.ZOR1:
        return '표준 오더';
      case OrderType.ZFD1:
        return '유상 Sample';
      case OrderType.ZFD2:
        return '무상';
      case OrderType.RANDOM:
        return '';
    }
  }

  String? getName(String code) {
    var temp = <OrderType>[OrderType.ZOR1, OrderType.ZFD1, OrderType.ZFD2];
    temp.forEach((orderType) {
      if (orderType.code == code) {
        temp = [orderType];
        return;
      }
    });
    return temp.length > 1 ? null : temp.single.name;
  }
}
