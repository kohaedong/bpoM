/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/service/hive_service.dart
 * Created Date: 2021-08-17 13:17:07
 * Last Modified: 2022-07-11 13:28:02
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:hive_flutter/hive_flutter.dart';
import 'package:medsalesportal/enums/common_code_return_type.dart';
import 'package:medsalesportal/enums/hive_box_type.dart';
import 'package:medsalesportal/model/commonCode/t_code_model.dart';
import 'package:medsalesportal/model/commonCode/t_values_model.dart';
import 'package:medsalesportal/model/commonCode/et_dd07v_customer_category_model.dart';
import 'package:medsalesportal/util/hive_select_data_util.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

typedef SearchEtDd07vCustomerConditional = bool Function(TCustomerCustomsModel);

class HiveService {
  factory HiveService() => _sharedInstance();
  static HiveService? _instance;
  HiveService._();
  static HiveService _sharedInstance() {
    if (_instance == null) {
      _instance = HiveService._();
    }
    return _instance!;
  }

  static HiveBoxType? cureenBoxType;
  static init(HiveBoxType boxType) {
    cureenBoxType = boxType;
  }

// * HiveBoxType 에 맞는 DB를 open 하기.
//* Hive특성 :
//* - 1개 이상 box를 open 할수 없다.
//* - 다른 box를 open 하기전에 현재 사용중인 box를 close 해야한다.
//* - box open 시 반드시 box Type을 지정해줘야한다.

  static Future<Box> getBox() async {
    switch (cureenBoxType!) {
      case HiveBoxType.T_CODE:
        return await Hive.boxExists(cureenBoxType!.boxName)
            ? Hive.isBoxOpen(cureenBoxType!.boxName)
                ? Hive.box<TCodeModel>(cureenBoxType!.boxName)
                : await Hive.openBox<TCodeModel>(cureenBoxType!.boxName)
            : await Hive.openBox<TCodeModel>(cureenBoxType!.boxName);
      case HiveBoxType.T_VALUE:
        return await Hive.boxExists(cureenBoxType!.boxName)
            ? Hive.isBoxOpen(cureenBoxType!.boxName)
                ? Hive.box<TValuesModel>(cureenBoxType!.boxName)
                : await Hive.openBox<TValuesModel>(cureenBoxType!.boxName)
            : await Hive.openBox<TValuesModel>(cureenBoxType!.boxName);
      case HiveBoxType.T_VALUE_COUNTRY:
        return await Hive.boxExists(cureenBoxType!.boxName)
            ? Hive.isBoxOpen(cureenBoxType!.boxName)
                ? Hive.box<TValuesModel>(cureenBoxType!.boxName)
                : await Hive.openBox<TValuesModel>(cureenBoxType!.boxName)
            : await Hive.openBox<TValuesModel>(cureenBoxType!.boxName);
      case HiveBoxType.ET_CUSTOMER_CATEGORY:
        return await Hive.boxExists(cureenBoxType!.boxName)
            ? Hive.isBoxOpen(cureenBoxType!.boxName)
                ? Hive.box<TCustomerCustomsModel>(cureenBoxType!.boxName)
                : await Hive.openBox<TCustomerCustomsModel>(
                    cureenBoxType!.boxName)
            : await Hive.openBox<TCustomerCustomsModel>(cureenBoxType!.boxName);
      case HiveBoxType.ET_CUSTOMER_CUSTOMS_INFO:
        return await Hive.boxExists(cureenBoxType!.boxName)
            ? Hive.isBoxOpen(cureenBoxType!.boxName)
                ? Hive.box<TValuesModel>(cureenBoxType!.boxName)
                : await Hive.openBox<TValuesModel>(cureenBoxType!.boxName)
            : await Hive.openBox<TValuesModel>(cureenBoxType!.boxName);
    }
  }

