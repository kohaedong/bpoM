/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/provider/base_popup_search_provider.dart
 * Created Date: 2021-09-11 17:15:06
 * Last Modified: 2022-07-06 11:08:17
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/hive_box_type.dart';
import 'package:medsalesportal/enums/popup_list_type.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/util/hive_select_data_util.dart';

class BasePopupSearchProvider extends ChangeNotifier {
  bool isLoadData = false;
  String? selectedOneRowValue1;
  String? selectedOneRowValue2;
  String? selectedThreeRowValue1;
  String? selectedThreeRowValue2;
  String? selectedThreeRowValue3;
  String? selectedThreeRowValue4;
  String? selectedOneRowValue1DefaultValue;
  // EtStaffListResponseModel? staList;
  // SearchMaterialResponseModel? materiaModel;
  // SalesorderDefaultPersonResponseModel? defaultPersonResponseModel;
  // List<PlantResultModel>? plantList;
  OneCellType? type;
  Map<String, dynamic>? bodyMap;

//--------------- plant Code----------
  String? selectedOrganizationCode;
  String? seletedCirculationCode;

  bool get isOneRowValue1Selected => selectedOneRowValue1 != null;
  bool get isOneRowValue2Selected => selectedOneRowValue2 != null;
  bool get isThreeRowValue1Selected => selectedThreeRowValue1 != null;
  bool get isThreeRowValue2Selected => selectedThreeRowValue2 != null;
  bool get isThreeRowValue3Selected => selectedThreeRowValue3 != null;
  bool get isThreeRowValue4Selected => selectedThreeRowValue4 != null;

//------ pageing ----------
  int pos = 0;
  int partial = 30;
  bool hasMore = true;
  Future<void> refresh() async {
    pos = 0;
    // materiaModel = null;
    // staList = null;
    onSearch(type!, true);
  }

  Future<bool?> nextPage() async {
    if (hasMore) {
      pos = partial + pos;
      return onSearch(type!, false).then((result) => result.isSuccessful);
    }
    return null;
  }

  void setDefaultOrganization({Map<String, dynamic>? bodyMaps}) async {
    if (this.bodyMap == null) {
      this.bodyMap = bodyMaps;
    }
    if (bodyMap != null) {
      if (bodyMap!['IV_VKORG'] != null &&
          bodyMap!['IV_VKORG'].toString().trim() != '') {
        selectedOrganizationCode = bodyMap!['IV_VKORG'].toString().trim();
        await HiveService.getSingleDataBySearchKey(
                selectedOrganizationCode!, 'H_TVKO',
                searchLevel: 1, group1SearchKey: selectedOrganizationCode!)
            .then((result) => selectedThreeRowValue1 = result);
      }
      if (bodyMap!['IV_VTWEG'] != null) {
        seletedCirculationCode = bodyMap!['IV_VTWEG'];
        await HiveService.getDataFromTValue(
                group1SearchKey: selectedOrganizationCode!,
                group2SearchKey: seletedCirculationCode,
                searchLevel: 2,
                tname: 'H_TVKOV')
            .then((list) => selectedThreeRowValue2 = list!.single);
      } else {
        // default
        seletedCirculationCode = '10';
        selectedThreeRowValue2 = '내수';
      }
    }
    notifyListeners();
  }

  setOneRowValue1(String value) {
    this.selectedOneRowValue1 = value;
    notifyListeners();
  }

  setOneRowValue2(String? value) {
    this.selectedOneRowValue2 = value;
    if (value == null || (value.length == 1) || value == '') {
      notifyListeners();
    }
  }

  setThreeRowValue1(String value) async {
    this.selectedThreeRowValue1 = value;
    this.selectedThreeRowValue2 = null;
    this.selectedThreeRowValue4 = null;
    selectedOrganizationCode = await HiveService.getSingleDataBySearchKey(
        selectedThreeRowValue1!, 'H_TVKO',
        searchLevel: 1,
        group1SearchKey: selectedThreeRowValue1,
        isMatchGroup1KeyList: true);
    // notifyListeners();
  }

  setThreeRowValue2(String value) async {
    this.selectedThreeRowValue2 = value;
    seletedCirculationCode = await HiveService.getSingleDataBySearchKey(
      selectedThreeRowValue2!,
      'H_TVKOV',
      searchLevel: 2,
      group1SearchKey: selectedOrganizationCode,
      group2SearchKey: selectedThreeRowValue2,
      isMatchGroup2KeyList: true,
    );
    notifyListeners();
  }

  setThreeRowValue3(String? value) {
    this.selectedThreeRowValue3 = value;
    notifyListeners();
  }

  setThreeRowValue4(String? value) {
    if (value == null) {}
    this.selectedThreeRowValue4 = value;
    notifyListeners();
  }

  Future<List<String>?> getOrganizationFromDB() async {
    final resultList = await HiveSelectDataUtil.select(
      HiveBoxType.T_VALUE,
      searchLevel: 0,
      tvalueConditional: (tValue) {
        return tValue.tname == 'H_TVKO';
      },
    );
    return resultList.strList;
  }