  static Future<void> save(dynamic data) async {
    switch (cureenBoxType) {
      case HiveBoxType.T_CODE:
        await getBox().then((box) {
          box as Box<TCodeModel>;
          data as List<TCodeModel>;
          box.addAll(data);
        });
        break;
      case HiveBoxType.T_VALUE:
        await getBox().then((box) {
          box as Box<TValuesModel>;
          data as List<TValuesModel>;
          box.addAll(data);
        });
        break;
      case HiveBoxType.T_VALUE_COUNTRY:
        await getBox().then((box) {
          box as Box<TValuesModel>;
          data as List<TValuesModel>;
          box.addAll(data);
        });
        break;
      case HiveBoxType.ET_CUSTOMER_CATEGORY:
        await getBox().then((box) {
          box as Box<TCustomerCustomsModel>;
          data as List<TCustomerCustomsModel>;
          box.addAll(data);
        });
        break;
      case HiveBoxType.ET_CUSTOMER_CUSTOMS_INFO:
        await getBox().then((box) {
          box as Box<TValuesModel>;
          data as List<TValuesModel>;
          box.addAll(data);
        });
        break;

      default:
    }
  }

  static Future<List<dynamic>?> getData(
      {SearchTcodeConditional? searchTcodeConditional,
      SearchTvalueConditional? searchTvalueConditional,
      SearchEtDd07vCustomerConditional?
          searchEtDd07vCustomerConditional}) async {
    if (!Hive.isBoxOpen(cureenBoxType!.boxName)) return null;

    if (cureenBoxType == HiveBoxType.T_CODE) {
      return Hive.box<TCodeModel>(cureenBoxType!.boxName)
          .values
          .where((tCode) => searchTcodeConditional!.call(tCode))
          .toList();
    }
    if (cureenBoxType == HiveBoxType.T_VALUE ||
        cureenBoxType == HiveBoxType.T_VALUE_COUNTRY ||
        cureenBoxType == HiveBoxType.ET_CUSTOMER_CUSTOMS_INFO) {
      return Hive.box<TValuesModel>(cureenBoxType!.boxName)
          .values
          .where((tValue) => searchTvalueConditional!.call(tValue))
          .toList();
    }

    if (cureenBoxType == HiveBoxType.ET_CUSTOMER_CATEGORY) {
      return Hive.box<TCustomerCustomsModel>(cureenBoxType!.boxName)
          .values
          .where((etCustomer) =>
              searchEtDd07vCustomerConditional!.call(etCustomer))
          .toList();
    }
    return null;
  }

  static Future<void> closeBox() async {
    if (Hive.isBoxOpen(cureenBoxType!.boxName))
      await Hive.box(cureenBoxType!.boxName).close();
  }

  static Future<void> deleteBox() async {
    if (await Hive.boxExists(cureenBoxType!.boxName)) {
      await Hive.deleteBoxFromDisk(cureenBoxType!.boxName);
    }
  }

  static Future<void> clearBox() async {
    if (Hive.isBoxOpen(cureenBoxType!.boxName))
      await Hive.box(cureenBoxType!.boxName).clear();
  }

  static Future<String> getDataFromTCodeByKeyCode(
    String code,
    String cdgrp,
  ) async {
    final result = await HiveSelectDataUtil.select(HiveBoxType.T_CODE,
        tcodeConditional: (tcode) {
          return tcode.cdgrp == '$cdgrp' &&
              tcode.cdnam != null &&
              tcode.cditm == '$code';
        },
        tcodeResultCondition: (tcode) => tcode.cdnam!);
    return result.strList != null && result.strList!.isNotEmpty
        ? result.strList![0]
        : '';
  }

  static Future<String> getSingleDataBySearchKey(
    String codeOrValue,
    String tname, {
    int? searchLevel,
    CommonCodeReturnType? returnType,
    bool? isMatchGroup1KeyList,
    bool? isMatchGroup2KeyList,
    bool? isMatchGroup3KeyList,
    bool? isMatchGroup4KeyList,
    String? group0SearchKey,
    String? group1SearchKey,
    String? group2SearchKey,
    String? group3SearchKey,
    String? group4SearchKey,
  }) async {
    final result = await HiveSelectDataUtil.select(
      HiveBoxType.T_VALUE,
      returnType: returnType,
      searchLevel: searchLevel ?? 0,
      group0SearchKey: group0SearchKey,
      group1SearchKey: group1SearchKey,
      group2SearchKey: group2SearchKey,
      group3SearchKey: group3SearchKey,
      group4SearchKey: group4SearchKey,
      isMatchGroup1KeyList: isMatchGroup1KeyList,
      isMatchGroup2KeyList: isMatchGroup2KeyList,
      isMatchGroup3KeyList: isMatchGroup3KeyList,
      isMatchGroup4KeyList: isMatchGroup4KeyList,
      tvalueConditional: (tValue) {
        return tValue.tname == '$tname' &&
            tValue.helpValues!.contains('$codeOrValue');
      },
    );
    return result.strList![0];
  }