  Future<List<String>?> getCirculationFromDB() async {
    final resultList = await HiveSelectDataUtil.select(HiveBoxType.T_VALUE,
        tvalueConditional: (tValue) {
      return tValue.tname == 'H_TVKOV' && tValue.helpValues!.isNotEmpty;
    }, searchLevel: 2, group1SearchKey: selectedOrganizationCode);

    return resultList.strList;
  }

  Future<BasePoupSearchResult> searchPersonForSalesOrder(
      {required Map<String, dynamic> bodyMaps}) async {
    var _api = ApiService();
    final isLogin = CacheService.getIsLogin();
    // _api.init(RequestType.DEFAULT_VALUE_FOR_PERSON);
    // Map<String, dynamic> body = {
    //   "methodName": RequestType.SEARCH_STAFF.serverMethod,
    //   "methodParamMap": {
    //     ...bodyMaps,
    //     "IS_LOGIN": isLogin,
    //     "resultTables": RequestType.DEFAULT_VALUE_FOR_PERSON.resultTable,
    //     "functionName": RequestType.DEFAULT_VALUE_FOR_PERSON.serverMethod,
    //   }
    // };
    // body.addAll(bodyMaps);
    // final result = await _api.request(body: body);
    // if (result == null || result.statusCode != 200) {
    //   return BasePoupSearchResult(false,
    //       message: result != null ? result.message : null);
    // }
    // if (result.statusCode == 200 && result.body['data'] != null) {
    //   defaultPersonResponseModel =
    //       SalesorderDefaultPersonResponseModel.fromJson(result.body['data']);
    //   if (defaultPersonResponseModel!.esReturn!.mtype == 'S') {
    //     return BasePoupSearchResult(true,
    //         defaultPersonResponseModel: defaultPersonResponseModel);
    //   }
    // }
    // return BasePoupSearchResult(false, message: result.errorMessage);
    return BasePoupSearchResult(false);
  }

  Future<BasePoupSearchResult> searchPerson(bool isMounted) async {
    // isLoadData = true;
    // if (isMounted) {
    //   notifyListeners();
    // }
    // var _api = ApiService();
    // final isLogin = CacheService.getIsLogin();
    // Map<String, dynamic>? body;
    // if (bodyMap != null) {
    //   body = {
    //     "methodName": RequestType.SEARCH_STAFF.serverMethod,
    //     "methodParamMap": {
    //       ...bodyMap!,
    //       "IV_SALESM": "X",
    //       "IV_SNAME": selectedOneRowValue1 == '${tr('staff_name')}'
    //           ? selectedOneRowValue2 == null || selectedOneRowValue2 == ''
    //               ? ''
    //               : '*$selectedOneRowValue2*'
    //           : '',
    //       "IV_DPTNM": selectedOneRowValue1 == '${tr('department_name')}'
    //           ? selectedOneRowValue2 == null || selectedOneRowValue2 == ''
    //               ? ''
    //               : '*$selectedOneRowValue2*'
    //           : '',
    //       "IS_LOGIN": isLogin,
    //       "pos": "$pos",
    //       "partial": "$partial",
    //       "resultTables": RequestType.SEARCH_STAFF.resultTable,
    //       "functionName": RequestType.SEARCH_STAFF.serverMethod,
    //     }
    //   };
    // } else {
    //   body = {
    //     "methodName": RequestType.SEARCH_STAFF.serverMethod,
    //     "methodParamMap": {
    //       "IV_SALESM": "X",
    //       "IV_SNAME": selectedOneRowValue1 == '${tr('staff_name')}'
    //           ? selectedOneRowValue2 == null || selectedOneRowValue2 == ''
    //               ? ''
    //               : '*$selectedOneRowValue2*'
    //           : '',
    //       "IV_DPTNM": selectedOneRowValue1 == '${tr('department_name')}'
    //           ? selectedOneRowValue2 == null || selectedOneRowValue2 == ''
    //               ? ''
    //               : '*$selectedOneRowValue2*'
    //           : '',
    //       "pos": "$pos",
    //       "partial": "$partial",
    //       "IS_LOGIN": isLogin,
    //       "resultTables": RequestType.SEARCH_STAFF.resultTable,
    //       "functionName": RequestType.SEARCH_STAFF.serverMethod,
    //     }
    //   };
    // }
    // print(selectedOneRowValue1);
    // _api.init(RequestType.SEARCH_STAFF);
    // final result = await _api.request(body: body);
    // if (result == null || result.statusCode != 200) {
    //   isLoadData = false;
    //   staList = null;
    //   notifyListeners();
    //   return BasePoupSearchResult(false);
    // }
    // if (result.statusCode == 200 && result.body['data'] != null) {
    //   var temp = EtStaffListResponseModel.fromJson(result.body['data']);
    //   if (temp.staffList!.length != partial) {
    //     hasMore = false;
    //   }
    //   if (staList == null) {
    //     staList = temp;
    //   } else {
    //     staList!.staffList!.addAll(temp.staffList!);
    //   }
    //   if (staList != null && staList!.staffList == null) {
    //     staList = null;
    //   }

    //   isLoadData = false;
    //   notifyListeners();
    //   return BasePoupSearchResult(true);
    // }
    // isLoadData = false;
    return BasePoupSearchResult(false);
  }