  static Future<List<String>?> getDataFromTValue(
      {String? group0SearchKey,
      String? group1SearchKey,
      String? group2SearchKey,
      String? group3SearchKey,
      String? group4SearchKey,
      int? searchLevel,
      String? tname}) async {
    final resultList = await HiveSelectDataUtil.select(
      HiveBoxType.T_VALUE,
      tvalueConditional: (tValue) {
        return tValue.tname == '$tname' && tValue.helpValues!.isNotEmpty;
      },
      searchLevel: searchLevel,
      group0SearchKey: group0SearchKey,
      group1SearchKey: group1SearchKey,
      group2SearchKey: group2SearchKey,
      group3SearchKey: group3SearchKey,
      group4SearchKey: group4SearchKey,
    );

    return resultList.strList;
  }

  static Future<bool> isNeedDownLoad() async {
    await HiveService.init(HiveBoxType.T_CODE);
    await HiveService.getBox();
    var dateTime = await HiveService.getBox().then((box) {
      if (box.isNotEmpty) {
        var temp = box.values.first as TCodeModel;
        return temp.timestamp;
      } else {
        return null;
      }
    });
    return dateTime == null || DateTime.now().difference(dateTime).inDays > 1
        ? true
        : false;
  }

  static Future<List<String>?> getDataFromTCode(String cdgrp,
      {String? cditm,
      String? cdnam,
      String? cdcls,
      bool? isMatchCditm,
      bool? isWithCode}) async {
    final resultList = await HiveSelectDataUtil.select(HiveBoxType.T_CODE,
        tcodeConditional: (tcode) {
          if (cdnam != null) {
            return tcode.cdgrp == cdgrp && tcode.cdnam == cdnam;
          }
          if (cditm != null && cdcls == null) {
            return tcode.cdgrp == cdgrp && tcode.cditm == cditm;
          }
          if (cditm != null && cdcls != null) {
            return tcode.cdgrp == cdgrp &&
                tcode.cdcls == cdcls &&
                tcode.cditm == cditm;
          }
          return tcode.cdgrp == cdgrp && tcode.cditm != '';
        },
        tcodeResultCondition: (tcode) => isMatchCditm != null
            ? tcode.cditm!
            : isWithCode != null
                ? '${tcode.cdnam!}-${tcode.cditm}'
                : '${tcode.cdnam!}');
    return resultList.strList;
  }

// 고객사 운영상태.
  static Future<List<String>?> getProcessingStatus() async {
    return getDataFromTCode('SHIP_STAT', cdcls: 'LTS', isWithCode: true);
  }

// 제품군
  static Future<List<String>?> getProductFamily() async {
    var a = await getDataFromTCode('KPC_SPART', cdcls: 'LTS', isWithCode: true);
    pr(a);
    return a;
  }

//제품유형
  static Future<List<String>?> getProductType() async {
    return await getDataFromTCode('KPC_SPART', cditm: '');
  }

// 사업
  static Future<List<String>?> getBusinessCategory() async {
    var a = await getDataFromTCode('KPC_BIZ', cdcls: 'LTS', isWithCode: true);
    pr(a);
    return a;
  }

// 영업그룹
  static Future<List<String>?> getBusinessGroup() async {
    return await getDataFromTCode('VKGRP', cdcls: 'LTS', cditm: '');
  }

// 처리상태
  static Future<List<String>?> getCustomerType(String cditm) async {
    return await getDataFromTCode('CUST_STAT', cditm: cditm);
  }
}