  Future<BasePoupSearchResult> searchMaterial(bool isMounted) async {
    // isLoadData = true;
    // if (isMounted) {
    //   notifyListeners();
    // }
    // var _api = ApiService();
    // final isLogin = CacheService.getIsLogin();

    // Map<String, dynamic> body;
    // if (bodyMap != null) {
    //   body = {
    //     "methodName": RequestType.SEARCH_MATERIAL.serverMethod,
    //     "methodParamMap": {
    //       ...bodyMap!,
    //       "IV_MATNR":
    //           '${selectedOneRowValue1 != '${tr('materials_name')}' ? '${selectedOneRowValue2 != null ? '$selectedOneRowValue2' : ''}' : ''}', // 자재 번호
    //       "IV_MAKTX":
    //           '${selectedOneRowValue1 == '${tr('materials_name')}' ? '${selectedOneRowValue2 != null ? '$selectedOneRowValue2' : ''}' : ''}', //자재내역
    //       "IV_BISMT": '', //기존자재번호
    //       "pos": "$pos",
    //       "partial": "$partial",
    //       "IS_LOGIN": isLogin,
    //       "resultTables": RequestType.SEARCH_MATERIAL.resultTable,
    //       "functionName": RequestType.SEARCH_MATERIAL.serverMethod,
    //     }
    //   };
    // } else {
    //   body = {
    //     "methodName": RequestType.SEARCH_MATERIAL.serverMethod,
    //     "methodParamMap": {
    //       "IV_MATNR":
    //           '${selectedOneRowValue1 != '${tr('materials_name')}' ? '${selectedOneRowValue2 != null ? '$selectedOneRowValue2' : ''}' : ''}', // 자재 번호
    //       "IV_MAKTX":
    //           '${selectedOneRowValue1 == '${tr('materials_name')}' ? '${selectedOneRowValue2 != null ? '$selectedOneRowValue2' : ''}' : ''}', //자재내역
    //       "IV_BISMT": '',
    //       "IV_VKORG": '',
    //       "IV_VTWEG": '',
    //       "IV_WERKS": "",
    //       "IT_WERKS": "",
    //       "pos": "$pos",
    //       "partial": "$partial",
    //       "IS_LOGIN": isLogin,
    //       "resultTables": RequestType.SEARCH_MATERIAL.resultTable,
    //       "functionName": RequestType.SEARCH_MATERIAL.serverMethod,
    //     }
    //   };
    // }
    // _api.init(RequestType.SEARCH_MATERIAL);
    // final result = await _api.request(body: body);
    // if (result == null || result.statusCode != 200) {
    //   isLoadData = false;
    //   staList = null;
    //   notifyListeners();
    //   return BasePoupSearchResult(false);
    // }
    // if (result.statusCode == 200 && result.body['data'] != null) {
    //   var temp = SearchMaterialResponseModel.fromJson(result.body['data']);
    //   if (temp.materialList!.length != partial) {
    //     hasMore = false;
    //   }
    //   if (materiaModel == null) {
    //     materiaModel = temp;
    //   } else {
    //     materiaModel!.materialList!.addAll(temp.materialList!);
    //   }
    //   print(materiaModel!.toJson());
    //   if (materiaModel != null && materiaModel!.materialList == null) {
    //     materiaModel = null;
    //   }

    //   isLoadData = false;
    //   notifyListeners();
    //   return BasePoupSearchResult(true);
    // }
    // isLoadData = false;

    return BasePoupSearchResult(false);
  }

  Future<BasePoupSearchResult> onSearch(OneCellType type, bool isMounted,
      {Map<String, dynamic>? bodyMaps}) async {
    if (bodyMaps != null && bodyMaps != bodyMap) {
      this.bodyMap = bodyMaps;
    }
    this.type = type;

    switch (type) {
      case OneCellType.SEARCH_SALSE_PERSON:
        if (selectedOneRowValue1 == null)
          // set default value
          selectedOneRowValue1 = '${tr('staff_name')}';
        return await searchPerson(isMounted);
      case OneCellType.SEARCH_MATERIALS:
        if (selectedOneRowValue1 == null)
          // set default value
          selectedOneRowValue1 = '${tr('materials_name')}';
        return await searchMaterial(isMounted);
      // case OneCellType.SEARCH_PLANT_RESULT:
      //   return await searchPlant();
      default:
        return BasePoupSearchResult(false);
    }
  }
}

class BasePoupSearchResult {
  bool isSuccessful;
  String? message;
  // SalesorderDefaultPersonResponseModel? defaultPersonResponseModel;
  BasePoupSearchResult(this.isSuccessful, {this.message});
}
